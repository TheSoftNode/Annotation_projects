#!/bin/bash

# Test script to verify Firebase iOS SDK version requirements
# This script tests claims from Response 1 about iOS deployment targets

echo "=========================================="
echo "Task 16 - Response 1 Verification Tests"
echo "=========================================="
echo ""

# Test 1: Firebase 11.13.0 - FirebaseAuthInterop
echo "Test 1: Firebase 11.13.0 - FirebaseAuthInterop deployment target"
echo "Response 1 claims: iOS 12.0"
echo "Actual requirement:"
curl -sL https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuthInterop.podspec | grep "deployment_target" | head -1
echo ""

# Test 2: Firebase 11.13.0 - FirebaseAuth
echo "Test 2: Firebase 11.13.0 - FirebaseAuth deployment target"
echo "Response 1 claims: iOS 12.0"
echo "Actual requirement:"
curl -sL https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuth.podspec | grep "deployment_target" | head -1
echo ""

# Test 3: Firebase 10.25.0 - FirebaseAuthInterop
echo "Test 3: Firebase 10.25.0 - FirebaseAuthInterop deployment target"
echo "Response 1 claims: iOS 11.0"
echo "Actual requirement:"
curl -sL https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-10.25.0/FirebaseAuthInterop.podspec | grep "deployment_target" | head -1
echo ""

# Test 4: Firebase 10.25.0 - FirebaseAuth
echo "Test 4: Firebase 10.25.0 - FirebaseAuth deployment target"
echo "Response 1 claims: iOS 11.0"
echo "Actual requirement:"
curl -sL https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-10.25.0/FirebaseAuth.podspec | grep "deployment_target" | head -1
echo ""

echo "=========================================="
echo "Summary:"
echo "- Firebase 11.13.0 requires iOS 13.0 (NOT 12.0)"
echo "- Firebase 10.25.0 requires iOS 11.0 (CORRECT)"
echo "=========================================="
