#!/bin/bash
# Test B: Compile popcount_intrinsics.c EXACTLY as written (verbatim)
# From: Factual_Gpt_R1_Task27.md
# Expected: LINK ERROR due to missing main()

echo "=========================================="
echo "Test B: Compile popcount_intrinsics.c Verbatim"
echo "=========================================="
echo ""
echo "This tests claim 32:"
echo "  - Build command validity for the exact snippet"
echo ""

cd "$(dirname "$0")"

echo "Step 1: Run exact compile command from response"
echo "--------------------------------------"
echo "Command: gcc -O3 -march=native -msse4.2 popcount_intrinsics.c -o popcount_sse42"
echo ""
gcc -O3 -march=native -msse4.2 popcount_intrinsics.c -o popcount_sse42 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "✗ UNEXPECTED: Link succeeded"
    echo "Expected: LINK ERROR (missing main function)"
else
    echo ""
    echo "✓ EXPECTED: Link failed"
    echo "Reason: The snippet ends with '/* ... same main() as before ... */'"
    echo "        so it is not a complete standalone program"
fi
echo ""

echo "=========================================="
echo "Conclusion"
echo "=========================================="
echo "The exact build command is NOT valid for the exact snippet."
echo "The snippet requires a main() function from elsewhere."
echo "=========================================="
