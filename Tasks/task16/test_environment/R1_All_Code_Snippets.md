# Response 1 - All Code Snippets (Verbatim Extraction)

## Snippet 1: Before/After Platform Comparison

**Location:** Lines 34, 38

```ruby
platform :ios, '11.0'   # ❌ Too low
```

to:

```ruby
platform :ios, '12.0'   # ✅ Required for Firebase 11+
```

---

## Snippet 2: Terminal Cleanup Commands

**Location:** Lines 62-68

```bash
cd ios

pod deintegrate         # Removes all pod files (safely)

pod cache clean --all   # Cleans CocoaPods cache

pod install --repo-update
```

---

## Snippet 3: Build Command

**Location:** Line 76

```bash
npx react-native run-ios
```

---

## Snippet 4: Firebase Downgrade Versions

**Location:** Lines 91-95

```ruby
pod 'Firebase/Auth', '~> 10.25.0'

pod 'Firebase/Firestore', '~> 10.25.0'

pod 'Firebase/Storage', '~> 10.25.0'
```

---

## Snippet 5: Combined Pod Commands

**Location:** Line 101

```bash
pod deintegrate && pod install --repo-update
```

---

## Snippet 6: Full Podfile (MAIN CODE SNIPPET)

**Location:** Lines 116-184

```ruby
platform :ios, '12.0'  # ✅ Updated to 12.0

use_frameworks! :linkage => :static

use_modular_headers!

target 'YourApp' do

  # React Native

  pod 'React', :path => '../node_modules/react-native/'

  pod 'React-Core', :path => '../node_modules/react-native/'

  pod 'React-DevSupport', :path => '../node_modules/react-native/'

  pod 'React-RCTActionSheet', :path => '../node_modules/react-native/'

  pod 'React-RCTAnimation', :path => '../node_modules/react-native/'

  pod 'React-RCTBlob', :path => '../node_modules/react-native/'

  pod 'React-RCTImage', :path => '../node_modules/react-native/'

  pod 'React-RCTLinking', :path => '../node_modules/react-native/'

  pod 'React-RCTNetwork', :path => '../node_modules/react-native/'

  pod 'React-RCTSettings', :path => '../node_modules/react-native/'

  pod 'React-RCTText', :path => '../node_modules/react-native/'

  pod 'React-RCTVibration', :path => '../node_modules/react-native/'

  pod 'React-cxxreact', :path => '../node_modules/react-native/ReactCommon/cxxreact'

  pod 'React-jsi', :path => '../node_modules/react-native/ReactCommon/jsi'

  pod 'React-jsiexecutor', :path => '../node_modules/react-native/ReactCommon/jsiexecutor'

  pod 'React-jsinspector', :path => '../node_modules/react-native/ReactCommon/jsinspector'

  pod 'ReactCommon/jscallinvoker', :path => '../node_modules/react-native/ReactCommon'

  pod 'ReactCommon/turbomodule/core', :path => '../node_modules/react-native/ReactCommon'

  pod 'Yoga', :path => '../node_modules/react-native/ReactCommon/yoga'

  # Firebase (via @react-native-firebase)

  pod 'RNFirebase', :path => '../node_modules/@react-native-firebase/app'

  pod 'RNFirebaseAuth', :path => '../node_modules/@react-native-firebase/auth'

  pod 'RNFirebaseFirestore', :path => '../node_modules/@react-native-firebase/firestore'

  pod 'RNFirebaseStorage', :path => '../node_modules/@react-native-firebase/storage'

  # If using Firebase directly (not via wrapper):

  # pod 'Firebase/Auth'

  # pod 'Firebase/Firestore'

  # pod 'Firebase/Storage'

  # Other pods...

end
```

---

## Summary

**Total Code Snippets:** 6
- **1 Full Podfile** (68 lines)
- **3 Bash command snippets**
- **2 Ruby code snippets**

**Errors in Code Snippets:**
1. ❌ `platform :ios, '12.0'` - Should be `13.0` for Firebase 11.13.0
2. ❌ `pod 'RNFirebase'` - Should be `RNFBApp`
3. ❌ `pod 'RNFirebaseAuth'` - Should be `RNFBAuth`
4. ❌ `pod 'RNFirebaseFirestore'` - Should be `RNFBFirestore`
5. ❌ `pod 'RNFirebaseStorage'` - Should be `RNFBStorage`
