#!/bin/bash

echo "=================================================="
echo "Running all Response 1 tests"
echo "=================================================="
echo ""

# Check compiler
echo "Checking compiler..."
clang --version
echo ""

# Test 1: Normal case
echo "=================================================="
echo "Test 1: Normal case (test_ok.c)"
echo "=================================================="
clang -std=c11 -Wall -Wextra -O0 -g test_ok.c -o test_ok
./test_ok
echo ""

# Test 2: Zero-length case
echo "=================================================="
echo "Test 2: Zero-length case (test_zero_len.c)"
echo "=================================================="
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=address,undefined test_zero_len.c -o test_zero_len
./test_zero_len
echo ""

# Test 3: Length larger than array
echo "=================================================="
echo "Test 3: Length larger than array (test_bad_len.c)"
echo "=================================================="
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=address,undefined test_bad_len.c -o test_bad_len
./test_bad_len
echo ""

# Test 4: Float overflow
echo "=================================================="
echo "Test 4: Float overflow (test_inf.c)"
echo "=================================================="
clang -std=c11 -Wall -Wextra -O0 -g test_inf.c -lm -o test_inf
./test_inf
echo ""

# Test 5: NaN propagation
echo "=================================================="
echo "Test 5: NaN propagation (test_nan.c)"
echo "=================================================="
clang -std=c11 -Wall -Wextra -O0 -g test_nan.c -lm -o test_nan
./test_nan
echo ""

# Test 6: Fixed version with zero-length
echo "=================================================="
echo "Test 6: Fixed version with zero-length (test_fixed_zero.c)"
echo "=================================================="
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=undefined test_fixed_zero.c -o test_fixed_zero
./test_fixed_zero
echo ""

echo "=================================================="
echo "All Response 1 tests completed"
echo "=================================================="
