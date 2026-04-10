#!/bin/bash
# Test R2: Verify OpenMP SIMD directives are respected

echo "=========================================="
echo "R2 Test: Verify OpenMP SIMD"
echo "=========================================="
echo ""

cd "$(dirname "$0")"

echo "Generating assembly with verbose annotations..."
echo "Command: gcc -O3 -fopenmp -fverbose-asm -S popcount_openmp.c -o popcount_openmp.s"
gcc -O3 -fopenmp -fverbose-asm -S popcount_openmp.c -o popcount_openmp.s
echo ""

echo "Searching for SIMD/vectorization in assembly:"
echo "Looking for: popcnt, vector instructions, SIMD patterns"
echo ""

grep -E "popcnt|vpand|vpsrlw|vpaddw|xmm|ymm" popcount_openmp.s | head -20

if grep -qE "popcnt|vpand|vpsrlw|vpaddw|xmm|ymm" popcount_openmp.s; then
    echo ""
    echo "✓ Vectorization detected: SIMD instructions found in assembly"
else
    echo ""
    echo "⚠ No obvious SIMD instructions detected"
fi

echo ""
echo "Assembly file saved as: popcount_openmp.s"
echo ""

echo "Test complete!"
