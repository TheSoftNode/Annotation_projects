#!/bin/bash

# Run all R2 tests and save outputs
OUTPUT_DIR="../outputs/R2"
mkdir -p "$OUTPUT_DIR"

echo "===== Running R2 Tests ====="
echo ""

# Test 1: Check private member access
echo "Test 1: Checking private member access (src.vec)..."
echo "=== Checking if bundle::vec is private ===" > "$OUTPUT_DIR/01_private_access_check.txt"
grep -B 2 -A 1 "private:" ../bundle_base.cpp >> "$OUTPUT_DIR/01_private_access_check.txt" 2>&1
echo "" >> "$OUTPUT_DIR/01_private_access_check.txt"
echo "=== R2 encode tries to access src.vec ===" >> "$OUTPUT_DIR/01_private_access_check.txt"
grep -n "src.vec" r2_extension.cpp >> "$OUTPUT_DIR/01_private_access_check.txt" 2>&1
echo "" >> "$OUTPUT_DIR/01_private_access_check.txt"
echo "Verdict: src.vec is private in bundle, but R2's encode accesses it directly." >> "$OUTPUT_DIR/01_private_access_check.txt"
echo "This should cause a compilation error." >> "$OUTPUT_DIR/01_private_access_check.txt"
echo "✓ Private access check completed"
echo ""

# Test 2: Check if consteval behavior
echo "Test 2: Checking if consteval runtime dispatch..."
echo "=== if consteval in bundle base ===" > "$OUTPUT_DIR/02_if_consteval_check.txt"
grep -B 2 -A 5 "if consteval" ../bundle_base.cpp >> "$OUTPUT_DIR/02_if_consteval_check.txt" 2>&1
echo "" >> "$OUTPUT_DIR/02_if_consteval_check.txt"
echo "Verdict: if consteval only executes first branch in constant-evaluated context." >> "$OUTPUT_DIR/02_if_consteval_check.txt"
echo "At runtime, the 'else' branch (memcpy) executes, NOT the custom codec hooks." >> "$OUTPUT_DIR/02_if_consteval_check.txt"
echo "R2's claim of 'runtime dispatch via if consteval' is not accurate." >> "$OUTPUT_DIR/02_if_consteval_check.txt"
echo "✓ if consteval check completed"
echo ""

# Test 3: Check operator[] return type
echo "Test 3: Checking operator[] return type..."
echo "=== operator[] in bundle base ===" > "$OUTPUT_DIR/03_operator_bracket_check.txt"
grep -A 1 "operator\\\[\\\]" ../bundle_base.cpp >> "$OUTPUT_DIR/03_operator_bracket_check.txt" 2>&1
echo "" >> "$OUTPUT_DIR/03_operator_bracket_check.txt"
echo "=== R2 usage example tries to assign through operator[] ===" >> "$OUTPUT_DIR/03_operator_bracket_check.txt"
echo "vec[i] = static_cast<int8_t>(-vec[i]); // from R2 example" >> "$OUTPUT_DIR/03_operator_bracket_check.txt"
echo "" >> "$OUTPUT_DIR/03_operator_bracket_check.txt"
echo "Verdict: operator[] returns by value (value_type), not by reference." >> "$OUTPUT_DIR/03_operator_bracket_check.txt"
echo "Assignment like 'vec[i] = ...' will not compile with the base bundle." >> "$OUTPUT_DIR/03_operator_bracket_check.txt"
echo "✓ operator[] check completed"
echo ""

# Test 4: Check vld1q_s8 return type
echo "Test 4: Verifying vld1q_s8 return type..."
echo "=== R2 claims 'Load into NEON vector: int8x16x1_t' ===" > "$OUTPUT_DIR/04_vld1q_return_type.txt"
echo "But the actual code uses:" >> "$OUTPUT_DIR/04_vld1q_return_type.txt"
grep -n "int8x16_t vec = vld1q_s8" r2_extension.cpp >> "$OUTPUT_DIR/04_vld1q_return_type.txt" 2>&1
echo "" >> "$OUTPUT_DIR/04_vld1q_return_type.txt"
echo "According to ARM ACLE documentation:" >> "$OUTPUT_DIR/04_vld1q_return_type.txt"
echo "vld1q_s8(int8_t const *ptr) returns int8x16_t (NOT int8x16x1_t)" >> "$OUTPUT_DIR/04_vld1q_return_type.txt"
echo "" >> "$OUTPUT_DIR/04_vld1q_return_type.txt"
echo "Verdict: R2's prose claim about int8x16x1_t contradicts the actual code and ARM docs." >> "$OUTPUT_DIR/04_vld1q_return_type.txt"
echo "✓ vld1q return type check completed"
echo ""

# Test 5: Test output clamp contradiction
echo "Test 5: Testing output clamp contradiction (value 8)..."
cat > "$OUTPUT_DIR/05_output_clamp_check.txt" << 'EOF'
=== R2 Example Output Claims ===
 -1   1  -2   2  -3   3  -4   4
 -5   5  -6   6  -7   7   8   0

=== Analyzing the final value 8 ===
The example starts with -8, negates it to 8, then repacks.

From R2's store_nibble code:
int8_t clamped = (val < -8) ? -8 : (val > 7 ? 7 : val);

When val = 8:
- (val > 7) is true
- So clamped = 7

Verdict: The output showing '8' contradicts the clamping logic in store_nibble.
After round-trip, -8 -> 8 -> clamped to 7 -> should print 7, not 8.
EOF
echo "✓ Output clamp check completed"
echo ""

# Test 6: Try to compile R2 extension with base
echo "Test 6: Attempting to compile R2 extension with base bundle..."
cat ../bundle_base.cpp > temp_combined_r2.cpp
cat r2_extension.cpp >> temp_combined_r2.cpp
# Add usage example
cat >> temp_combined_r2.cpp << 'EOF'

int main() {
    // Create test data: 16 int4 values (in range [-8,7])
    int4x8 packed;
    std::array<int8_t, 16> expected = {
        1, -1, 2, -2, 3, -3, 4, -4,
        5, -5, 6, -6, 7, -7, -8, 0
    };

    // Pack into int4x8
    for (int i = 0; i < 8; ++i) {
        uint8_t lo = int4x8::store_nibble(expected[2*i + 0]);
        uint8_t hi = int4x8::store_nibble(expected[2*i + 1]);
        packed.data[i] = std::byte{(hi << 4) | lo};
    }

    // Decode into SIMD bundle
    auto vec = bundle<int8_t>::load<int4x8>(&packed);

    // Extract and verify
    for (int i = 0; i < 16; ++i) {
        int8_t val = vec[i];
        std::cout << std::setw(3) << (int)val << " ";
        if ((i+1) % 8 == 0) std::cout << "\n";
    }

    return 0;
}
EOF

cd ..
clang++ -std=c++23 -O0 R2/temp_combined_r2.cpp -o R2/temp_combined_r2 2>&1 | tee "$OUTPUT_DIR/06_compile_r2_extension_output.txt"
if [ $? -eq 0 ]; then
    echo "✓ R2 extension compiled (unexpected!)"
    cd R2
    ./temp_combined_r2 >> "$OUTPUT_DIR/06_compile_r2_extension_output.txt" 2>&1
else
    echo "✗ R2 extension compilation failed (expected due to private access error)"
fi
echo ""

# Test 7: Verify sign extension logic
echo "Test 7: Testing sign extension logic..."
cat > temp_sign_test.cpp << 'EOF'
#include <iostream>
#include <cstdint>

// R2's sign extension helper
static constexpr int8_t load_nibble(uint8_t nibble) {
    int8_t val = static_cast<int8_t>(nibble & 0xF);
    return (val & 0x8) ? (val | 0xF0) : val;
}

int main() {
    std::cout << "Testing sign extension for nibble 0xF (should be -1):\n";
    uint8_t nibble = 0xF;
    int8_t result = load_nibble(nibble);
    std::cout << "nibble = 0xF, result = " << (int)result << "\n";
    std::cout << "Expected: -1\n";
    std::cout << "Match: " << (result == -1 ? "YES" : "NO") << "\n";

    std::cout << "\nTesting positive nibble 0x3 (should be 3):\n";
    nibble = 0x3;
    result = load_nibble(nibble);
    std::cout << "nibble = 0x3, result = " << (int)result << "\n";
    std::cout << "Expected: 3\n";
    std::cout << "Match: " << (result == 3 ? "YES" : "NO") << "\n";

    return 0;
}
EOF

cd ..
clang++ -std=c++23 -O0 R2/temp_sign_test.cpp -o R2/temp_sign_test 2>&1 | tee "$OUTPUT_DIR/07_sign_extension_test.txt"
if [ $? -eq 0 ]; then
    cd R2
    ./temp_sign_test >> "$OUTPUT_DIR/07_sign_extension_test.txt" 2>&1
    echo "✓ Sign extension test completed"
else
    echo "✗ Sign extension test compilation failed"
fi
echo ""

# Cleanup
cd R2
rm -f temp_combined_r2.cpp temp_combined_r2 temp_sign_test.cpp temp_sign_test
cd ..
rm -f bundle_base

echo "===== All R2 Tests Completed ====="
echo "Results saved to $OUTPUT_DIR/"
