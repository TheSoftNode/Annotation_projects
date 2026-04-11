# R2 Disputed Claims Summary (from GPT_FACTUAL_R2_TASK29.md)

## SUBSTANTIAL DISPUTED CLAIMS:

1. **Claim 5** (line 89): grep.html URL returns 404
   - URL: https://git.savannah.gnu.org/git/grep.html
   - Status: DISPUTED - 404 Not Found
   - **COVERED by AOI #3**

2. **Claim 6** (line 103): Homepage is part of GNU Coreutils
   - Status: DISPUTED - GNU grep is separate project
   - **COVERED by AOI #1**

3. **Claim 7** (line 119): grep-3.15 released Aug 2024
   - Status: DISPUTED - Latest is 3.12 (2025-04-10)
   - **COVERED by AOI #5**

4. **Claim 8** (line 135): Tarballs in /gnu/coreutils/
   - Status: DISPUTED - Actually in /gnu/grep/
   - **COVERED by AOI #1** (part of Coreutils confusion)

5. **Claim 9** (line 147): Maintainer is Jim Blandy
   - Status: DISPUTED - Actually Jim Meyering
   - **COVERED by AOI #6**

6. **Claim 10** (line 159): grep lives inside GNU Coreutils
   - Status: DISPUTED - grep is standalone project
   - **COVERED by AOI #1**

7. **Claim 11** (line 173): Modern grep not standalone, under Coreutils umbrella
   - Status: DISPUTED - grep is standalone
   - **COVERED by AOI #1**

8. **Claim 12** (line 185): grep/ directory in coreutils URL
   - URL: https://git.savannah.gnu.org/git/coreutils.git/tree/grep
   - Status: DISPUTED - 404 Not Found
   - **COVERED by AOI #1** (Coreutils claim)

9. **Claim 13** (line 199): All modern versions in Coreutils
   - Status: DISPUTED - Current development in separate grep project
   - **COVERED by AOI #1**

10. **Claim 14** (line 213): Git commit URL for v3.6
    - URL: Complex coreutils URL
    - Status: DISPUTED - Invalid URL
    - **NOT COVERED** (minor - broken example link)

11. **Claim 16** (line 245): Apple's source is proprietary
    - Status: DISPUTED - Apple has public grep source
    - **COVERED by AOI #8**

12. **Claim about PCRE** (line 471): GNU grep does not use PCRE, uses Oniguruma
    - Status: DISPUTED - grep has pcresearch.c with PCRE2
    - **COVERED by AOI #2**

13. **Claim about egrep/fgrep** (line 489): No egrep/fgrep in GNU grep
    - Status: DISPUTED - They exist as deprecated commands
    - **NOT COVERED** (minor)

14. **Claim about CVE** (line 583): CVE-2016-3253 as security example
    - Status: DISPUTED - CVE is REJECTED by NVD
    - **NOT COVERED** (minor)

15. **Claim about file location** (lines 237-241): grep.h, grep.c, regex.c in repo root
    - Status: DISPUTED - Files in src/, regex.c doesn't exist
    - **COVERED by AOI #7**

16. **Claim about grep-3.14 tag** (line 551): Checkout grep-3.14
    - Status: SUSPICIOUS - Latest is 3.12, not 3.14
    - **Related to AOI #5** (version confusion)

17. **Claim about Unix history** (line 515): First open-source in 7th Edition Unix (1979)
    - Status: DISPUTED - V6 has earlier grep.c
    - **NOT COVERED** (minor historical claim)

## Code browsing URLs (broken):
- Lines 367, 419, 439: Broken code browsing URLs
- **NOT COVERED** (minor - example URLs)

## Missing from current AOIs:
1. CVE-2016-3253 being REJECTED (minor)
2. egrep/fgrep claim (minor)
3. Broken example/code URLs (minor)
4. Unix history claim (minor)
