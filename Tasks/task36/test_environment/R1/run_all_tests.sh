#!/bin/bash

# Run all R1 tests and save outputs
OUTPUT_DIR="../outputs/R1"
mkdir -p "$OUTPUT_DIR"

echo "===== Running R1 Tests ====="
echo ""

# Test 1: Compile base bundle
echo "Test 1: Compiling base bundle..."
cd ..
clang++ -std=c++23 -O0 bundle_base.cpp -o bundle_base 2>&1 | tee "$OUTPUT_DIR/01_compile_base_output.txt"
if [ $? -eq 0 ]; then
    echo "✓ Base bundle compiled successfully"
    ./bundle_base >> "$OUTPUT_DIR/01_compile_base_output.txt" 2>&1
else
    echo "✗ Base bundle compilation failed"
fi
echo ""

# Test 2: Check API mismatches with grep
echo "Test 2: Checking API signature mismatches..."
cd R1
echo "=== Checking bundle base for expected hook signatures ===" > "$OUTPUT_DIR/02_api_mismatch_check.txt"
grep -n "template decode" ../bundle_base.cpp >> "$OUTPUT_DIR/02_api_mismatch_check.txt" 2>&1
grep -n "template encode" ../bundle_base.cpp >> "$OUTPUT_DIR/02_api_mismatch_check.txt" 2>&1
echo "" >> "$OUTPUT_DIR/02_api_mismatch_check.txt"
echo "=== Checking R1 extension for actual signatures ===" >> "$OUTPUT_DIR/02_api_mismatch_check.txt"
grep -n "static constexpr bundle" r1_extension.cpp >> "$OUTPUT_DIR/02_api_mismatch_check.txt" 2>&1
grep -n "static constexpr void encode" r1_extension.cpp >> "$OUTPUT_DIR/02_api_mismatch_check.txt" 2>&1
echo "✓ API mismatch check completed"
echo ""

# Test 3: Check encode signature issue (int8_t& vs int4x8)
echo "Test 3: Checking encode signature (int8_t& dst parameter)..."
echo "=== encode signature from R1 ===" > "$OUTPUT_DIR/03_encode_signature_check.txt"
grep -A 2 "static constexpr void encode" r1_extension.cpp >> "$OUTPUT_DIR/03_encode_signature_check.txt" 2>&1
echo "" >> "$OUTPUT_DIR/03_encode_signature_check.txt"
echo "=== memcpy line that copies 8 bytes into int8_t& ===" >> "$OUTPUT_DIR/03_encode_signature_check.txt"
grep -n "std::memcpy(&dst" r1_extension.cpp >> "$OUTPUT_DIR/03_encode_signature_check.txt" 2>&1
echo "✓ Encode signature check completed"
echo ""

# Test 4: Check store() call shape (static vs member)
echo "Test 4: Checking store() call shape (static vs member)..."
echo "=== store() declaration in base bundle ===" > "$OUTPUT_DIR/04_store_call_shape.txt"
grep -A 3 "void store" ../bundle_base.cpp >> "$OUTPUT_DIR/04_store_call_shape.txt" 2>&1
echo "" >> "$OUTPUT_DIR/04_store_call_shape.txt"
echo "=== R1 usage example shows static-style call ===" >> "$OUTPUT_DIR/04_store_call_shape.txt"
echo "int8x16::store<int4x8>(&packed, i8);" >> "$OUTPUT_DIR/04_store_call_shape.txt"
echo "But base bundle has store() as member function taking only void* dst" >> "$OUTPUT_DIR/04_store_call_shape.txt"
echo "✓ Store call shape check completed"
echo ""

# Test 5: Try to compile R1 extension with base (expect failure)
echo "Test 5: Attempting to compile R1 extension with base bundle..."
cat ../bundle_base.cpp > temp_combined_r1.cpp
cat r1_extension.cpp >> temp_combined_r1.cpp
# Add usage example
cat >> temp_combined_r1.cpp << 'EOF'

int main() {
    // Create a normal float vector
    auto f32 = float32x16::broadcast(1.5f);

    // Convert to int8 (truncate)
    auto i8 = int8x16::broadcast(1); // just an example

    // Pack into int4x8 (8 bytes)
    int4x8 packed{};
    i8.store<int4x8>(&packed); // member call - corrected from R1's example

    // Unpack back
    auto unpacked = int8x16::load<int4x8>(&packed); // 16 int8

    // Print first few values
    std::cout << static_cast<int>(unpacked[0]) << ", "
              << static_cast<int>(unpacked[1]) << "\n";

    return 0;
}
EOF

cd ..
clang++ -std=c++23 -O0 R1/temp_combined_r1.cpp -o R1/temp_combined_r1 2>&1 | tee "$OUTPUT_DIR/05_compile_r1_extension_output.txt"
if [ $? -eq 0 ]; then
    echo "✓ R1 extension compiled (unexpected!)"
    cd R1
    ./temp_combined_r1 >> "$OUTPUT_DIR/05_compile_r1_extension_output.txt" 2>&1
else
    echo "✗ R1 extension compilation failed (expected due to API mismatches)"
fi
echo ""

# Test 6: Verify int2x16 arithmetic claim
echo "Test 6: Verifying int2x16 arithmetic claim (1 byte = 8 values)..."
cat > "$OUTPUT_DIR/06_int2_arithmetic.txt" << 'EOF'
Response 1 claims: "int2x16 (1 byte = 8 values)"

Arithmetic check:
- 1 byte = 8 bits
- If each value is 2 bits, then 8 bits / 2 bits = 4 values per byte
- For 16 values with 2 bits each: 16 * 2 = 32 bits = 4 bytes

Verdict: The claim "1 byte = 8 values" is INCORRECT.
- Correct: 1 byte = 4 values (for 2-bit values)
- For 16 int2 values, you need 4 bytes, not 2 bytes
EOF
echo "✓ int2 arithmetic check completed"
echo ""

# Cleanup
cd R1
rm -f temp_combined_r1.cpp temp_combined_r1
cd ..
rm -f bundle_base

echo "===== All R1 Tests Completed ====="
echo "Results saved to $OUTPUT_DIR/"
