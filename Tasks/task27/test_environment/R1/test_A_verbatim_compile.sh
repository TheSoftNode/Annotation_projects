#!/bin/bash
# Test A: Compile popcount_vector.c EXACTLY as written (verbatim)
# From: Factual_Gpt_R1_Task27.md
# Expected: COMPILE FAILURE due to missing <stdlib.h>

echo "=========================================="
echo "Test A: Compile popcount_vector.c Verbatim"
echo "=========================================="
echo ""
echo "This tests claims 1, 6, 9, 10:"
echo "  - 'self-contained, portable example'"
echo "  - 'works with GCC, Clang'"
echo "  - 'Full program (C11)'"
echo "  - Build commands work as shown"
echo ""

cd "$(dirname "$0")"

echo "Step 1: Confirm compiler availability"
echo "--------------------------------------"
gcc --version | head -1
clang --version | head -1 2>/dev/null || echo "Clang: not available"
echo ""

echo "Step 2: Run exact GCC command from response"
echo "--------------------------------------"
echo "Command: gcc -O3 -march=native -Wall -Wextra popcount_vector.c -o popcount_vector"
echo ""
gcc -O3 -march=native -Wall -Wextra popcount_vector.c -o popcount_vector 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "✗ UNEXPECTED: Compilation succeeded"
    echo "Expected: COMPILE FAILURE (missing <stdlib.h> for malloc/free)"
else
    echo ""
    echo "✓ EXPECTED: Compilation failed"
    echo "Reason: The exact response text uses malloc/free without including <stdlib.h>"
fi
echo ""

echo "Step 3: Run exact Clang command from response"
echo "--------------------------------------"
echo "Command: clang -O3 -march=native -Wall -Wextra popcount_vector.c -o popcount_vector"
echo ""

if command -v clang &> /dev/null; then
    clang -O3 -march=native -Wall -Wextra popcount_vector.c -o popcount_vector 2>&1

    if [ $? -eq 0 ]; then
        echo ""
        echo "✗ UNEXPECTED: Compilation succeeded with Clang"
        echo "Expected: COMPILE FAILURE (missing <stdlib.h> for malloc/free)"
    else
        echo ""
        echo "✓ EXPECTED: Compilation failed with Clang"
        echo "Reason: Same as GCC - missing <stdlib.h>"
    fi
else
    echo "⚠ Clang not available, skipping"
fi
echo ""

echo "=========================================="
echo "STOP POINT FOR EXACT TESTING"
echo "=========================================="
echo "Since the exact file fails to compile, running it"
echo "after editing would no longer be a verbatim test."
echo ""
echo "Reference: man7.org documents malloc/free in <stdlib.h>"
echo "=========================================="
