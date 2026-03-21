# How to Execute the Test Files for Task 3

## 🚀 Quick Start (Recommended)

### Step 1: Run Setup (One Time Only)

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task3/test_environment
./setup.sh
```

This will automatically:
- Check for required tools (git, gcc, pkg-config)
- Make all test scripts executable
- Verify GTK library availability (optional)

### Step 2: Run All Tests

```bash
./run_all_tests.sh
```

This will run both Response 1 and Response 2 tests automatically.

---

## 📁 Project Structure

```
task3/
├── RLHF-TASK 2.md                    # Original task with both responses
├── Golden_Annotation_Task3.md        # Complete golden annotation
├── test_environment/                 # Test scripts directory
│   ├── setup.sh                      # Setup script (run first)
│   ├── run_all_tests.sh              # Run all tests
│   ├── test_response1_code.sh        # Tests for Response 1
│   ├── test_response2_code.sh        # Tests for Response 2
│   ├── HOW_TO_EXECUTE.md             # This file
│   └── README.md                     # Test environment documentation
└── xtor/                             # Cloned xtor repository
```

---

## 🔧 Manual Testing (Alternative)

If you want to run tests individually:

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task3/test_environment

# Run individual tests
./test_response1_code.sh
./test_response2_code.sh
```

---

## 📊 Expected Results

### Response 1 ✗ (Score: 3)
```
✓ Confirmed: xtor uses #include <gtk/gtk.h> (C API)
✗ COMPILATION FAILED

FINDING: Response 1 uses C++ gtkmm syntax incompatible with xtor's C codebase

Details:
  - xtor uses: #include <gtk/gtk.h> (C API)
  - Response 1 uses: Gtk:: namespace, -> operators (C++ gtkmm)
  - Required functions: gtk_vbox_new(), gtk_box_pack_start()
  - Response 1 provides: Gtk::box_new(), box->add()

SEVERITY: Substantial - Code examples unusable without significant translation
```

### Response 2 ✗ (Score: 2)
```
✓ Confirmed: xtor requires GTK+ 2.16
✗ COMPILATION FAILED

FINDING: Response 2 uses GTK 4 API incompatible with xtor's GTK 2.16

Details:
  - xtor requires: GTK+ 2.16
  - Response 2 uses: GTK 4 API functions
  - gtk_box_append() - Does not exist in GTK 2.x
  - gtk_window_set_child() - Does not exist in GTK 2.x

SEVERITY: Substantial - All code examples incompatible with xtor's GTK version
```

---

## 🛠️ Troubleshooting

**Problem:** `./setup.sh` permission denied

**Solution:**
```bash
chmod +x setup.sh
./setup.sh
```

**Problem:** git not found

**Solution:**
```bash
xcode-select --install    # Install command line tools
```

**Problem:** Tests show GTK libraries not installed

**Solution:** This is expected and fine. Tests still verify API compatibility through:
- Source code inspection
- API documentation verification
- Repository analysis

To install GTK libraries (optional):
```bash
brew install gtk+        # GTK+ 2.0
brew install gtk4        # GTK 4
```

---

## 📚 What Gets Verified

Both test scripts verify all claims made in the Golden Annotation:

### Response 1
1. ✓ xtor uses C language (#include <gtk/gtk.h>)
2. ✓ Response 1 uses C++ gtkmm (Gtk:: namespace)
3. ✓ API incompatibility (gtk_vbox_new vs Gtk::box_new)
4. ✓ Substantial severity (code unusable)

### Response 2
1. ✓ xtor requires GTK+ 2.16 (.glade files)
2. ✓ Response 2 uses GTK 4 API (gtk_box_append, gtk_window_set_child)
3. ✓ Functions don't exist in GTK 2.16
4. ✓ Substantial severity (code unusable)

### Both Responses
1. ✓ Strengths properly identified
2. ✓ Areas of Improvement verified with sources
3. ✓ Quality scores justified (R1=3, R2=2)
4. ✓ Preference ranking supported by evidence

---

## 🎯 Key Difference from Task 2

**Task 2:** Tested Python code execution (runtime behavior)

**Task 3:** Tests API compatibility (compile-time verification)

This is appropriate because:
- GTK code must compile before it can run
- API mismatches prevent compilation entirely
- Version incompatibility is detectable from source inspection
- Real-world workflow: check API → write code → compile → run

---

## 📝 Test Methodology

Each test script:

1. **Clones xtor repository** from GitHub
2. **Inspects source files** to determine API requirements
3. **Extracts code snippets** from responses (verbatim)
4. **Attempts compilation** with appropriate flags
5. **Compares APIs** (what's needed vs what's provided)
6. **Demonstrates correct syntax** for reference

All verification is independent and reproducible.

---

## ✅ Validation Checklist

After running tests, verify:

- [ ] Both test scripts executed successfully
- [ ] xtor repository inspection shows GTK 2.16 and C language
- [ ] Response 1 gtkmm incompatibility confirmed
- [ ] Response 2 GTK 4 incompatibility confirmed
- [ ] Both issues classified as Substantial
- [ ] Correct APIs demonstrated for reference

---

## 🔗 Related Files

- [Golden_Annotation_Task3.md](../Golden_Annotation_Task3.md) - Full annotation
- [RLHF-TASK 2.md](../RLHF-TASK%202.md) - Original task and responses
- [README.md](README.md) - Detailed test environment documentation
