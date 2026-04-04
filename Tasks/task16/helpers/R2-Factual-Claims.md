Use your **Mac** for any test that runs `pod install`, opens Xcode, or uses a real React Native iOS project. Use **Codespaces** only for read-only checks like fetching raw podspec files or comparing command help text. React Native’s iOS setup is built around Xcode/CocoaPods, and Firebase’s CocoaPods distribution requires Xcode and CocoaPods on the Apple side. ([React Native](https://reactnative.dev/docs/set-up-your-environment?utm_source=chatgpt.com))

Before testing, check that your Mac has CocoaPods and Xcode set up. If you want to test the wrapper-pod lines from the response, your project also needs the corresponding `@react-native-firebase/*` npm packages installed, and RNFirebase says the base `@react-native-firebase/app` module must be installed first. ([rnfirebase.io](https://rnfirebase.io/))

## **Claim-by-claim breakdown**

1. Claim: **"The error is caused by FirebaseAuthInterop (a transitive dependency of FirebaseAuth) not being compatible with the iOS deployment target you’re currently using."**  
   Verdict: **Supported.**  
   Why: the official `FirebaseAuth` 11.13.0 podspec declares a dependency on `FirebaseAuthInterop (~> 11.0)`, and your prompt’s CocoaPods error is specifically a minimum deployment target conflict on that dependency. Verify by inspecting the 11.13.0 podspec. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuth.podspec))  
2. Claim: **"Fix it by raising the platform :ios value (or by forcing an older version of FirebaseAuth), then reinstall the pods."**  
   Verdict: **Partly supported.**  
   Why: raising the deployment target is a standard fix for a minimum-target conflict, and using an older compatible Firebase version can also resolve it. But the response later gives very specific version guidance that is not supported by the primary sources I checked. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
3. Claim: **"Below is a step-by-step recipe that works for all recent React-Native / Firebase setups."**  
   Verdict: **Unverified.**  
   Why: the response’s later “golden Podfile” diverges from the official React Native template and RNFirebase install guidance, so this broad claim is not established by the primary docs I checked. ([GitHub](https://raw.githubusercontent.com/react-native-community/template/refs/heads/0.75-stable/template/ios/Podfile))  
4. Claim: **"FirebaseAuth (v 11.13.0) requires FirebaseAuthInterop ≈ 11.x."**  
   Verdict: **Supported.**  
   Why: the tagged `FirebaseAuth` 11.13.0 podspec includes `s.dependency 'FirebaseAuthInterop', '~> 11.0'`. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuth.podspec))  
5. Claim: **"The spec for FirebaseAuthInterop that satisfies \~\> 11.0 declares a minimum deployment target of 13.2 (or a newer version depending on the exact release)."**  
   Verdict: **Disputed for the exact version in your prompt.**  
   Why: the tagged `FirebaseAuthInterop` 11.13.0 podspec declares `s.ios.deployment_target = '13.0'`, not `13.2`. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuthInterop.podspec))  
6. Claim: **"Your current Podfile probably says platform :ios, '13.0' (or even 12.x)."**  
   Verdict: **Unverified / speculation.**  
   Why: that is a guess about the user’s Podfile, not something established by the prompt or a primary source.  
7. Claim: **"Because the required minimum is higher than the one you declared, CocoaPods refuses to install the pod."**  
   Verdict: **Supported.**  
   Why: that is exactly how CocoaPods handles deployment-target incompatibilities during resolution, and it matches the error text in your prompt. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
8. Claim: **"Change the platform line to 13.2 (or the exact minimum shown in the warning – usually 13.2 or 13.3)."**  
   Verdict: **Disputed for this exact prompt.**  
   Why: the primary source for `FirebaseAuthInterop` 11.13.0 shows `13.0`, not “usually 13.2 or 13.3,” at least for the exact version in your prompt. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuthInterop.podspec))  
9. Claim: **"platform :ios, '13.0' \# \<-- too low for FirebaseAuthInterop 11.x"**  
   Verdict: **Disputed for 11.13.0.**  
   Why: the tagged `FirebaseAuthInterop` 11.13.0 podspec says `13.0`, so `13.0` is not shown as too low by that exact primary source. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuthInterop.podspec))  
10. Claim: **"platform :ios, '13.2' \# \<-- meets FirebaseAuthInterop's min target"**  
    Verdict: **Supported numerically, but it overstates the exact minimum for 11.13.0.**  
    Why: `13.2` does meet a `13.0` minimum, but the exact minimum shown by the 11.13.0 podspec is `13.0`, not `13.2`. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuthInterop.podspec))  
11. Claim: **"pod deintegrate \# removes the old spec cache"**  
    Verdict: **Disputed.**  
    Why: CocoaPods documents `pod deintegrate` as removing traces of CocoaPods from the Xcode project. That is not the same thing as removing the old spec cache. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
12. Claim: **"pod install \--repo-update \# pulls the newest specs that satisfy 13.2"**  
    Verdict: **Supported in its command meaning.**  
    Why: CocoaPods documents `--repo-update` as forcing `pod repo update` before install. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
13. Claim: **"Build in Xcode (YourApp.xcworkspace). The error should disappear."**  
    Verdict: **Unverified outcome claim.**  
    Why: that depends on the actual project. It is not established by the primary sources, especially because other parts of the response are disputed.  
14. Claim: **"Sometimes you have to stay on platform :ios, '12.0' (e.g., because you rely on an older API that only works on 12)."**  
    Verdict: **Unverified example.**  
    Why: that is a hypothetical scenario, not something supported by the sources I checked.  
15. Claim: **"pod ipc FirebaseAuth"**  
    Verdict: **Disputed.**  
    Why: the official CocoaPods command reference lists `pod ipc repl`, `pod ipc spec`, `pod ipc podfile`, `pod ipc podfile-json`, `pod ipc list`, and `pod ipc update-search-index`. It does not document `pod ipc <PODNAME>` as a valid command form. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html?utm_source=chatgpt.com))  
16. Claim: **"Look at the table; the last version whose spec file’s s.ios.deployment\_target is \<= 12.0 will be shown."**  
    Verdict: **Disputed in context.**  
    Why: the preceding command is not the documented way to inspect podspec versions, so this verification path is not supported by the official CocoaPods command docs. The documented commands for installed spec lookup are `pod spec cat` and `pod spec which`. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
17. Claim: **"As of early-2025 the highest such version is typically Firebase/Auth 6.3.x (or similar)."**  
    Verdict: **Disputed.**  
    Why: the tagged `10.25.0` podspecs for `FirebaseAuth` and `FirebaseAuthInterop` already show iOS 11.0 deployment targets, so `6.3.x` is not the highest branch supported by the primary sources I checked. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-10.25.0/FirebaseAuthInterop.podspec))  
18. Claim: **"pod 'Firebase/Auth', '\~\> 6.3' \# \<- forces the older branch"**  
    Verdict: **Technically this would force an older branch, but the implied “highest compatible branch” rationale is disputed.**  
    Why: it is older, but the response’s suggestion is much older than what the 10.25.0 primary sources already show as compatible with lower iOS targets. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-10.25.0/FirebaseAuthInterop.podspec))  
19. Claim: **"pod lib lint FirebaseAuth \--verbose \# should pass"**  
    Verdict: **Disputed / wrong documented usage.**  
    Why: the official command syntax is `pod lib lint [PODSPEC_PATHS ...]`, which validates podspec files from the working directory or supplied path(s). `FirebaseAuth` by itself is not the documented form. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
20. Claim: **"pod dependency tree \--plain"**  
    Verdict: **Disputed as a standard CocoaPods command.**  
    Why: the official CocoaPods command reference does not list `pod dependency tree`. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
21. Claim: **"rm \-rf ios/Pods ios/Podfile.lock Deletes the pod cache so CocoaPods will download fresh specs."**  
    Verdict: **Disputed.**  
    Why: deleting `ios/Pods` and `ios/Podfile.lock` removes the local Pods directory and lockfile, but CocoaPods documents its internal cache separately under `pod cache clean`. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
22. Claim: **"pod cache clean \--all Empties CocoaPods’ internal cache."**  
    Verdict: **Supported.**  
    Why: CocoaPods documents `pod cache clean --all` as removing all cached pods without asking. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
23. Claim: **"pod update Updates pods to the versions resolved by the latest Podfile."**  
    Verdict: **Supported in substance.**  
    Why: CocoaPods documents `pod update` as updating the specified pods, or all pods if none are specified, ignoring the current `Podfile.lock`. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
24. Claim: **"The workspace isn’t being used; you opened the .xcodeproj instead of the .xcworkspace. Always open YourApp.xcworkspace."**  
    Verdict: **Supported.**  
    Why: CocoaPods’ documented workflow is `pod install` followed by opening the generated `.xcworkspace`. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html))  
25. Claim: **"Google services GoogleService-Info.plist missing You haven’t added the Firebase config file to the Xcode bundle."**  
    Verdict: **Supported.**  
    Why: RNFirebase’s iOS setup docs require `GoogleService-Info.plist` for iOS configuration. ([rnfirebase.io](https://rnfirebase.io/))  
26. Claim: **"The snippet below is complete and works with Firebase 11.x series provided you target iOS 13.2+."**  
    Verdict: **Disputed.**  
    Why: for the exact Firebase 11.13.0 Auth path, the primary podspec source says `13.0`, not `13.2`; React Native 0.73 raised the minimum iOS version to `13.4`; and the snippet includes multiple lines that do not match the official React Native template or documented CocoaPods syntax. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuthInterop.podspec))  
27. Claim: **"install\_mode :immediate"**  
    Verdict: **Unverified / not documented in the official CocoaPods Podfile syntax reference I checked.**  
    Why: the Podfile syntax reference documents `install! 'cocoapods', ...` but not `install_mode :immediate`. ([CocoaPods Guides](https://guides.cocoapods.org/syntax/podfile.html))  
28. Claim: **"RNAutomation.toggle\_autolinking"**  
    Verdict: **Unverified / not supported by the official React Native template or docs I checked.**  
    Why: the official template uses `prepare_react_native_project!`, `use_native_modules!`, and `use_react_native!`; this symbol does not appear there. ([GitHub](https://raw.githubusercontent.com/react-native-community/template/refs/heads/0.75-stable/template/ios/Podfile))  
29. Claim: **"use\_react\_native( labs: \["Swift"\] )"**  
    Verdict: **Disputed against the official template style.**  
    Why: the official template uses `use_react_native!` with a bang, not `use_react_native(...)` in the form shown here. ([GitHub](https://raw.githubusercontent.com/react-native-community/template/refs/heads/0.75-stable/template/ios/Podfile))  
30. Claim: **"Pod::MaterialPodfileDefaults.new(\[:android, :ios\]).apply"**  
    Verdict: **Unverified / not supported by the official React Native template or CocoaPods Podfile syntax docs I checked.**  
    Why: I did not find this in the official template or the documented Podfile DSL. ([GitHub](https://raw.githubusercontent.com/react-native-community/template/refs/heads/0.75-stable/template/ios/Podfile))  
31. Claim: **"pod 'Firebase/Firestore', :modual\_headers \=\> true \# typo intentional? no, correct is :modular\_headers \=\> true"**  
    Verdict: **Disputed as written.**  
    Why: the official CocoaPods syntax is `:modular_headers`, not `:modual_headers`. ([CocoaPods Guides](https://guides.cocoapods.org/syntax/podfile.html))  
32. Claim: **"pod 'RNFirebase/Auth', :path \=\> '../node\_modules/@react-native-firebase/auth'"**  
    Verdict: **Disputed.**  
    Why: the official RNFirebase podspec name is `RNFBAuth`, not `RNFirebase/Auth`. ([GitHub](https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/auth/RNFBAuth.podspec))  
33. Claim: **"pod 'RNFirebase/Firestore', :path \=\> '../node\_modules/@react-native-firebase/firestore'"**  
    Verdict: **Disputed.**  
    Why: the official podspec name is `RNFBFirestore`, not `RNFirebase/Firestore`. ([GitHub](https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/firestore/RNFBFirestore.podspec))  
34. Claim: **"pod 'RNFirebase/Storage', :path \=\> '../node\_modules/@react-native-firebase/storage'"**  
    Verdict: **Disputed.**  
    Why: the official podspec name is `RNFBStorage`, not `RNFirebase/Storage`. ([GitHub](https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/storage/RNFBStorage.podspec))  
35. Claim: **"pod 'GoogleUtilities', '\~\> 1.4' \# needed by many Firebase pods"**  
    Verdict: **Disputed for the Firebase 11.13.0 context in your prompt.**  
    Why: the `FirebaseAuth` 11.13.0 podspec depends on `GoogleUtilities/AppDelegateSwizzler` and `GoogleUtilities/Environment` around `~> 8.1`, not a root `GoogleUtilities '~> 1.4'` line. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuth.podspec))  
36. Claim: **"installer.pods\_project.build\_development\_target \= '13.0'"**  
    Verdict: **Unverified / not in the official Podfile syntax reference I checked.**  
    Why: I did not find `build_development_target` in the documented Podfile DSL. ([CocoaPods Guides](https://guides.cocoapods.org/syntax/podfile.html))  
37. Claim: *"config.build\_settings\['EXCLUDED\_ARCHS\[sdk=iphonesimulator\]'\] \= 'arm64' if UIHostedViewController.isSimulator"*\*  
    Verdict: **Unverified / not supported by the official React Native template or the Podfile syntax docs I checked.**  
    Why: I did not find this in the official template or CocoaPods syntax reference. ([GitHub](https://raw.githubusercontent.com/react-native-community/template/refs/heads/0.75-stable/template/ios/Podfile))  
38. Claim: **"Important – post\_install block at the bottom is optional; it just makes Xcode happy on Apple-silicon simulators."**  
    Verdict: **Unverified.**  
    Why: that outcome is not established by the primary sources I checked, and the exact post-install lines themselves are not documented in those sources. ([GitHub](https://raw.githubusercontent.com/react-native-community/template/refs/heads/0.75-stable/template/ios/Podfile))

## **Step-by-step manual testing**

### **1\) Read-only source checks for the exact Firebase version in the prompt**

Use: **Mac Terminal or Codespaces**  
Needs installed first: **nothing beyond `curl`**

Run these exactly:

curl \-L https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuthInterop.podspec | grep deployment\_target  
curl \-L https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuth.podspec | grep \-E "deployment\_target|FirebaseAuthInterop"  
curl \-L https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/Firebase.podspec | grep \-A2 "subspec 'Auth'"

Expected result:

* `FirebaseAuthInterop` should show `s.ios.deployment_target = '13.0'`.  
* `FirebaseAuth` should show a dependency on `FirebaseAuthInterop`, `~> 11.0`.  
* `Firebase/Auth` should show the Auth subspec at `13.0`.  
  Those results support the dependency-chain claim and dispute the response’s `13.2` claim for the exact 11.13.0 prompt. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-11.13.0/FirebaseAuthInterop.podspec))

### **2\) Read-only source checks for the downgrade claim**

Use: **Mac Terminal or Codespaces**  
Needs installed first: **nothing beyond `curl`**

Run these exactly:

curl \-L https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-10.25.0/FirebaseAuthInterop.podspec | grep deployment\_target  
curl \-L https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-10.25.0/FirebaseAuth.podspec | grep deployment\_target

Expected result:

* both should show `11.0`.  
  That is enough to dispute the response’s “highest such version is typically 6.3.x” claim. ([GitHub](https://raw.githubusercontent.com/firebase/firebase-ios-sdk/CocoaPods-10.25.0/FirebaseAuthInterop.podspec))

### **3\) Check the CocoaPods command claims without touching your project**

Use: **Mac Terminal**  
Needs installed first: **CocoaPods**

Run these exactly:

pod \--version  
pod ipc \--help  
pod spec cat \--help  
pod lib lint \--help  
pod install \--help  
pod cache clean \--help  
pod deintegrate \--help

Expected result:

* `pod ipc --help` should list subcommands like `spec`, `podfile`, `podfile-json`, `list`, not `pod ipc FirebaseAuth`.  
* `pod spec cat --help` should show the supported way to print podspec content by query.  
* `pod lib lint --help` should show it expects podspec path(s), not a bare pod name.  
* `pod install --help` should show `--repo-update`.  
* `pod cache clean --help` should show `--all`.  
* `pod deintegrate --help` should describe removing CocoaPods traces from the Xcode project. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html?utm_source=chatgpt.com))

### **4\) Directly test the disputed command examples**

Use: **Mac Terminal**  
Needs installed first: **CocoaPods**

Run these exactly:

pod ipc FirebaseAuth  
pod dependency tree \--plain

Expected result:

* these should fail or be unrecognized in a standard CocoaPods install, because they are not in the official CocoaPods command reference I checked. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html?utm_source=chatgpt.com))

### **5\) Check the RNFirebase pod names the response uses**

Use: **Mac Terminal or Codespaces**  
Needs installed first: **nothing beyond `curl`**

Run these exactly:

curl \-L https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/app/RNFBApp.podspec | grep 's.name'  
curl \-L https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/auth/RNFBAuth.podspec | grep 's.name'  
curl \-L https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/firestore/RNFBFirestore.podspec | grep 's.name'  
curl \-L https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/storage/RNFBStorage.podspec | grep 's.name'

Expected result:

* the names should be `RNFBApp`, `RNFBAuth`, `RNFBFirestore`, `RNFBStorage`.  
  That disputes the response’s `RNFirebase/...` pod names. ([GitHub](https://raw.githubusercontent.com/invertase/react-native-firebase/master/packages/app/RNFBApp.podspec))

### **6\) Check the React Native template-style claims**

Use: **Mac Terminal or browser**  
Needs installed first: **nothing**

Open the official RN template/reference Podfile and compare the helper names. The official template uses `prepare_react_native_project!`, `use_native_modules!`, and `use_react_native!`. It does not show `RNAutomation.toggle_autolinking`, `use_react_native(...)`, or `Pod::MaterialPodfileDefaults...` in the template I checked. ([GitHub](https://raw.githubusercontent.com/react-native-community/template/refs/heads/0.75-stable/template/ios/Podfile))

### **7\) Parse-test the exact “golden Podfile” without building the whole app**

Use: **Mac Terminal**  
Needs installed first: **CocoaPods**  
Best done in: **a disposable copy of a Podfile or a throwaway branch**

Save the response’s Podfile snippet exactly as a Podfile, then run:

pod ipc podfile Podfile

Expected result:

* if the exact Ruby/CocoaPods DSL is acceptable, CocoaPods will convert it;  
* if it errors on unknown methods or invalid DSL, that is evidence against the “complete and works” claim.  
  `pod ipc podfile` is a documented CocoaPods command for converting Podfiles. ([CocoaPods Guides](https://guides.cocoapods.org/terminal/commands.html?utm_source=chatgpt.com))

### **8\) Real project test of the exact snippet**

Use: **Mac only**  
Needs installed first:

* **Xcode**  
* **CocoaPods**  
* a real **React Native iOS project**  
* if you are testing the wrapper lines, the corresponding npm packages installed first, starting with `@react-native-firebase/app` ([React Native](https://reactnative.dev/docs/set-up-your-environment?utm_source=chatgpt.com))

Do this in a throwaway branch:

git checkout \-b verify-response2

Then:

1. Back up your current `ios/Podfile`.  
2. Paste the response’s exact Podfile snippet in.  
3. If the snippet references `@react-native-firebase/*` path pods, make sure those npm packages are actually installed first.  
4. Run:

cd ios  
pod install \--repo-update

Expected result:

* if the response is accurate, `pod install` should succeed;  
* if it fails on pod names, unknown methods, or invalid DSL/options, those are direct findings against the response.  
  This is the fairest “does the exact code work” test because it uses the real Apple/CocoaPods environment React Native iOS expects. ([React Native](https://reactnative.dev/docs/set-up-your-environment?utm_source=chatgpt.com))

### **9\) Check the `GoogleService-Info.plist` claim**

Use: **Mac only**  
Needs installed first: **an RNFirebase iOS project**

In your project:

1. Confirm whether `GoogleService-Info.plist` exists.  
2. Confirm whether it is included in the Xcode project target.  
3. Build again.

Expected result:

* if the file is missing from the bundle setup, RNFirebase’s iOS setup docs support that as a real cause of Firebase config issues. ([rnfirebase.io](https://rnfirebase.io/))

The fastest high-value checks are **Test 1, Test 3, Test 5, and Test 8**. Send me the outputs from those and I’ll turn them into a clean factual-accuracy verdict.

