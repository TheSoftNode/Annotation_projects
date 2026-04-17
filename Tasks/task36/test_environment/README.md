# Task 36 - C++ ARM NEON int4 Extension Test Environment

This test environment verifies the claims made in Response 1 and Response 2 about adding an int4 extension to the bundle SIMD abstraction.

## Task Overview

The task asks to extend a C++23 ARM NEON SIMD bundle struct to support int4 (4-bit integer) encoding that packs 16 int8 values into 8 bytes.

## Files

- **bundle_base.cpp** - The base bundle implementation from the conversation history
- **R1/bundle_with_response1.cpp** - Complete file with base + R1 extension + R1 usage example
- **R2/bundle_with_response2.cpp** - Complete file with base + R2 extension + R2 usage example
- **R1/test_compile_r1.sh** - Test script for Response 1
- **R2/test_compile_r2.sh** - Test script for Response 2
- **outputs/** - Test output files

## Important Testing Notes

**⚠️ These tests MUST be run on Apple Silicon Mac Terminal, NOT GitHub Codespaces.**

The responses are specifically written for Apple Silicon with ARM NEON intrinsics. GitHub Codespaces runs in a Linux container which is not the appropriate environment for this code.

## Prerequisites

Before running tests, ensure you have:

1. Apple Silicon Mac (arm64 architecture)
2. Xcode Command Line Tools installed

Check your environment:

```bash
uname -m                 # Should output: arm64
clang++ --version        # Should show Apple clang
xcode-select -p          # Should show developer tools path
```

If clang++ is missing, install Command Line Tools:

```bash
xcode-select --install
```

## Running Tests

### Quick Run (Both Responses)

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task36/test_environment

# Make scripts executable
chmod +x R1/test_compile_r1.sh R2/test_compile_r2.sh

# Run Response 1 tests
./R1/test_compile_r1.sh

# Run Response 2 tests
./R2/test_compile_r2.sh
```

### What Each Test Does

**Response 1 Tests (test_compile_r1.sh):**
1. Environment check (uname, clang++, xcode-select)
2. Compile base bundle alone
3. Grep check for API signature mismatches
4. Compile complete Response 1 file
5. int2x16 arithmetic verification

**Response 2 Tests (test_compile_r2.sh):**
1. Environment check
2. Grep checks for private access, if consteval, operator[]
3. Compile complete Response 2 file
4. Sign extension logic test
5. Output clamp contradiction analysis

## Test Outputs

All test outputs are saved to:
- **outputs/R1/** - Response 1 test results
  - 00_environment.txt
  - 01_compile_base_output.txt
  - 02_grep_api_check.txt
  - 03_compile_response1_output.txt
  - 04_int2_arithmetic.txt

- **outputs/R2/** - Response 2 test results
  - 00_environment.txt
  - 01_grep_checks.txt
  - 02_compile_response2_output.txt
  - 03_sign_extension_test.txt
  - 04_output_clamp_analysis.txt

## Key Issues Expected

Based on the factual files, the tests should reveal:

### Response 1 Issues:
- **API signature mismatch**: bundle expects `T::template decode<ValueType>`, R1 provides non-template `decode(int4x8)`
- **encode signature**: takes `int8_t& dst` but tries to copy 8 bytes into it via memcpy
- **store() call**: example uses `int8x16::store<int4x8>(&packed, i8)` but base has member function taking only `void* dst`
- **if consteval**: doesn't work as runtime dispatch mechanism (only executes in constant-evaluated context)
- **int2x16 arithmetic**: claims "1 byte = 8 values" but 1 byte only holds 4 2-bit values

### Response 2 Issues:
- **Private access violation**: encode tries to access `src.vec.val[0]` which is private in bundle
- **if consteval**: same issue as R1, not a runtime dispatcher
- **operator[] assignment**: tries `vec[i] = ...` but operator[] returns by value, not reference
- **vld1q_s8 type**: prose claims "int8x16x1_t" but vld1q_s8 returns int8x16_t per ARM docs
- **Output claim**: shows value 8 after negating -8, but clamping should produce 7

## What to Send for Analysis

After running tests, send:

1. **Environment info** from outputs/R1/00_environment.txt or outputs/R2/00_environment.txt
2. **All output files** from outputs/R1/ and outputs/R2/
3. **Compilation errors** - especially important for mapping to factual claims
4. **Runtime output** - if either response somehow compiles

These will be mapped back to specific claim numbers in the factual files to determine accuracy.

## File Structure

```
test_environment/
├── README.md (this file)
├── bundle_base.cpp (base implementation only)
├── R1/
│   ├── README.md
│   ├── bundle_with_response1.cpp (complete file: base + R1 + example)
│   ├── test_compile_r1.sh
│   ├── r1_extension.cpp (R1 extension only, for reference)
│   └── run_all_tests.sh (old version, use test_compile_r1.sh instead)
├── R2/
│   ├── README.md
│   ├── bundle_with_response2.cpp (complete file: base + R2 + example)
│   ├── test_compile_r2.sh
│   ├── r2_extension.cpp (R2 extension only, for reference)
│   └── run_all_tests.sh (old version, use test_compile_r2.sh instead)
└── outputs/
    ├── R1/
    └── R2/
```

## Testing Approach

The tests follow the exact methodology from the factual files:

1. **Test the base first** - verify bundle compiles standalone
2. **Grep checks** - inspect API signatures before compilation
3. **Compile combined files** - test R1/R2 extensions integrated with base
4. **Analyze errors** - map compilation errors to specific claims
5. **Verify logic** - test individual helpers (sign extension, clamping)

This ensures a fair, systematic evaluation of each response's technical accuracy.
