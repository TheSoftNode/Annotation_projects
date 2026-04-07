# Individual Test Commands

## R1 GPT Factual Tests

Run these from `/Tasks/task21/test_environment/gpt_factual_tests/`:

```bash
# Test 1
kotlinc test1.kt -include-runtime -d test1.jar
java -jar test1.jar | tee ../outputs/R1/test1_output.txt

# Test 2
kotlinc test2.kt -include-runtime -d test2.jar
java -jar test2.jar | tee ../outputs/R1/test2_output.txt

# Test 3
kotlinc test3.kt -include-runtime -d test3.jar
java -jar test3.jar | tee ../outputs/R1/test3_output.txt

# Test 4 (will hang - skip or use timeout)
kotlinc test4.kt -include-runtime -d test4.jar
timeout 5s java -jar test4.jar | tee ../outputs/R1/test4_output.txt
```

## R2 GPT Factual Tests

Run these from `/Tasks/task21/test_environment/gpt_factual_tests_R2/`:

```bash
# Test A
kotlinc test_raw_expression.kt -include-runtime -d test_raw_expression.jar
java -jar test_raw_expression.jar | tee ../outputs/R2/test_raw_expression_output.txt

# Test B
kotlinc test_nextfloat.kt -include-runtime -d test_nextfloat.jar
java -jar test_nextfloat.jar | tee ../outputs/R2/test_nextfloat_output.txt

# Test C
kotlinc test_range_normal.kt -include-runtime -d test_range_normal.jar
java -jar test_range_normal.jar | tee ../outputs/R2/test_range_normal_output.txt

# Test D
kotlinc test_range_extreme.kt -include-runtime -d test_range_extreme.jar
java -jar test_range_extreme.jar | tee ../outputs/R2/test_range_extreme_output.txt

# Test E (expected to fail)
kotlinc test_flow_verbatim.kt 2>&1 | tee ../outputs/R2/test_flow_verbatim_output.txt

# Test F
kotlinc test_recursive_helper.kt -include-runtime -d test_recursive_helper.jar
java -jar test_recursive_helper.jar | tee ../outputs/R2/test_recursive_helper_output.txt

# Test G (will stack overflow)
kotlinc test_recursive_boundary.kt -include-runtime -d test_recursive_boundary.jar
java -jar test_recursive_boundary.jar 2>&1 | tee ../outputs/R2/test_recursive_boundary_output.txt
```

## R1 Code Snippets

Run these from `/Tasks/task21/test_environment/R1/`:

```bash
# Snippet 1
kotlinc -script test1_basic_generateSequence.kts | tee ../outputs/R1/snippet1_output.txt

# Snippet 2
kotlinc -script test2_generic_version.kts | tee ../outputs/R1/snippet2_output.txt

# Snippet 3
kotlinc -script test3_example_unsafe_expression.kts | tee ../outputs/R1/snippet3_output.txt
```

## R2 Code Snippets

Run these from `/Tasks/task21/test_environment/R2/`:

```bash
# Snippet 1
kotlinc -script test1_problem_example.kts | tee ../outputs/R2/snippet1_output.txt

# Snippet 2
kotlinc -script test2_simplest_solution.kts | tee ../outputs/R2/snippet2_output.txt

# Snippet 3
kotlinc -script test3_range_scaling.kts | tee ../outputs/R2/snippet3_output.txt

# Snippet 4 (expected to fail)
kotlinc -script test4_flow_filter.kts 2>&1 | tee ../outputs/R2/snippet4_output.txt

# Snippet 5
kotlinc -script test5_recursive_helper.kts | tee ../outputs/R2/snippet5_output.txt

# Snippet 6
kotlinc -script test6_tldr_oneliner.kts | tee ../outputs/R2/snippet6_output.txt
```
