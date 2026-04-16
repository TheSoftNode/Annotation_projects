#!/bin/bash

echo "=================================================="
echo "Running all Response 2 tests"
echo "=================================================="
echo ""

# Check compiler
echo "Checking compiler..."
clang --version
echo ""

# Test A: Normal case
echo "=================================================="
echo "Test A: Normal case (test_a_ok.c)"
echo "=================================================="
clang -std=c11 -Wall -Wextra -Wsign-compare -O0 -g test_a_ok.c -o test_a_ok
./test_a_ok
echo ""

# Test B: Zero-length case
echo "=================================================="
echo "Test B: Zero-length case (test_b_zero.c)"
echo "=================================================="
clang -std=c11 -Wall -Wextra -Wsign-compare -O0 -g -fsanitize=address,undefined test_b_zero.c -o test_b_zero
./test_b_zero
echo ""

# Test C: Negative argument (disproves claim)
echo "=================================================="
echo "Test C: Negative argument (test_c_negative_argument.c)"
echo "This disproves: 'Negative length not possible with unsigned'"
echo "=================================================="
clang -std=c11 -Wall -Wextra -Wconversion -Wsign-conversion -O0 -g -fsanitize=address,undefined test_c_negative_argument.c -o test_c_negative_argument
./test_c_negative_argument
echo ""

# Test D: UINT_MAX minus 1 (disproves claim)
echo "=================================================="
echo "Test D: UINT_MAX minus 1 (test_d_uintmax_minus_1.c)"
echo "This disproves: 'length-1 wraps when length is near UINT_MAX'"
echo "=================================================="
clang -std=c11 -Wall -Wextra -O0 -g test_d_uintmax_minus_1.c -o test_d_uintmax_minus_1
./test_d_uintmax_minus_1
echo ""

# Test E: Fixed version with zero-length
echo "=================================================="
echo "Test E: Fixed version with zero-length (test_e_fixed_zero.c)"
echo "=================================================="
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=address,undefined test_e_fixed_zero.c -o test_e_fixed_zero
./test_e_fixed_zero
echo ""

# Test F: Fixed version normal case
echo "=================================================="
echo "Test F: Fixed version normal case (test_f_fixed_ok.c)"
echo "=================================================="
clang -std=c11 -Wall -Wextra -O0 -g test_f_fixed_ok.c -o test_f_fixed_ok
./test_f_fixed_ok
echo ""

echo "=================================================="
echo "All Response 2 tests completed"
echo "=================================================="
