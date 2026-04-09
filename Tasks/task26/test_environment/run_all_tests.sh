#!/bin/bash
# Local test runner for Task 26 (runs what it can without metric-learn)
# For full testing, use CODESPACES_SETUP_AND_RUN.sh in GitHub Codespaces

echo "============================================================"
echo "TASK 26 - LOCAL TEST RUNNER"
echo "Topic: 'L-BFGS-B good or bad for MLKR?'"
echo "============================================================"
echo
echo "NOTE: Some tests require metric-learn which may not be installed locally"
echo "      For complete testing, use GitHub Codespaces"
echo
echo "============================================================"
echo

OUTPUTS_DIR="./outputs"
mkdir -p "$OUTPUTS_DIR/R1" "$OUTPUTS_DIR/R2"

# ============================================================
# R1 TESTS
# ============================================================

echo "============================================================"
echo "PART 1: RESPONSE 1 TESTS"
echo "============================================================"
echo

cd R1 2>/dev/null || cd test_environment/R1

for test in test_claim*.py test_r1*.py; do
    if [ -f "$test" ]; then
        echo "Running $test..."
        echo "------------------------------------------------------------"
        python3 "$test" 2>&1 | tee "../outputs/R1/${test%.py}_output.txt"
        echo
    fi
done

cd - > /dev/null

# ============================================================
# R2 TESTS
# ============================================================

echo "============================================================"
echo "PART 2: RESPONSE 2 TESTS"
echo "============================================================"
echo

cd R2 2>/dev/null || cd test_environment/R2

for test in test[0-9]*.py test_r2*.py; do
    if [ -f "$test" ]; then
        echo "Running $test..."
        echo "------------------------------------------------------------"
        python3 "$test" 2>&1 | tee "../outputs/R2/${test%.py}_output.txt"
        echo
    fi
done

cd - > /dev/null

# ============================================================
# SUMMARY
# ============================================================

echo "============================================================"
echo "LOCAL TESTS COMPLETE"
echo "============================================================"
echo
echo "Output files saved to: $OUTPUTS_DIR/"
echo
ls -lh "$OUTPUTS_DIR/R1/" "$OUTPUTS_DIR/R2/"
echo
echo "Next steps:"
echo "1. Review outputs for factual verification"
echo "2. Run CODESPACES_SETUP_AND_RUN.sh for metric-learn tests"
echo "3. Use outputs as source excerpts for AOIs"
echo
echo "============================================================"
