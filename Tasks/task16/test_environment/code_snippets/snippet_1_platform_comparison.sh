#!/bin/bash

# Response 1 - Snippet 1: Before/After Platform Comparison
# Location: Lines 34, 38 in RESPONSE_1.md

RESULTS_FILE="/Users/apple/Desktop/Applyloop-project3/Tasks/task16/test_environment/code_snippets/snippet_1_results.txt"

echo "=========================================="
echo "Testing Response 1 - Snippet 1"
echo "Before/After Platform Comparison"
echo "=========================================="
echo ""

# Create results file
echo "Response 1 - Snippet 1 Test Results" > "$RESULTS_FILE"
echo "Date: $(date)" >> "$RESULTS_FILE"
echo "========================================" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "BEFORE (Line 34):" | tee -a "$RESULTS_FILE"
echo "platform :ios, '11.0'   # ❌ Too low" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "AFTER (Line 38):" | tee -a "$RESULTS_FILE"
echo "platform :ios, '12.0'   # ✅ Required for Firebase 11+" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "========================================" | tee -a "$RESULTS_FILE"
echo "VERIFICATION:" | tee -a "$RESULTS_FILE"
echo "Checking actual Firebase 11.13.0 requirement..." | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Verify actual requirement
ACTUAL_REQUIREMENT=$(curl -sL https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuthInterop.podspec | grep "deployment_target" | head -1)

echo "Firebase 11.13.0 actual requirement:" | tee -a "$RESULTS_FILE"
echo "$ACTUAL_REQUIREMENT" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "========================================" | tee -a "$RESULTS_FILE"
echo "ANALYSIS:" | tee -a "$RESULTS_FILE"
echo "❌ Response 1 claims: iOS 12.0" | tee -a "$RESULTS_FILE"
echo "✅ Actual requirement: iOS 13.0" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"
echo "AOI #2: Wrong deployment target in code snippet" | tee -a "$RESULTS_FILE"
echo "The suggested fix 'platform :ios, 12.0' will NOT work!" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"

cat "$RESULTS_FILE"
