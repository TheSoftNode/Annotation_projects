#!/bin/bash

echo "===== OS INFO ====="
uname -a
echo
cat /etc/os-release 2>/dev/null || sw_vers 2>/dev/null || true

echo
echo "===== DEPENDENCY CHECK ====="
which ps || echo "ps not found"
which grep || echo "grep not found"
which awk || echo "awk not found"
which python3 || echo "python3 not found"

echo
echo "===== PS AUX HEADER CHECK ====="
ps aux | head -n 5

echo
echo "===== FIELD COUNT CHECK ====="
echo "Checking which field is STAT:"
ps aux | head -1 | awk '{for(i=1;i<=NF;i++) print "Field " i ": " $i}'

echo
echo "===== RESPONSE COMMAND 1 ====="
echo "Command: ps aux | grep 'Z' | grep -v grep"
ps aux | grep 'Z' | grep -v grep

echo
echo "===== RESPONSE COMMAND 2 ====="
echo "Command: ps aux | awk '\$8 ~ /Z/ { print }'"
ps aux | awk '$8 ~ /Z/ { print }'

echo
echo "===== RESPONSE COMMAND 3 ====="
echo "Command: ps aux | awk '\$8 ~ /Z/'"
ps aux | awk '$8 ~ /Z/'

echo
echo "===== CHECK IF AWK SOLUTION SHOWS GREP ====="
echo "Running: ps aux | grep 'awk' to see if awk command appears"
ps aux | grep 'awk' | head -3

echo
echo "===== DONE ====="
