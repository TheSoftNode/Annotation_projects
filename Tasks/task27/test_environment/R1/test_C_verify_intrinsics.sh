#!/bin/bash
# Test C: Verify intrinsics claim by compiling to object file and inspecting assembly
# This does NOT modify source - only changes compiler mode

echo "========================================="
echo "R1 Test C: Verify Intrinsics Assembly"
echo "========================================="
echo ""
echo "Testing claims about _mm_popcnt_u32 mapping to POPCNT instruction"
echo "File: popcount_intrinsics.c"
echo ""

# Compile to object file only
echo "--- Compile to Object File ---"
echo "Command: gcc -O3 -march=native -msse4.2 -c popcount_intrinsics.c -o popcount_intrinsics.o"
gcc -O3 -march=native -msse4.2 -c popcount_intrinsics.c -o popcount_intrinsics.o 2>&1
EXIT_CODE=$?
echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "Object compilation: SUCCESS"
else
    echo "Object compilation: FAILED"
    exit 1
fi
echo ""

# Inspect assembly for popcount instructions
echo "--- Inspect Assembly for POPCNT Instructions ---"
echo "Command: gcc -O3 -march=native -msse4.2 -S popcount_intrinsics.c -o - | grep -n 'popcnt\\|vpopcnt'"
echo ""
gcc -O3 -march=native -msse4.2 -S popcount_intrinsics.c -o - | grep -n "popcnt\|vpopcnt"
GREP_EXIT=$?
echo ""
if [ $GREP_EXIT -eq 0 ]; then
    echo "Found popcount-related instructions in assembly"
else
    echo "No popcount instructions found (may indicate scalar fallback)"
fi
echo ""

# Check what -march=native enabled
echo "--- Check -march=native Capabilities ---"
echo "Command: gcc -march=native -Q --help=target | egrep 'sse4.2|popcnt|avx512vpopcntdq|avx512bitalg'"
echo ""
gcc -march=native -Q --help=target | egrep "sse4.2|popcnt|avx512vpopcntdq|avx512bitalg"
echo ""

# Clean up
rm -f popcount_intrinsics.o

echo "========================================="
echo "Test C Complete"
echo "========================================="
echo ""
echo "This verifies:"
echo "  - _mm_popcnt_u32 intrinsic usage"
echo "  - Whether POPCNT/VPOPCNT instructions appear in assembly"
echo "  - What CPU features -march=native enables"
