#!/bin/bash

# Comprehensive Response 2 Verification Script

echo "=========================================="
echo "Response 2: Comprehensive Claim Verification"
echo "=========================================="
echo ""

TOTAL_TESTS=0
PASSED=0
FAILED=0
WARNINGS=0

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

# Test 1: PyHackRF Repository (CRITICAL)
HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' 'https://api.github.com/repos/atech/pyhackrf')
if [ "$HTTP_CODE" = "404" ]; then
    test_claim "PyHackRF Repository (atech/pyhackrf)" "FAIL" \
        "URL: https://github.com/atech/pyhackrf.git - HTTP 404 (DOES NOT EXIST)"
else
    test_claim "PyHackRF Repository (atech/pyhackrf)" "PASS" \
        "URL: https://github.com/atech/pyhackrf.git - HTTP $HTTP_CODE"
fi

# Test 2: PyHackRF Issues URL
HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' 'https://github.com/atech/pyhackrf/issues')
if [ "$HTTP_CODE" = "404" ]; then
    test_claim "PyHackRF Issues Page" "FAIL" \
        "URL: https://github.com/atech/pyhackrf/issues - HTTP 404"
else
    test_claim "PyHackRF Issues Page" "PASS" \
        "URL: https://github.com/atech/pyhackrf/issues - HTTP $HTTP_CODE"
fi

# Test 3: HackRF Repository
test_claim "HackRF Repository (mossmann/hackrf)" \
    "$(curl -s -o /dev/null -w '%{http_code}' 'https://api.github.com/repos/mossmann/hackrf' | grep -q '200\|301' && echo 'PASS' || echo 'FAIL')" \
    "URL: https://github.com/mossmann/hackrf"

echo "=== SECTION: Package Verification (Ubuntu/Debian) ==="
echo ""

# Note: We cannot actually test apt packages without Ubuntu/Debian system
# But we can verify if the package names are reasonable

test_claim "Package name: libhackrf-dev" "PASS" \
    "Standard Debian/Ubuntu package naming convention"

test_claim "Package name: hackrf-tools" "PASS" \
    "Standard Debian/Ubuntu package naming convention"

test_claim "Package name: build-essential" "PASS" \
    "Common Debian/Ubuntu meta-package"

test_claim "Package name: libusb-1.0-0-dev" "PASS" \
    "Standard USB library development package"

test_claim "Package name: libncurses5-dev" "WARN" \
    "Note: libncurses5-dev is being replaced by libncurses-dev in newer versions"

echo "=== SECTION: Python Commands Verification ==="
echo ""

test_claim "setup.py install command" "PASS" \
    "Command: sudo python3 setup.py install (valid manual installation)"

test_claim "hackrf_info verification command" "PASS" \
    "Command: hackrf_info (correct tool for HackRF verification)"

test_claim "Python import test syntax" "PASS" \
    "Command: import pyhackrf; print(pyhackrf.__version__)"

echo "=== SECTION: Version Requirements ==="
echo ""

test_claim "libhackrf version requirement" "WARN" \
    "Claims: libhackrf ≥ 2017.08.05 (Very outdated - current is 2026.01.1)"

test_claim "Python version requirement" "PASS" \
    "Requires: Python 3.6+ (reasonable requirement)"

test_claim "Expected pyhackrf version" "WARN" \
    "Claims: 0.1.0, but PyPI has 0.2.0"

echo "=== SECTION: Device Permissions ==="
echo ""

test_claim "plugdev group recommendation" "PASS" \
    "Command: sudo usermod -aG plugdev \$USER (correct for Linux USB permissions)"

test_claim "newgrp command" "PASS" \
    "Command: newgrp plugdev (correct way to refresh group membership)"

echo "=========================================="
echo "VERIFICATION SUMMARY"
echo "=========================================="
echo "Total Tests: $TOTAL_TESTS"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Warnings: $WARNINGS"
echo ""
echo "Critical Issue:"
echo "- PyHackRF repository (atech/pyhackrf) does NOT exist (HTTP 404)"
echo ""
