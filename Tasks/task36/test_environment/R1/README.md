# Response 1 Test Files

These test files verify the claims in Response 1 about the int4 extension.

## Tests:

1. **test_compile_base.sh** - Verify the base bundle compiles
2. **test_api_mismatch.sh** - Check for signature mismatches between bundle and int4x8
3. **test_compile_r1_extension.sh** - Try to compile Response 1 extension with base bundle
4. **test_encode_signature.sh** - Verify encode signature issue (int8_t& vs int4x8)
5. **test_static_vs_member.sh** - Check store() call shape mismatch
6. **test_int2_arithmetic.sh** - Verify the int2x16 claim (1 byte = 8 values)

## How to run all tests:

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task36/test_environment/R1
chmod +x *.sh
./run_all_tests.sh
```

All outputs will be saved to ../outputs/R1/
