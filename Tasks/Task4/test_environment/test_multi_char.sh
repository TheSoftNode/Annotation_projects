#!/bin/bash
# Test multi-character input bug

echo "=== Testing multi-character input bug ==="
echo ""
echo "Test 1: Type 'ate' as single input"
echo "ate" | ./response2_hangman 2>&1 | grep -A2 "Guess a letter" | head -12

echo ""
echo "=== Verification ==="
echo "Expected: 'a', 't', 'e' processed as 3 separate guesses"
echo "Actual result shown above"
