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
echo "NOTE: R2 is OFF-TOPIC - it answers about Linux kernel"
echo "      schedule_work() instead of floats vs integers"
echo

# Test R2 - Kernel header verification
echo "--- R2 Test: Kernel Header Verification ---"
if [ -f "./R2/test_r2_kernel_headers.sh" ]; then
    chmod +x ./R2/test_r2_kernel_headers.sh
    ./R2/test_r2_kernel_headers.sh | tee "$OUTPUTS_DIR/R2/r2_kernel_headers_output.txt"
    echo
else
    echo "WARNING: R2/test_r2_kernel_headers.sh not found"
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
echo "3. Note R2's off-topic issue as a major AOI"
echo
echo "============================================================"
