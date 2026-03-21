# Task 3 Test Environment

This directory contains test scripts to verify the code compatibility issues identified in both responses for Task 3 (GTK widget resizing).

## What Gets Tested

### Response 1
- **Issue:** Uses gtkmm (C++) syntax when xtor requires GTK C API
- **Verification:** Clones xtor repo, checks actual API used, attempts compilation
- **Expected Result:** ✗ Compilation fails due to C++ syntax in C codebase
- **Severity:** Substantial

### Response 2
- **Issue:** Uses GTK 4 API when xtor requires GTK 2.16
- **Verification:** Checks xtor .glade files for version, verifies API availability
- **Expected Result:** ✗ GTK 4 functions don't exist in GTK 2.16
- **Severity:** Substantial

## Quick Start

### Step 1: Run Setup (One Time Only)

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task3/test_environment
./setup.sh
```

This checks for required tools (git, gcc, pkg-config) and makes scripts executable.

### Step 2: Run All Tests

```bash
./run_all_tests.sh
```

This runs both Response 1 and Response 2 tests automatically.

## Individual Tests

```bash
./test_response1_code.sh    # Test Response 1 only (gtkmm C++ issue)
./test_response2_code.sh    # Test Response 2 only (GTK 4 API issue)
```

## Expected Results

### Response 1 Test Output

```
✓ Confirmed: xtor uses #include <gtk/gtk.h> (C API)
✗ COMPILATION FAILED

FINDING: Response 1 uses C++ gtkmm syntax incompatible with xtor's C codebase

Details:
  - xtor uses: #include <gtk/gtk.h> (C API)
  - Response 1 uses: Gtk:: namespace, -> operators (C++ gtkmm)
  - Required functions in xtor: gtk_vbox_new(), gtk_box_pack_start()
  - Response 1 provides: Gtk::box_new(), box->add()

SEVERITY: Substantial - Code examples unusable without significant translation
```

### Response 2 Test Output

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

## Requirements

### Essential (Required)
- **git** - For cloning xtor repository
- **gcc** - For attempting compilation tests
- **pkg-config** - For checking GTK library availability

### Optional (Helpful but not required)
- **GTK+ 2.0** - Allows full compilation testing
- **GTK 4** - Helps demonstrate API incompatibility

Install optional libraries:
```bash
brew install gtk+        # GTK+ 2.0
brew install gtk4        # GTK 4
```

## How Tests Work

1. **Clone xtor repository** from GitHub
2. **Inspect source files** to determine actual API requirements
3. **Attempt compilation** of response code examples
4. **Compare APIs** between what responses provide vs what xtor needs
5. **Demonstrate correct syntax** for xtor's environment

## API Comparison Tables

### Response 1: C++ gtkmm vs C GTK

| What xtor needs (GTK C) | What Response 1 provides (gtkmm C++) | Compatible? |
|-------------------------|---------------------------------------|-------------|
| `#include <gtk/gtk.h>` | `#include <gtkmm.h>` | ✗ |
| `gtk_vbox_new(FALSE, 5)` | `Gtk::box_new(Gtk::ORIENTATION_VERTICAL, 5)` | ✗ |
| `gtk_box_pack_start()` | `box->add()` | ✗ |
| `GtkWidget*` | `Gtk::Box*` | ✗ |

### Response 2: GTK 4 vs GTK 2.16

| What xtor needs (GTK 2.16) | What Response 2 provides (GTK 4) | Compatible? |
|----------------------------|----------------------------------|-------------|
| `gtk_init(&argc, &argv)` | `gtk_init()` | ✗ |
| `gtk_vbox_new()` | `gtk_box_new()` | ⚠ Partial |
| `gtk_box_pack_start()` | `gtk_box_append()` | ✗ |
| `gtk_container_add()` | `gtk_window_set_child()` | ✗ |

## Relation to Golden Annotation

These tests verify all claims made in [Golden_Annotation_Task3.md](../Golden_Annotation_Task3.md):

- ✓ Response 1 Substantial AOI: gtkmm C++ incompatibility
- ✓ Response 2 Substantial AOI: GTK 4 API incompatibility
- ✓ Both issues materially undermine code utility
- ✓ Quality scores (R1=3, R2=2) justified by severity

## Troubleshooting

**Problem:** Permission denied when running scripts

**Solution:**
```bash
chmod +x setup.sh
chmod +x run_all_tests.sh
chmod +x test_response1_code.sh
chmod +x test_response2_code.sh
```

**Problem:** git not found

**Solution:**
```bash
xcode-select --install    # Install command line tools
```

**Problem:** Tests work but can't compile GTK code

**Solution:** This is expected if GTK libraries aren't installed. Tests still verify API incompatibility through source inspection.

## Test Philosophy

Unlike Task 2 which tested Python code execution, Task 3 tests **API compatibility** by:

1. **Source verification** - Checking actual xtor codebase
2. **Compilation attempts** - Proving code won't compile
3. **API documentation** - Verifying function availability
4. **Version checking** - Confirming GTK version requirements

This approach mirrors real-world development where API mismatches prevent code from even compiling, let alone running.

## Files in This Directory

- `setup.sh` - Setup script (checks dependencies, makes scripts executable)
- `run_all_tests.sh` - Runs all tests sequentially
- `test_response1_code.sh` - Tests Response 1's gtkmm C++ code
- `test_response2_code.sh` - Tests Response 2's GTK 4 code
- `README.md` - This file

## Notes

All code snippets in the test scripts are taken **verbatim** from the responses in [RLHF-TASK 2.md](../RLHF-TASK%202.md). The only additions are:

- Repository cloning commands
- Source inspection commands
- Compilation attempts
- Analysis and verification output
- Demonstrations of correct syntax

This allows independent verification of all claims made in the golden annotation.
