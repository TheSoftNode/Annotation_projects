#!/bin/bash
# test_r2_factual.sh — Claim-by-claim tests from helpers/Factual_R2_Task42.md
# Follows EVERY step from that document. Nothing skipped.
# Run from: task42/test_environment/

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_DIR="$SCRIPT_DIR/outputs/R2"
mkdir -p "$OUT_DIR"

echo "=========================================="
echo "  R2 FACTUAL CLAIMS TESTS"
echo "  (From helpers/Factual_R2_Task42.md)"
echo "=========================================="
echo ""

###############################################################################
# STEP 1: CHECK THE COMPILER
# "Run: cc --version || gcc --version || clang --version"
###############################################################################
echo "=========================================="
echo "  STEP 1: CHECK THE COMPILER"
echo "=========================================="
echo ""

echo "--- Compiler version ---"
(cc --version || gcc --version || clang --version) 2>&1 | head -3 | tee "$OUT_DIR/factual_step1_compiler.log"
echo ""

###############################################################################
# STEP 2: RECORD TIMEZONE-RELATED ENVIRONMENT
# "Run: locale / echo "$TZ" / date / date +%z / ls -l /etc/localtime /etc/timezone"
###############################################################################
echo "=========================================="
echo "  STEP 2: TIMEZONE ENVIRONMENT"
echo "=========================================="
echo ""

echo "--- locale ---"
locale 2>&1 | tee "$OUT_DIR/factual_step2_locale.log"
echo ""

echo "--- echo \$TZ ---"
echo "TZ=${TZ:-<unset>}"
echo ""

echo "--- date ---"
date 2>&1
echo ""

echo "--- date +%z ---"
date +%z 2>&1
echo ""

echo "--- ls -l /etc/localtime /etc/timezone ---"
ls -l /etc/localtime /etc/timezone 2>/dev/null || echo "/etc/timezone may not exist"
echo ""

echo "This tests Claim 14: response says tzset() reads TZ, /etc/localtime, /etc/timezone."
echo "Linux man-pages document TZ and /etc/localtime but NOT /etc/timezone as standard." | tee "$OUT_DIR/factual_step2_tz_env.log"
echo ""

###############################################################################
# STEP 3: CODE ALREADY SAVED
# "Create gmt_offset.c and paste the exact code block from the response."
# (Already saved as r2_original.c)
###############################################################################
echo "=========================================="
echo "  STEP 3: SOURCE CODE"
echo "=========================================="
echo ""
echo "Code already saved as r2_original.c"
echo "Lines: $(wc -l < "$SCRIPT_DIR/r2_original.c")"
echo ""

###############################################################################
# STEP 4: COMPILE USING THE RESPONSE'S COMPILE STYLE
# "gcc -std=c99 -Wall -Wextra -o gmt_offset gmt_offset.c"
# "cc -std=c99 -Wall -Wextra -pedantic -o gmt_offset gmt_offset.c"
# Expected: "Very likely compile failure"
###############################################################################
echo "=========================================="
echo "  STEP 4: COMPILE VERBATIM CODE"
echo "=========================================="
echo ""

echo "--- 4A: Response's compile style ---"
echo "Command: gcc -std=c99 -Wall -Wextra -o /tmp/r2_verbatim r2_original.c"
echo ""
gcc -std=c99 -Wall -Wextra -o /tmp/r2_verbatim "$SCRIPT_DIR/r2_original.c" 2>"$OUT_DIR/factual_step4a_compile.log"
COMPILE_A_EXIT=$?
if [ $COMPILE_A_EXIT -eq 0 ]; then
    echo "RESULT: Compilation SUCCEEDED"
else
    echo "RESULT: Compilation FAILED (exit $COMPILE_A_EXIT)"
fi
echo "Compiler output:"
cat "$OUT_DIR/factual_step4a_compile.log"
echo ""

echo "--- 4B: Strict pedantic compile ---"
echo "Command: cc -std=c99 -Wall -Wextra -pedantic -o /tmp/r2_strict r2_original.c"
echo ""
cc -std=c99 -Wall -Wextra -pedantic -o /tmp/r2_strict "$SCRIPT_DIR/r2_original.c" 2>"$OUT_DIR/factual_step4b_compile.log"
COMPILE_B_EXIT=$?
if [ $COMPILE_B_EXIT -eq 0 ]; then
    echo "RESULT: Compilation SUCCEEDED"
else
    echo "RESULT: Compilation FAILED (exit $COMPILE_B_EXIT)"
fi
echo "Compiler output:"
cat "$OUT_DIR/factual_step4b_compile.log"
echo ""

echo "Factual doc says: 'Very likely compile failure.'"
echo "Expected errors: 'errno undeclared' and/or 'struct tm has no member named tm_gmtoff'"
echo ""

###############################################################################
# STEP 5: PROVE THE FIRST COMPILE ISSUE — errno WITHOUT <errno.h>
# "grep -n 'errno\|#include' gmt_offset.c"
###############################################################################
echo "=========================================="
echo "  STEP 5: errno WITHOUT <errno.h>"
echo "=========================================="
echo ""

echo "Command: grep -n 'errno\|#include' r2_original.c"
echo ""
grep -n 'errno\|#include' "$SCRIPT_DIR/r2_original.c" | tee "$OUT_DIR/factual_step5_errno.log"
echo ""

USES_ERRNO=$(grep -c 'errno' "$SCRIPT_DIR/r2_original.c" || true)
HAS_ERRNO_H=$(grep -c '<errno.h>' "$SCRIPT_DIR/r2_original.c" || true)
echo "errno used: $USES_ERRNO times"
echo "<errno.h> included: $HAS_ERRNO_H times"
echo ""
if [ "$USES_ERRNO" -gt 0 ] && [ "$HAS_ERRNO_H" -eq 0 ]; then
    echo "CONFIRMED: errno is used but <errno.h> is NOT included."
    echo "This violates C99/POSIX: <errno.h> defines errno."
    echo "Source: man7.org errno(3)"
else
    echo "errno.h status: included=$HAS_ERRNO_H, uses=$USES_ERRNO"
fi
echo ""

###############################################################################
# STEP 6: PROVE THE tm_gmtoff VISIBILITY ISSUE
# "grep -n 'tm_gmtoff\|_POSIX_C_SOURCE' gmt_offset.c"
# "grep -R -n 'tm_gmtoff' /usr/include 2>/dev/null | head -n 20"
###############################################################################
echo "=========================================="
echo "  STEP 6: tm_gmtoff VISIBILITY"
echo "=========================================="
echo ""

echo "--- 6A: Source code references ---"
echo "Command: grep -n 'tm_gmtoff\|_POSIX_C_SOURCE' r2_original.c"
echo ""
grep -n 'tm_gmtoff\|_POSIX_C_SOURCE' "$SCRIPT_DIR/r2_original.c" | tee "$OUT_DIR/factual_step6a_gmtoff_source.log"
echo ""

echo "--- 6B: System header search ---"
echo "Command: grep -R -n 'tm_gmtoff' /usr/include 2>/dev/null | head -n 20"
echo ""
grep -R -n 'tm_gmtoff' /usr/include 2>/dev/null | head -n 20 | tee "$OUT_DIR/factual_step6b_gmtoff_headers.log" || echo "(no results)"
echo ""

echo "On glibc, tm_gmtoff is exposed via __USE_MISC path."
echo "The code defines _POSIX_C_SOURCE 200809L which may NOT enable __USE_MISC."
echo "This is why tm_gmtoff can fail to be visible even though glibc has it."
echo "Source: codebrowser.dev glibc/time/bits/types/struct_tm.h"
echo ""

###############################################################################
# STEP 7: INSPECT MACRO EXPOSURE WITHOUT CHANGING SOURCE
# "cc -std=c99 -dM -E gmt_offset.c | grep -E '...'"
###############################################################################
echo "=========================================="
echo "  STEP 7: MACRO EXPOSURE INSPECTION"
echo "=========================================="
echo ""

echo "Command: cc -std=c99 -dM -E r2_original.c | grep -E '_POSIX_C_SOURCE|_DEFAULT_SOURCE|_GNU_SOURCE|__USE_MISC|__GLIBC__'"
echo ""
cc -std=c99 -dM -E "$SCRIPT_DIR/r2_original.c" 2>/dev/null | grep -E '_POSIX_C_SOURCE|_DEFAULT_SOURCE|_GNU_SOURCE|__USE_MISC|__GLIBC__' | tee "$OUT_DIR/factual_step7_macros.log" || echo "(no matching macros found)"
echo ""

echo "Expected:"
echo "  _POSIX_C_SOURCE should appear (defined in source)."
echo "  __GLIBC__ should appear (on glibc systems)."
echo "  _DEFAULT_SOURCE or __USE_MISC may NOT appear — needed for tm_gmtoff."
echo "Source: man7.org feature_test_macros(7)"
echo ""

###############################################################################
# STEP 8: VERIFY STANDARDS CLAIMS FROM SYSTEM DOCS
# Man page checks for time, localtime, mktime, tzset, tm, errno
###############################################################################
echo "=========================================="
echo "  STEP 8: MAN PAGE VERIFICATION"
echo "=========================================="
echo ""

echo "--- 8A: man 3p time ---"
echo "Expected: says seconds since the Epoch"
(man 3p time 2>/dev/null || man 3 time 2>/dev/null || man time 2>/dev/null) | col -b 2>/dev/null | sed -n '1,80p' | tee "$OUT_DIR/factual_step8a_man_time.log" || echo "(man page not available)"
echo ""

echo "--- 8B: man 3p localtime ---"
echo "Expected: converts to local broken-down time, behaves as though it calls tzset()"
(man 3p localtime 2>/dev/null || man 3 localtime 2>/dev/null || man localtime 2>/dev/null) | col -b 2>/dev/null | sed -n '1,120p' | tee "$OUT_DIR/factual_step8b_man_localtime.log" || echo "(man page not available)"
echo ""

echo "--- 8C: man 3p mktime ---"
echo "Expected: broken-down time is interpreted as local time"
(man 3p mktime 2>/dev/null || man 3 mktime 2>/dev/null || man mktime 2>/dev/null) | col -b 2>/dev/null | sed -n '1,120p' | tee "$OUT_DIR/factual_step8c_man_mktime.log" || echo "(man page not available)"
echo ""

echo "--- 8D: man 3 tzset ---"
echo "Expected: initializes timezone conversion, sets timezone/daylight/tzname"
echo "Expected: localtime() behaves as if it calls tzset() — explicit call not required"
(man 3 tzset 2>/dev/null || man tzset 2>/dev/null) | col -b 2>/dev/null | sed -n '1,120p' | tee "$OUT_DIR/factual_step8d_man_tzset.log" || echo "(man page not available)"
echo ""

echo "--- 8E: man 3 tm / man 3type tm ---"
echo "Expected: tm_gmtoff is UTC offset, tm_isdst shows DST status"
(man 3type tm 2>/dev/null || man 3 tm 2>/dev/null) | col -b 2>/dev/null | sed -n '1,120p' | tee "$OUT_DIR/factual_step8e_man_tm.log" || echo "(man page not available)"
echo ""

echo "--- 8F: man 3 errno ---"
echo "Expected: <errno.h> defines errno"
(man 3 errno 2>/dev/null || man errno 2>/dev/null) | col -b 2>/dev/null | sed -n '1,80p' | tee "$OUT_DIR/factual_step8f_man_errno.log" || echo "(man page not available)"
echo ""

###############################################################################
# STEP 9: RUNTIME TESTING (only if compilation succeeded)
# "For the exact unmodified code, runtime testing should stop if
#  compilation fails."
###############################################################################
echo "=========================================="
echo "  STEP 9: RUNTIME TESTING"
echo "=========================================="
echo ""

if [ -f /tmp/r2_verbatim ]; then
    echo "Verbatim compile succeeded — running runtime tests."
    echo ""

    echo "--- Default TZ ---"
    /tmp/r2_verbatim 2>&1 | tee "$OUT_DIR/factual_step9_run_default.log"
    echo "Exit code: $?"
    echo ""

    echo "--- Compare with system date +%z ---"
    SYSTEM_OFFSET=$(date +%z)
    echo "System offset (date +%z): $SYSTEM_OFFSET"
    echo ""

    echo "--- Multiple TZ tests ---"
    for TZ_VAL in UTC America/New_York Asia/Tokyo Europe/London Australia/Adelaide Asia/Kathmandu; do
        export TZ="$TZ_VAL"
        SYS_OFF=$(date +%z)
        # Convert +HHMM to seconds
        S=${SYS_OFF:0:1}
        H=${SYS_OFF:1:2}
        M=${SYS_OFF:3:2}
        SYS_SECS=$(( 10#$H * 3600 + 10#$M * 60 ))
        if [ "$S" = "-" ]; then
            SYS_SECS=$(( -SYS_SECS ))
        fi

        R2_OUT=$(TZ="$TZ_VAL" /tmp/r2_verbatim 2>&1 || true)
        printf "TZ=%-25s  system_offset=%+6d  r2_output='%s'\n" "$TZ_VAL" "$SYS_SECS" "$R2_OUT"
    done | tee "$OUT_DIR/factual_step9_tz_table.log"
    unset TZ
    echo ""

else
    echo "Verbatim compile FAILED — runtime testing stops here."
    echo "This is the FAIR result per the factual document:"
    echo "'For the exact unmodified code, runtime testing should stop"
    echo " if compilation fails.'"
    echo "'Do not change the source if your goal is to judge the original"
    echo " response exactly as written.'"
fi
echo ""

###############################################################################
# COMBINED REPORT
###############################################################################
echo "=========================================="
echo "  COMBINED REPORT"
echo "=========================================="
echo ""

echo "=== 1. Compiler ==="
(cc --version || gcc --version || clang --version) 2>&1 | head -1
echo ""

echo "=== 2. locale ==="
locale 2>&1
echo ""

echo "=== 3. TZ environment ==="
echo "TZ=${TZ:-<unset>}"
date +%z
ls -l /etc/localtime /etc/timezone 2>/dev/null || echo "/etc/timezone not found"
echo ""

echo "=== 4. Compile output (response style) ==="
cat "$OUT_DIR/factual_step4a_compile.log"
echo "Exit: $COMPILE_A_EXIT"
echo ""

echo "=== 5. Compile output (strict pedantic) ==="
cat "$OUT_DIR/factual_step4b_compile.log"
echo "Exit: $COMPILE_B_EXIT"
echo ""

echo "=== 6. errno grep ==="
cat "$OUT_DIR/factual_step5_errno.log"
echo ""

echo "=== 7. tm_gmtoff source grep ==="
cat "$OUT_DIR/factual_step6a_gmtoff_source.log"
echo ""

echo "=== 8. tm_gmtoff header grep ==="
cat "$OUT_DIR/factual_step6b_gmtoff_headers.log"
echo ""

echo "=== 9. Macro exposure ==="
cat "$OUT_DIR/factual_step7_macros.log"
echo ""

echo "=== 10. Runtime (if available) ==="
if [ -f "$OUT_DIR/factual_step9_run_default.log" ]; then
    cat "$OUT_DIR/factual_step9_run_default.log"
else
    echo "(compilation failed — no runtime)"
fi
echo ""

###############################################################################
# CLAIM-BY-CLAIM VERDICTS (all 25 from the factual document)
###############################################################################
echo "=========================================="
echo "  CLAIM-BY-CLAIM VERDICTS (25 claims)"
echo "=========================================="
echo ""

echo "CLAIM 1: 'Solution – get the current GMT-offset in pure C99 on Linux,"
echo "  without asking the user for a particular timestamp.'"
echo "  Verdict: PARTLY SUPPORTED / PARTLY DISPUTED"
echo "  - Does target Linux, does not ask user for timestamp."
echo "  - NOT 'pure C99': uses localtime_r() (POSIX), tzset() (POSIX),"
echo "    tm_gmtoff (BSD/GNU extension), timegm() (GNU extension)."
echo "  - Still uses a timestamp internally via time()."
echo ""

echo "CLAIM 2: 'The only thing we need from the system is the current"
echo "  wall-clock time; we obtain that with the standard time() function.'"
echo "  Verdict: SUPPORTED"
echo "  - POSIX: time() returns seconds since the Epoch."
echo ""

echo "CLAIM 3: 'After that we convert it to a broken-down time with"
echo "  localtime() (or the thread-safe localtime_r()) and read the"
echo "  tm_gmtoff field that glibc fills in.'"
echo "  Verdict: PARTLY SUPPORTED"
echo "  - localtime()/localtime_r() do convert to local broken-down time."
echo "  - tm_gmtoff exists on glibc/musl but is feature-macro-gated."
echo "  - In the exact code's macro setup, tm_gmtoff may NOT be visible."
echo ""

echo "CLAIM 4: 'tm_gmtoff is seconds east of UTC – the offset you must"
echo "  add to a UTC (GMT) time to get the local civil time.'"
echo "  Verdict: SUPPORTED"
echo "  - Linux tm(3type) confirms: seconds east of UTC."
echo ""

echo "CLAIM 5: 'If you need the offset in the opposite sense just change"
echo "  the sign.'"
echo "  Verdict: SUPPORTED"
echo "  - Follows from the documented sign convention."
echo ""

echo "CLAIM 6: 'If tm_gmtoff is not available on a very old or non-glibc"
echo "  system we fall back to timezone/daylight/global variables.'"
echo "  Verdict: PARTLY SUPPORTED"
echo "  - POSIX documents timezone/daylight/tzname from tzset()."
echo "  - BUT IANA tz project says these 'do not suffice' in general."
echo ""

echo "CLAIM 7: 'This fallback works for the standard-time offset; to know"
echo "  whether DST is currently active we still need a localtime() call.'"
echo "  Verdict: PARTLY SUPPORTED / PARTLY DISPUTED"
echo "  - timezone is documented as standard-time difference."
echo "  - IANA tz maintainers say timezone/daylight insufficient generally."
echo ""

echo "CLAIM 8: 'Initialise the timezone database from the environment..."
echo "  This must be done before any call to localtime*.'"
echo "  Verdict: DISPUTED"
echo "  - POSIX says localtime() behaves as though it calls tzset()."
echo "  - glibc manual says explicit tzset() usually unnecessary."
echo ""

echo "CLAIM 9: 'Obtain the current calendar time.'"
echo "  Verdict: SUPPORTED"
echo "  - time() returns seconds since the Epoch."
echo ""

echo "CLAIM 10: 'Convert to broken-down local time. Use the re-entrant"
echo "  variant; fall back to the non-reentrant one only if the former"
echo "  is not available (very old systems).'"
echo "  Verdict: MOSTLY SUPPORTED"
echo "  - localtime_r() is POSIX reentrant. localtime() uses static storage."
echo ""

echo "CLAIM 11: 'Preferred method: use tm_gmtoff if the libc provides it."
echo "  It is defined in <time.h> on glibc, musl, BSD, etc.'"
echo "  Verdict: PARTLY SUPPORTED"
echo "  - tm_gmtoff exists in glibc/musl/BSD."
echo "  - But on glibc it requires correct feature-test macros."
echo "  - 'always directly visible' is too broad."
echo ""

echo "CLAIM 12: 'Fallback for very old libc that lacks tm_gmtoff."
echo "  The global variable timezone holds the offset (seconds west of UTC)"
echo "  for standard time. daylight tells whether DST rules exist.'"
echo "  Verdict: PARTLY SUPPORTED"
echo "  - POSIX defines timezone/daylight per tzset()."
echo "  - IANA tz docs say they do not suffice generally."
echo ""

echo "CLAIM 13: 'std_offset += 3600L; /* most zones shift by +1 hour */'"
echo "  Verdict: WEAK / DISPUTED"
echo "  - Not a standards guarantee. Many zones use offsets != 3600."
echo "  - Lord Howe Island: +30min DST. Nepal, India: non-hour offsets."
echo ""

echo "CLAIM 14: 'tzset() reads the TZ environment variable, /etc/localtime"
echo "  (or /etc/timezone) and initialises timezone, daylight, tzname[].'"
echo "  Verdict: PARTLY SUPPORTED / PARTLY UNSUPPORTED"
echo "  - TZ, /etc/localtime, timezone, daylight, tzname[] are documented."
echo "  - /etc/timezone is NOT in man-pages as a standard mechanism."
echo ""

echo "CLAIM 15: 'time(NULL) obtains the current epoch seconds.'"
echo "  Verdict: SUPPORTED"
echo ""

echo "CLAIM 16: 'localtime_r()/localtime() breaks the epoch into a"
echo "  struct tm representing local civil time.'"
echo "  Verdict: SUPPORTED"
echo ""

echo "CLAIM 17: 'Read tm_gmtoff — if available, this field is seconds"
echo "  east of UTC.'"
echo "  Verdict: SUPPORTED (with portability caveat)"
echo "  - Sign/direction correct. Feature-macro-controlled on glibc."
echo ""

echo "CLAIM 18: 'Fallback: use -timezone and add an hour when tm.tm_isdst>0.'"
echo "  Verdict: PARTLY SUPPORTED / PARTLY DISPUTED"
echo "  - Describes what code does, but not reliable generally per IANA tz."
echo ""

echo "CLAIM 19: 'Guarantees the function still works on legacy systems"
echo "  while still being pure C99.'"
echo "  Verdict: DISPUTED"
echo "  - No standards basis for guarantee."
echo "  - 'Pure C99' not accurate: uses POSIX/extension APIs."
echo ""

echo "CLAIM 20: 'time_t utc = mktime(&gm); /* converts the broken-down"
echo "  time to epoch, interpreting the fields as *local* time. */'"
echo "  Verdict: SUPPORTED"
echo "  - POSIX: mktime() converts broken-down time as local time."
echo ""

echo "CLAIM 21: 'time_t utc_epoch = timegm(&gm); /* GNU extension */'"
echo "  Verdict: PARTLY SUPPORTED"
echo "  - timegm() being GNU extension is confirmed."
echo "  - 'use mktime with TZ=UTC' workaround is common but not guaranteed."
echo ""

echo "CLAIM 22: 'Pure C99 – only standard headers (<time.h>, <stdio.h>,"
echo "  <stdlib.h>) and POSIX-2008 (localtime_r) are used.'"
echo "  Verdict: DISPUTED"
echo "  - Uses errno without <errno.h>."
echo "  - Uses POSIX tzset() and XSI globals timezone/daylight."
echo "  - Relies on tm_gmtoff (nonstandard extension)."
echo "  - Uses timegm() (GNU extension) in example."
echo ""

echo "CLAIM 23: 'No reliance on a user-provided timestamp; we ask the"
echo "  system for the current time.'"
echo "  Verdict: SUPPORTED"
echo "  - Correct: uses time() internally, not user-supplied."
echo ""

echo "CLAIM 24: 'Correctly handles daylight-saving time because the"
echo "  conversion (localtime) already knows whether the instant falls"
echo "  in DST.'"
echo "  Verdict: PARTLY SUPPORTED"
echo "  - localtime() does correct for DST. tm_isdst indicates status."
echo "  - But the fallback assumes DST = exactly +3600, which is not general."
echo ""

echo "CLAIM 25: 'Works on any modern Linux glibc/musl system; the fallback"
echo "  makes it usable on older implementations as well.'"
echo "  Verdict: DISPUTED"
echo "  - Exact code did not compile in Linux/glibc test."
echo "  - tm_gmtoff visibility depends on feature-test settings."
echo "  - 'Any modern Linux glibc/musl' is too strong."
echo ""

echo "=========================================="
echo "  R2 FACTUAL CLAIMS TESTS COMPLETE"
echo "=========================================="
