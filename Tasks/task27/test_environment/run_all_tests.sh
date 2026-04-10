#!/bin/bash
# Master test runner for Task 27: Vectorized Popcount
# Updated to use CORRECT factual file (Factual_Gpt_R1_Task27.md)

echo "=========================================="
echo "Task 27: Vectorized Popcount Tests"
echo "=========================================="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/outputs"

mkdir -p "$OUTPUT_DIR/R1"
mkdir -p "$OUTPUT_DIR/R2"

echo "Environment check:"
echo "- GCC version: $(gcc --version 2>&1 | head -1)"
echo "- Clang version: $(clang --version 2>&1 | head -1 || echo 'Not installed')"
echo "- Platform: $(uname -s) $(uname -m)"
echo ""
echo "=========================================="

# Test R1 - Verbatim factual tests
echo ""
echo "=========================================="
echo "Running R1 Factual Tests (Verbatim Testing)"
echo "=========================================="
echo "Based on: Factual_Gpt_R1_Task27.md"
echo ""

cd "$SCRIPT_DIR/R1"

echo "[1/4] Test A: Compile popcount_vector.c verbatim..."
echo "Expected: COMPILE FAILURE (missing <stdlib.h>)"
bash test_A_verbatim_compile.sh | tee "$OUTPUT_DIR/R1/test_A_verbatim.txt"
echo ""

echo "[2/4] Test B: Compile popcount_intrinsics.c verbatim..."
echo "Expected: LINK ERROR (missing main)"
bash test_B_intrinsics_verbatim.sh | tee "$OUTPUT_DIR/R1/test_B_intrinsics.txt"
echo ""

echo "[3/4] Test C: Verify intrinsics without modifying source..."
bash test_C_verify_intrinsics.sh | tee "$OUTPUT_DIR/R1/test_C_verify.txt"
echo ""

echo "[4/4] Test D: Check compile-time error claim..."
echo "Status: DISPUTED"
bash test_D_compile_time_error.sh | tee "$OUTPUT_DIR/R1/test_D_disputed.txt"
echo ""

# Test R2 - Basic functionality
echo ""
echo "=========================================="
echo "Running R2 Basic Tests"
echo "=========================================="
echo "Note: R2 factual file tests conversation history,"
echo "not the actual R2 OpenMP SIMD code."
echo "Running basic compilation tests for R2 code:"
echo ""

cd "$SCRIPT_DIR/R2"

echo "[1/2] Basic OpenMP compilation..."
bash test_r2_basic_compile.sh | tee "$OUTPUT_DIR/R2/test_basic.txt"
echo ""

echo "[2/2] Verify OpenMP SIMD directives..."
bash test_r2_verify_openmp.sh | tee "$OUTPUT_DIR/R2/test_openmp_verify.txt"
echo ""

# Summary
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo ""
echo "All test outputs saved to: $OUTPUT_DIR"
echo ""
echo "R1 Factual Tests (Verbatim):"
echo "  - $OUTPUT_DIR/R1/test_A_verbatim.txt"
echo "  - $OUTPUT_DIR/R1/test_B_intrinsics.txt"
echo "  - $OUTPUT_DIR/R1/test_C_verify.txt"
echo "  - $OUTPUT_DIR/R1/test_D_disputed.txt"
echo ""
echo "R2 Basic Tests:"
echo "  - $OUTPUT_DIR/R2/test_basic.txt"
echo "  - $OUTPUT_DIR/R2/test_openmp_verify.txt"
echo ""
echo "Key Findings from R1 Factual Tests:"
echo "  - Test A: Expects compile failure (missing <stdlib.h>)"
echo "  - Test B: Expects link failure (missing main)"
echo "  - Test C: Verifies assembly instruction generation"
echo "  - Test D: Disputes 'compile-time error' claim"
echo ""
echo "Test run complete!"
