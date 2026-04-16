# Response 1 Test Environment

This folder contains test files extracted verbatim from Response 1 and the Factual file.

## Tests

### Test 1: Normal case (test_ok.c)
```bash
clang -std=c11 -Wall -Wextra -O0 -g test_ok.c -o test_ok
./test_ok
```
**Expected:** `6.000000`

### Test 2: Zero-length case (test_zero_len.c)
```bash
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=address,undefined test_zero_len.c -o test_zero_len
./test_zero_len
```
**Expected:** Sanitizer report/crash showing out-of-bounds access

### Test 3: Length larger than array (test_bad_len.c)
```bash
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=address,undefined test_bad_len.c -o test_bad_len
./test_bad_len
```
**Expected:** Sanitizer report/crash

### Test 4: Float overflow (test_inf.c)
```bash
clang -std=c11 -Wall -Wextra -O0 -g test_inf.c -lm -o test_inf
./test_inf
```
**Expected:** `sum=inf isinf=1`

### Test 5: NaN propagation (test_nan.c)
```bash
clang -std=c11 -Wall -Wextra -O0 -g test_nan.c -lm -o test_nan
./test_nan
```
**Expected:** `isnan=1`

### Test 6: Fixed version with zero-length (test_fixed_zero.c)
```bash
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=undefined test_fixed_zero.c -o test_fixed_zero
./test_fixed_zero
```
**Expected:** `0.000000` (no errors)

## Run All Tests (GitHub Codespaces)

Run these commands in Codespaces:

```bash
# Check compiler
clang --version

# Test 1
clang -std=c11 -Wall -Wextra -O0 -g test_ok.c -o test_ok && ./test_ok

# Test 2
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=address,undefined test_zero_len.c -o test_zero_len && ./test_zero_len

# Test 3
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=address,undefined test_bad_len.c -o test_bad_len && ./test_bad_len

# Test 4
clang -std=c11 -Wall -Wextra -O0 -g test_inf.c -lm -o test_inf && ./test_inf

# Test 5
clang -std=c11 -Wall -Wextra -O0 -g test_nan.c -lm -o test_nan && ./test_nan

# Test 6
clang -std=c11 -Wall -Wextra -O0 -g -fsanitize=undefined test_fixed_zero.c -o test_fixed_zero && ./test_fixed_zero
```
