#!/bin/bash
# Test: Epsilon comparison speed vs integer equality
# Proves R2's "Slow & Risky" label for epsilon comparison is misleading

set -e

echo "Compiling test_r2_epsilon_speed.c..."
clang -O2 -o test_r2_epsilon_speed test_r2_epsilon_speed.c -lm

echo ""
./test_r2_epsilon_speed
