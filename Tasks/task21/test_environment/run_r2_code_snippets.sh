#!/bin/bash
# Run R2 Code Snippets

cd R2

echo "=== Running R2 Code Snippets ==="
echo ""

# Test 1: Problem example
echo "=== Test 1: Problem example ===" | tee ../outputs/R2/snippet1_output.txt
kotlinc -script test1_problem_example.kts | tee -a ../outputs/R2/snippet1_output.txt
echo "" | tee -a ../outputs/R2/snippet1_output.txt

# Test 2: Simplest solution
echo "=== Test 2: Simplest solution ===" | tee ../outputs/R2/snippet2_output.txt
kotlinc -script test2_simplest_solution.kts | tee -a ../outputs/R2/snippet2_output.txt
echo "" | tee -a ../outputs/R2/snippet2_output.txt

# Test 3: Range scaling
echo "=== Test 3: Range scaling ===" | tee ../outputs/R2/snippet3_output.txt
kotlinc -script test3_range_scaling.kts | tee -a ../outputs/R2/snippet3_output.txt
echo "" | tee -a ../outputs/R2/snippet3_output.txt

# Test 4: Flow filter (will fail without coroutines library)
echo "=== Test 4: Flow filter (expected to fail without coroutines) ===" | tee ../outputs/R2/snippet4_output.txt
kotlinc -script test4_flow_filter.kts 2>&1 | tee -a ../outputs/R2/snippet4_output.txt
echo "" | tee -a ../outputs/R2/snippet4_output.txt

# Test 5: Recursive helper
echo "=== Test 5: Recursive helper ===" | tee ../outputs/R2/snippet5_output.txt
kotlinc -script test5_recursive_helper.kts | tee -a ../outputs/R2/snippet5_output.txt
echo "" | tee -a ../outputs/R2/snippet5_output.txt

# Test 6: TL;DR one-liner
echo "=== Test 6: TL;DR one-liner ===" | tee ../outputs/R2/snippet6_output.txt
kotlinc -script test6_tldr_oneliner.kts | tee -a ../outputs/R2/snippet6_output.txt
echo "" | tee -a ../outputs/R2/snippet6_output.txt

echo ""
echo "All R2 code snippets completed!"
