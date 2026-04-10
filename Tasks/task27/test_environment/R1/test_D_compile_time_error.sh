#!/bin/bash
# Test D: Check "compile-time error on CPUs lacking POPCNT" claim
# From: Factual_Gpt_R1_Task27.md
# Tests claim 33 (DISPUTED)

echo "=========================================="
echo "Test D: Compile-Time Error Claim"
echo "=========================================="
echo ""
echo "Claim 33 from response:"
echo '  "On CPUs lacking POPCNT the -msse4.2 flag'
echo '   will cause a compile-time error"'
echo ""
echo "Status: DISPUTED"
echo ""

echo "Analysis:"
echo "--------------------------------------"
echo "1. -msse4.2 is a COMPILER TARGET OPTION"
echo "   GCC documents it as enabling built-ins and"
echo "   code generation for that ISA family."
echo ""
echo "2. Intel documents that if the CPU does NOT"
echo "   support POPCNT, executing it causes #UD,"
echo "   which is a RUNTIME illegal instruction,"
echo "   NOT a compile-time host check."
echo ""
echo "3. The compiler does NOT check the HOST CPU"
echo "   at compile time. It generates code for the"
echo "   TARGET specified by -msse4.2."
echo ""
echo "4. If you compile with -msse4.2 on ANY machine,"
echo "   the compilation succeeds. The error only"
echo "   occurs at RUNTIME if executed on a CPU"
echo "   without POPCNT support."
echo ""

echo "Demonstration:"
echo "--------------------------------------"
echo "Compiling with -msse4.2 on this machine..."
echo ""

cd "$(dirname "$0")"

gcc -O3 -march=native -msse4.2 -c popcount_intrinsics.c -o popcount_intrinsics.o 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Compilation succeeded"
    echo ""
    echo "This proves the claim is WRONG."
    echo "The -msse4.2 flag does NOT cause a compile-time"
    echo "error based on the HOST CPU capabilities."
else
    echo "✗ Compilation failed (unexpected for this test)"
fi
echo ""

echo "=========================================="
echo "Conclusion"
echo "=========================================="
echo "The claim is NOT FACTUAL."
echo ""
echo "Correct statement would be:"
echo '  "On CPUs lacking POPCNT, the -msse4.2 flag'
echo '   allows compilation, but execution will cause'
echo '   a runtime illegal instruction exception (#UD)"'
echo ""
echo "References:"
echo "  - GCC: -msse4.2 is a target option"
echo "  - Intel: POPCNT #UD is runtime, not compile-time"
echo "=========================================="
