#!/bin/bash

read -p "Continue? [y/N] " -n 1 -r

echo

if [[ $REPLY =~ ^[Yy]$ ]]; then

    echo "Proceeding..."

else

    echo "Operation cancelled."

    exit 1

fi

# ============================================================
# TEST RESULTS
# ============================================================
# Test 1: Input 'y'
# Result: Proceeding...
# Status: ✅ PASS
#
# Test 2: Input '' (empty/Enter)
# Result: Operation cancelled.
# Status: ✅ PASS - Default 'N' works correctly
#
# Test 3: Input 'n'
# Result: Operation cancelled.
# Status: ✅ PASS
#
# Overall: Works correctly, default is 'No' for safety
