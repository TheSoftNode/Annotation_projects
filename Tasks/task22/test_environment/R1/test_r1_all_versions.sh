#!/bin/bash

echo "=== Testing R1 Version 1 ==="
gcc r1_version1.c -o r1_v1
if [ $? -eq 0 ]; then
    echo "Compilation successful"
    echo ""
    echo "Test 1: Input 40 (multiple of 20)"
    echo "40" | ./r1_v1
    echo ""
    echo "Test 2: Input 35 (not multiple of 20)"
    echo "35" | ./r1_v1
    echo ""
    echo "Test 3: Input -5 (negative)"
    echo "-5" | ./r1_v1
    echo ""
    echo "Test 4: Input 0 (zero)"
    echo "0" | ./r1_v1
    echo ""
    echo "Test 5: Input 20 (edge case)"
    echo "20" | ./r1_v1
else
    echo "Compilation failed"
fi

echo ""
echo "=== Testing R1 Version 2 ==="
gcc r1_version2.c -o r1_v2
if [ $? -eq 0 ]; then
    echo "Compilation successful"
    echo ""
    echo "Test 1: Input 40"
    echo "40" | ./r1_v2
    echo ""
    echo "Test 2: Input 35"
    echo "35" | ./r1_v2
    echo ""
    echo "Test 3: Input -5"
    echo "-5" | ./r1_v2
    echo ""
    echo "Test 4: Input 0"
    echo "0" | ./r1_v2
else
    echo "Compilation failed"
fi

echo ""
echo "=== Testing R1 Version 3 ==="
gcc r1_version3.c -o r1_v3
if [ $? -eq 0 ]; then
    echo "Compilation successful"
    echo ""
    echo "Test 1: Input 40"
    echo "40" | ./r1_v3
    echo ""
    echo "Test 2: Input 35"
    echo "35" | ./r1_v3
    echo ""
    echo "Test 3: Input -5"
    echo "-5" | ./r1_v3
    echo ""
    echo "Test 4: Input 0"
    echo "0" | ./r1_v3
else
    echo "Compilation failed"
fi
