#!/bin/bash
# Test C: Verify intrinsics claim without modifying file
# From: Factual_Gpt_R1_Task27.md
# Tests claims 23, 24, 25, 31 about instruction generation

echo "=========================================="
echo "Test C: Verify Intrinsics (No Source Modification)"
echo "=========================================="
echo ""
echo "This tests claims about:"
echo "  - Vector instruction generation"
echo "  - _mm_popcnt_u32 → POPCNT mapping"
echo "  - Assembly instruction patterns"
echo ""

cd "$(dirname "$0")"

echo "Step 1: Compile to object file only"
echo "--------------------------------------"
echo "Command: gcc -O3 -march=native -msse4.2 -c popcount_intrinsics.c -o popcount_intrinsics.o"
echo ""
gcc -O3 -march=native -msse4.2 -c popcount_intrinsics.c -o popcount_intrinsics.o 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Object compilation succeeded"
else
    echo "✗ Object compilation failed"
    echo "Your environment may not have SSE4.2 support"
    exit 1
fi
echo ""

echo "Step 2: Inspect assembly for popcount instructions"
echo "--------------------------------------"
echo "Command: gcc -O3 -march=native -msse4.2 -S popcount_intrinsics.c -o - | grep -n 'popcnt\|vpopcnt'"
echo ""
echo "Looking for:"
echo "  - popcntl / popcntq (scalar POPCNT)"
echo "  - vpopcntd (vector popcount, AVX-512 only)"
echo ""

ASM_OUTPUT=$(gcc -O3 -march=native -msse4.2 -S popcount_intrinsics.c -o - 2>&1 | grep -n "popcnt\|vpopcnt")

if [ -n "$ASM_OUTPUT" ]; then
    echo "$ASM_OUTPUT"
    echo ""

    if echo "$ASM_OUTPUT" | grep -q "popcntl\|popcntq"; then
        echo "✓ Found scalar POPCNT instructions"
        echo "  This supports the claim that _mm_popcnt_u32 maps to POPCNT"
    fi

    if echo "$ASM_OUTPUT" | grep -q "vpopcnt"; then
        echo "✓ Found vector popcount instructions"
        echo "  This indicates AVX-512 VPOPCNTDQ support"
    fi
else
    echo "⚠ No popcount instructions found in assembly"
    echo "  The compiler may have used a different strategy"
fi
echo ""

echo "Step 3: Inspect what -march=native enabled"
echo "--------------------------------------"
echo "Command: gcc -march=native -Q --help=target | egrep 'sse4.2|popcnt|avx512vpopcntdq|avx512bitalg'"
echo ""

MARCH_OUTPUT=$(gcc -march=native -Q --help=target 2>&1 | egrep "sse4.2|popcnt|avx512vpopcntdq|avx512bitalg")

if [ -n "$MARCH_OUTPUT" ]; then
    echo "$MARCH_OUTPUT"
else
    echo "⚠ No relevant ISA features found"
fi
echo ""

echo "=========================================="
echo "Conclusion"
echo "=========================================="
echo "GCC documents -march=native as selecting"
echo "instruction subsets supported by the local machine."
echo ""
echo "Intel distinguishes:"
echo "  - Scalar POPCNT (SSE4.2)"
echo "  - Vector popcount (AVX-512VPOPCNTDQ, AVX-512BITALG)"
echo "=========================================="
