#!/bin/bash
# test_r1_factual.sh — Claim-by-claim tests from helpers/Factual_R1_Task42.md
# Follows EVERY step from that document. Nothing skipped.
# Run from: task42/test_environment/

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_DIR="$SCRIPT_DIR/outputs/R1"
mkdir -p "$OUT_DIR"

echo "=========================================="
echo "  R1 FACTUAL CLAIMS TESTS"
echo "  (From helpers/Factual_R1_Task42.md)"
echo "=========================================="
echo ""

###############################################################################
# SECTION 2: DEPENDENCY CHECK
# "Use GitHub Codespaces... record your locale settings before testing."
###############################################################################
echo "=========================================="
echo "  SECTION 2: DEPENDENCY CHECK"
echo "=========================================="
echo ""

echo "--- Compiler version ---"
(cc --version || gcc --version || clang --version) 2>&1 | head -3 | tee "$OUT_DIR/factual_dependency_compiler.log"
echo ""

echo "--- Locale environment ---"
echo "The code uses setlocale(LC_TIME, \"\") which depends on the process"
echo "locale environment. Recording current locale settings:"
echo ""
locale 2>&1 | tee "$OUT_DIR/factual_dependency_locale.log"
echo ""

###############################################################################
# SECTION 3: STRICT VERBATIM TEST
# "Create a file with the response code exactly as written"
# Compile: cc -std=c99 -Wall -Wextra -pedantic response1.c -o response1
# Expected: "Compilation should fail" — not a complete standalone program.
###############################################################################
echo "=========================================="
echo "  SECTION 3: STRICT VERBATIM TEST"
echo "=========================================="
echo ""

echo "--- Compile r1_original.c exactly as written ---"
echo "Command: cc -std=c99 -Wall -Wextra -pedantic r1_original.c"
echo ""
cc -std=c99 -Wall -Wextra -pedantic "$SCRIPT_DIR/r1_original.c" -o /tmp/r1_verbatim 2>"$OUT_DIR/factual_sec3_verbatim_compile.log"
VERBATIM_EXIT=$?
if [ $VERBATIM_EXIT -eq 0 ]; then
    echo "RESULT: Compilation SUCCEEDED (unexpected per factual doc)"
else
    echo "RESULT: Compilation FAILED as expected (exit $VERBATIM_EXIT)"
    echo "The snippet says '// ... [previous includes and definitions]'"
    echo "and is NOT a self-contained compilable example."
fi
echo ""
echo "Full compiler output:"
cat "$OUT_DIR/factual_sec3_verbatim_compile.log"
echo ""

###############################################################################
# SECTION 4: STATIC INSPECTION TESTS
# "Even if the compile fails, you can still test whether the factual
#  statements are present in the text of the code."
###############################################################################
echo "=========================================="
echo "  SECTION 4: STATIC INSPECTION TESTS"
echo "=========================================="
echo ""

# --- 4A: Check whether it really includes a localtime check and a strftime check ---
echo "--- 4A: localtime null check and strftime check present? ---"
echo "Command: grep -n 'localTime == NULL\|strftime(formattedTime' r1_original.c"
echo ""
grep -n 'localTime == NULL\|strftime(formattedTime' "$SCRIPT_DIR/r1_original.c" | tee "$OUT_DIR/factual_sec4a_checks.log"
echo ""
echo "Expected: One line showing the localtime null check."
echo "          One line showing the strftime(...) == 0 check."
echo "This tests Claim 1 and Claim 4: 'includes error checking for localtime and strftime'."
echo ""

# --- 4B: Check whether it really uses the claimed format string ---
echo "--- 4B: Format string '%Y-%m-%d %H:%M:%S' present? ---"
echo "Command: grep -n '%Y-%m-%d %H:%M:%S' r1_original.c"
echo ""
grep -n '%Y-%m-%d %H:%M:%S' "$SCRIPT_DIR/r1_original.c" | tee "$OUT_DIR/factual_sec4b_format.log"
echo ""
echo "Expected: One line showing the exact format string."
echo "This tests Claim 3: 'Format the time using strftime'."
echo ""

# --- 4C: Check whether it really uses a timestamp ---
echo "--- 4C: Does R1 use timestamps? ---"
echo "Command: grep -n 'time(&rawtime)\|localtime(&rawtime)\|gmtime(&rawtime)' r1_original.c"
echo ""
grep -n 'time(&rawtime)\|localtime(&rawtime)\|gmtime(&rawtime)' "$SCRIPT_DIR/r1_original.c" | tee "$OUT_DIR/factual_sec4c_timestamp.log"
echo ""
echo "Expected: Lines showing all three calls (time, localtime, gmtime)."
echo "The prompt says 'without using timestamp' — R1 uses time() to get one."
echo "time() returns the current time value (a timestamp)."
echo "Both gmtime() and localtime() are applied to that value."
echo "This is a timestamp-based offset calculation tied to rawtime."
echo ""

# --- 4D: Check the exact ordering that matters for the overwrite issue ---
echo "--- 4D: Call ordering (static buffer overwrite) ---"
echo "Command: nl -ba r1_original.c | sed -n '1,40p'"
echo ""
nl -ba "$SCRIPT_DIR/r1_original.c" | sed -n '1,40p' | tee "$OUT_DIR/factual_sec4d_ordering.log"
echo ""
echo "Expected order (critical for the clobber bug):"
echo "  1. localTime = localtime(&rawtime);"
echo "  2. time_t gmtimeOffset = mktime(gmtime(&rawtime));"
echo "  3. time_t localTimeOffset = mktime(localTime);"
echo ""
echo "POSIX says asctime(), ctime(), gmtime(), and localtime() may return"
echo "data in shared static objects. A later call may overwrite an earlier result."
echo "In this code, localTime = localtime(&rawtime) happens BEFORE gmtime(&rawtime),"
echo "so localTime may be overwritten before mktime(localTime) runs."
echo "This directly undermines the reliability of the 'Get the time offset' logic."
echo ""

###############################################################################
# SECTION 4 EXTRA: MISSING ERROR CHECKS (from Claim 4 analysis)
# "But it does NOT check time(), gmtime(), or mktime()."
###############################################################################
echo "--- 4E: Missing error checks for time(), gmtime(), mktime() ---"
echo ""
echo "Checking for time() error handling:"
if grep -q 'time(&rawtime).*==.*-1\|time(&rawtime).*< 0\|if.*time(' "$SCRIPT_DIR/r1_original.c"; then
    echo "  FOUND: time() error check exists"
else
    echo "  NOT FOUND: No error check for time()"
    echo "  time() can return (time_t)-1 on error"
fi
echo ""

echo "Checking for gmtime() error handling:"
if grep -q 'gmtime.*==.*NULL\|if.*gmtime(' "$SCRIPT_DIR/r1_original.c"; then
    echo "  FOUND: gmtime() null check exists"
else
    echo "  NOT FOUND: No null check for gmtime()"
    echo "  gmtime() can return NULL on error"
fi
echo ""

echo "Checking for mktime() error handling:"
if grep -q 'mktime.*==.*-1\|if.*mktime(' "$SCRIPT_DIR/r1_original.c"; then
    echo "  FOUND: mktime() error check exists"
else
    echo "  NOT FOUND: No error check for mktime()"
    echo "  mktime() returns (time_t)-1 on error"
fi
echo ""

echo "Claim 4 says: 'This code now includes error checking for localtime and strftime'"
echo "Verdict: Partially supported — it checks localtime and strftime, but does NOT"
echo "check time(), gmtime(), or mktime()." | tee "$OUT_DIR/factual_sec4e_missing_checks.log"
echo ""

###############################################################################
# SECTION 4 EXTRA: strftime() == 0 nuance (from Claim 1 and Claim 4)
# "treating strftime(...) == 0 as a plain 'failure' condition is not
#  universally accurate, because the documented return value 0 does not
#  always mean error."
###############################################################################
echo "--- 4F: strftime() == 0 does NOT always mean error ---"
echo ""
cat > /tmp/test_strftime_zero.c << 'EOF'
#include <stdio.h>
#include <time.h>
#include <string.h>

int main() {
    struct tm tm;
    memset(&tm, 0, sizeof(tm));
    tm.tm_year = 2025 - 1900;
    tm.tm_mon = 3;  /* April */
    tm.tm_mday = 18;
    tm.tm_hour = 12;

    char buf[100];
    size_t ret;

    /* Normal case — format string produces output */
    ret = strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", &tm);
    printf("Format '%%Y-%%m-%%d %%H:%%M:%%S': ret=%zu, buf='%s'\n", ret, buf);

    /* Edge case — empty format string produces empty output, ret=0 */
    ret = strftime(buf, sizeof(buf), "", &tm);
    printf("Format '' (empty): ret=%zu, buf='%s'\n", ret, buf);

    /* Edge case — buffer too small */
    ret = strftime(buf, 5, "%Y-%m-%d %H:%M:%S", &tm);
    printf("Buffer size 5 (too small): ret=%zu\n", ret);

    printf("\nPOSIX man page says: 'If the total number of resulting bytes\n");
    printf("including the terminating null byte is not more than maxsize,\n");
    printf("strftime() shall return the number of bytes placed into the\n");
    printf("array pointed to by s, not including the terminating null byte.\n");
    printf("Otherwise, 0 shall be returned and the contents of the array\n");
    printf("are unspecified.'\n");
    printf("\nReturn value 0 with an empty format string is NOT an error.\n");
    printf("R1 treats strftime()==0 as unconditional failure. That is not\n");
    printf("universally accurate per POSIX.\n");

    return 0;
}
EOF
gcc -std=c99 -Wall -Wextra -o /tmp/test_strftime_zero /tmp/test_strftime_zero.c 2>&1
/tmp/test_strftime_zero | tee "$OUT_DIR/factual_sec4f_strftime_zero.log"
echo ""

###############################################################################
# SECTION 5: RUNTIME TEST (with includes added)
# "If your surrounding file already supplies the missing includes/definitions"
# Run: ./response1; echo $?
###############################################################################
echo "=========================================="
echo "  SECTION 5: RUNTIME TEST (with includes)"
echo "=========================================="
echo ""

echo "--- Compile r1_completable.c ---"
if gcc -std=c99 -Wall -Wextra -pedantic -o /tmp/r1_factual_run "$SCRIPT_DIR/r1_completable.c" 2>"$OUT_DIR/factual_sec5_compile.log"; then
    echo "Compilation succeeded."
    echo "Compiler warnings (if any):"
    cat "$OUT_DIR/factual_sec5_compile.log"
    echo ""

    echo "--- Run r1_completable ---"
    echo "Expected: Two lines — 'Local time: ...' and 'Time offset to GMT: ... seconds'"
    echo "Or error: 'Error: localtime failed' or 'Error: strftime failed'"
    echo ""

    /tmp/r1_factual_run 2>&1 | tee "$OUT_DIR/factual_sec5_run_default.log"
    R1_EXIT=$?
    echo "Exit code: $R1_EXIT"
    echo ""

    echo "--- Run with TZ=America/New_York ---"
    TZ=America/New_York /tmp/r1_factual_run 2>&1 | tee "$OUT_DIR/factual_sec5_run_ny.log"
    echo "Exit code: $?"
    echo ""

    echo "--- Run with TZ=Asia/Tokyo ---"
    TZ=Asia/Tokyo /tmp/r1_factual_run 2>&1 | tee "$OUT_DIR/factual_sec5_run_tokyo.log"
    echo "Exit code: $?"
    echo ""

    echo "--- Run with TZ=UTC ---"
    TZ=UTC /tmp/r1_factual_run 2>&1 | tee "$OUT_DIR/factual_sec5_run_utc.log"
    echo "Exit code: $?"
    echo ""
else
    echo "Compilation FAILED:"
    cat "$OUT_DIR/factual_sec5_compile.log"
    echo "SKIPPING runtime tests."
fi
echo ""

###############################################################################
# SECTION 6: INDEPENDENT SHELL CHECKS FOR RUNTIME CLAIMS
# Compare R1 output with Linux shell tools.
###############################################################################
echo "=========================================="
echo "  SECTION 6: INDEPENDENT SHELL CHECKS"
echo "=========================================="
echo ""

# --- 6A: Compare the formatted local time ---
echo "--- 6A: Compare formatted local time with date command ---"
echo ""
echo "R1 program output (Local time line):"
if [ -f /tmp/r1_factual_run ]; then
    R1_LOCAL_TIME=$(/tmp/r1_factual_run 2>/dev/null | grep 'Local time:' || echo "N/A")
    echo "  $R1_LOCAL_TIME"
else
    echo "  (program not available)"
fi
echo ""
echo "System date command:"
SYSTEM_LOCAL=$(date '+%Y-%m-%d %H:%M:%S')
echo "  Local time: $SYSTEM_LOCAL"
echo ""
echo "Expected: These should be very close (within a second)."
echo "" | tee "$OUT_DIR/factual_sec6a_local_compare.log"

# --- 6B: Compare the UTC time ---
echo "--- 6B: Compare UTC time with date -u ---"
echo ""
echo "date -u output:"
SYSTEM_UTC=$(date -u '+%Y-%m-%d %H:%M:%S')
echo "  UTC time: $SYSTEM_UTC"
echo "This gives the UTC side for comparison." | tee "$OUT_DIR/factual_sec6b_utc_compare.log"
echo ""

# --- 6C: Compare the numeric timezone offset ---
echo "--- 6C: Compare numeric timezone offset with date +%z ---"
echo ""
SYSTEM_OFFSET=$(date +%z)
echo "System offset (date +%z): $SYSTEM_OFFSET"
echo ""

# Convert +HHMM to seconds
SIGN=${SYSTEM_OFFSET:0:1}
HH=${SYSTEM_OFFSET:1:2}
MM=${SYSTEM_OFFSET:3:2}
OFFSET_SECS=$(( 10#$HH * 3600 + 10#$MM * 60 ))
if [ "$SIGN" = "-" ]; then
    OFFSET_SECS=$(( -OFFSET_SECS ))
fi
echo "Converted to seconds: $OFFSET_SECS"
echo ""

if [ -f /tmp/r1_factual_run ]; then
    R1_OFFSET=$(/tmp/r1_factual_run 2>/dev/null | grep 'Time offset to GMT:' | sed 's/[^-0-9]//g' || echo "N/A")
    echo "R1 program offset: $R1_OFFSET seconds"
    echo ""

    if [ "$R1_OFFSET" = "$OFFSET_SECS" ]; then
        echo "MATCH: R1 offset matches system offset."
    else
        echo "MISMATCH: R1 offset ($R1_OFFSET) != system offset ($OFFSET_SECS)."
        echo "This is evidence against R1's offset logic."
        echo "(Expected due to the static buffer clobber bug.)"
    fi
else
    echo "R1 program not available — skipping comparison."
fi
echo "" | tee "$OUT_DIR/factual_sec6c_offset_compare.log"

# Now test with explicit TZ values to make comparison clear
echo "--- 6C (extended): Offset comparison across timezones ---"
echo ""

for TZ_VAL in UTC America/New_York Asia/Tokyo Europe/London Australia/Adelaide Asia/Kathmandu; do
    export TZ="$TZ_VAL"
    SYS_OFF=$(date +%z)
    # Convert to seconds
    S=${SYS_OFF:0:1}
    H=${SYS_OFF:1:2}
    M=${SYS_OFF:3:2}
    SYS_SECS=$(( 10#$H * 3600 + 10#$M * 60 ))
    if [ "$S" = "-" ]; then
        SYS_SECS=$(( -SYS_SECS ))
    fi

    if [ -f /tmp/r1_factual_run ]; then
        R1_OFF=$(TZ="$TZ_VAL" /tmp/r1_factual_run 2>/dev/null | grep 'Time offset to GMT:' | sed 's/[^-0-9]//g' || echo "N/A")
    else
        R1_OFF="N/A"
    fi

    if [ "$R1_OFF" = "$SYS_SECS" ]; then
        VERDICT="MATCH"
    else
        VERDICT="MISMATCH"
    fi

    printf "TZ=%-25s  system=%+6d  r1=%6s  %s\n" "$TZ_VAL" "$SYS_SECS" "$R1_OFF" "$VERDICT"
done | tee "$OUT_DIR/factual_sec6c_offset_table.log"
unset TZ
echo ""

###############################################################################
# SECTION 6 EXTRA: mktime() interprets struct tm as LOCAL time
# Factual doc says: "mktime() interprets its struct tm input as local time,
# while gmtime() produces a broken-down UTC time."
###############################################################################
echo "--- 6D: mktime() interprets input as local time ---"
echo ""
cat > /tmp/test_mktime_local.c << 'EOF'
#include <stdio.h>
#include <time.h>
#include <string.h>

int main() {
    time_t rawtime;
    time(&rawtime);

    /* gmtime produces UTC broken-down time */
    struct tm gm_copy;
    struct tm *gm = gmtime(&rawtime);
    memcpy(&gm_copy, gm, sizeof(struct tm));

    /* mktime interprets its input as LOCAL time */
    /* So mktime(gmtime_result) treats UTC values as if they were local */
    time_t gm_as_local = mktime(&gm_copy);

    /* localtime produces local broken-down time */
    struct tm lt_copy;
    struct tm *lt = localtime(&rawtime);
    memcpy(&lt_copy, lt, sizeof(struct tm));
    time_t lt_as_local = mktime(&lt_copy);

    printf("rawtime (original):         %ld\n", (long)rawtime);
    printf("mktime(gmtime_copy):        %ld  (UTC values treated as local)\n", (long)gm_as_local);
    printf("mktime(localtime_copy):     %ld  (local values treated as local = original)\n", (long)lt_as_local);
    printf("Difference (local - gm):    %ld seconds\n", (long)(lt_as_local - gm_as_local));
    printf("\nNote: mktime(gmtime_copy) converts UTC broken-down time back to\n");
    printf("time_t but treats it as local time. The difference between the\n");
    printf("two mktime results gives the UTC offset — but ONLY if the struct tm\n");
    printf("values are preserved correctly (R1 does not preserve them).\n");

    return 0;
}
EOF
gcc -std=c99 -Wall -Wextra -o /tmp/test_mktime_local /tmp/test_mktime_local.c 2>&1

echo "TZ=America/New_York (expect ~-18000 or ~-14400):"
TZ=America/New_York /tmp/test_mktime_local | tee "$OUT_DIR/factual_sec6d_mktime_ny.log"
echo ""
echo "TZ=Asia/Tokyo (expect ~32400):"
TZ=Asia/Tokyo /tmp/test_mktime_local | tee "$OUT_DIR/factual_sec6d_mktime_tokyo.log"
echo ""
echo "TZ=UTC (expect 0):"
TZ=UTC /tmp/test_mktime_local | tee "$OUT_DIR/factual_sec6d_mktime_utc.log"
echo ""

echo "This proves the mktime-difference method WORKS in principle — but only"
echo "if localtime and gmtime results are stored in SEPARATE struct tm variables,"
echo "NOT via pointers to the same static buffer (which is what R1 does wrong)."
echo ""

###############################################################################
# SECTION 7: COMBINED REPORT (what to send back)
# Consolidates all key outputs into one block.
###############################################################################
echo "=========================================="
echo "  SECTION 7: COMBINED REPORT"
echo "=========================================="
echo ""

echo "=== 1. locale ==="
locale 2>&1
echo ""

echo "=== 2. Verbatim compile output ==="
echo "Command: cc -std=c99 -Wall -Wextra -pedantic r1_original.c"
cat "$OUT_DIR/factual_sec3_verbatim_compile.log"
echo "Exit code: $VERBATIM_EXIT"
echo ""

echo "=== 3. Combined grep: all claims in one pass ==="
echo "Command: grep -n 'localTime == NULL\|strftime(formattedTime\|%Y-%m-%d %H:%M:%S\|time(&rawtime)\|localtime(&rawtime)\|gmtime(&rawtime)' r1_original.c"
grep -n 'localTime == NULL\|strftime(formattedTime\|%Y-%m-%d %H:%M:%S\|time(&rawtime)\|localtime(&rawtime)\|gmtime(&rawtime)' "$SCRIPT_DIR/r1_original.c" | tee "$OUT_DIR/factual_sec7_combined_grep.log"
echo ""

echo "=== 4. Runtime output (if available) ==="
if [ -f /tmp/r1_factual_run ]; then
    echo "--- ./response1 ---"
    /tmp/r1_factual_run 2>&1
    echo ""
    echo "--- date '+%Y-%m-%d %H:%M:%S' ---"
    date '+%Y-%m-%d %H:%M:%S'
    echo ""
    echo "--- date -u '+%Y-%m-%d %H:%M:%S' ---"
    date -u '+%Y-%m-%d %H:%M:%S'
    echo ""
    echo "--- date +%z ---"
    date +%z
else
    echo "(program did not compile)"
fi
echo ""

###############################################################################
# CLAIM-BY-CLAIM SUMMARY
###############################################################################
echo "=========================================="
echo "  CLAIM-BY-CLAIM VERDICTS"
echo "=========================================="
echo ""

echo "CLAIM 1: 'Here's an example of how you could modify the code to include"
echo "  error checking and to use the strftime function to format the time'"
echo "  Verdict: PARTIALLY SUPPORTED"
echo "  - It does include localtime null check and strftime return check."
echo "  - It does use strftime."
echo "  - But it is NOT a self-contained compilable example"
echo "    (starts with '// ... [previous includes and definitions]')."
echo "  - strftime()==0 does not always indicate error per POSIX."
echo ""

echo "CLAIM 2: '// Get the time offset' logic"
echo "  Verdict: NOT FULLY SUPPORTED / DISPUTED"
echo "  - Uses time() (a timestamp) despite prompt saying 'without using timestamp.'"
echo "  - mktime() interprets input as local time; gmtime() produces UTC."
echo "  - Static buffer issue: localtime() result pointer may be overwritten"
echo "    by gmtime() call before mktime(localTime) runs."
echo "  - Result: timeOffset is likely 0 regardless of timezone."
echo ""

echo "CLAIM 3: '// Format the time using strftime' with '%Y-%m-%d %H:%M:%S'"
echo "  Verdict: SUPPORTED"
echo "  - strftime() is the standard API for formatting broken-down time."
echo "  - The format string is exactly '%Y-%m-%d %H:%M:%S'."
echo ""

echo "CLAIM 4: 'This code now includes error checking for localtime and strftime"
echo "  and formats the local time in the specified format.'"
echo "  Verdict: PARTIALLY SUPPORTED"
echo "  - It does check localtime and strftime."
echo "  - It does format with '%Y-%m-%d %H:%M:%S'."
echo "  - But it does NOT check time(), gmtime(), or mktime()."
echo "  - strftime()==0 is not a reliable universal error indicator."
echo ""

echo "=========================================="
echo "  R1 FACTUAL CLAIMS TESTS COMPLETE"
echo "=========================================="
