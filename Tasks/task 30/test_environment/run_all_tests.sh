#!/bin/bash

# Master test runner for Task 30 - Matrix Indexing Tests

echo "=========================================================================="
echo "Task 30: Matrix Indexing with Pointer Arithmetic - Test Suite"
echo "=========================================================================="
echo ""

# Create outputs directories
mkdir -p outputs/R1 outputs/R2

# Run R1 basic test
echo "Running R1 Basic Test..."
echo "=========================================================================="
cd R1
./test_R1_matrix_indexing.sh | tee ../outputs/R1/test_R1_basic_output.txt
R1_BASIC=$?
cd ..

echo ""
echo ""

# Run R1 sanitizer test
echo "Running R1 Sanitizer Test..."
echo "=========================================================================="
cd R1
./test_R1_sanitizer.sh | tee ../outputs/R1/test_R1_sanitizer_output.txt
R1_SAN=$?
cd ..

echo ""
echo ""

# Run R2 all versions test
echo "Running R2 All Versions Test..."
echo "=========================================================================="
cd R2
./test_R2_all_versions.sh | tee ../outputs/R2/test_R2_all_versions_output.txt
R2_VERSIONS=$?
cd ..

echo ""
echo ""

# Run R2 side effects test
echo "Running R2 Side Effects Test..."
echo "=========================================================================="
cd R2
./test_R2_side_effects.sh | tee ../outputs/R2/test_R2_side_effects_output.txt
R2_SIDE=$?
cd ..

echo ""
echo ""

# Summary
echo "=========================================================================="
echo "Test Summary"
echo "=========================================================================="
echo ""

echo "R1 Tests:"
if [ $R1_BASIC -eq 0 ]; then
    echo "  ✓ Basic Test: PASSED"
else
    echo "  ✗ Basic Test: FAILED"
fi

if [ $R1_SAN -eq 0 ]; then
    echo "  ✓ Sanitizer Test: PASSED"
else
    echo "  ✗ Sanitizer Test: FAILED"
fi

echo ""
echo "R2 Tests:"
if [ $R2_VERSIONS -eq 0 ]; then
    echo "  ✓ All Versions Test: PASSED"
else
    echo "  ✗ All Versions Test: FAILED"
fi

if [ $R2_SIDE -eq 0 ]; then
    echo "  ✓ Side Effects Test: PASSED"
else
    echo "  ✗ Side Effects Test: FAILED"
fi

echo ""

if [ $R1_BASIC -eq 0 ] && [ $R1_SAN -eq 0 ] && [ $R2_VERSIONS -eq 0 ] && [ $R2_SIDE -eq 0 ]; then
    echo "=========================================================================="
    echo "ALL TESTS PASSED (4/4)"
    echo "=========================================================================="
    exit 0
else
    echo "=========================================================================="
    echo "SOME TESTS FAILED"
    echo "=========================================================================="
    exit 1
fi
