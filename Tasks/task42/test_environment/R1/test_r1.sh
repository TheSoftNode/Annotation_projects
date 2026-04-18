#!/bin/bash
# test_r1.sh — All tests for Response 1
# Run from: task42/test_environment/

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_DIR="$SCRIPT_DIR/outputs/R1"
mkdir -p "$OUT_DIR"

echo "=========================================="
echo "  RESPONSE 1 TESTS"
echo "=========================================="
echo ""

PASS=0
FAIL=0

# ----------------------------------------------------------
# TEST 1: Does R1 code compile as-written (without includes)?
# ----------------------------------------------------------
echo "--- TEST 1: Compilation of r1_original.c (no includes) ---"
if gcc -std=c99 -Wall -Wextra -o /tmp/r1_orig "$SCRIPT_DIR/R1/r1_original.c" 2>"$OUT_DIR/test1_compile_original.log"; then
    echo "RESULT: Compiles WITHOUT includes (unexpected)"
    cat "$OUT_DIR/test1_compile_original.log"
else
    echo "RESULT: Does NOT compile without includes (as expected — missing headers)"
    echo "Compiler errors:"
    cat "$OUT_DIR/test1_compile_original.log"
fi
echo ""

# ----------------------------------------------------------
# TEST 2: Does R1 code compile with includes added?
# ----------------------------------------------------------
echo "--- TEST 2: Compilation of r1_completable.c (includes added) ---"
if gcc -std=c99 -Wall -Wextra -o /tmp/r1_comp "$SCRIPT_DIR/R1/r1_completable.c" 2>"$OUT_DIR/test2_compile.log"; then
    echo "RESULT: Compiles successfully with added includes"
    PASS=$((PASS + 1))
else
    echo "RESULT: FAILS to compile even with includes"
    FAIL=$((FAIL + 1))
fi
echo "Warnings/errors:"
cat "$OUT_DIR/test2_compile.log"
echo ""

# ----------------------------------------------------------
# TEST 3: Static buffer clobber — does gmtime() destroy localTime pointer?
# gmtime() and localtime() share a static buffer on most implementations.
# R1 calls localtime(&rawtime), stores pointer in localTime,
# then calls gmtime(&rawtime) which clobbers the static buffer.
# Then it calls mktime(localTime) — localTime now points to gmtime's result.
# ----------------------------------------------------------
echo "--- TEST 3: Static buffer clobber (gmtime clobbers localtime result) ---"
cat > /tmp/test_r1_clobber.c << 'EOF'
#include <stdio.h>
#include <time.h>
#include <string.h>

int main() {
    time_t rawtime;
    time(&rawtime);

    /* Step 1: Call localtime — get pointer to static buffer */
    struct tm *localTime = localtime(&rawtime);
    /* Save a copy of what localtime returned */
    struct tm saved_local;
    memcpy(&saved_local, localTime, sizeof(struct tm));

    printf("After localtime():\n");
    printf("  tm_hour=%d, tm_gmtoff=%ld, tm_isdst=%d\n",
           localTime->tm_hour, localTime->tm_gmtoff, localTime->tm_isdst);

    /* Step 2: Call gmtime — this overwrites the same static buffer */
    struct tm *gmTime = gmtime(&rawtime);

    printf("After gmtime():\n");
    printf("  gmTime:    tm_hour=%d, tm_gmtoff=%ld, tm_isdst=%d\n",
           gmTime->tm_hour, gmTime->tm_gmtoff, gmTime->tm_isdst);
    printf("  localTime: tm_hour=%d, tm_gmtoff=%ld, tm_isdst=%d\n",
           localTime->tm_hour, localTime->tm_gmtoff, localTime->tm_isdst);

    /* Check if localTime was clobbered */
    int clobbered = (localTime->tm_hour == gmTime->tm_hour &&
                     localTime->tm_gmtoff == gmTime->tm_gmtoff);

    /* Even if hour happens to match (UTC+0), check the full struct */
    int structs_match = (memcmp(localTime, gmTime, sizeof(struct tm)) == 0);
    int local_changed = (memcmp(localTime, &saved_local, sizeof(struct tm)) != 0);

    printf("\nlocalTime pointer == gmTime pointer? %s\n",
           (localTime == gmTime) ? "YES (same static buffer)" : "NO");
    printf("localTime content matches gmTime? %s\n",
           structs_match ? "YES (CLOBBERED!)" : "NO");
    printf("localTime changed from original? %s\n",
           local_changed ? "YES (CLOBBERED!)" : "NO");

    if (local_changed) {
        printf("\nBUG CONFIRMED: gmtime() clobbered the localTime pointer.\n");
        printf("R1's mktime(localTime) after gmtime() operates on GMT data, not local.\n");
        printf("This means: mktime(gmtime) and mktime(localTime) produce the SAME value.\n");
        printf("Result: timeOffset = 0 regardless of timezone.\n");
    }

    /* Now reproduce R1's exact logic */
    time(&rawtime);
    struct tm *lt = localtime(&rawtime);
    time_t gmtimeOffset = mktime(gmtime(&rawtime));  /* clobbers lt */
    time_t localTimeOffset = mktime(lt);              /* lt is now gmtime data */
    int timeOffset = (int)(localTimeOffset - gmtimeOffset);

    printf("\n--- R1's actual computed offset ---\n");
    printf("gmtimeOffset  = %ld\n", (long)gmtimeOffset);
    printf("localTimeOffset = %ld\n", (long)localTimeOffset);
    printf("timeOffset = %d seconds (should be non-zero for non-UTC zones)\n", timeOffset);

    return 0;
}
EOF
gcc -std=c99 -Wall -Wextra -o /tmp/test_r1_clobber /tmp/test_r1_clobber.c 2>&1

echo "Running in current TZ ($TZ or system default):"
/tmp/test_r1_clobber | tee "$OUT_DIR/test3_clobber_default.log"
echo ""

echo "Running with TZ=America/New_York (UTC-5 or UTC-4):"
TZ=America/New_York /tmp/test_r1_clobber | tee "$OUT_DIR/test3_clobber_ny.log"
echo ""

echo "Running with TZ=Asia/Tokyo (UTC+9):"
TZ=Asia/Tokyo /tmp/test_r1_clobber | tee "$OUT_DIR/test3_clobber_tokyo.log"
echo ""

echo "Running with TZ=Europe/London (UTC+0 or UTC+1):"
TZ=Europe/London /tmp/test_r1_clobber | tee "$OUT_DIR/test3_clobber_london.log"
echo ""

# ----------------------------------------------------------
# TEST 4: Does setlocale(LC_TIME, "") affect the offset?
# R1 calls setlocale(LC_TIME, "") — locale affects date formatting
# but NOT timezone offset computation. Test this.
# ----------------------------------------------------------
echo "--- TEST 4: setlocale(LC_TIME) relevance to time offset ---"
cat > /tmp/test_r1_locale.c << 'EOF'
#include <stdio.h>
#include <time.h>
#include <locale.h>

int main() {
    time_t rawtime;
    time(&rawtime);

    /* Without setlocale */
    struct tm *lt1 = localtime(&rawtime);
    long offset1 = lt1->tm_gmtoff;
    printf("Without setlocale: tm_gmtoff = %ld\n", offset1);

    /* With setlocale(LC_TIME, "") */
    setlocale(LC_TIME, "");
    struct tm *lt2 = localtime(&rawtime);
    long offset2 = lt2->tm_gmtoff;
    printf("With setlocale(LC_TIME, \"\"): tm_gmtoff = %ld\n", offset2);

    /* With setlocale to a different locale */
    setlocale(LC_TIME, "C");
    struct tm *lt3 = localtime(&rawtime);
    long offset3 = lt3->tm_gmtoff;
    printf("With setlocale(LC_TIME, \"C\"): tm_gmtoff = %ld\n", offset3);

    printf("\nAll offsets equal? %s\n",
           (offset1 == offset2 && offset2 == offset3) ? "YES — locale does NOT affect offset" : "NO — locale DOES affect offset");

    return 0;
}
EOF
gcc -std=c99 -Wall -Wextra -o /tmp/test_r1_locale /tmp/test_r1_locale.c 2>&1
TZ=America/New_York /tmp/test_r1_locale | tee "$OUT_DIR/test4_locale.log"
echo ""

# ----------------------------------------------------------
# TEST 5: R1 output correctness — run with known TZ values
# Even though the static buffer bug exists, let's see what R1 outputs.
# ----------------------------------------------------------
echo "--- TEST 5: R1 output with various timezones ---"
if [ -f /tmp/r1_comp ]; then
    echo "TZ=UTC:"
    TZ=UTC /tmp/r1_comp | tee "$OUT_DIR/test5_utc.log"
    echo ""
    echo "TZ=America/New_York:"
    TZ=America/New_York /tmp/r1_comp | tee "$OUT_DIR/test5_ny.log"
    echo ""
    echo "TZ=Asia/Tokyo:"
    TZ=Asia/Tokyo /tmp/r1_comp | tee "$OUT_DIR/test5_tokyo.log"
    echo ""
    echo "TZ=Australia/Adelaide (UTC+9:30 / +10:30, half-hour offset):"
    TZ=Australia/Adelaide /tmp/r1_comp | tee "$OUT_DIR/test5_adelaide.log"
    echo ""
    echo "TZ=Asia/Kathmandu (UTC+5:45, 45-min offset):"
    TZ=Asia/Kathmandu /tmp/r1_comp | tee "$OUT_DIR/test5_kathmandu.log"
    echo ""
else
    echo "SKIPPED: r1_completable.c did not compile"
fi

# ----------------------------------------------------------
# TEST 6: R1 references "modify the code" — hallucination check
# The prompt is a standalone question with no prior conversation.
# ----------------------------------------------------------
echo "--- TEST 6: Context hallucination check ---"
echo "R1 says: 'Here's an example of how you could modify the code'"
echo "R1 uses: '// ... [previous includes and definitions]'"
echo "The prompt is: 'linux c99 way to retrieve locale info about time offset to aplly to gmt. without using timestamp.'"
echo "There is NO prior conversation or code to modify."
echo "VERDICT: R1 hallucinates a prior context that does not exist."
echo "" | tee "$OUT_DIR/test6_hallucination.log"

# ----------------------------------------------------------
# TEST 7: Does R1 use a timestamp? (prompt says "without using timestamp")
# ----------------------------------------------------------
echo "--- TEST 7: Timestamp usage check ---"
echo "R1 calls: time(&rawtime) — this retrieves the current timestamp."
echo "R1 calls: localtime(&rawtime) — converts timestamp to local time."
echo "R1 calls: mktime(gmtime(&rawtime)) — uses timestamp via gmtime."
echo "The prompt says 'without using timestamp' — R1 uses time() to get one."
echo "NOTE: It is ambiguous whether 'without using timestamp' means"
echo "  (a) don't use a user-provided timestamp, or"
echo "  (b) don't use any timestamp at all (including time())."
echo "Interpretation (a) makes the requirement satisfiable; (b) does not,"
echo "since you need some reference point to determine the current offset."
echo "" | tee "$OUT_DIR/test7_timestamp.log"

# ----------------------------------------------------------
# TEST 8: strftime relevance
# ----------------------------------------------------------
echo "--- TEST 8: strftime relevance to the task ---"
echo "The user asks for 'locale info about time offset to apply to gmt'."
echo "R1 includes strftime to format 'Local time: 2025-04-18 12:30:00'."
echo "strftime formats dates — it does NOT retrieve time offset info."
echo "The offset calculation (mktime difference) is the relevant part."
echo "strftime is irrelevant to the user's request."
echo "" | tee "$OUT_DIR/test8_strftime.log"

# ----------------------------------------------------------
echo ""
echo "=========================================="
echo "  R1 TESTS COMPLETE"
echo "=========================================="
