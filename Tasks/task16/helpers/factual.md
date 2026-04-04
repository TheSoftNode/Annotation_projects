Part 1: Factual Claims Breakdown & Verification
Claim 1: "Firebase 11.x (including FirebaseAuth 11.13.0) requires iOS 12.0 or higher as the minimum deployment target."

Verification Status: INCORRECT

Analysis: Firebase 11.0.0 actually increased the minimum deployment target to iOS 13.0, not iOS 12.0. Attempting to use iOS 12.0 with Firebase 11+ will still result in compatibility or compilation errors.

Primary Source Disputing the Claim: The official Firebase iOS SDK GitHub Changelog for release 11.0.0 explicitly states the minimum supported version for iOS is 13.0.

https://github.com/firebase/firebase-ios-sdk/blob/main/FirebaseCore/CHANGELOG.md
