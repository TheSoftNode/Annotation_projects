#!/bin/bash
# Complete setup and test runner for Task 26 in GitHub Codespaces
# Tests scikit-learn, scipy, and metric-learn claims from both responses

echo "============================================================"
echo "TASK 26 - CODESPACES SETUP AND TEST RUNNER"
echo "Topic: 'L-BFGS-B good or bad for MLKR?'"
echo "============================================================"
echo

# ============================================================
# PART 1: SETUP VIRTUAL ENVIRONMENT
# ============================================================

echo "============================================================"
echo "PART 1: Setting up Python environment..."
echo "============================================================"
echo

python3 -m venv venv
source venv/bin/activate

python -m pip install -U pip
echo

echo "Installing dependencies: scikit-learn, scipy, metric-learn"
echo "------------------------------------------------------------"
pip install scikit-learn scipy metric-learn

echo
python -V
echo

echo "Verifying installations:"
python -m pip show scikit-learn scipy metric-learn
echo

# ============================================================
# PART 2: RUN R1 TESTS
# ============================================================

echo "============================================================"
echo "PART 2: Running R1 Tests"
echo "============================================================"
echo

cd R1

for test in test_claim*.py; do
    echo "Running $test..."
    echo "------------------------------------------------------------"
    python3 "$test" | tee "../outputs/R1/${test%.py}_output.txt"
    echo
done

cd ..

# ============================================================
# PART 3: RUN R2 TESTS
# ============================================================

echo "============================================================"
echo "PART 3: Running R2 Tests"
echo "============================================================"
echo

cd R2

for test in test*.py; do
    echo "Running $test..."
    echo "------------------------------------------------------------"
    python3 "$test" | tee "../outputs/R2/${test%.py}_output.txt"
    echo
done

cd ..

# ============================================================
# SUMMARY
# ============================================================

echo "============================================================"
echo "ALL TESTS COMPLETE"
echo "============================================================"
echo
echo "Output files saved to:"
echo "  - outputs/R1/"
echo "  - outputs/R2/"
echo
echo "Key findings to review:"
echo "  R1: Check if MLKR interpretation and sklearn-contrib/mkl URL are correct"
echo "  R2: Check code snippet completeness and solver recommendations"
echo
echo "============================================================"
