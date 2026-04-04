# Task 16 - Response 1 Testing Environment

## Prerequisites Status

✅ **Xcode Command Line Tools:** Installed at `/Library/Developer/CommandLineTools`
✅ **Node.js:** v22.13.1
✅ **npm:** 11.4.2
❌ **CocoaPods:** Not installed

## Installation Instructions

### Install CocoaPods

```bash
# Option 1: Using Homebrew (recommended)
brew install cocoapods

# Option 2: Using RubyGems
sudo gem install cocoapods
```

## Testing Scripts

### Test 1: Verify Firebase 11.13.0 iOS Minimum Deployment Target

**Purpose:** Verify that Firebase 11.13.0 requires iOS 13.0 (not 12.0 as Response 1 claims)

```bash
# Test FirebaseAuthInterop deployment target
curl -L https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuthInterop.podspec | grep deployment_target

# Expected output: s.ios.deployment_target = '13.0'
```

```bash
# Test FirebaseAuth deployment target
curl -L https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuth.podspec | grep deployment_target

# Expected output: s.ios.deployment_target = '13.0'
```

### Test 2: Verify Firebase 10.25.0 iOS Minimum Deployment Target

**Purpose:** Verify that Firebase 10.25.0 supports iOS 11.0

```bash
# Test FirebaseAuthInterop 10.25.0 deployment target
curl -L https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-10.25.0/FirebaseAuthInterop.podspec | grep deployment_target

# Expected output: s.ios.deployment_target = '11.0'
```

### Test 3: Verify React Native Firebase Pod Names

**Purpose:** Verify that modern pod names are RNFBApp, RNFBAuth, etc. (not RNFirebase, RNFirebaseAuth)

```bash
# Test app pod name
curl -L https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/app/RNFBApp.podspec | grep 's.name'

# Expected output: s.name = "RNFBApp"
```

```bash
# Test auth pod name
curl -L https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/auth/RNFBAuth.podspec | grep 's.name'

# Expected output: s.name = "RNFBAuth"
```

```bash
# Test firestore pod name
curl -L https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/firestore/RNFBFirestore.podspec | grep 's.name'

# Expected output: s.name = "RNFBFirestore"
```

```bash
# Test storage pod name
curl -L https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/storage/RNFBStorage.podspec | grep 's.name'

# Expected output: s.name = "RNFBStorage"
```

### Test 4: Verify CocoaPods Commands

**Purpose:** Verify pod deintegrate, pod cache clean, and pod install --repo-update behavior

```bash
# Check pod deintegrate help
pod deintegrate --help | head -20

# Expected: Should mention "Remove all traces of CocoaPods from your Xcode project"
# NOT "removes all pod files"
```

```bash
# Check pod cache clean help
pod cache clean --help | grep -A6 -- --all

# Expected: Should mention removing all cached pods
```

```bash
# Check pod install help
pod install --help | grep -A3 -- --repo-update

# Expected: Should mention forcing pod repo update before install
```

## Full Integration Test (Requires CocoaPods Installation)

### Step 1: Create Test React Native Project

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task16/test_environment
npx react-native@latest init YourApp
cd YourApp
```

### Step 2: Install React Native Firebase Packages

```bash
npm install @react-native-firebase/app @react-native-firebase/auth @react-native-firebase/firestore @react-native-firebase/storage
```

### Step 3: Replace Podfile with Response 1's Exact Podfile

Create a backup first:
```bash
cp ios/Podfile ios/Podfile.backup
```

Then replace `ios/Podfile` with the exact content from Response 1 (lines 116-184 of RESPONSE_1.md)

### Step 4: Run Response 1's Exact Commands

```bash
cd ios
pod deintegrate
pod cache clean --all
pod install --repo-update
```

**Expected Result:** This should FAIL with an error about iOS deployment target being too low, because:
- Response 1 sets `platform :ios, '12.0'`
- Firebase 11.13.0 actually requires iOS 13.0
- Response 1 uses deprecated pod names (RNFirebase instead of RNFBApp)

### Step 5: Test the Corrected Version

Replace the Podfile with corrected values:

```ruby
platform :ios, '13.0'  # ✅ Correct version for Firebase 11+

use_frameworks! :linkage => :static
$RNFirebaseAsStaticFramework = true

target 'YourApp' do
  config = use_native_modules!

  use_react_native!(
    :path => config[:reactNativePath],
    :hermes_enabled => true
  )

  # React Native Firebase uses autolinking - no manual pod declarations needed!
end
```

Then run:
```bash
pod install --repo-update
```

**Expected Result:** Should succeed with iOS 13.0 and autolinking

## Test Results Documentation

Create test result files documenting:
1. Which claims were verified
2. What evidence was found
3. Whether Response 1's solution works or fails
4. Screenshots/output of failures
