# Response 2 Test Files

These test files verify the claims in Response 2 about the int4 extension.

## Tests:

1. **test_private_access.sh** - Check if R2 can access private `vec` member
2. **test_if_consteval.sh** - Verify if consteval behavior at runtime
3. **test_operator_bracket.sh** - Check operator[] return type (value vs reference)
4. **test_vld1q_return_type.sh** - Verify vld1q_s8 returns int8x16_t not int8x16x1_t
5. **test_output_clamp.sh** - Test the output block with value `8` after clamping
6. **test_compile_r2_extension.sh** - Try to compile R2 extension with base bundle
7. **test_sign_extension.sh** - Verify sign extension logic works correctly

## How to run all tests:

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task36/test_environment/R2
chmod +x *.sh
./run_all_tests.sh
```

All outputs will be saved to ../outputs/R2/
