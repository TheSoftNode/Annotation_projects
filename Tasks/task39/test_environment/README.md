# Task 39 Test Environment

Testing C code edge cases for the `sum_elements` function with unsigned length parameter.

## Structure

```
test_environment/
├── R1/              # Response 1 tests
├── R2/              # Response 2 tests
└── outputs/
    ├── R1/          # Output from R1 tests
    └── R2/          # Output from R2 tests
```

## Environment Setup

**Recommended:** Use GitHub Codespaces for clean testing with sanitizers.

1. Create a new Codespace
2. Navigate to this directory
3. Verify compiler:
   ```bash
   clang --version
   ```

## Quick Start

### Test Response 1
```bash
cd R1
# See R1/README.md for detailed test commands
```

### Test Response 2
```bash
cd R2
# See R2/README.md for detailed test commands
```

## Key Claims Being Tested

### Response 1
- Zero-length causes unsigned underflow to UINT_MAX
- Signed/unsigned comparison issues
- Float overflow to +inf
- NaN propagation
- Fixed version with `i < length` and `size_t`

### Response 2
- Zero-length underflow issue
- **Claim to disprove:** "Negative length not possible with unsigned" (Test C)
- **Claim to disprove:** "length-1 wraps when length is near UINT_MAX even if non-zero" (Test D)
- Fixed version with unsigned loop counter

## Test Files

All test files are extracted **verbatim** from:
- Response code snippets
- Factual file test procedures

No modifications have been made to the function bodies or test logic.
