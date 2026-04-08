#!/bin/bash

echo "=== Testing R2 Main Version ==="
gcc r2_main.c -o r2_main
if [ $? -eq 0 ]; then
    echo "Compilation successful"
    echo ""
    echo "Test 1: Input 40 (multiple of 20)"
    echo "40" | ./r2_main
    echo ""
    echo "Test 2: Input 35 (not multiple of 20)"
    echo "35" | ./r2_main
    echo ""
    echo "Test 3: Input -5 (negative)"
    echo "-5" | ./r2_main
    echo ""
    echo "Test 4: Input 0 (zero)"
    echo "0" | ./r2_main
    echo ""
    echo "Test 5: Input 20 (edge case)"
    echo "20" | ./r2_main
    echo ""
    echo "Test 6: Input 100 (multiple of 20)"
    echo "100" | ./r2_main
else
    echo "Compilation failed"
fi
