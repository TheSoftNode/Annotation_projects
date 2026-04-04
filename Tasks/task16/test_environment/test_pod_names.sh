#!/bin/bash

# Test script to verify React Native Firebase pod names
# This script tests claims from Response 1 about pod naming

echo "=========================================="
echo "Task 16 - React Native Firebase Pod Names"
echo "=========================================="
echo ""

# Test 1: App pod name
echo "Test 1: @react-native-firebase/app pod name"
echo "Response 1 uses: RNFirebase"
echo "Actual pod name:"
curl -sL https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/app/RNFBApp.podspec | grep "s.name" | head -1
echo ""

# Test 2: Auth pod name
echo "Test 2: @react-native-firebase/auth pod name"
echo "Response 1 uses: RNFirebaseAuth"
echo "Actual pod name:"
curl -sL https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/auth/RNFBAuth.podspec | grep "s.name" | head -1
echo ""

# Test 3: Firestore pod name
echo "Test 3: @react-native-firebase/firestore pod name"
echo "Response 1 uses: RNFirebaseFirestore"
echo "Actual pod name:"
curl -sL https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/firestore/RNFBFirestore.podspec | grep "s.name" | head -1
echo ""

# Test 4: Storage pod name
echo "Test 4: @react-native-firebase/storage pod name"
echo "Response 1 uses: RNFirebaseStorage"
echo "Actual pod name:"
curl -sL https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/storage/RNFBStorage.podspec | grep "s.name" | head -1
echo ""

echo "=========================================="
echo "Summary:"
echo "- Modern pod names use RNFB prefix, not RNFirebase"
echo "- RNFirebase pod names are from v5 (deprecated)"
echo "=========================================="
