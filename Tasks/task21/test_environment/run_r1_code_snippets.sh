#!/bin/bash
# Run R1 Code Snippets

cd R1

echo "=== Running R1 Code Snippets ==="
echo ""

# Test 1: Basic generateSequence
echo "=== Test 1: Basic generateSequence ===" | tee ../outputs/R1/snippet1_output.txt
kotlinc -script test1_basic_generateSequence.kts | tee -a ../outputs/R1/snippet1_output.txt
echo "" | tee -a ../outputs/R1/snippet1_output.txt

# Test 2: Generic version
echo "=== Test 2: Generic version ===" | tee ../outputs/R1/snippet2_output.txt
kotlinc -script test2_generic_version.kts | tee -a ../outputs/R1/snippet2_output.txt
echo "" | tee -a ../outputs/R1/snippet2_output.txt

# Test 3: Example unsafe expression
echo "=== Test 3: Example unsafe expression ===" | tee ../outputs/R1/snippet3_output.txt
kotlinc -script test3_example_unsafe_expression.kts | tee -a ../outputs/R1/snippet3_output.txt
echo "" | tee -a ../outputs/R1/snippet3_output.txt

echo ""
echo "All R1 code snippets completed!"
