#!/bin/bash

echo "======================================"
echo "GPT Factual Verification for R1"
echo "======================================"
echo ""

# Version 1
echo "=== VERSION 1 (response1_v1.c) ==="
echo "Compiling with -Wall -Wextra -std=c11..."
gcc -Wall -Wextra -std=c11 r1_version1.c -o response1_v1 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
else
    echo "✗ Compilation failed"
fi
echo ""

echo "Testing version 1:"
echo "Input: 40"
printf "40\n" | ./response1_v1
echo ""

echo "Input: 35"
printf "35\n" | ./response1_v1
echo ""

echo "Input: -5"
printf -- "-5\n" | ./response1_v1
echo ""

echo "Input: 0"
printf "0\n" | ./response1_v1
echo ""

echo "---"
echo ""

# Version 2
echo "=== VERSION 2 (response1_v2.c) ==="
echo "Compiling with -Wall -Wextra -std=c11..."
gcc -Wall -Wextra -std=c11 r1_version2.c -o response1_v2 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
else
    echo "✗ Compilation failed"
fi
echo ""

echo "Testing version 2:"
echo "Input: 40"
printf "40\n" | ./response1_v2
echo ""

echo "Input: 35"
printf "35\n" | ./response1_v2
echo ""

echo "Input: -5"
printf -- "-5\n" | ./response1_v2
echo ""

echo "Input: 0"
printf "0\n" | ./response1_v2
echo ""

echo "---"
echo ""

# Version 3
echo "=== VERSION 3 (response1_v3.c) ==="
echo "Compiling with -Wall -Wextra -std=c11..."
gcc -Wall -Wextra -std=c11 r1_version3.c -o response1_v3 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
else
    echo "✗ Compilation failed"
fi
echo ""

echo "Testing version 3:"
echo "Input: 40"
printf "40\n" | ./response1_v3
echo ""

echo "Input: 35"
printf "35\n" | ./response1_v3
echo ""

echo "Input: 0"
printf "0\n" | ./response1_v3
echo ""

echo "Input: -5"
printf -- "-5\n" | ./response1_v3
echo ""

echo "---"
echo ""

# Verify nested structure
echo "=== STRUCTURAL VERIFICATION ==="
echo ""
echo "Checking for 'else if' in version 3:"
grep -n "else if" r1_version3.c
echo ""

echo "Line numbers for version 1:"
nl -ba r1_version1.c | grep -E "(if|else)"
echo ""
