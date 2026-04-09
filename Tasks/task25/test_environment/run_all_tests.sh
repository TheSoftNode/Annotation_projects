#!/bin/bash
# Master test runner for Task 25
# Runs all tests for both R1 and R2 responses

OUTPUTS_DIR="./outputs"
mkdir -p "$OUTPUTS_DIR/R1" "$OUTPUTS_DIR/R2"

echo "============================================================"
echo "TASK 25 - MASTER TEST RUNNER"
echo "Topic: 'So wouldn't floats be better?' (HFT trading)"
echo "============================================================"
echo
echo "Test Environment Information:"
echo "  Platform: $(uname -s)"
echo "  Machine: $(uname -m)"
echo "  Date: $(date)"
echo
echo "============================================================"
echo

# ============================================================
# CONVERSATION HISTORY TESTS
# ============================================================

echo "============================================================"
echo "PART 1: CONVERSATION HISTORY CODE TESTS"
echo "============================================================"
echo

if [ -f "./test_conversation_history_code.sh" ]; then
    echo "Running conversation history tests..."
    chmod +x ./test_conversation_history_code.sh
    ./test_conversation_history_code.sh | tee "$OUTPUTS_DIR/conversation_history_output.txt"
    echo
else
    echo "WARNING: test_conversation_history_code.sh not found"
    echo
fi

# ============================================================
# R1 TESTS
# ============================================================

echo "============================================================"
echo "PART 2: RESPONSE 1 TESTS"
echo "============================================================"
echo

# Test R1 - Python floating-point tests
echo "--- R1 Test: Python Floating-Point Behavior ---"
if [ -f "./R1/test_r1_python.py" ]; then
    chmod +x ./R1/test_r1_python.py
    python3 ./R1/test_r1_python.py | tee "$OUTPUTS_DIR/R1/r1_python_output.txt"
    echo
else
    echo "WARNING: R1/test_r1_python.py not found"
    echo
fi

# Test R1 - ffast-math compiler flag
echo "--- R1 Test D: -ffast-math Compiler Flag ---"
if [ -f "./R1/test_r1_ffast_math.sh" ]; then
    chmod +x ./R1/test_r1_ffast_math.sh
    ./R1/test_r1_ffast_math.sh | tee "$OUTPUTS_DIR/R1/r1_ffast_math_output.txt"
    echo
else
    echo "WARNING: R1/test_r1_ffast_math.sh not found"
    echo
fi

# Test R1 - __int128 availability
echo "--- R1 Test E: __int128 Availability ---"
if [ -f "./R1/test_r1_int128.sh" ]; then
    chmod +x ./R1/test_r1_int128.sh
    ./R1/test_r1_int128.sh | tee "$OUTPUTS_DIR/R1/r1_int128_output.txt"
    echo
else
    echo "WARNING: R1/test_r1_int128.sh not found"
    echo
fi

# Test R1 - NaN/infinity behavior
echo "--- R1 Test F: NaN and Infinity Behavior ---"
if [ -f "./R1/test_r1_fp_specials.sh" ]; then
    chmod +x ./R1/test_r1_fp_specials.sh
    ./R1/test_r1_fp_specials.sh | tee "$OUTPUTS_DIR/R1/r1_fp_specials_output.txt"
    echo
else
    echo "WARNING: R1/test_r1_fp_specials.sh not found"
    echo
fi

# ============================================================
# R2 TESTS
# ============================================================

echo "============================================================"
echo "PART 3: RESPONSE 2 TESTS"
echo "============================================================"
echo

# Test R2 - Float precision issues
echo "--- R2 Test A: Float Precision Issues ---"
if [ -f "./R2/test_r2_float_precision.py" ]; then
    chmod +x ./R2/test_r2_float_precision.py
    python3 ./R2/test_r2_float_precision.py | tee "$OUTPUTS_DIR/R2/r2_float_precision_output.txt"
    echo
else
    echo "WARNING: R2/test_r2_float_precision.py not found"
    echo
fi

# Test R2 - Float overflow behavior
echo "--- R2 Test B: Float Overflow Behavior ---"
if [ -f "./R2/test_r2_float_overflow.py" ]; then
    chmod +x ./R2/test_r2_float_overflow.py
    python3 ./R2/test_r2_float_overflow.py | tee "$OUTPUTS_DIR/R2/r2_float_overflow_output.txt"
    echo
else
    echo "WARNING: R2/test_r2_float_overflow.py not found"
    echo
fi

# Test R2 - Epsilon comparison
echo "--- R2 Test E: Float Equality Trap ---"
if [ -f "./R2/test_r2_epsilon_comparison.py" ]; then
    chmod +x ./R2/test_r2_epsilon_comparison.py
    python3 ./R2/test_r2_epsilon_comparison.py | tee "$OUTPUTS_DIR/R2/r2_epsilon_comparison_output.txt"
    echo
else
    echo "WARNING: R2/test_r2_epsilon_comparison.py not found"
    echo
fi

# Test R2 - Performance benchmark
echo "--- R2 Test C: Performance Benchmark ---"
if [ -f "./R2/test_r2_benchmark_multiply.sh" ]; then
    chmod +x ./R2/test_r2_benchmark_multiply.sh
    cd R2
    bash test_r2_benchmark_multiply.sh | tee ../outputs/R2/r2_benchmark_multiply_output.txt
    cd ..
    echo
else
    echo "WARNING: R2/test_r2_benchmark_multiply.sh not found"
    echo
fi

# ============================================================
# SUMMARY
# ============================================================

echo "============================================================"
echo "ALL TESTS COMPLETE"
echo "============================================================"
echo
echo "Output files saved to: $OUTPUTS_DIR/"
echo
ls -lh "$OUTPUTS_DIR/"
echo
echo "Next steps:"
echo "1. Review all output files for factual verification"
echo "2. Use outputs as source excerpts for AOIs"
echo "3. Begin drafting strengths and AOIs for both responses"
echo
echo "============================================================"
