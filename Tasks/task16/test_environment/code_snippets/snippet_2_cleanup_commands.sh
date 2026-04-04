#!/bin/bash

# Response 1 - Snippet 2: Terminal Cleanup Commands
# Location: Lines 62-68 in RESPONSE_1.md
# This is VERBATIM from Response 1

echo "=========================================="
echo "Testing Response 1 - Snippet 2"
echo "Terminal Cleanup Commands"
echo "=========================================="
echo ""

# Note: These commands require CocoaPods to be installed
# and should be run from a React Native project directory

echo "Command 1: cd ios"
echo "Expected: Change to ios directory"
echo ""

echo "Command 2: pod deintegrate         # Removes all pod files (safely)"
echo "Expected: Remove CocoaPods from Xcode project"
echo "Note: Comment claims 'Removes all pod files' - This is INACCURATE (AOI #6)"
echo "Actual behavior: Removes traces from Xcode project, not all pod files"
echo ""

echo "Command 3: pod cache clean --all   # Cleans CocoaPods cache"
echo "Expected: Clean all cached pods"
echo "Note: This command description is ACCURATE"
echo ""

echo "Command 4: pod install --repo-update"
echo "Expected: Install pods and update repo specs"
echo "Note: This command description is ACCURATE"
echo ""

echo "=========================================="
echo "Test Result: Commands are syntactically correct"
echo "AOI Found: Comment for 'pod deintegrate' is misleading"
echo "=========================================="
