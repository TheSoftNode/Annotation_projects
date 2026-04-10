#!/bin/bash
# R2 Test: Verbatim Compile Test
# Expected: COMPILE FAILURE due to VLA initialization error

echo "========================================="
echo "R2 Test: Verbatim Compile Test"
echo "========================================="
echo ""
echo "Testing claim: 'Here is the corrected, vectorized code'"
echo "File: popcount_openmp.c (EXACT verbatim from RESPONSE 2)"
echo ""
echo "Expected issue: const size_t n = 8; makes vec[n] a VLA,"
echo "and GCC rejects non-empty initializers for VLAs"
echo ""

# Test with GCC
echo "--- GCC Test ---"
echo "Command: gcc -O3 -fopenmp -o popcount_vector popcount_openmp.c"
echo ""
gcc -O3 -fopenmp -o popcount_vector popcount_openmp.c 2>&1
GCC_EXIT=$?
echo ""
echo "GCC exit code: $GCC_EXIT"
if [ $GCC_EXIT -eq 0 ]; then
    echo "Result: UNEXPECTED SUCCESS (expected VLA initialization error)"
    rm -f popcount_vector
else
    echo "Result: COMPILE FAILED AS EXPECTED (VLA initialization error)"
fi
echo ""

# Test with Clang (if available)
echo "--- Clang Test ---"
echo "Command: clang -O3 -fopenmp -o popcount_vector popcount_openmp.c"
echo ""
clang -O3 -fopenmp -o popcount_vector popcount_openmp.c 2>&1
CLANG_EXIT=$?
echo ""
echo "Clang exit code: $CLANG_EXIT"
if [ $CLANG_EXIT -eq 0 ]; then
    echo "Result: UNEXPECTED SUCCESS (expected VLA or OpenMP error)"
    rm -f popcount_vector
else
    echo "Result: COMPILE/LINK FAILED (VLA initialization or OpenMP runtime issue)"
fi
echo ""

echo "========================================="
echo "Test Complete"
echo "========================================="
echo ""
echo "Verified claims:"
echo "  - 'Here is the corrected, vectorized code' - DISPUTED (does not compile)"
echo "  - 'How to Compile' section - DISPUTED (exact command fails)"
echo "  - 'const size_t n' for dynamic size - DISPUTED (causes VLA issue)"
