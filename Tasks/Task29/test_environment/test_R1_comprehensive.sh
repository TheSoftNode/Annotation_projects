#!/bin/bash
# Comprehensive Test Script for R1 Based on GPT Factual Verification
# This script follows the exact testing checklist from GPT_FACTUAL_R1_TASK29.md

echo "============================================"
echo "R1 COMPREHENSIVE TEST SUITE - Task 29"
echo "Testing environment: $(uname -s)"
echo "Date: $(date)"
echo "============================================"
echo ""

# Test 1: GNU grep identity check
echo "=== TEST 1: Check if grep is GNU grep ==="
grep --version | head -n 1
echo ""

# Test 2: Clone GNU grep repository
echo "=== TEST 2: Clone GNU grep repository ==="
cd /tmp
rm -rf grep
git clone https://git.savannah.gnu.org/git/grep.git
if [ -d "grep" ]; then
    echo "✓ Clone successful - grep/ directory created"
    cd grep
    git remote -v
else
    echo "✗ Clone failed"
fi
echo ""

# Test 3: Check Debian/Ubuntu package listing for source files
echo "=== TEST 3: Debian/Ubuntu package listing (dpkg -L) ==="
echo "Running: dpkg -L grep | grep -E '\.(c|h|cc|cpp)$' | head"
dpkg -L grep 2>/dev/null | grep -E '\.(c|h|cc|cpp)$' | head
if [ $? -ne 0 ] || [ -z "$(dpkg -L grep 2>/dev/null | grep -E '\.(c|h|cc|cpp)$')" ]; then
    echo "→ No source files found in installed package (expected for binary packages)"
fi
echo ""

# Test 4: Verify claimed source files in cloned repository
echo "=== TEST 4: Check claimed source files in repository ==="
cd /tmp/grep 2>/dev/null || { echo "Cannot cd to grep directory"; exit 1; }

echo "Checking src/grep.c:"
ls -l src/grep.c 2>/dev/null && echo "✓ exists" || echo "✗ not found"

echo "Checking src/dfa.c:"
ls -l src/dfa.c 2>/dev/null && echo "✓ exists" || echo "✗ not found"

echo "Checking src/xmalloc.c:"
ls -l src/xmalloc.c 2>/dev/null && echo "✓ exists" || echo "✗ NOT FOUND (DISPUTED)"

echo "Checking src/mmap.c:"
ls -l src/mmap.c 2>/dev/null && echo "✓ exists" || echo "✗ NOT FOUND (DISPUTED)"

echo "Checking src/bm.c:"
ls -l src/bm.c 2>/dev/null && echo "✓ exists" || echo "✗ NOT FOUND (DISPUTED)"

echo "Checking lib/ directory:"
ls lib 2>/dev/null | head && echo "✓ lib/ exists" || echo "✗ lib/ not found"

echo "Checking tests/ directory:"
ls tests 2>/dev/null | head && echo "✓ tests/ exists" || echo "✗ tests/ not found"
echo ""

# Test 5: Find Boyer-Moore and Aho-Corasick references
echo "=== TEST 5: Search for Boyer-Moore and Aho-Corasick in source ==="
cd /tmp/grep
echo "Searching for 'Boyer' in src/:"
grep -R -n "Boyer" src/ 2>/dev/null | head -5

echo ""
echo "Searching for 'Aho' in src/:"
grep -R -n "Aho" src/ 2>/dev/null | head -5

echo ""
echo "Checking if Boyer-Moore code is in src/kwset.c (not src/bm.c):"
grep -n "Boyer" src/kwset.c 2>/dev/null | head -3
echo ""

# Test 6: Check scan_directory function in grep.c
echo "=== TEST 6: Search for scan_directory in src/grep.c ==="
cd /tmp/grep
grep -n "scan_directory" src/grep.c 2>/dev/null
if [ $? -ne 0 ]; then
    echo "→ scan_directory NOT FOUND in src/grep.c (DISPUTED)"
fi
echo ""

# Test 7: Check for mmap usage
echo "=== TEST 7: Search for mmap in source ==="
cd /tmp/grep
grep -R -n "mmap" src/ 2>/dev/null
if [ $? -ne 0 ]; then
    echo "→ No mmap found in src/ (DISPUTED)"
fi
echo ""

# Test 8: Check egrep/fgrep behavior
echo "=== TEST 8: Check egrep/fgrep implementation ==="
if command -v egrep &> /dev/null; then
    echo "egrep found, checking details:"
    ls -l "$(command -v egrep)"
    echo ""
    echo "First 5 lines of egrep:"
    head -n 5 "$(command -v egrep)" 2>/dev/null || file "$(command -v egrep)"
else
    echo "egrep not found on this system"
fi

echo ""
if command -v fgrep &> /dev/null; then
    echo "fgrep found, checking details:"
    ls -l "$(command -v fgrep)"
    echo ""
    echo "First 5 lines of fgrep:"
    head -n 5 "$(command -v fgrep)" 2>/dev/null || file "$(command -v fgrep)"
else
    echo "fgrep not found on this system"
fi

echo ""
echo "Checking for egrep.sh in source:"
cd /tmp/grep
find . -name "*egrep*" -o -name "*fgrep*" 2>/dev/null
echo ""

# Test 9: Verify key directories structure
echo "=== TEST 9: Repository directory structure ==="
cd /tmp/grep
echo "Top-level directories:"
ls -d */ 2>/dev/null
echo ""
echo "Files in src/ (first 20):"
ls src/ 2>/dev/null | head -20
echo ""

# Test 10: Check BusyBox grep URL
echo "=== TEST 10: Verify BusyBox URL accessibility ==="
busybox_url="https://git.busybox.net/busybox/tree/"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$busybox_url" --max-time 10)
if [ "$http_code" == "200" ]; then
    echo "✓ BusyBox URL accessible: $busybox_url (HTTP $http_code)"
else
    echo "✗ BusyBox URL FAILED: $busybox_url (HTTP $http_code - DISPUTED)"
fi
echo ""

# Test 11: Check GNU grep FTP for version claim
echo "=== TEST 11: Verify grep version claim (grep-3.11 as latest 2024) ==="
ftp_url="https://ftp.gnu.org/gnu/grep/"
echo "Checking GNU FTP directory for latest versions:"
curl -s "$ftp_url" --max-time 10 | grep -E "grep-[0-9]+\.[0-9]+\.tar" | tail -5
echo ""

# Test 12: Verify BSD grep sources
echo "=== TEST 12: Verify BSD grep source URLs ==="
freebsd_url="https://cgit.freebsd.org/src/tree/usr.bin/grep/"
openbsd_url="https://github.com/openbsd/src/tree/master/usr.bin/grep"

echo "FreeBSD grep URL:"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$freebsd_url" --max-time 10)
echo "$freebsd_url → HTTP $http_code"

echo ""
echo "OpenBSD grep URL:"
http_code=$(curl -s -o /dev/null -w "%{http_code}" "$openbsd_url" --max-time 10)
echo "$openbsd_url → HTTP $http_code"
echo ""

# Test 13: Verify ripgrep and silver searcher URLs
echo "=== TEST 13: Verify alternative grep tools URLs ==="
ripgrep_url="https://github.com/BurntSushi/ripgrep"
ag_url="https://github.com/ggreer/the_silver_searcher"

http_code=$(curl -s -o /dev/null -w "%{http_code}" "$ripgrep_url" --max-time 10)
echo "ripgrep: $ripgrep_url → HTTP $http_code"

http_code=$(curl -s -o /dev/null -w "%{http_code}" "$ag_url" --max-time 10)
echo "silver searcher: $ag_url → HTTP $http_code"
echo ""

# Summary
echo "============================================"
echo "R1 COMPREHENSIVE TEST SUITE COMPLETE"
echo "============================================"
echo ""
echo "KEY FINDINGS TO VERIFY:"
echo "1. dpkg -L command likely shows NO source files (binary package)"
echo "2. src/xmalloc.c - check if exists"
echo "3. src/mmap.c - check if exists"
echo "4. src/bm.c - check if exists"
echo "5. scan_directory function - check if found in grep.c"
echo "6. Boyer-Moore code location - should be in kwset.c not bm.c"
echo "7. BusyBox URL - check HTTP status"
echo "8. grep-3.11 version claim - verify against FTP directory"
echo "9. egrep/fgrep - check if symlinks or scripts"
echo ""
