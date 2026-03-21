#!/bin/bash
# Test script for response1_hangman.c
# This script runs the hangman game with automated input

echo "=========================================="
echo "TEST 1: Complete game with correct guesses"
echo "=========================================="
echo ""

# Test with a sequence of guesses (we don't know the word, so we'll guess common letters)
# Then answer 'n' to not play again
echo -e "a\ne\ni\no\nu\nr\ns\nt\nl\nn\nm\nc\np\nb\nd\ng\nf\nh\nk\nw\ny\nz\nv\nj\nq\nx\nn" | ./response1_hangman

echo ""
echo "=========================================="
echo "TEST 2: Game with early quit (simulating EOF)"
echo "=========================================="
echo ""

# Send just a few letters
echo -e "a\ne\ni" | ./response1_hangman

echo ""
echo "=========================================="
echo "TEST 3: Testing duplicate letter handling"
echo "=========================================="
echo ""

# Try the same letter multiple times
echo -e "a\na\na\ne\ni\no\nu\nr\ns\nt\nl\nn\nm\nc\np\nb\nd\ng\nf\nh\nk\nw\ny\nz\nv\nj\nq\nx\nn" | ./response1_hangman

echo ""
echo "=========================================="
echo "All automated tests complete!"
echo "=========================================="
