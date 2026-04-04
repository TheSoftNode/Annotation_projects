#!/bin/bash

# Test script to verify all invalid commands and code from Response 2
# This will run all the commands mentioned in the AOIs and save outputs

OUTPUT_DIR="/Users/apple/Desktop/Applyloop-project3/Tasks/task16/test_environment/outputs"
mkdir -p "$OUTPUT_DIR"

echo "======================================================================"
echo "Testing all invalid commands and code from Response 2"
echo "======================================================================"
echo ""

# Test 1: pod ipc FirebaseAuth (AOI #2)
echo "=== TEST 1: pod ipc FirebaseAuth ==="
echo "Running: pod ipc FirebaseAuth"
pod ipc FirebaseAuth 2>&1 | tee "$OUTPUT_DIR/test1_pod_ipc.txt"
echo ""
echo "Output saved to: $OUTPUT_DIR/test1_pod_ipc.txt"
echo ""

# Test 2: pod lib lint FirebaseAuth (AOI #3)
echo "=== TEST 2: pod lib lint FirebaseAuth --verbose ==="
echo "Running: pod lib lint FirebaseAuth --verbose"
pod lib lint FirebaseAuth --verbose 2>&1 | head -30 | tee "$OUTPUT_DIR/test2_pod_lib_lint.txt"
echo ""
echo "Output saved to: $OUTPUT_DIR/test2_pod_lib_lint.txt"
echo ""

# Test 3: pod dependency tree (AOI #3)
echo "=== TEST 3: pod dependency tree --plain ==="
echo "Running: pod dependency tree --plain"
pod dependency tree --plain 2>&1 | tee "$OUTPUT_DIR/test3_pod_dependency_tree.txt"
echo ""
echo "Output saved to: $OUTPUT_DIR/test3_pod_dependency_tree.txt"
echo ""

# Test 4 & 5: Ruby code tests (AOI #4 and #7)
echo "=== TEST 4 & 5: Ruby code tests ==="
cat > "$OUTPUT_DIR/test_ruby_code.rb" << 'RUBYEOF'
#!/usr/bin/env ruby

puts "=== TEST 4: Pod::MaterialPodfileDefaults (AOI #4) ==="
puts "Code: require 'cocoapods'; Pod::MaterialPodfileDefaults.new([:android, :ios]).apply"
begin
  require 'cocoapods'
  Pod::MaterialPodfileDefaults.new([:android, :ios]).apply
  puts "SUCCESS: Code executed without errors"
rescue => e
  puts "ERROR: #{e.class}"
  puts "#{e.message}"
  puts ""
  puts "Full error:"
  puts e.backtrace.first(3).join("\n")
end

puts ""
puts "=== TEST 5: UIHostedViewController.isSimulator (AOI #7) ==="
puts "Code: UIHostedViewController.isSimulator"
begin
  result = UIHostedViewController.isSimulator
  puts "SUCCESS: #{result}"
rescue => e
  puts "ERROR: #{e.class}"
  puts "#{e.message}"
  puts ""
  puts "Full error:"
  puts e.backtrace.first(3).join("\n")
end
RUBYEOF

chmod +x "$OUTPUT_DIR/test_ruby_code.rb"
ruby "$OUTPUT_DIR/test_ruby_code.rb" 2>&1 | tee "$OUTPUT_DIR/test4_and_test5_ruby_code.txt"
echo ""
echo "Output saved to: $OUTPUT_DIR/test4_and_test5_ruby_code.txt"
echo ""

echo "======================================================================"
echo "All tests completed!"
echo "======================================================================"
echo ""
echo "Summary of outputs:"
echo "  1. pod ipc FirebaseAuth          -> $OUTPUT_DIR/test1_pod_ipc.txt"
echo "  2. pod lib lint FirebaseAuth     -> $OUTPUT_DIR/test2_pod_lib_lint.txt"
echo "  3. pod dependency tree           -> $OUTPUT_DIR/test3_pod_dependency_tree.txt"
echo "  4. Ruby code tests               -> $OUTPUT_DIR/test4_and_test5_ruby_code.txt"
echo ""
echo "All outputs are also displayed above."
echo ""
