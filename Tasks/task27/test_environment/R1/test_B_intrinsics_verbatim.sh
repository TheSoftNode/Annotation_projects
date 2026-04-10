#!/bin/bash
# Test B: Compile popcount_intrinsics.c exactly as written
# Expected: LINK ERROR due to missing main() function

echo "========================================="
echo "R1 Test B: Intrinsics Verbatim Link Test"
echo "========================================="
echo ""
echo "Testing claim: 'Compile with: gcc -O3 -march=native -msse4.2 popcount_intrinsics.c -o popcount_sse42'"
echo "File: popcount_intrinsics.c (EXACT verbatim from RESPONSE 1)"
echo ""

echo "Command: gcc -O3 -march=native -msse4.2 popcount_intrinsics.c -o popcount_sse42"
echo ""
gcc -O3 -march=native -msse4.2 popcount_intrinsics.c -o popcount_sse42 2>&1
EXIT_CODE=$?
echo ""
echo "Exit code: $EXIT_CODE"
if [ $EXIT_CODE -eq 0 ]; then
    echo "Result: UNEXPECTED SUCCESS (expected link error)"
    rm -f popcount_sse42
else
    echo "Result: LINK FAILED AS EXPECTED (missing main function)"
fi
echo ""

echo "========================================="
echo "Test B Complete"
echo "========================================="
echo ""
echo "Verified claim:"
echo "  - Build command works - DISPUTED (snippet has no main, link fails)"
