#!/bin/bash

# Response 1 - Snippet 6: Full Podfile Test
# Location: Lines 116-184 in RESPONSE_1.md
# This script tests Response 1's recommended Podfile

echo "=========================================="
echo "Testing Response 1 - Snippet 6"
echo "Full Recommended Podfile"
echo "=========================================="
echo ""

TEST_DIR="/Users/apple/Desktop/Applyloop-project3/Tasks/task16/test_environment/snippet_6_podfile_test"
RESULTS_FILE="/Users/apple/Desktop/Applyloop-project3/Tasks/task16/test_environment/code_snippets/snippet_6_results.txt"

# Create results file
echo "Response 1 - Snippet 6 Test Results" > "$RESULTS_FILE"
echo "Date: $(date)" >> "$RESULTS_FILE"
echo "========================================" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Check if CocoaPods is installed
echo "Step 1: Checking CocoaPods installation..."
if ! command -v pod &> /dev/null; then
    echo "❌ FAILED: CocoaPods not installed" | tee -a "$RESULTS_FILE"
    echo "" >> "$RESULTS_FILE"
    echo "Cannot proceed with full Podfile test without CocoaPods." >> "$RESULTS_FILE"
    echo "Install with: brew install cocoapods" >> "$RESULTS_FILE"
    exit 1
fi

POD_VERSION=$(pod --version)
echo "✅ CocoaPods installed: $POD_VERSION" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Create test directory structure
echo "Step 2: Creating test React Native project structure..."
mkdir -p "$TEST_DIR/ios"
mkdir -p "$TEST_DIR/node_modules/@react-native-firebase/app"
mkdir -p "$TEST_DIR/node_modules/@react-native-firebase/auth"
mkdir -p "$TEST_DIR/node_modules/@react-native-firebase/firestore"
mkdir -p "$TEST_DIR/node_modules/@react-native-firebase/storage"

echo "Test directory created: $TEST_DIR" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Copy Response 1's VERBATIM Podfile
echo "Step 3: Copying Response 1's verbatim Podfile..."
cp /Users/apple/Desktop/Applyloop-project3/Tasks/task16/test_environment/R1_Final_Podfile_VERBATIM.rb "$TEST_DIR/ios/Podfile"

echo "✅ Podfile copied" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Analyze the Podfile before running
echo "Step 4: Analyzing Podfile content..." | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "Platform version:" | tee -a "$RESULTS_FILE"
grep "^platform" "$TEST_DIR/ios/Podfile" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

echo "Firebase pod names:" | tee -a "$RESULTS_FILE"
grep "pod 'RNFirebase" "$TEST_DIR/ios/Podfile" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Expected Errors
echo "========================================" | tee -a "$RESULTS_FILE"
echo "EXPECTED ERRORS:" | tee -a "$RESULTS_FILE"
echo "1. platform :ios, '12.0' - Should be '13.0' for Firebase 11.13.0" | tee -a "$RESULTS_FILE"
echo "2. pod 'RNFirebase' - Should be 'RNFBApp'" | tee -a "$RESULTS_FILE"
echo "3. pod 'RNFirebaseAuth' - Should be 'RNFBAuth'" | tee -a "$RESULTS_FILE"
echo "4. pod 'RNFirebaseFirestore' - Should be 'RNFBFirestore'" | tee -a "$RESULTS_FILE"
echo "5. pod 'RNFirebaseStorage' - Should be 'RNFBStorage'" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Try to run pod install
echo "Step 5: Running 'pod install --repo-update'..." | tee -a "$RESULTS_FILE"
echo "This will likely FAIL due to the errors above." | tee -a "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

cd "$TEST_DIR/ios"
pod install --repo-update 2>&1 | tee -a "$RESULTS_FILE"

POD_EXIT_CODE=$?

echo "" >> "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"
if [ $POD_EXIT_CODE -eq 0 ]; then
    echo "❌ UNEXPECTED: pod install succeeded!" | tee -a "$RESULTS_FILE"
    echo "Response 1's Podfile should have failed." | tee -a "$RESULTS_FILE"
else
    echo "✅ EXPECTED: pod install failed (exit code: $POD_EXIT_CODE)" | tee -a "$RESULTS_FILE"
    echo "This confirms Response 1's solution does NOT work." | tee -a "$RESULTS_FILE"
fi
echo "========================================" | tee -a "$RESULTS_FILE"

echo "" >> "$RESULTS_FILE"
echo "Full test results saved to: $RESULTS_FILE"

cat "$RESULTS_FILE"
