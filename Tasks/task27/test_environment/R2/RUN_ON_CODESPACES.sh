#!/bin/bash

# Run this script on GitHub Codespaces to get the proper GCC/Linux output
# for R2 verbatim compile test

echo "==========================================="
echo "R2 Verbatim Compile Test - Linux GCC"
echo "==========================================="
echo ""

cd /workspaces/*/Tasks/task27/test_environment/R2 || {
    echo "Error: Could not find task27 directory"
    echo "Please adjust the path to match your Codespaces workspace"
    exit 1
}

echo "Running test..."
bash test_R2_verbatim_compile.sh

echo ""
echo "==========================================="
echo "To capture just the GCC error output:"
echo "==========================================="
echo ""
gcc -O3 -fopenmp -o popcount_vector popcount_openmp.c 2>&1 | grep -A 2 "error:"
