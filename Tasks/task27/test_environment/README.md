# Task 27 Test Environment

This directory contains all code and test scripts to verify the factual claims in RESPONSE_1 and RESPONSE_2 for Task 27.

## Task Overview
**User Request:** "vectorize and solve for 0 through n"
**Context:** Computing popcount (Hamming weight) for array elements from index 0 to n

## Directory Structure

```
test_environment/
├── R1/                           # Response 1: SIMD vector extension approach
│   ├── popcount_vector.c         # Main SIMD implementation with SWAR
│   ├── popcount_intrinsics.c     # SSE4.2 intrinsics version
│   ├── test_r1_basic_compile.sh  # Basic compilation test
│   ├── test_r1_intrinsics.sh     # SSE4.2 intrinsics test
│   └── test_r1_verify_vectorization.sh  # Assembly verification
├── R2/                           # Response 2: OpenMP SIMD approach
│   ├── popcount_openmp.c         # OpenMP SIMD implementation
│   ├── test_r2_basic_compile.sh  # Basic compilation test
│   └── test_r2_verify_openmp.sh  # OpenMP verification
├── outputs/                      # Test outputs
│   ├── R1/
│   └── R2/
├── run_all_tests.sh             # Master test runner
└── README.md                     # This file
```

## Running Tests

### Run All Tests
```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task27/test_environment
chmod +x run_all_tests.sh R1/*.sh R2/*.sh
./run_all_tests.sh
```

### Run Individual Tests

**R1 Tests:**
```bash
cd R1
chmod +x *.sh
./test_r1_basic_compile.sh
./test_r1_intrinsics.sh
./test_r1_verify_vectorization.sh
```

**R2 Tests:**
```bash
cd R2
chmod +x *.sh
./test_r2_basic_compile.sh
./test_r2_verify_openmp.sh
```

## Requirements

### Mac
- Xcode Command Line Tools: `xcode-select --install`
- GCC and Clang should be available
- OpenMP support may require: `brew install libomp`

### GitHub Codespaces / Linux
```bash
sudo apt update
sudo apt install -y build-essential clang
```

## Expected Outputs

### R1 (SIMD Vector Extension)
- Should compile successfully with GCC and Clang
- Should show vectorized popcount results for 12 array elements
- Assembly inspection should reveal SIMD instructions (popcnt, vpand, vpsrlw, etc.)

### R2 (OpenMP SIMD)
- Should compile successfully with `-fopenmp` flag
- Should show popcount results for 8 array elements
- Assembly should show compiler attempted SIMD vectorization

## Verification Against Factual Files

This test environment implements test cases from:
- `/Tasks/task27/helpers/Gpt_factual_R1_task27.md`
- `/Tasks/task27/helpers/Gpt_factual_R2_task27.md`

All code is extracted verbatim from RESPONSE_1 and RESPONSE_2.
