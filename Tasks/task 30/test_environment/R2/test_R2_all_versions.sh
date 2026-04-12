#!/bin/bash

# Test R2: Verify original code and both alternative implementations

echo "=========================================================================="
echo "R2 Test: Matrix Indexing - Original and Alternative Implementations"
echo "=========================================================================="
echo ""

EXPECTED_OUTPUT="1 2 3 4 
5 6 7 8 "

# Test 1: Original implementation
echo "Test 1: Original implementation with *(matrix[i]++)"
echo "----------------------------------------------------------------------"
gcc test_R2_original.c -o test_R2_original 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Compilation FAILED for original"
    exit 1
fi

ACTUAL_OUTPUT=$(./test_R2_original)
echo "Output: $ACTUAL_OUTPUT"

if [ "$ACTUAL_OUTPUT" = "$EXPECTED_OUTPUT" ]; then
    echo "✓ Original implementation produces correct output"
else
    echo "✗ Original implementation output MISMATCH"
    exit 1
fi

echo ""

# Test 2: Alternative 1 - matrix[i][j] syntax
echo "Test 2: Alternative 1 - Using matrix[i][j] (no side effects)"
echo "----------------------------------------------------------------------"
gcc test_R2_alternative1.c -o test_R2_alternative1 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Compilation FAILED for alternative 1"
    exit 1
fi

ACTUAL_OUTPUT=$(./test_R2_alternative1)
echo "Output: $ACTUAL_OUTPUT"

if [ "$ACTUAL_OUTPUT" = "$EXPECTED_OUTPUT" ]; then
    echo "✓ Alternative 1 produces correct output"
else
    echo "✗ Alternative 1 output MISMATCH"
    exit 1
fi

echo ""

# Test 3: Alternative 2 - temporary pointer
echo "Test 3: Alternative 2 - Using temporary pointer (no side effects)"
echo "----------------------------------------------------------------------"
gcc test_R2_alternative2.c -o test_R2_alternative2 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Compilation FAILED for alternative 2"
    exit 1
fi

ACTUAL_OUTPUT=$(./test_R2_alternative2)
echo "Output: $ACTUAL_OUTPUT"

if [ "$ACTUAL_OUTPUT" = "$EXPECTED_OUTPUT" ]; then
    echo "✓ Alternative 2 produces correct output"
else
    echo "✗ Alternative 2 output MISMATCH"
    exit 1
fi

echo ""
echo "=========================================================================="
echo "Summary: All 3 implementations produce identical correct output"
echo "=========================================================================="
echo ""
echo "✓ Original: *(matrix[i]++) - modifies matrix pointers (side effects)"
echo "✓ Alternative 1: matrix[i][j] - no side effects, cleaner syntax"
echo "✓ Alternative 2: temp pointer - no side effects on matrix array"
echo ""
echo "R2 Test: PASSED"
echo "=========================================================================="
