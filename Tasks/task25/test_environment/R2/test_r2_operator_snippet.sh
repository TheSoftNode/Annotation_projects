#!/bin/bash
# Test 7: Verify R2's operator* snippet is incomplete
# The snippet uses safe_multiply() and SCALE which are never defined.

echo "============================================================"
echo "R2 Test 7: operator* Snippet Completeness Check"
echo "============================================================"
echo

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/test_r2_operator_snippet.cpp"

echo "Source file: $SRC"
echo

# Try compiling
COMPILER=""
if command -v g++ &>/dev/null; then
    COMPILER="g++"
elif command -v clang++ &>/dev/null; then
    COMPILER="clang++"
else
    echo "ERROR: No C++ compiler found"
    exit 1
fi

echo "Compiling with: $COMPILER -std=c++17"
echo "------------------------------------------------------------"
echo

OUTPUT=$($COMPILER -std=c++17 "$SRC" -o /tmp/test_r2_operator_snippet 2>&1)
EXIT_CODE=$?

echo "$OUTPUT"
echo

if [ $EXIT_CODE -ne 0 ]; then
    echo "RESULT: COMPILATION FAILED (as expected)"
    echo "  The snippet is illustrative, not standalone."
    echo "  'safe_multiply' and 'SCALE' are undefined."
else
    echo "RESULT: COMPILATION SUCCEEDED (unexpected)"
    rm -f /tmp/test_r2_operator_snippet
fi

echo
echo "============================================================"
echo "What this tests:"
echo "  - R2's operator* code snippet used safe_multiply() and SCALE"
echo "    which are never defined, making it incomplete as-is."
echo "============================================================"
