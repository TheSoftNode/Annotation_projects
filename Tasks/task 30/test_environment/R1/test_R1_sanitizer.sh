#!/bin/bash

# Test R1: Verify no undefined behavior using address and undefined behavior sanitizers

echo "=========================================================================="
echo "R1 Test: Sanitizer Check - No Undefined Behavior"
echo "=========================================================================="
echo ""
echo "Testing R1's claim: 'the loop ends before accessing one-past-end'"
echo ""

# Compile with sanitizers
echo "Step 1: Compiling with AddressSanitizer and UndefinedBehaviorSanitizer..."
gcc -Wall -Wextra -pedantic -std=c11 -fsanitize=address,undefined -g test_matrix_indexing.c -o test_matrix_san 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Compilation with sanitizers FAILED"
    exit 1
fi

echo "✓ Compilation successful"
echo ""

# Run with sanitizers
echo "Step 2: Running program with sanitizers..."
OUTPUT=$(./test_matrix_san 2>&1)
SANITIZER_EXIT=$?

echo "Output:"
echo "$OUTPUT"
echo ""

# Check for sanitizer errors
if echo "$OUTPUT" | grep -i "sanitizer\|ASAN\|UBSAN\|ERROR" > /dev/null; then
    echo "✗ Sanitizer detected errors"
    exit 1
fi

if [ $SANITIZER_EXIT -ne 0 ]; then
    echo "✗ Program exited with non-zero status: $SANITIZER_EXIT"
    exit 1
fi

echo "✓ No sanitizer errors detected"
echo ""
echo "Verification: R1's claim is correct - the loop ends before dereferencing"
echo "the one-past-end pointer (arr1[4] and arr2[4])"
echo ""
echo "=========================================================================="
echo "R1 Sanitizer Test: PASSED"
echo "=========================================================================="
