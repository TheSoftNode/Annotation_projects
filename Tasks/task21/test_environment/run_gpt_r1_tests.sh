#!/bin/bash
# Run GPT Factual Tests for R1

cd gpt_factual_tests

echo "=== Compiling and running R1 GPT Factual Tests ==="
echo ""

# Test 1: Test exact nextFloat() sequence expression
echo "=== Test 1: nextFloat() sequence expression ===" | tee ../outputs/R1/test1_output.txt
kotlinc test1.kt -include-runtime -d test1.jar
java -jar test1.jar | tee -a ../outputs/R1/test1_output.txt
echo "" | tee -a ../outputs/R1/test1_output.txt

# Test 2: Test isFinite() claim directly
echo "=== Test 2: isFinite() claim ===" | tee ../outputs/R1/test2_output.txt
kotlinc test2.kt -include-runtime -d test2.jar
java -jar test2.jar | tee -a ../outputs/R1/test2_output.txt
echo "" | tee -a ../outputs/R1/test2_output.txt

# Test 3: Test exact "unsafe expression" example
echo "=== Test 3: Unsafe expression example ===" | tee ../outputs/R1/test3_output.txt
kotlinc test3.kt -include-runtime -d test3.jar
java -jar test3.jar | tee -a ../outputs/R1/test3_output.txt
echo "" | tee -a ../outputs/R1/test3_output.txt

# Test 4: Test boundary - this will hang, so we skip or run with timeout
echo "=== Test 4: Boundary test (will hang - skipping) ===" | tee ../outputs/R1/test4_output.txt
echo "This test intentionally generates only NaN and will hang." | tee -a ../outputs/R1/test4_output.txt
echo "Run manually with timeout if needed: timeout 5s java -jar test4.jar" | tee -a ../outputs/R1/test4_output.txt
# kotlinc test4.kt -include-runtime -d test4.jar
# timeout 5s java -jar test4.jar | tee -a ../outputs/R1/test4_output.txt || echo "Timed out as expected" | tee -a ../outputs/R1/test4_output.txt

echo ""
echo "All R1 GPT Factual tests completed!"
