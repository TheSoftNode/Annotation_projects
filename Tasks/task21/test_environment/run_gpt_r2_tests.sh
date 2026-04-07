#!/bin/bash
# Run GPT Factual Tests for R2

cd gpt_factual_tests_R2

echo "=== Compiling and running R2 GPT Factual Tests ==="
echo ""

# Test A: Test the exact Math.random() * Float.MAX_VALUE claim
echo "=== Test A: Math.random() * Float.MAX_VALUE ===" | tee ../outputs/R2/test_raw_expression_output.txt
kotlinc test_raw_expression.kt -include-runtime -d test_raw_expression.jar
java -jar test_raw_expression.jar | tee -a ../outputs/R2/test_raw_expression_output.txt
echo "" | tee -a ../outputs/R2/test_raw_expression_output.txt

# Test B: Test the exact Random.nextFloat() claim
echo "=== Test B: Random.nextFloat() ===" | tee ../outputs/R2/test_nextfloat_output.txt
kotlinc test_nextfloat.kt -include-runtime -d test_nextfloat.jar
java -jar test_nextfloat.jar | tee -a ../outputs/R2/test_nextfloat_output.txt
echo "" | tee -a ../outputs/R2/test_nextfloat_output.txt

# Test C: Test the range-scaling claim with normal values
echo "=== Test C: Range scaling (normal) ===" | tee ../outputs/R2/test_range_normal_output.txt
kotlinc test_range_normal.kt -include-runtime -d test_range_normal.jar
java -jar test_range_normal.jar | tee -a ../outputs/R2/test_range_normal_output.txt
echo "" | tee -a ../outputs/R2/test_range_normal_output.txt

# Test D: Test the disputed "finite min/max always implies finite result" claim
echo "=== Test D: Range scaling (extreme) ===" | tee ../outputs/R2/test_range_extreme_output.txt
kotlinc test_range_extreme.kt -include-runtime -d test_range_extreme.jar
java -jar test_range_extreme.jar | tee -a ../outputs/R2/test_range_extreme_output.txt
echo "" | tee -a ../outputs/R2/test_range_extreme_output.txt

# Test E: Test the Flow snippet (will fail to compile)
echo "=== Test E: Flow snippet (expected to fail) ===" | tee ../outputs/R2/test_flow_verbatim_output.txt
kotlinc test_flow_verbatim.kt 2>&1 | tee -a ../outputs/R2/test_flow_verbatim_output.txt
echo "" | tee -a ../outputs/R2/test_flow_verbatim_output.txt

# Test F: Test the recursive helper
echo "=== Test F: Recursive helper ===" | tee ../outputs/R2/test_recursive_helper_output.txt
kotlinc test_recursive_helper.kt -include-runtime -d test_recursive_helper.jar
java -jar test_recursive_helper.jar | tee -a ../outputs/R2/test_recursive_helper_output.txt
echo "" | tee -a ../outputs/R2/test_recursive_helper_output.txt

# Test G: Test the boundary of recursive helper (will stack overflow)
echo "=== Test G: Recursive boundary (will stack overflow) ===" | tee ../outputs/R2/test_recursive_boundary_output.txt
kotlinc test_recursive_boundary.kt -include-runtime -d test_recursive_boundary.jar
java -jar test_recursive_boundary.jar 2>&1 | tee -a ../outputs/R2/test_recursive_boundary_output.txt || echo "Stack overflow as expected" | tee -a ../outputs/R2/test_recursive_boundary_output.txt
echo "" | tee -a ../outputs/R2/test_recursive_boundary_output.txt

echo ""
echo "All R2 GPT Factual tests completed!"
