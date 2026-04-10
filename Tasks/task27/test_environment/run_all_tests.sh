#!/bin/bash
# Master test runner for Task 27
# Runs all factual verification tests for R1 and R2

echo "========================================"
echo "Task 27: Factual Verification Test Suite"
echo "========================================"
echo ""
echo "User Request: 'vectorize and solve for 0 through n'"
echo "Testing RESPONSE 1 (SIMD vector extension) and RESPONSE 2 (OpenMP SIMD)"
echo ""
echo "Environment: $(uname -s) $(uname -m)"
echo "GCC: $(gcc --version 2>&1 | head -1)"
echo "Clang: $(clang --version 2>&1 | head -1)"
echo ""
echo "NOTE: Per factual files, tests are designed for GitHub Codespaces"
echo "      Running on Mac may show different results due to compiler differences"
echo ""

# Create output directories
mkdir -p outputs/R1
mkdir -p outputs/R2

# Run R1 tests
echo "========================================"
echo "RESPONSE 1: SIMD Vector Extension Tests"
echo "========================================"
echo ""

cd R1

echo "Running Test A: Verbatim Compile Test..."
bash test_A_verbatim_compile.sh | tee ../outputs/R1/test_A_output.txt
echo ""

echo "Running Test B: Intrinsics Verbatim Link Test..."
bash test_B_intrinsics_verbatim.sh | tee ../outputs/R1/test_B_output.txt
echo ""

echo "Running Test C: Verify Intrinsics Assembly..."
bash test_C_verify_intrinsics.sh | tee ../outputs/R1/test_C_output.txt
echo ""

echo "Running Test D: Compile-Time Error Claim..."
bash test_D_compile_time_error.sh | tee ../outputs/R1/test_D_output.txt
echo ""

cd ..

# Run R2 tests
echo "========================================"
echo "RESPONSE 2: OpenMP SIMD Tests"
echo "========================================"
echo ""

cd R2

echo "Running R2 Verbatim Compile Test..."
bash test_R2_verbatim_compile.sh | tee ../outputs/R2/test_R2_output.txt
echo ""

cd ..

# Summary
echo "========================================"
echo "All Tests Complete"
echo "========================================"
echo ""
echo "Output files saved to:"
echo "  - outputs/R1/test_A_output.txt"
echo "  - outputs/R1/test_B_output.txt"
echo "  - outputs/R1/test_C_output.txt"
echo "  - outputs/R1/test_D_output.txt"
echo "  - outputs/R2/test_R2_output.txt"
echo ""
echo "Key Findings:"
echo "  R1 Test A: Expected compile failure (missing stdlib.h)"
echo "  R1 Test B: Expected link failure (missing main)"
echo "  R1 Test C: Assembly inspection for POPCNT instructions"
echo "  R1 Test D: Analysis of compile-time error claim"
echo "  R2 Test:   Expected compile failure (VLA initialization)"
