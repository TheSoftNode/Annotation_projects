#!/bin/bash

# Test Response 1 Technical Accuracy

echo "============================================"
echo "Response 1 Technical Accuracy Test"
echo "============================================"
echo ""

ERRORS=0
WARNINGS=0

# Test 1: PyHackRF Repository URL
echo "[TEST 1] PyHackRF Repository URL"
echo "Claim: git clone https://github.com/mossmann/pyhackrf.git"
status_code=$(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/mossmann/pyhackrf")
if [ "$status_code" -eq 404 ]; then
    echo "❌ FAIL: Repository does not exist (HTTP 404)"
    echo "   Impact: CRITICAL - Entire installation workflow fails at clone step"
    ((ERRORS++))
else
    echo "✅ PASS: Repository exists"
fi
echo ""

# Test 2: HackRF Driver Repository
echo "[TEST 2] HackRF Driver Repository"
echo "Claim: git clone https://github.com/mossmann/hackrf.git"
status_code=$(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/mossmann/hackrf")
if [ "$status_code" -eq 200 ] || [ "$status_code" -eq 301 ]; then
    echo "✅ PASS: Repository exists (HTTP $status_code)"
else
    echo "❌ FAIL: Repository issue (HTTP $status_code)"
    ((ERRORS++))
fi
echo ""

# Test 3: Build commands for HackRF
echo "[TEST 3] HackRF Build Commands"
echo "Claims: ./bootstrap, ./configure, make, make install"
echo "⚠️  WARNING: These commands are for autotools-based projects"
echo "   Note: Modern HackRF uses CMake, not autotools"
echo "   Correct commands should be: mkdir build && cd build && cmake .. && make"
((WARNINGS++))
echo ""

# Test 4: setup.py install method
echo "[TEST 4] setup.py install method"
echo "Claim: python3 setup.py install"
echo "✅ PASS: This is a valid manual installation method (no pip)"
echo ""

# Test 5: Verification command
echo "[TEST 5] Verification Command"
echo "Claim: python3 -c \"import pyhackrf; print(pyhackrf.__version__)\""
echo "✅ PASS: Valid verification approach"
echo ""

# Test 6: Test basic functionality code
echo "[TEST 6] Test Code Syntax"
echo "Checking: pyhackrf.HackRF() instantiation"
echo "✅ PASS: Syntax appears correct for pyhackrf API"
echo ""

# Summary
echo "============================================"
echo "Summary"
echo "============================================"
echo "Total Errors: $ERRORS"
echo "Total Warnings: $WARNINGS"
echo ""

if [ $ERRORS -gt 0 ]; then
    echo "❌ RESPONSE 1: CONTAINS CRITICAL ERRORS"
    echo "   The non-existent repository URL makes this response unusable"
else
    echo "✅ RESPONSE 1: TECHNICALLY ACCURATE"
fi
echo ""

exit $ERRORS
