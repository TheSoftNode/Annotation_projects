#!/bin/bash
# run_all_tests.sh — Master test runner for Task 42
# Run from: task42/test_environment/
#
# Usage:
#   bash run_all_tests.sh 2>&1 | tee ../test_verification/FULL_TEST_OUTPUT.md
#

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$SCRIPT_DIR/outputs/R1"
mkdir -p "$SCRIPT_DIR/outputs/R2"

echo "############################################"
echo "#  TASK 42 — FULL TEST SUITE               #"
echo "#  Linux C99 GMT Offset Retrieval           #"
echo "############################################"
echo ""
echo "Date:     $(date)"
echo "System:   $(uname -a)"
echo "GCC:      $(gcc --version | head -1)"
echo "glibc:    $(ldd --version 2>&1 | head -1)"
echo ""

echo ""
echo "============================================"
echo "  RUNNING R1 TESTS"
echo "============================================"
echo ""
bash "$SCRIPT_DIR/R1/test_r1.sh" || true

echo ""
echo ""
echo "============================================"
echo "  RUNNING R1 FACTUAL CLAIMS TESTS"
echo "============================================"
echo ""
bash "$SCRIPT_DIR/R1/test_r1_factual.sh" || true

echo ""
echo ""
echo "============================================"
echo "  RUNNING R2 TESTS"
echo "============================================"
echo ""
bash "$SCRIPT_DIR/R2/test_r2.sh" || true

echo ""
echo ""
echo "============================================"
echo "  RUNNING R2 FACTUAL CLAIMS TESTS"
echo "============================================"
echo ""
bash "$SCRIPT_DIR/R2/test_r2_factual.sh" || true

echo ""
echo ""
echo "############################################"
echo "#  ALL TESTS COMPLETE                      #"
echo "############################################"
