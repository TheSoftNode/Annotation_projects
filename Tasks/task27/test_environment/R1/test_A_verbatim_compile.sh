#!/bin/bash
# Test A: Compile popcount_vector.c exactly as written
# Expected: COMPILE FAILURE due to missing <stdlib.h> (malloc/free undeclared)

echo "========================================="
echo "R1 Test A: Verbatim Compile Test"
echo "========================================="
echo ""
echo "Testing claim: 'self-contained, portable example' and 'Full program (C11)'"
echo "File: popcount_vector.c (EXACT verbatim from RESPONSE 1)"
echo ""

# Test with GCC
echo "--- GCC Test ---"
echo "Command: gcc -O3 -march=native -Wall -Wextra popcount_vector.c -o popcount_vector"
echo ""
gcc -O3 -march=native -Wall -Wextra popcount_vector.c -o popcount_vector 2>&1
GCC_EXIT=$?
echo ""
echo "GCC exit code: $GCC_EXIT"
if [ $GCC_EXIT -eq 0 ]; then
    echo "Result: UNEXPECTED SUCCESS (expected compile failure)"
else
    echo "Result: COMPILE FAILED AS EXPECTED (missing stdlib.h)"
fi
echo ""

# Clean up if it somehow compiled
rm -f popcount_vector

# Test with Clang
echo "--- Clang Test ---"
echo "Command: clang -O3 -march=native -Wall -Wextra popcount_vector.c -o popcount_vector"
echo ""
clang -O3 -march=native -Wall -Wextra popcount_vector.c -o popcount_vector 2>&1
CLANG_EXIT=$?
echo ""
echo "Clang exit code: $CLANG_EXIT"
if [ $CLANG_EXIT -eq 0 ]; then
    echo "Result: UNEXPECTED SUCCESS (expected compile failure)"
else
    echo "Result: COMPILE FAILED AS EXPECTED (missing stdlib.h)"
fi
echo ""

# Clean up
rm -f popcount_vector

echo "========================================="
echo "Test A Complete"
echo "========================================="
echo ""
echo "Verified claims:"
echo "  - 'self-contained' - DISPUTED (missing stdlib.h)"
echo "  - 'portable example' - DISPUTED (missing stdlib.h)"
echo "  - 'Full program (C11)' - DISPUTED (not buildable as written)"
echo "  - 'Build with gcc/clang' - DISPUTED (exact commands fail)"
