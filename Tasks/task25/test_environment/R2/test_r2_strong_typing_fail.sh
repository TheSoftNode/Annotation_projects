#!/bin/bash
# Test 5: Strong typing prevents cross-type multiplication
# R2 Claim 30: "Compiler prevents: Price p = qty * price; // Error!"

echo "============================================================"
echo "R2 Test 5: Strong Typing - Compiler Should Reject This"
echo "============================================================"
echo

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/test_r2_strong_typing_fail.cpp"

echo "Source file: $SRC"
echo

# Try compiling with g++ (or clang++ on macOS)
COMPILER=""
if command -v g++ &>/dev/null; then
    COMPILER="g++"
elif command -v clang++ &>/dev/null; then
    COMPILER="clang++"
else
    echo "ERROR: No C++ compiler found (need g++ or clang++)"
    exit 1
fi

echo "Compiling with: $COMPILER -std=c++17"
echo "------------------------------------------------------------"
echo

OUTPUT=$($COMPILER -std=c++17 "$SRC" -o /tmp/test_r2_strong_typing 2>&1)
EXIT_CODE=$?

echo "$OUTPUT"
echo

if [ $EXIT_CODE -ne 0 ]; then
    echo "RESULT: COMPILATION FAILED (as expected)"
    echo "  R2's claim is VERIFIED: the compiler rejects cross-type"
    echo "  multiplication when no operator* is defined for these types."
else
    echo "RESULT: COMPILATION SUCCEEDED (unexpected)"
    echo "  R2's claim would be DISPUTED if the compiler allows this."
    rm -f /tmp/test_r2_strong_typing
fi

echo
echo "============================================================"
echo "What this tests:"
echo "  - R2 Claim 30: 'Compiler prevents: Price p = qty * price; // Error!'"
echo "============================================================"
