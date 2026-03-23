# Task 5 Test Environment - PyHackRF Manual Installation

## Overview
This test environment verifies the technical accuracy of two responses about manually installing pyhackrf without using pip.

## Key Verification Points

### Response 1 Verification
1. **Repository URL**: `https://github.com/mossmann/pyhackrf.git`
   - Status: ❌ **DOES NOT EXIST** (404 error)
   - Impact: Critical - entire installation workflow fails

2. **HackRF Driver Repository**: `https://github.com/mossmann/hackrf.git`
   - Status: ✅ Correct (also available as greatscottgadgets/hackrf)

3. **Installation Method**: Build libhackrf from source, then install pyhackrf
   - Status: ✅ Conceptually correct approach

### Response 2 Verification
1. **Repository URL**: `https://github.com/atech/pyhackrf.git`
   - Status: ❌ **DOES NOT EXIST** (404 error)
   - Impact: Critical - clone step fails

2. **Package Manager Approach**: `apt install libhackrf-dev`
   - Status: ✅ Correct - this package exists in Debian/Ubuntu repos

3. **Installation Method**: Install libhackrf from package manager, then install pyhackrf
   - Status: ✅ Simpler, valid approach

## Correct Information

### Valid PyHackRF Repositories
1. **Primary**: `https://github.com/dressel/pyhackrf` (official PyPI package source)
2. **Alternative**: `https://github.com/GvozdevLeonid/python_hackrf` (python-hackrf on PyPI)

### Valid HackRF Driver Repository
- **Official**: `https://github.com/greatscottgadgets/hackrf` (or mossmann/hackrf)

## Test Scripts

- `verify_repositories.sh` - Checks if repository URLs are valid
- `verify_package_availability.sh` - Checks if system packages exist
- `test_response1_accuracy.sh` - Tests Response 1 claims
- `test_response2_accuracy.sh` - Tests Response 2 claims

## How to Run Tests

```bash
chmod +x *.sh
./run_all_tests.sh
```

## Expected Results

Both responses contain critical factual errors (non-existent repository URLs) that would prevent the installation from working as described.
