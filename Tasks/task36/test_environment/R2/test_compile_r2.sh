#!/bin/bash

# Test Response 2 compilation - exactly as described in factual file
OUTPUT_DIR="../outputs/R2"
mkdir -p "$OUTPUT_DIR"

echo "===== Testing Response 2 Compilation ====="
echo ""

# Step 1: Check environment
echo "Step 1: Checking environment..."
echo "=== Environment Check ===" > "$OUTPUT_DIR/00_environment.txt"
echo "uname -m:" >> "$OUTPUT_DIR/00_environment.txt"
uname -m >> "$OUTPUT_DIR/00_environment.txt"
echo "" >> "$OUTPUT_DIR/00_environment.txt"
echo "clang++ --version:" >> "$OUTPUT_DIR/00_environment.txt"
clang++ --version >> "$OUTPUT_DIR/00_environment.txt"
echo "" >> "$OUTPUT_DIR/00_environment.txt"
echo "xcode-select -p:" >> "$OUTPUT_DIR/00_environment.txt"
xcode-select -p >> "$OUTPUT_DIR/00_environment.txt"
echo "✓ Environment check completed"
echo ""

# Step 2: Grep checks for critical issues
echo "Step 2: Checking for critical code issues..."
echo "=== Checking if vec is private in bundle ===" > "$OUTPUT_DIR/01_grep_checks.txt"
grep -B 2 -A 1 "private:" ../bundle_base.cpp >> "$OUTPUT_DIR/01_grep_checks.txt" 2>&1
echo "" >> "$OUTPUT_DIR/01_grep_checks.txt"
echo "=== R2 encode tries to access src.vec ===" >> "$OUTPUT_DIR/01_grep_checks.txt"
grep -n "src.vec" bundle_with_response2.cpp >> "$OUTPUT_DIR/01_grep_checks.txt" 2>&1
echo "" >> "$OUTPUT_DIR/01_grep_checks.txt"
echo "=== Checking if consteval usage ===" >> "$OUTPUT_DIR/01_grep_checks.txt"
grep -n "if consteval" ../bundle_base.cpp >> "$OUTPUT_DIR/01_grep_checks.txt" 2>&1
echo "" >> "$OUTPUT_DIR/01_grep_checks.txt"
echo "=== Checking operator[] return type ===" >> "$OUTPUT_DIR/01_grep_checks.txt"
grep -A 1 "operator\\\[\\\]" ../bundle_base.cpp >> "$OUTPUT_DIR/01_grep_checks.txt" 2>&1
echo "" >> "$OUTPUT_DIR/01_grep_checks.txt"
echo "=== R2 tries assignment through operator[] ===" >> "$OUTPUT_DIR/01_grep_checks.txt"
grep -n "vec\\\[i\\\] =" bundle_with_response2.cpp >> "$OUTPUT_DIR/01_grep_checks.txt" 2>&1
echo "" >> "$OUTPUT_DIR/01_grep_checks.txt"
echo "=== Checking vld1q_s8 usage ===" >> "$OUTPUT_DIR/01_grep_checks.txt"
grep -n "vld1q_s8" bundle_with_response2.cpp >> "$OUTPUT_DIR/01_grep_checks.txt" 2>&1
echo "✓ Code issue checks completed"
echo ""

# Step 3: Compile Response 2 with base bundle
echo "Step 3: Compiling Response 2 extension with base bundle..."
cd ..
clang++ -std=c++23 -O0 R2/bundle_with_response2.cpp -o R2/test_response2 2>&1 | tee "$OUTPUT_DIR/02_compile_response2_output.txt"
if [ $? -eq 0 ]; then
    echo "✓ Response 2 compiled successfully (unexpected!)"
    cd R2
    ./test_response2 >> "$OUTPUT_DIR/02_compile_response2_output.txt" 2>&1
    echo "✓ Response 2 runtime output captured"
    rm test_response2
else
    echo "✗ Response 2 compilation failed (expected due to private access error)"
fi
echo ""

# Step 4: Test sign extension logic separately
echo "Step 4: Testing sign extension logic..."
cat > temp_sign_test.cpp << 'EOF'
#include <iostream>
#include <cstdint>

// R2's sign extension helper (copied verbatim)
static constexpr int8_t load_nibble(uint8_t nibble) {
    int8_t val = static_cast<int8_t>(nibble & 0xF);
    return (val & 0x8) ? (val | 0xF0) : val;  // Sign extend 4-bit to 8-bit
}

int main() {
    std::cout << "Testing R2's sign extension logic:\n\n";

    std::cout << "Test 1: nibble 0xF (should be -1)\n";
    uint8_t nibble = 0xF;
    int8_t result = load_nibble(nibble);
    std::cout << "  Input: 0x" << std::hex << (int)nibble << std::dec << "\n";
    std::cout << "  Output: " << (int)result << "\n";
    std::cout << "  Expected: -1\n";
    std::cout << "  Match: " << (result == -1 ? "YES" : "NO") << "\n\n";

    std::cout << "Test 2: nibble 0x3 (should be 3)\n";
    nibble = 0x3;
    result = load_nibble(nibble);
    std::cout << "  Input: 0x" << std::hex << (int)nibble << std::dec << "\n";
    std::cout << "  Output: " << (int)result << "\n";
    std::cout << "  Expected: 3\n";
    std::cout << "  Match: " << (result == 3 ? "YES" : "NO") << "\n\n";

    std::cout << "Test 3: nibble 0x7 (should be 7, max positive)\n";
    nibble = 0x7;
    result = load_nibble(nibble);
    std::cout << "  Input: 0x" << std::hex << (int)nibble << std::dec << "\n";
    std::cout << "  Output: " << (int)result << "\n";
    std::cout << "  Expected: 7\n";
    std::cout << "  Match: " << (result == 7 ? "YES" : "NO") << "\n\n";

    std::cout << "Test 4: nibble 0x8 (should be -8, min negative)\n";
    nibble = 0x8;
    result = load_nibble(nibble);
    std::cout << "  Input: 0x" << std::hex << (int)nibble << std::dec << "\n";
    std::cout << "  Output: " << (int)result << "\n";
    std::cout << "  Expected: -8\n";
    std::cout << "  Match: " << (result == -8 ? "YES" : "NO") << "\n";

    return 0;
}
EOF

cd ..
clang++ -std=c++23 -O0 R2/temp_sign_test.cpp -o R2/temp_sign_test 2>&1 | tee "$OUTPUT_DIR/03_sign_extension_test.txt"
if [ $? -eq 0 ]; then
    cd R2
    echo "" >> "$OUTPUT_DIR/03_sign_extension_test.txt"
    ./temp_sign_test >> "$OUTPUT_DIR/03_sign_extension_test.txt" 2>&1
    echo "✓ Sign extension test completed"
    rm temp_sign_test temp_sign_test.cpp
else
    echo "✗ Sign extension test compilation failed"
    cd R2
    rm temp_sign_test.cpp
fi
echo ""

# Step 5: Output clamp analysis
echo "Step 5: Analyzing output clamp contradiction..."
cat > "$OUTPUT_DIR/04_output_clamp_analysis.txt" << 'EOF'
=== Response 2 Claimed Output ===
 1  -1   2  -2   3  -3   4  -4
 5  -5   6  -6   7  -7  -8   0
-1   1  -2   2  -3   3  -4   4
-5   5  -6   6  -7   7   8   0

=== Analyzing the final value: 8 ===

From R2's example:
1. Initial value: -8
2. Negation: -(-8) = 8
3. Re-packing through store_nibble

From R2's store_nibble code:
    int8_t clamped = (val < -8) ? -8 : (val > 7 ? 7 : val);
    return static_cast<uint8_t>(clamped & 0xF);

Analysis when val = 8:
- Condition (val > 7) is TRUE
- So clamped = 7
- Return value = 7 & 0xF = 7

Conclusion:
The output showing '8' in the final line CONTRADICTS the clamping logic.
After round-trip: -8 → negate to 8 → clamp to 7 → decode back as 7

The correct output should show 7, not 8.
This is a factual inconsistency between the code and the claimed output.
EOF
echo "✓ Output clamp analysis completed"
echo ""

echo "===== Response 2 Testing Complete ====="
echo "Results saved to: $OUTPUT_DIR/"
