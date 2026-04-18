#!/bin/bash
# test_r2.sh — All tests for Response 2
# Run from: task42/test_environment/

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_DIR="$SCRIPT_DIR/outputs/R2"
mkdir -p "$OUT_DIR"

echo "=========================================="
echo "  RESPONSE 2 TESTS"
echo "=========================================="
echo ""

# ----------------------------------------------------------
# TEST 1: Does R2 code compile as-written with gcc -std=c99?
# R2 claims: "Compile: gcc -std=c99 -Wall -Wextra -o gmt_offset gmt_offset.c"
# But R2 uses errno without #include <errno.h>.
# ----------------------------------------------------------
echo "--- TEST 1: Compilation as-written (gcc -std=c99 -Wall -Wextra) ---"
gcc -std=c99 -Wall -Wextra -o /tmp/r2_orig "$SCRIPT_DIR/R2/r2_original.c" 2>"$OUT_DIR/test1_compile.log"
COMPILE_EXIT=$?
if [ $COMPILE_EXIT -eq 0 ]; then
    echo "RESULT: Compiles successfully (exit $COMPILE_EXIT)"
    echo "Warnings (if any):"
    cat "$OUT_DIR/test1_compile.log"
else
    echo "RESULT: Compilation FAILED (exit $COMPILE_EXIT)"
    echo "Errors:"
    cat "$OUT_DIR/test1_compile.log"
fi
echo ""

# ----------------------------------------------------------
# TEST 2: Strict compilation — does errno compile without <errno.h>?
# On glibc, <time.h> or <stdio.h> might pull in errno transitively.
# Test with -Werror to see if it's clean.
# ----------------------------------------------------------
echo "--- TEST 2: Strict compilation (-Werror -pedantic) ---"
gcc -std=c99 -Wall -Wextra -Werror -pedantic -o /tmp/r2_strict "$SCRIPT_DIR/R2/r2_original.c" 2>"$OUT_DIR/test2_strict.log"
STRICT_EXIT=$?
if [ $STRICT_EXIT -eq 0 ]; then
    echo "RESULT: Passes strict compilation"
else
    echo "RESULT: Strict compilation FAILS"
    echo "Errors:"
    cat "$OUT_DIR/test2_strict.log"
fi
echo ""

# ----------------------------------------------------------
# TEST 3: Explicit errno test — is errno available without <errno.h>?
# ----------------------------------------------------------
echo "--- TEST 3: errno without <errno.h> ---"
cat > /tmp/test_errno.c << 'EOF'
#include <stdio.h>
/* No #include <errno.h> */
int main() {
    errno = 0;
    printf("errno = %d\n", errno);
    return 0;
}
EOF
if gcc -std=c99 -Wall -Wextra -o /tmp/test_errno /tmp/test_errno.c 2>"$OUT_DIR/test3_errno.log"; then
    echo "RESULT: errno IS available without <errno.h> (pulled in transitively)"
else
    echo "RESULT: errno is NOT available without <errno.h>"
fi
echo "Compiler output:"
cat "$OUT_DIR/test3_errno.log"
echo ""

# Now test if R2's specific includes pull it in:
cat > /tmp/test_errno2.c << 'EOF'
#define _POSIX_C_SOURCE 200809L
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
/* No #include <errno.h> — same as R2 */
int main() {
    int e = errno;
    printf("errno = %d\n", e);
    return 0;
}
EOF
if gcc -std=c99 -Wall -Wextra -o /tmp/test_errno2 /tmp/test_errno2.c 2>>"$OUT_DIR/test3_errno.log"; then
    echo "RESULT: R2's includes DO pull in errno transitively"
else
    echo "RESULT: R2's includes do NOT pull in errno — missing <errno.h> is a bug"
fi
echo ""

# ----------------------------------------------------------
# TEST 4: R2 output correctness with known timezones
# ----------------------------------------------------------
echo "--- TEST 4: R2 output with various timezones ---"
if [ -f /tmp/r2_orig ]; then
    echo "TZ=UTC (expected: +00:00):"
    TZ=UTC /tmp/r2_orig | tee "$OUT_DIR/test4_utc.log"
    echo ""

    echo "TZ=America/New_York (expected: -05:00 or -04:00 if DST):"
    TZ=America/New_York /tmp/r2_orig | tee "$OUT_DIR/test4_ny.log"
    echo ""

    echo "TZ=Asia/Tokyo (expected: +09:00, no DST):"
    TZ=Asia/Tokyo /tmp/r2_orig | tee "$OUT_DIR/test4_tokyo.log"
    echo ""

    echo "TZ=Europe/Berlin (expected: +01:00 or +02:00 if DST):"
    TZ=Europe/Berlin /tmp/r2_orig | tee "$OUT_DIR/test4_berlin.log"
    echo ""

    echo "TZ=Australia/Adelaide (expected: +09:30 or +10:30 if DST):"
    TZ=Australia/Adelaide /tmp/r2_orig | tee "$OUT_DIR/test4_adelaide.log"
    echo ""

    echo "TZ=Asia/Kathmandu (expected: +05:45, no DST):"
    TZ=Asia/Kathmandu /tmp/r2_orig | tee "$OUT_DIR/test4_kathmandu.log"
    echo ""

    echo "TZ=Pacific/Chatham (expected: +12:45 or +13:45 if DST):"
    TZ=Pacific/Chatham /tmp/r2_orig | tee "$OUT_DIR/test4_chatham.log"
    echo ""
else
    echo "SKIPPED: r2_original.c did not compile"
fi

# ----------------------------------------------------------
# TEST 5: "Pure C99" claim — tm_gmtoff is NOT in C99
# Compile with strict C99 and see if tm_gmtoff is available
# ----------------------------------------------------------
echo "--- TEST 5: Is tm_gmtoff part of C99 standard? ---"
cat > /tmp/test_tmgmtoff.c << 'EOF'
/* Strict C99 — no POSIX extensions */
#include <time.h>
#include <stdio.h>
int main() {
    time_t now = time(0);
    struct tm *lt = localtime(&now);
    printf("tm_gmtoff = %ld\n", lt->tm_gmtoff);
    return 0;
}
EOF
echo "Compiling with -std=c99 (strict, no GNU extensions):"
if gcc -std=c99 -Wall -Wextra -pedantic -o /tmp/test_tmgmtoff /tmp/test_tmgmtoff.c 2>"$OUT_DIR/test5_c99_strict.log"; then
    echo "RESULT: tm_gmtoff compiles under -std=c99 -pedantic on this system"
    echo "NOTE: This is because glibc defines it regardless, but it is NOT part of ISO C99"
else
    echo "RESULT: tm_gmtoff does NOT compile under strict C99"
fi
echo "Compiler output:"
cat "$OUT_DIR/test5_c99_strict.log"
echo ""

echo "Compiling with -std=gnu99 (GNU extensions):"
if gcc -std=gnu99 -Wall -Wextra -o /tmp/test_tmgmtoff_gnu /tmp/test_tmgmtoff.c 2>"$OUT_DIR/test5_gnu99.log"; then
    echo "RESULT: Compiles under -std=gnu99"
else
    echo "RESULT: Does not compile under gnu99"
fi
echo ""

# ----------------------------------------------------------
# TEST 6: _POSIX_C_SOURCE is not C99
# R2 uses #define _POSIX_C_SOURCE 200809L — this is POSIX, not C99.
# ----------------------------------------------------------
echo "--- TEST 6: _POSIX_C_SOURCE is POSIX, not C99 ---"
echo "R2 defines: #define _POSIX_C_SOURCE 200809L"
echo "_POSIX_C_SOURCE is a POSIX feature test macro, not part of ISO C99."
echo "localtime_r() requires POSIX; it is not in the C99 standard."
echo "R2 claims 'Pure C99' in comments and key points."
echo "VERDICT: The code uses POSIX extensions. 'Pure C99' is inaccurate."
echo "" | tee "$OUT_DIR/test6_posix.log"

# ----------------------------------------------------------
# TEST 7: DST handling — verify offset changes between DST and non-DST
# Use a fixed date in past to test both standard and daylight time
# ----------------------------------------------------------
echo "--- TEST 7: DST handling verification ---"
cat > /tmp/test_dst.c << 'EOF'
#define _POSIX_C_SOURCE 200809L
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Test offset for a specific date by setting the clock via TZ tricks */
void check_offset_for_tz(const char *tz_name) {
    setenv("TZ", tz_name, 1);
    tzset();

    time_t now = time(NULL);
    struct tm tm;
    localtime_r(&now, &tm);

    long hours = tm.tm_gmtoff / 3600L;
    long mins = (labs(tm.tm_gmtoff) % 3600L) / 60L;
    char sign = (tm.tm_gmtoff < 0) ? '-' : '+';

    printf("TZ=%-25s  offset=%c%02ld:%02ld  tm_isdst=%d  tm_gmtoff=%ld\n",
           tz_name, sign, labs(hours), mins, tm.tm_isdst, tm.tm_gmtoff);
}

int main() {
    printf("Current system time DST offsets:\n\n");

    check_offset_for_tz("America/New_York");
    check_offset_for_tz("America/Chicago");
    check_offset_for_tz("America/Denver");
    check_offset_for_tz("America/Los_Angeles");
    check_offset_for_tz("Europe/London");
    check_offset_for_tz("Europe/Berlin");
    check_offset_for_tz("Asia/Tokyo");
    check_offset_for_tz("Australia/Sydney");
    check_offset_for_tz("Pacific/Auckland");
    check_offset_for_tz("UTC");

    printf("\nNote: Whether DST is active depends on the current date.\n");
    printf("Asia/Tokyo never has DST. UTC offset is always +00:00.\n");

    return 0;
}
EOF
gcc -std=c99 -Wall -Wextra -o /tmp/test_dst /tmp/test_dst.c 2>&1
/tmp/test_dst | tee "$OUT_DIR/test7_dst.log"
echo ""

# ----------------------------------------------------------
# TEST 8: timegm() availability — R2's usage example uses it
# timegm is a GNU/BSD extension, NOT C99 or POSIX.
# ----------------------------------------------------------
echo "--- TEST 8: timegm() availability ---"
cat > /tmp/test_timegm.c << 'EOF'
#define _POSIX_C_SOURCE 200809L
#include <time.h>
#include <stdio.h>

int main() {
    struct tm gm = {0};
    gm.tm_year = 2025 - 1900;
    gm.tm_mon  = 10;  /* November */
    gm.tm_mday = 2;
    gm.tm_hour = 12;

    time_t t = timegm(&gm);
    printf("timegm result: %ld\n", (long)t);
    return 0;
}
EOF
echo "Compiling with -std=c99:"
if gcc -std=c99 -Wall -Wextra -o /tmp/test_timegm /tmp/test_timegm.c 2>"$OUT_DIR/test8_timegm.log"; then
    echo "RESULT: timegm() compiles with -std=c99 (available via glibc)"
    /tmp/test_timegm
else
    echo "RESULT: timegm() does NOT compile with -std=c99"
    cat "$OUT_DIR/test8_timegm.log"
fi
echo ""

echo "Note: R2 acknowledges timegm is a 'GNU extension' and suggests"
echo "'use mktime with TZ=UTC' as alternative. This is a usage example"
echo "section, not the main solution."
echo "" | tee -a "$OUT_DIR/test8_timegm.log"

# ----------------------------------------------------------
# TEST 9: R2 uses time() — does this violate "without using timestamp"?
# ----------------------------------------------------------
echo "--- TEST 9: Timestamp usage check ---"
echo "R2 calls: time((time_t *)0) — retrieves the current timestamp."
echo "R2 explanation: 'The only thing we need from the system is the"
echo "  current wall-clock time' and 'This is the only timestamp we use,"
echo "  and it is the current time.'"
echo "The prompt says 'without using timestamp.'"
echo "R2 interprets this as 'without a user-provided timestamp' and"
echo "  explicitly addresses this interpretation."
echo "NOTE: Same ambiguity as R1. Both use time()."
echo "" | tee "$OUT_DIR/test9_timestamp.log"

# ----------------------------------------------------------
# TEST 10: R2 fallback path — test with timezone global variable
# Force the non-tm_gmtoff path by compiling without __GLIBC__ etc.
# ----------------------------------------------------------
echo "--- TEST 10: R2 fallback path (timezone/daylight globals) ---"
cat > /tmp/test_r2_fallback.c << 'EOF'
#define _POSIX_C_SOURCE 200809L
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    tzset();
    time_t now = time(NULL);
    struct tm tm;
    localtime_r(&now, &tm);

    /* Primary: tm_gmtoff (what R2 uses on glibc) */
    long primary = tm.tm_gmtoff;

    /* Fallback: -timezone + DST adjustment (R2's fallback logic) */
    long std_offset = -timezone;
    if (tm.tm_isdst > 0) {
        std_offset += 3600L;
    }
    long fallback = std_offset;

    long p_hours = primary / 3600L;
    long p_mins  = (labs(primary) % 3600L) / 60L;
    char p_sign  = (primary < 0) ? '-' : '+';

    long f_hours = fallback / 3600L;
    long f_mins  = (labs(fallback) % 3600L) / 60L;
    char f_sign  = (fallback < 0) ? '-' : '+';

    printf("tm_gmtoff method:  %c%02ld:%02ld (%ld seconds)\n",
           p_sign, labs(p_hours), p_mins, primary);
    printf("fallback method:   %c%02ld:%02ld (%ld seconds)\n",
           f_sign, labs(f_hours), f_mins, fallback);
    printf("Methods agree: %s\n",
           (primary == fallback) ? "YES" : "NO — DISCREPANCY!");

    return 0;
}
EOF
gcc -std=c99 -Wall -Wextra -o /tmp/test_r2_fallback /tmp/test_r2_fallback.c 2>&1

echo "TZ=America/New_York:"
TZ=America/New_York /tmp/test_r2_fallback | tee "$OUT_DIR/test10_fallback_ny.log"
echo ""
echo "TZ=Asia/Tokyo:"
TZ=Asia/Tokyo /tmp/test_r2_fallback | tee "$OUT_DIR/test10_fallback_tokyo.log"
echo ""
echo "TZ=Europe/Berlin:"
TZ=Europe/Berlin /tmp/test_r2_fallback | tee "$OUT_DIR/test10_fallback_berlin.log"
echo ""
echo "TZ=Asia/Kathmandu (UTC+5:45 — tests non-hourly offset):"
TZ=Asia/Kathmandu /tmp/test_r2_fallback | tee "$OUT_DIR/test10_fallback_kathmandu.log"
echo ""
echo "TZ=Australia/Lord_Howe (UTC+10:30/+11:00 — half-hour DST):"
TZ=Australia/Lord_Howe /tmp/test_r2_fallback | tee "$OUT_DIR/test10_fallback_lordhowe.log"
echo ""

echo "NOTE: The fallback assumes DST shift is always +1 hour (3600L)."
echo "This is incorrect for zones like Australia/Lord_Howe (+30min DST)"
echo "or Morocco (which has had irregular DST shifts)."
echo "" | tee "$OUT_DIR/test10_fallback_note.log"

# ----------------------------------------------------------
# TEST 11: Sanitizer run — check for undefined behavior
# ----------------------------------------------------------
echo "--- TEST 11: AddressSanitizer + UndefinedBehaviorSanitizer ---"
if gcc -std=c99 -Wall -Wextra -fsanitize=address,undefined -o /tmp/r2_asan "$SCRIPT_DIR/R2/r2_original.c" 2>"$OUT_DIR/test11_asan_compile.log"; then
    echo "Compiled with sanitizers. Running:"
    TZ=America/New_York /tmp/r2_asan 2>&1 | tee "$OUT_DIR/test11_asan_run.log"
    echo ""
    TZ=Asia/Tokyo /tmp/r2_asan 2>&1 | tee -a "$OUT_DIR/test11_asan_run.log"
else
    echo "Sanitizer compilation failed:"
    cat "$OUT_DIR/test11_asan_compile.log"
fi
echo ""

echo "=========================================="
echo "  R2 TESTS COMPLETE"
echo "=========================================="
