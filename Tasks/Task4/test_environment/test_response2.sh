#!/bin/bash

# Test script for Response 2 Hangman game
# This script runs automated tests to check for logic bugs

echo "=== Testing Response 2 Hangman Game ==="
echo ""

# Test 1: Check for duplicate letter counting bug
echo "Test 1: Duplicate letter handling (word with duplicate letters)"
echo "Testing with word containing 'r' and 'p' multiple times"
echo "Expected: If word is 'programming' (3 r's, 1 p, 1 o, 2 g's, 2 m's, 1 a, 1 i, 1 n)"
echo "Guessing 'r' should increment correctCount by 3, not 1"
echo ""

# Create test input file
cat > test1_input.txt << 'EOF'
p
r
o
g
a
m
i
n
EOF

# Run test
echo "Running test with automated input..."
./response2_hangman < test1_input.txt > test1_output.txt 2>&1

echo "Test 1 output saved to test1_output.txt"
echo ""

# Test 2: Test with simple word to verify logic
echo "Test 2: Testing win condition with systematic guessing"
cat > test2_input.txt << 'EOF'
a
b
c
d
e
f
g
h
i
j
k
l
m
n
o
p
q
r
s
t
u
v
w
x
y
z
EOF

# Run test 2
echo "Running test 2..."
./response2_hangman < test2_input.txt > test2_output.txt 2>&1
echo "Test 2 output saved to test2_output.txt"
echo ""

# Test 3: Test repeated letter guessing
echo "Test 3: Testing repeated letter guessing"
cat > test3_input.txt << 'EOF'
a
a
a
b
c
d
e
f
g
h
i
j
k
l
m
n
o
p
q
r
s
t
u
v
w
x
y
z
EOF

# Run test 3
echo "Running test 3..."
./response2_hangman < test3_input.txt > test3_output.txt 2>&1
echo "Test 3 output saved to test3_output.txt"
echo ""

echo "=== All tests completed ==="
echo "Review output files for analysis"
