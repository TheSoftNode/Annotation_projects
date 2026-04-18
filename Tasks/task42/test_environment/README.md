# Task 42 Test Environment — Linux C99 GMT Offset

## Requirements

- **Linux** with glibc (GitHub Codespaces works)
- `gcc` with C99 support

## How to Run

```bash
cd /workspaces/<repo>/Tasks/task42/test_environment
chmod +x run_all_tests.sh
bash run_all_tests.sh 2>&1 | tee ../test_verification/TEST_OUTPUT.md
```

## Test Structure

```
test_environment/
├── run_all_tests.sh          # Master runner — runs everything
├── R1/
│   ├── r1_original.c         # R1 code as-written (with missing includes added)
│   ├── r1_completable.c      # R1 code with includes so it compiles
│   └── test_r1.sh            # All R1 tests
├── R2/
│   ├── r2_original.c         # R2 code as-written
│   └── test_r2.sh            # All R2 tests
└── outputs/
    ├── R1/                   # R1 test logs
    └── R2/                   # R2 test logs
```

## Claims Being Tested

### Response 1 Claims

| #   | Claim                                                                       | Test                           |
| --- | --------------------------------------------------------------------------- | ------------------------------ |
| C1  | Code compiles and runs                                                      | Compilation test               |
| C2  | `setlocale(LC_TIME, "")` is relevant to time offset                         | Compile without it, compare    |
| C3  | `mktime(gmtime(&rawtime))` vs `mktime(localTime)` gives correct offset      | Compare with known TZ values   |
| C4  | `localTime` pointer is still valid after `gmtime(&rawtime)` call            | Static buffer clobber test     |
| C5  | Error checking for `localtime` works                                        | NULL check test                |
| C6  | `strftime` formatting works and is relevant to the task                     | Relevance check                |
| C7  | References "previous includes and definitions" — implies prior conversation | Context hallucination check    |
| C8  | Uses `time()` despite prompt saying "without using timestamp"               | Requirement satisfaction check |

### Response 2 Claims

| #   | Claim                                                         | Test                           |
| --- | ------------------------------------------------------------- | ------------------------------ |
| C1  | Code compiles with `gcc -std=c99`                             | Compilation test               |
| C2  | `tm_gmtoff` gives correct offset on glibc                     | Known TZ verification          |
| C3  | Claims "pure C99" but uses `tm_gmtoff` (non-standard)         | Strict C99 compilation test    |
| C4  | Claims "pure C99" but uses `_POSIX_C_SOURCE`                  | Standard compliance check      |
| C5  | Uses `errno` without `#include <errno.h>`                     | Compilation strictness test    |
| C6  | Fallback path with `timezone`/`daylight` works                | Force fallback test            |
| C7  | `localtime_r` is thread-safe alternative                      | Functional equivalence test    |
| C8  | Output format ±HH:MM is correct                               | Multiple TZ verification       |
| C9  | Uses `time()` despite prompt saying "without using timestamp" | Requirement satisfaction check |
| C10 | `timegm` usage example at the end — is it available in C99?   | GNU extension check            |
| C11 | DST handling is correct                                       | DST vs non-DST TZ comparison   |
