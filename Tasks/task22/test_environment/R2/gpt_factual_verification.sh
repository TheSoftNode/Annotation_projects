#!/bin/bash

echo "======================================"
echo "GPT Factual Verification for R2"
echo "======================================"
echo ""

echo "=== COMPILATION CHECKS ==="
echo ""
echo "Compiler check 1 (basic):"
gcc r2_main.c -o response2 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
else
    echo "✗ Compilation failed"
fi
echo ""

echo "Compiler check 2 (strict):"
gcc -Wall -Wextra -std=c11 r2_main.c -o response2 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Compilation successful with strict flags"
else
    echo "✗ Compilation failed with strict flags"
fi
echo ""

echo "=== RUNTIME TESTS ==="
echo ""
echo "Input: 40"
printf "40\n" | ./response2
echo ""

echo "Input: 35"
printf "35\n" | ./response2
echo ""

echo "Input: -5"
printf -- "-5\n" | ./response2
echo ""

echo "Input: 0"
printf "0\n" | ./response2
echo ""

echo "=== STRUCTURAL VERIFICATION ==="
echo ""
echo "nl -ba r2_main.c:"
nl -ba r2_main.c
echo ""

echo "grep -n \"if\" r2_main.c:"
grep -n "if" r2_main.c
echo ""

echo "grep -n 'Error: Please enter a positive number only.' r2_main.c:"
grep -n 'Error: Please enter a positive number only.' r2_main.c
echo ""

echo "grep -n 'is a multiple of 20' r2_main.c:"
grep -n 'is a multiple of 20' r2_main.c
echo ""

echo "grep -n 'is not a multiple of 20' r2_main.c:"
grep -n 'is not a multiple of 20' r2_main.c
echo ""
