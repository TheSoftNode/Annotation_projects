#!/usr/bin/env bash

echo "===== ENVIRONMENT ====="
uname -a
echo
cat /etc/os-release 2>/dev/null || true

echo
echo "===== TOOL CHECK ====="
which ps || true
which grep || true
which bash || true
which python3 || true
which cat || true
which head || true
which nohup || true

echo
echo "===== PS SAMPLE ====="
ps aux | head -n 5

echo
echo "===== START ZOMBIE HELPER ====="
nohup python3 make_zombie.py > zombie.log 2>&1 &
sleep 2

echo
echo "===== ZOMBIE HELPER OUTPUT ====="
cat zombie.log

echo
echo "===== TEST 1: EARLIER COMMAND ====="
echo "COMMAND: ps aux | grep 'Z' | grep -v grep"
ps aux | grep 'Z' | grep -v grep

echo
echo "===== TEST 2: RESPONSE FIRST GREP ONLY ====="
echo "COMMAND: ps aux | grep '[Z]'"
ps aux | grep '[Z]'

echo
echo "===== TEST 3: EXACT RESPONSE COMMAND ====="
echo "COMMAND: ps aux | grep '[Z]' | grep -v grep"
ps aux | grep '[Z]' | grep -v grep

echo
echo "===== TEST 4: REPEAT RESPONSE FIRST GREP 10 TIMES ====="
for i in 1 2 3 4 5 6 7 8 9 10
do
  echo "--- RUN $i ---"
  ps aux | grep '[Z]'
done

echo
echo "===== TEST 5: REPEAT EXACT RESPONSE COMMAND 10 TIMES ====="
for i in 1 2 3 4 5 6 7 8 9 10
do
  echo "--- RUN $i ---"
  ps aux | grep '[Z]' | grep -v grep
done

echo
echo "===== END ====="
