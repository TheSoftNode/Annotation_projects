# R1 Factual Claims

## Claim 1: --assign is not a standard or widely-supported awk option
**Source:** Line 4
**Quote:** "The reason is that `--assign var=value` is **not** a standard (or even widely‑supported) `awk` option"

**Verification needed:** Check POSIX awk specification and various awk implementations

---

## Claim 2: Most awk implementations ignore --assign and treat it as a filename
**Source:** Lines 21-23
**Quote:** "GNU `awk` (`gawk`) *does* recognise `--assign` as a synonym for `-v`, but many other `awk`s (e.g. `mawk`, `busybox awk`, the `awk` that comes with macOS/BridgeBSD) **do not**. When an unknown option is encountered, `awk` treats it as a filename to read from."

**Verification needed:** Test on mawk, busybox awk, and macOS awk

---

## Claim 3: -v option is defined by POSIX
**Source:** Line 72
**Quote:** "`-v var=value` is defined by POSIX and works in **all** `awk` implementations."

**Verification needed:** Check POSIX specification

---

## Claim 4: ENVIRON works even with very old awks
**Source:** Line 97
**Quote:** "This avoids passing the values on the command line altogether and works even with very old `awk`s."

**Verification needed:** Check if ENVIRON is in POSIX or just common

---

## Claim 5: GNU awk recognizes --assign as synonym for -v
**Source:** Lines 21-22
**Quote:** "GNU `awk` (`gawk`) *does* recognise `--assign` as a synonym for `-v`"

**Verification needed:** Test with gawk or check gawk documentation

---

## Claim 6: The trailing space issue (optional polishing tip)
**Source:** Lines 115-117
**Quote:** "You add a space before each `,` (`\", \"`). This yields strings like `resource_usage_prod,name=latency, cpu_count=42`. The extra space after the comma is harmless for InfluxDB line‑protocol but looks odd."

**Verification needed:** Check InfluxDB line protocol specification

---

## Claim 7: += operator is available in most awks
**Source:** Line 120
**Quote:** "Use the `+=` operator for strings (available in most awks)"

**Verification needed:** Check if += is POSIX or extension
