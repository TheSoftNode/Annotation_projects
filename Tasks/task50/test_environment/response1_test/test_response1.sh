#!/usr/bin/env bash

echo "===== ENVIRONMENT ====="
uname -a
echo
cat /etc/os-release 2>/dev/null || true

echo
echo "===== TOOL CHECK ====="
which ps || true
which grep || true
which awk || true
which python3 || true
which bash || true
which nohup || true
which head || true
which cat || true

echo
echo "===== HEADER CHECK ====="
ps aux | head -n 2

echo
echo "===== HEADER FIELD COUNT ====="
ps aux | head -n 1 | awk '{for (i=1; i<=NF; i++) print i ":" $i}'

echo
echo "===== START ZOMBIE HELPER ====="
nohup python3 make_zombie.py > zombie.log 2>&1 &
sleep 2

echo
echo "===== ZOMBIE HELPER OUTPUT ====="
cat zombie.log

echo
echo "===== TEST 1: BASELINE GREP ====="
echo "COMMAND: ps aux | grep 'Z'"
ps aux | grep 'Z'

echo
echo "===== TEST 2: EXACT PREVIOUS OPTION REFERENCED IN RESPONSE ====="
echo "COMMAND: ps aux | grep 'Z' | grep -v grep"
ps aux | grep 'Z' | grep -v grep

echo
echo "===== TEST 3: EXACT AWK COMMAND WITH ACTION ====="
echo "COMMAND: ps aux | awk '\$8 ~ /Z/ { print }'"
ps aux | awk '$8 ~ /Z/ { print }'

echo
echo "===== TEST 4: EXACT AWK COMMAND WITHOUT ACTION ====="
echo "COMMAND: ps aux | awk '\$8 ~ /Z/'"
ps aux | awk '$8 ~ /Z/'

echo
echo "===== TEST 5: REPEAT ORIGINAL GREP FILTER 5 TIMES ====="
for i in 1 2 3 4 5
do
  echo "--- RUN $i ---"
  ps aux | grep 'Z' | grep -v grep
done

echo
echo "===== TEST 6: REPEAT AWK FILTER 5 TIMES ====="
for i in 1 2 3 4 5
do
  echo "--- RUN $i ---"
  ps aux | awk '$8 ~ /Z/ { print }'
done

echo
echo "===== END ====="
