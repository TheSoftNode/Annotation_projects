#!/bin/bash
# Test 6: Verify __int128 support
# R2 Claim 31: "On Linux/GCC/Clang (standard for HFT), __int128 is very efficient."

echo "============================================================"
echo "R2 Test 6: __int128 Support Verification"
echo "============================================================"
echo

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/test_r2_int128_support.cpp"

# Try g++ first, fall back to clang++
COMPILER=""
if command -v g++ &>/dev/null; then
    COMPILER="g++"
elif command -v clang++ &>/dev/null; then
    COMPILER="clang++"
else
    echo "ERROR: No C++ compiler found"
    exit 1
fi

echo "Compiling with: $COMPILER -std=c++17 -O2"
echo "------------------------------------------------------------"
$COMPILER -std=c++17 -O2 "$SRC" -o /tmp/test_r2_int128 2>&1

if [ $? -eq 0 ]; then
    echo "Compilation successful"
    echo
    /tmp/test_r2_int128
    rm -f /tmp/test_r2_int128
else
    echo "COMPILATION FAILED"
    echo "  __int128 may not be supported on this platform."
fi
