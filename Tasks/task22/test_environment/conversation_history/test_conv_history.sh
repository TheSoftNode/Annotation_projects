#!/bin/bash

echo "=== Testing Conversation History Code ==="
gcc conv_history.c -o conv_history
if [ $? -eq 0 ]; then
    echo "Compilation successful"
    echo ""
    echo "Test 1: Input 60"
    echo "60" | ./conv_history
    echo ""
    echo "Test 2: Input 25"
    echo "25" | ./conv_history
    echo ""
    echo "Test 3: Input -10"
    echo "-10" | ./conv_history
    echo ""
    echo "Test 4: Input 0"
    echo "0" | ./conv_history
    echo ""
    echo "Test 5: Input 20"
    echo "20" | ./conv_history
else
    echo "Compilation failed"
fi
