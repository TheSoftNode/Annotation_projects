#!/bin/bash

# Test Response 1 compilation - exactly as described in factual file
OUTPUT_DIR="../outputs/R1"
mkdir -p "$OUTPUT_DIR"

echo "===== Testing Response 1 Compilation ====="
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

# Step 2: Compile base bundle alone
echo "Step 2: Compiling base bundle alone..."
cd ..
clang++ -std=c++23 -O0 bundle_base.cpp -o test_bundle_base 2>&1 | tee "$OUTPUT_DIR/01_compile_base_output.txt"
if [ $? -eq 0 ]; then
    echo "✓ Base bundle compiled successfully"
    ./test_bundle_base >> "$OUTPUT_DIR/01_compile_base_output.txt" 2>&1
    rm test_bundle_base
else
    echo "✗ Base bundle compilation failed"
fi
echo ""

# Step 3: Grep checks for API signatures
echo "Step 3: Checking API signature mismatches..."
cd R1
echo "=== Checking bundle base for template decode/encode ===" > "$OUTPUT_DIR/02_grep_api_check.txt"
grep -n "template decode" ../bundle_base.cpp >> "$OUTPUT_DIR/02_grep_api_check.txt" 2>&1 || echo "Not found in base" >> "$OUTPUT_DIR/02_grep_api_check.txt"
grep -n "template encode" ../bundle_base.cpp >> "$OUTPUT_DIR/02_grep_api_check.txt" 2>&1 || echo "Not found in base" >> "$OUTPUT_DIR/02_grep_api_check.txt"
echo "" >> "$OUTPUT_DIR/02_grep_api_check.txt"
echo "=== Checking R1 extension for decode/encode signatures ===" >> "$OUTPUT_DIR/02_grep_api_check.txt"
grep -n "static constexpr bundle<int8_t, 16> decode" bundle_with_response1.cpp >> "$OUTPUT_DIR/02_grep_api_check.txt" 2>&1
grep -n "static constexpr void encode" bundle_with_response1.cpp >> "$OUTPUT_DIR/02_grep_api_check.txt" 2>&1
echo "" >> "$OUTPUT_DIR/02_grep_api_check.txt"
echo "=== Checking store() declaration ===" >> "$OUTPUT_DIR/02_grep_api_check.txt"
grep -n "void store" ../bundle_base.cpp >> "$OUTPUT_DIR/02_grep_api_check.txt" 2>&1
echo "" >> "$OUTPUT_DIR/02_grep_api_check.txt"
echo "=== R1 example store() call ===" >> "$OUTPUT_DIR/02_grep_api_check.txt"
grep -n "int8x16::store<int4x8>" bundle_with_response1.cpp >> "$OUTPUT_DIR/02_grep_api_check.txt" 2>&1
echo "✓ API signature check completed"
echo ""

# Step 4: Compile Response 1 with base bundle
echo "Step 4: Compiling Response 1 extension with base bundle..."
cd ..
clang++ -std=c++23 -O0 R1/bundle_with_response1.cpp -o R1/test_response1 2>&1 | tee "$OUTPUT_DIR/03_compile_response1_output.txt"
if [ $? -eq 0 ]; then
    echo "✓ Response 1 compiled successfully (unexpected!)"
    cd R1
    ./test_response1 >> "$OUTPUT_DIR/03_compile_response1_output.txt" 2>&1
    echo "✓ Response 1 runtime output captured"
    rm test_response1
else
    echo "✗ Response 1 compilation failed (expected due to API mismatches)"
fi
echo ""

# Step 5: Arithmetic check for int2x16 claim
echo "Step 5: Checking int2x16 arithmetic claim..."
cat > "$OUTPUT_DIR/04_int2_arithmetic.txt" << 'EOF'
Response 1 Claim: "Extensible: You can add int2x16 (1 byte = 8 values) the same way."

Arithmetic verification:
- 1 byte = 8 bits
- If each value uses 2 bits:
  - 8 bits / 2 bits per value = 4 values per byte
- For 16 values with 2 bits each:
  - 16 values × 2 bits = 32 bits = 4 bytes

Conclusion: The claim "1 byte = 8 values" is INCORRECT.
- Actual: 1 byte = 4 values (for 2-bit values)
- For 16 int2 values: need 4 bytes, not 2 bytes
EOF
echo "✓ int2 arithmetic verification completed"
echo ""

echo "===== Response 1 Testing Complete ====="
echo "Results saved to: $OUTPUT_DIR/"
