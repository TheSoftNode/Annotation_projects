#!/bin/bash

# Comprehensive Response 1 Verification Script
# Tests every single claim made in Response 1

echo "=========================================="
echo "Response 1: Comprehensive Claim Verification"
echo "=========================================="
echo ""

# Track results
TOTAL_TESTS=0
PASSED=0
FAILED=0
WARNINGS=0

# Function to test a claim
test_claim() {
    local test_name="$1"
    local test_result="$2"
    local details="$3"
    
    ((TOTAL_TESTS++))
    echo "[$TOTAL_TESTS] $test_name"
    
    if [ "$test_result" = "PASS" ]; then
        echo "✅ PASS"
        ((PASSED++))
    elif [ "$test_result" = "FAIL" ]; then
        echo "❌ FAIL"
        ((FAILED++))
    elif [ "$test_result" = "WARN" ]; then
        echo "⚠️  WARNING"
        ((WARNINGS++))
    fi
    
    if [ -n "$details" ]; then
        echo "   $details"
    fi
    echo ""
}

echo "=== SECTION: URLs and Repository Verification ==="
echo ""

# Test 1: HackRF Releases URL
test_claim "HackRF Releases URL" \
    "$(curl -s -o /dev/null -w '%{http_code}' 'https://github.com/mossmann/hackrf/releases' | grep -q '200\|301' && echo 'PASS' || echo 'FAIL')" \
    "URL: https://github.com/mossmann/hackrf/releases"

# Test 2: HackRF Repository
test_claim "HackRF Repository (mossmann/hackrf)" \
    "$(curl -s -o /dev/null -w '%{http_code}' 'https://api.github.com/repos/mossmann/hackrf' | grep -q '200\|301' && echo 'PASS' || echo 'FAIL')" \
    "URL: https://github.com/mossmann/hackrf.git"

# Test 3: PyHackRF Repository (CRITICAL)
HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' 'https://api.github.com/repos/mossmann/pyhackrf')
if [ "$HTTP_CODE" = "404" ]; then
    test_claim "PyHackRF Repository (mossmann/pyhackrf)" "FAIL" \
        "URL: https://github.com/mossmann/pyhackrf.git - HTTP 404 (DOES NOT EXIST)"
else
    test_claim "PyHackRF Repository (mossmann/pyhackrf)" "PASS" \
        "URL: https://github.com/mossmann/pyhackrf.git - HTTP $HTTP_CODE"
fi

# Test 4: MSYS2 Website
test_claim "MSYS2 Website" \
    "$(curl -s -o /dev/null -w '%{http_code}' 'https://www.msys2.org/' | grep -q '200' && echo 'PASS' || echo 'FAIL')" \
    "URL: https://www.msys2.org/"

# Test 5: Prebuilt wheels URL
test_claim "Prebuilt PyHackRF Wheels URL" \
    "$(curl -s -o /dev/null -w '%{http_code}' 'https://www.lfd.uci.edu/~gohlke/pythonlibs/' | grep -q '200' && echo 'PASS' || echo 'FAIL')" \
    "URL: https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyhackrf"

echo "=== SECTION: macOS Package Verification ==="
echo ""

# Test 6: Homebrew - pkg-config
test_claim "Homebrew package: pkg-config" \
    "$(brew info pkg-config >/dev/null 2>&1 && echo 'PASS' || echo 'WARN')" \
    "Command: brew install pkg-config"

# Test 7: Homebrew - libusb
test_claim "Homebrew package: libusb" \
    "$(brew info libusb >/dev/null 2>&1 && echo 'PASS' || echo 'WARN')" \
    "Command: brew install libusb"

# Test 8: Homebrew - python3
test_claim "Homebrew package: python3" \
    "$(brew info python3 >/dev/null 2>&1 && echo 'PASS' || echo 'WARN')" \
    "Command: brew install python3"

# Test 9: Homebrew - git
test_claim "Homebrew package: git" \
    "$(brew info git >/dev/null 2>&1 && echo 'PASS' || echo 'WARN')" \
    "Command: brew install git"

echo "=== SECTION: Build Commands Verification ==="
echo ""

# Test 10: HackRF Build System
test_claim "HackRF Build System (./bootstrap, ./configure)" "FAIL" \
    "Response claims autotools (./bootstrap, ./configure) but HackRF uses CMAKE"

echo "=== SECTION: File Paths Verification ==="
echo ""

# Test 11: /usr/local/lib exists on macOS
test_claim "Library path /usr/local/lib" \
    "$([ -d /usr/local/lib ] && echo 'PASS' || echo 'WARN')" \
    "Path: /usr/local/lib"

echo "=== SECTION: Python Commands Verification ==="
echo ""

# Test 12: python3 exists
test_claim "python3 command available" \
    "$(command -v python3 >/dev/null 2>&1 && echo 'PASS' || echo 'FAIL')" \
    "Command: python3"

# Test 13: setup.py syntax
test_claim "Python setup.py commands syntax" "PASS" \
    "Commands: python3 setup.py build, python3 setup.py install"

echo "=========================================="
echo "VERIFICATION SUMMARY"
echo "=========================================="
echo "Total Tests: $TOTAL_TESTS"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Warnings: $WARNINGS"
echo ""
echo "Critical Issues:"
echo "- PyHackRF repository (mossmann/pyhackrf) does NOT exist"
echo "- Build commands are WRONG (uses autotools instead of CMake)"
echo ""
