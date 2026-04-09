#!/bin/bash
# Test code snippets from conversation history

echo "============================================================"
echo "Conversation History - Code Tests"
echo "============================================================"
echo

echo "Compiling conversation history code..."
gcc test_conversation_history_code.c -o test_conversation_history_code -lm
echo "Compilation successful"
echo

echo "Running tests..."
echo "------------------------------------------------------------"
./test_conversation_history_code
echo

echo "============================================================"
echo "Conversation History Tests Complete"
echo "============================================================"

# Cleanup
rm -f test_conversation_history_code
