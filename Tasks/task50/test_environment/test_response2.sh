#!/bin/bash

echo "===== TESTING RESPONSE 2 ====="
echo

echo "===== TEST 1: Does grep '[Z]' show the grep process itself? ====="
echo "Command: ps aux | grep '[Z]'"
echo "Expected: If brackets work as claimed, grep should NOT appear"
ps aux | grep '[Z]'
echo

echo "===== TEST 2: Count how many grep processes appear ====="
echo "Command: ps aux | grep '[Z]' | grep 'grep'"
ps aux | grep '[Z]' | grep 'grep'
echo

echo "===== TEST 3: Does the full R2 solution work? ====="
echo "Command: ps aux | grep '[Z]' | grep -v grep"
ps aux | grep '[Z]' | grep -v grep
echo

echo "===== TEST 4: Verify bracket notation behavior ====="
echo "Testing if [Z] pattern matches 'Z' in text:"
echo "test Z line" | grep '[Z]'
echo "Output above shows [Z] DOES match 'Z' in text"
echo

echo "===== TEST 5: Check the actual grep command line ====="
echo "Command: ps aux | grep '[Z]' | grep 'grep \[Z\]'"
echo "This checks if the command line shows 'grep [Z]' which contains 'Z'"
ps aux | grep '[Z]' | grep 'grep \[Z\]' || echo "No match found"
echo

echo "===== TEST 6: Compare bracket vs no bracket ====="
echo "Without brackets:"
ps aux | grep 'Z' | wc -l
echo "With brackets:"
ps aux | grep '[Z]' | wc -l
echo "Line counts should be similar since both match 'Z'"
echo

echo "===== DONE ====="
