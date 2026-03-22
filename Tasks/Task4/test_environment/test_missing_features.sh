#!/bin/bash
# Test missing features

echo "=== Checking for ASCII hangman art ==="
grep -n "draw\|hangman.*art\|stages\[\]" response2_hangman.c
if [ $? -ne 0 ]; then
    echo "No ASCII art function found"
fi

echo ""
echo "=== Checking for play-again loop ==="
grep -n "playAgain\|play.*again\|while.*play" response2_hangman.c
if [ $? -ne 0 ]; then
    echo "No play-again loop found"
fi

echo ""
echo "=== Checking main function structure ==="
grep -A5 "int main" response2_hangman.c | tail -10
echo "..."
tail -5 response2_hangman.c

echo ""
echo "=== Verification ==="
echo "Response 2 exits after one game (return 0)"
echo "No outer loop for replay"
