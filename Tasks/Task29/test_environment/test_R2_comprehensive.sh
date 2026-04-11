#!/bin/bash
# Comprehensive Test Script for R2 Based on GPT Factual Verification
# This script follows the exact testing checklist from GPT_FACTUAL_R2_TASK29.md

echo "============================================"
echo "R2 COMPREHENSIVE TEST SUITE - Task 29"
echo "Testing environment: $(uname -s)"
echo "Date: $(date)"
echo "============================================"
echo ""

# Test 1: Verify primary GNU grep repository
echo "=== TEST 1: Verify GNU grep primary repository ==="
repo_url="https://git.savannah.gnu.org/git/grep.git"
echo "Testing URL: $repo_url"
cd /tmp
rm -rf grep
git clone "$repo_url"
if [ -d "grep" ]; then
    echo "✓ Clone successful"
    cd grep
    git remote -v
else
    echo "✗ Clone failed"
fi
echo ""

# Test 2: Verify web browser URL
echo "=== TEST 2: Check web browser URL ==="
web_url="https://git.savannah.gnu.org/git/grep.html"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$web_url" --max-time 10)
if [ "$http_code" == "200" ]; then
    echo "✓ URL accessible: $web_url"
else
    echo "✗ URL FAILED (DISPUTED): $web_url → HTTP $http_code"
fi
echo ""

# Test 3: CRITICAL - Verify if grep is part of Coreutils
echo "=== TEST 3: CRITICAL - Is grep part of GNU Coreutils? ==="
echo "Checking GNU grep official page..."
grep_page="https://www.gnu.org/software/grep/"
coreutils_page="https://www.gnu.org/software/coreutils/"

echo "Fetching GNU grep page title:"
curl -s "$grep_page" --max-time 10 | grep -i "<title>" | head -1

echo ""
echo "Checking if GNU lists grep as separate project:"
curl -s "https://www.gnu.org/software/" --max-time 10 | grep -i "grep" | head -3

echo ""
echo "Testing Coreutils grep directory URL:"
coreutils_grep_url="https://git.savannah.gnu.org/git/coreutils.git/tree/grep"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$coreutils_grep_url" --max-time 10)
echo "$coreutils_grep_url → HTTP $http_code"
if [ "$http_code" == "404" ]; then
    echo "→ DISPUTED: grep/ directory does NOT exist in Coreutils (404)"
fi
echo ""

# Test 4: Verify source tarball location
echo "=== TEST 4: Check source tarball location ==="
echo "R2 claims tarballs are in: https://ftp.gnu.org/gnu/coreutils/"
echo "Checking for grep-*.tar.xz in Coreutils FTP:"
curl -s "https://ftp.gnu.org/gnu/coreutils/" --max-time 10 | grep -i "grep-" | head -3
if [ $? -ne 0 ]; then
    echo "→ No grep-*.tar.xz found in Coreutils directory"
fi

echo ""
echo "Checking actual grep FTP directory:"
curl -s "https://ftp.gnu.org/gnu/grep/" --max-time 10 | grep -E "grep-[0-9]+\.[0-9]+\.tar" | tail -5
echo ""

# Test 5: Verify version claim (grep-3.15 Released Aug 2024)
echo "=== TEST 5: Verify version claim (grep-3.15) ==="
echo "R2 claims: grep-3.15 released Aug 2024"
echo "Checking actual latest version from FTP:"
curl -s "https://ftp.gnu.org/gnu/grep/" --max-time 10 | grep -oE "grep-[0-9]+\.[0-9]+" | sort -V | tail -5
echo ""
echo "Checking GNU grep homepage for latest version:"
curl -s "https://www.gnu.org/software/grep/" --max-time 10 | grep -i "latest" | head -3
echo ""

# Test 6: Verify maintainer claim
echo "=== TEST 6: Verify maintainer (Jim Blandy vs Jim Meyering) ==="
echo "R2 claims: Jim Blandy (jsb@lightyear.com)"
echo "Checking GNU grep page for actual maintainer:"
curl -s "https://www.gnu.org/software/grep/" --max-time 10 | grep -i "maintainer" -A 2 | head -5
echo ""

# Test 7: Check file layout claims
echo "=== TEST 7: Verify file layout in repository ==="
cd /tmp/grep 2>/dev/null || { echo "Cannot cd to grep directory"; exit 1; }

echo "R2 claims files are in repo root: grep.h, grep.c, regex.c"
echo ""
echo "Checking repo root:"
ls grep.h grep.c regex.c 2>/dev/null
if [ $? -ne 0 ]; then
    echo "→ Files NOT in root (DISPUTED)"
fi

echo ""
echo "Checking actual src/ directory:"
ls src/ | head -20

echo ""
echo "Looking for regex.c in src/:"
ls src/regex.c 2>/dev/null && echo "✓ found" || echo "✗ NOT FOUND (DISPUTED)"
echo ""

# Test 8: Check broken code links
echo "=== TEST 8: Verify code browsing URLs from R2 ==="
urls=(
    "https://git.savannah.gnu.org/git/grep/tree/grep.c#L897"
    "https://git.savannah.gnu.org/git/grep/blob/master/x=malloc.c"
    "https://git.savannah.gnu.org/git/grep/blob/master/grep.c#L2694"
)

for url in "${urls[@]}"; do
    http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url" --max-time 10)
    if [ "$http_code" == "200" ]; then
        echo "✓ $url"
    else
        echo "✗ BROKEN (HTTP $http_code): $url"
    fi
done
echo ""

# Test 9: CRITICAL - Verify PCRE / Oniguruma claim
echo "=== TEST 9: CRITICAL - PCRE vs Oniguruma claim ==="
cd /tmp/grep

echo "R2 claims: 'GNU grep does not use PCRE' and 'uses Oniguruma'"
echo ""
echo "Checking for pcresearch.c in src/:"
ls src/pcresearch.c 2>/dev/null && echo "✓ pcresearch.c EXISTS (contradicts claim)" || echo "✗ not found"

echo ""
echo "Searching for PCRE references:"
grep -R -n "PCRE" src/ 2>/dev/null | head -5

echo ""
echo "Searching for PCRE2 references:"
grep -R -n "PCRE2" src/ 2>/dev/null | head -5

echo ""
echo "Searching for Oniguruma references:"
grep -R -n "Oniguruma" . 2>/dev/null | head -5
if [ $? -ne 0 ]; then
    echo "→ No Oniguruma references found (DISPUTED)"
fi

echo ""
echo "Checking Oniguruma URL from R2:"
oniguruma_url="https://github.com/OniguramaOniguruma"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$oniguruma_url" --max-time 10)
echo "$oniguruma_url → HTTP $http_code"
if [ "$http_code" == "404" ]; then
    echo "→ BROKEN URL (DISPUTED) - correct URL is https://github.com/kkos/oniguruma"
fi

echo ""
echo "Checking correct Oniguruma URL:"
correct_url="https://github.com/kkos/oniguruma"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$correct_url" --max-time 10)
echo "$correct_url → HTTP $http_code"
echo ""

# Test 10: Verify egrep/fgrep claim
echo "=== TEST 10: Check egrep/fgrep claim ==="
cd /tmp/grep
echo "R2 claims: 'No egrep/fgrep as separate binaries'"
echo ""
echo "Searching for egrep/fgrep in source tree:"
find . -name "*egrep*" -o -name "*fgrep*" 2>/dev/null
echo ""

# Test 11: Check Git history command
echo "=== TEST 11: Test git log command for mmap ==="
cd /tmp/grep
echo "Running: git log --oneline -p --grep='mmap' | head -20"
git log --oneline -p --grep="mmap" 2>/dev/null | head -20
if [ $? -ne 0 ] || [ -z "$(git log --oneline --grep='mmap' 2>/dev/null)" ]; then
    echo "→ No mmap-related commits found or limited results"
fi
echo ""

# Test 12: Verify version tag claim
echo "=== TEST 12: Check version tag (grep-3.14) ==="
cd /tmp/grep
echo "Listing all grep-* tags:"
git tag -l 'grep-*' | tail -10

echo ""
echo "Attempting to checkout grep-3.14 as claimed in R2:"
git checkout grep-3.14 2>/dev/null
if [ $? -ne 0 ]; then
    echo "→ Tag grep-3.14 NOT FOUND (DISPUTED)"
    git checkout main 2>/dev/null || git checkout master 2>/dev/null
fi
echo ""

# Test 13: Verify Apple macOS source claim
echo "=== TEST 13: Check Apple macOS source claim ==="
echo "R2 claims: 'Apple's source is proprietary' / 'usually closed source'"
echo ""
apple_url="https://opensource.apple.com/releases"
echo "Checking Apple open source releases page:"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$apple_url" --max-time 10)
echo "$apple_url → HTTP $http_code"

echo ""
echo "Checking Apple grep source mirror:"
apple_grep="https://github.com/apple-oss-distributions/grep"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$apple_grep" --max-time 10)
echo "$apple_grep → HTTP $http_code"
if [ "$http_code" == "200" ]; then
    echo "→ Apple grep source IS publicly available (DISPUTED claim)"
fi
echo ""

# Test 14: Verify CVE claim
echo "=== TEST 14: Verify CVE-2016-3253 claim ==="
cve_url="https://nvd.nist.gov/vuln/detail/CVE-2016-3253"
echo "R2 claims: CVE-2016-3253 (buffer overflow in grep prior to 2.24)"
echo "Checking NVD entry:"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$cve_url" --max-time 10)
echo "$cve_url → HTTP $http_code"

if [ "$http_code" == "200" ]; then
    echo "Fetching CVE status:"
    curl -s "$cve_url" --max-time 10 | grep -i "reject" -A 2 | head -5
fi
echo ""

# Test 15: Verify ripgrep URL
echo "=== TEST 15: Verify ripgrep URL ==="
ripgrep_url="https://github.com/BurntSushi/ripgrep"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$ripgrep_url" --max-time 10)
echo "$ripgrep_url → HTTP $http_code"
echo ""

# Summary
echo "============================================"
echo "R2 COMPREHENSIVE TEST SUITE COMPLETE"
echo "============================================"
echo ""
echo "CRITICAL FINDINGS TO VERIFY:"
echo ""
echo "1. SUBSTANTIAL: grep in Coreutils claim"
echo "   - Check if grep/ exists in Coreutils repo"
echo "   - Check if GNU lists grep as separate project"
echo ""
echo "2. SUBSTANTIAL: Oniguruma URL malformed"
echo "   - https://github.com/OniguramaOniguruma (404)"
echo "   - Correct: https://github.com/kkos/oniguruma"
echo ""
echo "3. SUBSTANTIAL: grep.html URL broken"
echo "   - https://git.savannah.gnu.org/git/grep.html (404)"
echo ""
echo "4. SUBSTANTIAL: PCRE claim disputed"
echo "   - R2 says 'does not use PCRE'"
echo "   - But pcresearch.c exists in source"
echo ""
echo "5. MINOR: Version claim (grep-3.15 Aug 2024)"
echo "   - Check actual latest version from FTP"
echo ""
echo "6. MINOR: Maintainer (Jim Blandy vs Jim Meyering)"
echo ""
echo "7. MINOR: CVE-2016-3253 status (Rejected?)"
echo ""
