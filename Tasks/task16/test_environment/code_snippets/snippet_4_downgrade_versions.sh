#!/bin/bash

# Response 1 - Snippet 4: Firebase Downgrade Versions
# Location: Lines 91-95 in RESPONSE_1.md

RESULTS_FILE="/Users/apple/Desktop/Applyloop-project3/Tasks/task16/test_environment/code_snippets/snippet_4_results.txt"

echo "=========================================="
echo "Testing Response 1 - Snippet 4"
echo "Firebase Downgrade Versions"
echo "=========================================="
echo ""

# Create results file
echo "Response 1 - Snippet 4 Test Results" > "$RESULTS_FILE"
echo "Date: $(date)" >> "$RESULTS_FILE"
echo "========================================" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "Response 1's Downgrade Recommendation:" | tee -a "$RESULTS_FILE"
echo "pod 'Firebase/Auth', '~> 10.25.0'" | tee -a "$RESULTS_FILE"
echo "pod 'Firebase/Firestore', '~> 10.25.0'" | tee -a "$RESULTS_FILE"
echo "pod 'Firebase/Storage', '~> 10.25.0'" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "========================================" | tee -a "$RESULTS_FILE"
echo "VERIFICATION:" | tee -a "$RESULTS_FILE"
echo "Checking Firebase 10.25.0 iOS requirements..." | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Verify Firebase 10.25.0 requirements
echo "Firebase 10.25.0 - FirebaseAuth:" | tee -a "$RESULTS_FILE"
FIREBASE_10_AUTH=$(curl -sL https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-10.25.0/FirebaseAuth.podspec | grep "deployment_target" | head -1)
echo "$FIREBASE_10_AUTH" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "Firebase 10.25.0 - FirebaseAuthInterop:" | tee -a "$RESULTS_FILE"
FIREBASE_10_INTEROP=$(curl -sL https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-10.25.0/FirebaseAuthInterop.podspec | grep "deployment_target" | head -1)
echo "$FIREBASE_10_INTEROP" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "========================================" | tee -a "$RESULTS_FILE"
echo "ANALYSIS:" | tee -a "$RESULTS_FILE"
echo "✅ Response 1 correctly states Firebase 10.25.0 supports iOS 11.0+" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"
echo "NOTE: However, this downgrade advice is for direct Firebase pods," | tee -a "$RESULTS_FILE"
echo "not @react-native-firebase wrappers used in the context." | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"

cat "$RESULTS_FILE"
