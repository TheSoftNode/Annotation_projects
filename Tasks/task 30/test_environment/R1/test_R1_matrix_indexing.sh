#!/bin/bash

# Test R1: Verify the matrix indexing code compiles and produces correct output

echo "=========================================================================="
echo "R1 Test: Matrix Indexing with Pointer Post-Increment"
echo "=========================================================================="
echo ""

# Compile the code
echo "Step 1: Compiling test_matrix_indexing.c..."
gcc test_matrix_indexing.c -o test_matrix_indexing 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Compilation FAILED"
    exit 1
fi

echo "✓ Compilation successful"
echo ""

# Run the program and capture output
echo "Step 2: Running the program..."
ACTUAL_OUTPUT=$(./test_matrix_indexing)

echo "Actual output:"
echo "$ACTUAL_OUTPUT"
echo ""

# Expected output (trailing space after each line)
EXPECTED_OUTPUT="1 2 3 4 
5 6 7 8 "

echo "Expected output:"
echo "$EXPECTED_OUTPUT"
echo ""

# Verify output matches
if [ "$ACTUAL_OUTPUT" = "$EXPECTED_OUTPUT" ]; then
    echo "✓ Output matches expected result"
    echo ""
    echo "Verification: The code correctly demonstrates:"
    echo "  - Array of pointers (matrix) pointing to separate arrays"
    echo "  - Post-increment pointer arithmetic: *(matrix[i]++)"
    echo "  - Sequential traversal of each row via pointer increment"
    echo "  - Output: First row (1 2 3 4), Second row (5 6 7 8)"
else
    echo "✗ Output DOES NOT match expected result"
    echo ""
    echo "Diff:"
    diff <(echo "$EXPECTED_OUTPUT") <(echo "$ACTUAL_OUTPUT")
    exit 1
fi

echo ""
echo "=========================================================================="
echo "R1 Test: PASSED"
echo "=========================================================================="
