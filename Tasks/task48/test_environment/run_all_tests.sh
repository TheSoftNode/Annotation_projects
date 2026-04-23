#!/bin/bash

# =============================================================================
# Task 48 - Comprehensive Test Script
# Tests all code samples from Response 1 and Response 2
# Per guidance from Factual_R1_Task48.md and Factual_R2_Task48.md
# =============================================================================

OUTPUT_DIR="outputs"
mkdir -p "$OUTPUT_DIR"

R1_OUTPUT="$OUTPUT_DIR/R1_test_results.txt"
R2_OUTPUT="$OUTPUT_DIR/R2_test_results.txt"

# Clear previous outputs
> "$R1_OUTPUT"
> "$R2_OUTPUT"

echo "================================================================="
echo "TASK 48 - BASH CALCULATOR SCRIPT TESTING"
echo "================================================================="
echo ""
echo "Environment:"
bash --version | head -1
command -v bc >/dev/null && echo "bc: installed" || echo "bc: NOT FOUND"
echo ""

# =============================================================================
# RESPONSE 1 TESTS
# =============================================================================

echo "=================================================================" | tee -a "$R1_OUTPUT"
echo "RESPONSE 1 TESTS" | tee -a "$R1_OUTPUT"
echo "=================================================================" | tee -a "$R1_OUTPUT"
echo "" | tee -a "$R1_OUTPUT"

cd R1 || exit 1

# -----------------------------------------------------------------------------
# TEST O: ORIGINAL SCRIPT
# -----------------------------------------------------------------------------

echo "=== TEST O: ORIGINAL SCRIPT ===" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test O1: Normal addition (3 + 4) ---" | tee -a "../$R1_OUTPUT"
echo -e "3\n4\n+" | bash original.sh > /tmp/o1.txt 2>&1
cat /tmp/o1.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $?" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test O2: Integer division (2 / 4) ---" | tee -a "../$R1_OUTPUT"
echo -e "2\n4\n/" | bash original.sh > /tmp/o2.txt 2>&1
cat /tmp/o2.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $?" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test O3: Divide by zero (8 / 0) ---" | tee -a "../$R1_OUTPUT"
echo -e "8\n0\n/" | bash original.sh > /tmp/o3.txt 2>&1
EXIT_O3=$?
cat /tmp/o3.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_O3" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test O4: Invalid operator (8 % 3) ---" | tee -a "../$R1_OUTPUT"
echo -e "8\n3\n%" | bash original.sh > /tmp/o4.txt 2>&1
EXIT_O4=$?
cat /tmp/o4.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_O4" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test O5: Non-numeric input (ten + 4) ---" | tee -a "../$R1_OUTPUT"
echo -e "ten\n4\n+" | bash original.sh > /tmp/o5.txt 2>&1
EXIT_O5=$?
cat /tmp/o5.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_O5" | tee -a "../$R1_OUTPUT"
echo "CRITICAL TEST: Does 'ten' cause arithmetic failure as claimed?" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

# -----------------------------------------------------------------------------
# TEST M: MINIMAL VERSION
# -----------------------------------------------------------------------------

echo "=== TEST M: MINIMAL VERSION ===" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test M1: Valid multiplication (6 * 7) ---" | tee -a "../$R1_OUTPUT"
echo -e "6\n7\n*" | bash minimal.sh > /tmp/m1.txt 2>&1
EXIT_M1=$?
cat /tmp/m1.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_M1" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test M2: Invalid first number (ten + 7) ---" | tee -a "../$R1_OUTPUT"
echo -e "ten\n7\n+" | bash minimal.sh > /tmp/m2.txt 2>&1
EXIT_M2=$?
cat /tmp/m2.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_M2" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test M3: Divide by zero (8 / 0) ---" | tee -a "../$R1_OUTPUT"
echo -e "8\n0\n/" | bash minimal.sh > /tmp/m3.txt 2>&1
EXIT_M3=$?
cat /tmp/m3.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_M3" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test M4: Invalid operator (8 % 3) ---" | tee -a "../$R1_OUTPUT"
echo -e "8\n3\n%" | bash minimal.sh > /tmp/m4.txt 2>&1
EXIT_M4=$?
cat /tmp/m4.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_M4" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

# -----------------------------------------------------------------------------
# TEST C: CLEANED VERSION
# -----------------------------------------------------------------------------

echo "=== TEST C: CLEANED VERSION ===" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test C1: Valid addition (3 + 4) ---" | tee -a "../$R1_OUTPUT"
echo -e "3\n4\n+" | bash cleaned.sh > /tmp/c1.txt 2>&1
EXIT_C1=$?
cat /tmp/c1.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_C1" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test C2: Integer division (2 / 4) ---" | tee -a "../$R1_OUTPUT"
echo -e "2\n4\n/" | bash cleaned.sh > /tmp/c2.txt 2>&1
EXIT_C2=$?
cat /tmp/c2.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_C2" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test C3: Multiplication (6 * 7) - CRITICAL TEST ---" | tee -a "../$R1_OUTPUT"
echo "Response claims multiplication is supported but case statement may have bug" | tee -a "../$R1_OUTPUT"
echo -e "6\n7\n*" | bash cleaned.sh > /tmp/c3.txt 2>&1
EXIT_C3=$?
cat /tmp/c3.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_C3" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

echo "--- Test C4: Operator validation with 'foo' - CRITICAL TEST ---" | tee -a "../$R1_OUTPUT"
echo "Testing if read_operator accepts invalid input due to * wildcard" | tee -a "../$R1_OUTPUT"
echo -e "3\n4\nfoo" | timeout 5 bash cleaned.sh > /tmp/c4.txt 2>&1
EXIT_C4=$?
cat /tmp/c4.txt | tee -a "../$R1_OUTPUT"
echo "Exit code: $EXIT_C4" | tee -a "../$R1_OUTPUT"
echo "" | tee -a "../$R1_OUTPUT"

cd ..

# =============================================================================
# RESPONSE 2 TESTS
# =============================================================================

echo "=================================================================" | tee -a "$R2_OUTPUT"
echo "RESPONSE 2 TESTS" | tee -a "$R2_OUTPUT"
echo "=================================================================" | tee -a "$R2_OUTPUT"
echo "" | tee -a "$R2_OUTPUT"

cd R2 || exit 1

# -----------------------------------------------------------------------------
# TEST A: ORIGINAL SCRIPT (Same as R1 but testing R2's claims)
# -----------------------------------------------------------------------------

echo "=== TEST A: ORIGINAL SCRIPT (R2 Claims) ===" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test A1: Addition (3 + 4) ---" | tee -a "../$R2_OUTPUT"
echo -e "3\n4\n+" | bash original.sh > /tmp/a1.txt 2>&1
cat /tmp/a1.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $?" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test A2: Integer division (5 / 2) ---" | tee -a "../$R2_OUTPUT"
echo "R2 claims: result=$((5 / 2)) gives 2, not 2.5" | tee -a "../$R2_OUTPUT"
echo -e "5\n2\n/" | bash original.sh > /tmp/a2.txt 2>&1
cat /tmp/a2.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $?" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test A3: Invalid input 'abc' - CRITICAL TEST ---" | tee -a "../$R2_OUTPUT"
echo "R2 claims: number1=abc causes 'error: invalid number'" | tee -a "../$R2_OUTPUT"
echo -e "abc\n5\n+" | bash original.sh > /tmp/a3.txt 2>&1
EXIT_A3=$?
cat /tmp/a3.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $EXIT_A3" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test A4: Blank input - CRITICAL TEST ---" | tee -a "../$R2_OUTPUT"
echo "R2 claims: blank input causes syntax error" | tee -a "../$R2_OUTPUT"
echo -e "\n5\n+" | bash original.sh > /tmp/a4.txt 2>&1
EXIT_A4=$?
cat /tmp/a4.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $EXIT_A4" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test A5: Decimal input '3.5' - CRITICAL TEST ---" | tee -a "../$R2_OUTPUT"
echo "R2 claims: 3.5 causes syntax error" | tee -a "../$R2_OUTPUT"
echo -e "3.5\n2\n+" | bash original.sh > /tmp/a5.txt 2>&1
EXIT_A5=$?
cat /tmp/a5.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $EXIT_A5" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

# -----------------------------------------------------------------------------
# TEST I: IMPROVED VERSION
# -----------------------------------------------------------------------------

echo "=== TEST I: IMPROVED VERSION ===" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test I1: Addition (5 + 3) ---" | tee -a "../$R2_OUTPUT"
echo -e "5\n3\n+" | bash improved.sh > /tmp/i1.txt 2>&1
cat /tmp/i1.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $?" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test I2: Multiplication (8 * 2) ---" | tee -a "../$R2_OUTPUT"
echo -e "8\n2\n*" | bash improved.sh > /tmp/i2.txt 2>&1
cat /tmp/i2.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $?" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test I3: Divide by zero (10 / 0) - CRITICAL TEST ---" | tee -a "../$R2_OUTPUT"
echo "Testing if script exits with error code (R2 summary table claims it should)" | tee -a "../$R2_OUTPUT"
echo -e "10\n0\n/" | bash improved.sh > /tmp/i3.txt 2>&1
EXIT_I3=$?
cat /tmp/i3.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $EXIT_I3" | tee -a "../$R2_OUTPUT"
echo "Expected: Should exit with code 1 per summary table" | tee -a "../$R2_OUTPUT"
echo "Actual: $EXIT_I3" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test I4: Invalid input 'abc' ---" | tee -a "../$R2_OUTPUT"
echo -e "abc\n5\n+" | bash improved.sh > /tmp/i4.txt 2>&1
EXIT_I4=$?
cat /tmp/i4.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $EXIT_I4" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test I5: Invalid operator (5 % 3) - CRITICAL TEST ---" | tee -a "../$R2_OUTPUT"
echo "Testing if invalid operator is properly rejected" | tee -a "../$R2_OUTPUT"
echo -e "5\n3\n%" | bash improved.sh > /tmp/i5.txt 2>&1
EXIT_I5=$?
cat /tmp/i5.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $EXIT_I5" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

echo "--- Test I6: Division (10 / 2) ---" | tee -a "../$R2_OUTPUT"
echo -e "10\n2\n/" | bash improved.sh > /tmp/i6.txt 2>&1
EXIT_I6=$?
cat /tmp/i6.txt | tee -a "../$R2_OUTPUT"
echo "Exit code: $EXIT_I6" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

# -----------------------------------------------------------------------------
# TEST BC: FLOATING-POINT BONUS
# -----------------------------------------------------------------------------

echo "=== TEST BC: FLOATING-POINT WITH BC ===" | tee -a "../$R2_OUTPUT"
echo "" | tee -a "../$R2_OUTPUT"

if command -v bc >/dev/null 2>&1; then
  echo "--- Test BC: Floating-point division (5 / 2) with bc ---" | tee -a "../$R2_OUTPUT"
  echo "Testing the bonus bc example from R2" | tee -a "../$R2_OUTPUT"
  RESULT_BC=$(echo "scale=2; 5 / 2" | bc -l 2>&1)
  BC_EXIT=$?
  echo "Command: echo \"scale=2; 5 / 2\" | bc -l" | tee -a "../$R2_OUTPUT"
  echo "Result: $RESULT_BC" | tee -a "../$R2_OUTPUT"
  echo "Exit code: $BC_EXIT" | tee -a "../$R2_OUTPUT"
  echo "" | tee -a "../$R2_OUTPUT"
else
  echo "bc not available - skipping floating-point test" | tee -a "../$R2_OUTPUT"
  echo "" | tee -a "../$R2_OUTPUT"
fi

cd ..

# =============================================================================
# SUMMARY
# =============================================================================

echo ""
echo "================================================================="
echo "TEST EXECUTION COMPLETE"
echo "================================================================="
echo ""
echo "Results saved to:"
echo "  - $R1_OUTPUT"
echo "  - $R2_OUTPUT"
echo ""
echo "Test Summary:"
echo "  R1 Tests: O1-O5 (original), M1-M4 (minimal), C1-C4 (cleaned) = 13 tests"
echo "  R2 Tests: A1-A5 (original), I1-I6 (improved), BC (bonus) = 12 tests"
echo "  Total: 25 tests"
echo ""
echo "Critical tests to review:"
echo "  R1 Test O5: Non-numeric input behavior (does 'ten' cause arithmetic error?)"
echo "  R1 Test C3: Multiplication in cleaned version (wildcard bug in case statement)"
echo "  R1 Test C4: Operator validation (does * wildcard accept invalid input?)"
echo "  R2 Test A3: 'abc' input error claim (does it cause 'invalid number' error?)"
echo "  R2 Test A4: Blank input error claim (does it cause syntax error?)"
echo "  R2 Test A5: Decimal input '3.5' error claim (does it cause syntax error?)"
echo "  R2 Test I3: Division by zero exit code (does it exit with code 1?)"
echo "  R2 Test I5: Invalid operator handling in improved version"
echo ""
