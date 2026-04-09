#!/bin/bash
# Test C: Performance benchmarks for multiply operations

echo "============================================================"
echo "R2 Test C: Compiling and running benchmark"
echo "============================================================"
echo

echo "Compiling benchmark with -O3 optimization..."
gcc -O3 test_r2_benchmark_multiply.c -o test_r2_benchmark_multiply
echo "Compilation successful"
echo

echo "Running benchmark..."
echo "This may take 30-60 seconds..."
echo
./test_r2_benchmark_multiply
echo

# Cleanup
rm -f test_r2_benchmark_multiply

echo "Benchmark complete"
