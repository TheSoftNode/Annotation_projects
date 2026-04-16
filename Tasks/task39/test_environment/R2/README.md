# Response 2 Test Environment

This folder contains test files extracted verbatim from Response 2 and the Factual file.

## Tests

### Test A: Normal case (test_a_ok.c)
```bash
clang -std=c11 -Wall -Wextra -Wsign-compare -O0 -g test_a_ok.c -o test_a_ok
./test_a_ok
```
**Expected:** `6.000000`

### Test B: Zero-length case (test_b_zero.c)
```bash
clang -std=c11 -Wall -Wextra -Wsign-compare -O0 -g -fsanitize=address,undefined test_b_zero.c -o test_b_zero
./test_b_zero
```
**Expected:** Sanitizer report/crash

### Test C: Negative argument (test_c_negative_argument.c)
**This tests the claim: "Negative length passed accidentally | Not possible with unsigned"**
```bash
clang -std=c11 -Wall -Wextra -Wconversion -Wsign-conversion -O0 -g -fsanitize=address,undefined test_c_negative_argument.c -o test_c_negative_argument
./test_c_negative_argument
```
**Expected:** Compiler warning + runtime failure (proves claim is WRONG - negative CAN be passed to unsigned)

### Test D: UINT_MAX minus 1 (test_d_uintmax_minus_1.c)
**This tests the claim: "length is extremely large (near UINT_MAX) | Even if length != 0, length-1 can wrap"**
```bash
clang -std=c11 -Wall -Wextra -O0 -g test_d_uintmax_minus_1.c -o test_d_uintmax_minus_1
./test_d_uintmax_minus_1
```
**Expected:** `length - 1 = UINT_MAX - 1` (NOT wrapped - proves claim is WRONG)

### Test E: Fixed version with zero-length (test_e_fixed_zero.c)
```bash
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=address,undefined test_e_fixed_zero.c -o test_e_fixed_zero
./test_e_fixed_zero
```
**Expected:** `0.000000` (no errors)

### Test F: Fixed version normal case (test_f_fixed_ok.c)
```bash
clang -std=c11 -Wall -Wextra -O0 -g test_f_fixed_ok.c -o test_f_fixed_ok
./test_f_fixed_ok
```
**Expected:** `6.000000`

## Run All Tests (GitHub Codespaces)

Run these commands in Codespaces:

```bash
# Check compiler
clang --version

# Test A
clang -std=c11 -Wall -Wextra -Wsign-compare -O0 -g test_a_ok.c -o test_a_ok && ./test_a_ok

# Test B
clang -std=c11 -Wall -Wextra -Wsign-compare -O0 -g -fsanitize=address,undefined test_b_zero.c -o test_b_zero && ./test_b_zero

# Test C (disproves "not possible with unsigned" claim)
clang -std=c11 -Wall -Wextra -Wconversion -Wsign-conversion -O0 -g -fsanitize=address,undefined test_c_negative_argument.c -o test_c_negative_argument && ./test_c_negative_argument

# Test D (disproves wrap claim for non-zero near UINT_MAX)
clang -std=c11 -Wall -Wextra -O0 -g test_d_uintmax_minus_1.c -o test_d_uintmax_minus_1 && ./test_d_uintmax_minus_1

# Test E
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=address,undefined test_e_fixed_zero.c -o test_e_fixed_zero && ./test_e_fixed_zero

# Test F
clang -std=c11 -Wall -Wextra -O0 -g test_f_fixed_ok.c -o test_f_fixed_ok && ./test_f_fixed_ok
```
