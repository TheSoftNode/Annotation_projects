#!/bin/bash
# Test R2: Basic OpenMP SIMD compilation and execution

echo "=========================================="
echo "R2 Test: OpenMP SIMD Compilation"
echo "=========================================="
echo ""

cd "$(dirname "$0")"

echo "Step 1: Compiling popcount_openmp.c with OpenMP support"
echo "Command: gcc -O3 -fopenmp -o popcount_openmp popcount_openmp.c"
gcc -O3 -fopenmp -o popcount_openmp popcount_openmp.c
if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
else
    echo "✗ Compilation failed"
    exit 1
fi
echo ""

echo "Step 2: Running popcount_openmp"
./popcount_openmp
echo ""

echo "Test complete!"
