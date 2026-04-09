#!/bin/bash

echo "=========================================="
echo "Task 25 - Testing Code Examples"
echo "=========================================="
echo ""

echo "Compiling conversation history code..."
gcc -o test_conv_history test_conversation_history_code.c -lm

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
    echo ""
    echo "Running tests..."
    echo "=========================================="
    ./test_conv_history
    echo "=========================================="
else
    echo "✗ Compilation failed"
fi

echo ""
echo "Test complete!"
