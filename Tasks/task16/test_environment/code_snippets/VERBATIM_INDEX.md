# Response 1 - VERBATIM Code Snippets Only

**These files contain ONLY the exact code from Response 1 with NO testing additions.**

## Snippet 1: Platform Comparison (2 files)

**Before:**
- File: `VERBATIM_snippet_1_before.txt`
- Content: `platform :ios, '11.0'   # ❌ Too low`

**After:**
- File: `VERBATIM_snippet_1_after.txt`
- Content: `platform :ios, '12.0'   # ✅ Required for Firebase 11+`

---

## Snippet 2: Terminal Cleanup Commands

**File:** `VERBATIM_snippet_2_cleanup_commands.sh`

**Content:**
```bash
cd ios

pod deintegrate         # Removes all pod files (safely)

pod cache clean --all   # Cleans CocoaPods cache

pod install --repo-update
```

---

## Snippet 3: Build Command

**File:** `VERBATIM_snippet_3_build_command.sh`

**Content:**
```bash
npx react-native run-ios
```

---

## Snippet 4: Firebase Downgrade

**File:** `VERBATIM_snippet_4_downgrade.rb`

**Content:**
```ruby
pod 'Firebase/Auth', '~> 10.25.0'

pod 'Firebase/Firestore', '~> 10.25.0'

pod 'Firebase/Storage', '~> 10.25.0'
```

---

## Snippet 5: Combined Commands

**File:** `VERBATIM_snippet_5_combined_commands.sh`

**Content:**
```bash
pod deintegrate && pod install --repo-update
```

---

## Snippet 6: Full Podfile

**File:** `R1_Final_Podfile_VERBATIM.rb` (already created)

**Content:** 68 lines - See the file

---

## Notes

- All files prefixed with `VERBATIM_` contain ONLY Response 1's exact code
- Files without `VERBATIM_` prefix are test wrappers with verification logic
- Use `VERBATIM_` files for excerpts in the Golden Annotation
- Use test wrapper files to run verification and capture results
