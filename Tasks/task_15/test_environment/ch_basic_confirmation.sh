#!/bin/bash

read -p "Do you want to continue? (y/N): " -n 1 -r

echo  # move to a new line

if [[ ! $REPLY =~ ^[Yy]$ ]]; then

    echo "Aborting."

    exit 1

fi

echo "Continuing with the next step..."

# Your next command here

# ============================================================
# TEST RESULTS
# ============================================================
# Test 1: Input 'n'
# Result: Aborting.
# Status: ✅ PASS - Correctly aborts on 'n'
#
# Test 2: Input 'y'
# Result: Continuing with the next step...
# Status: ✅ PASS - Correctly continues on 'y'
#
# Test 3: Input 'Y'
# Result: Continuing with the next step...
# Status: ✅ PASS - Correctly handles uppercase 'Y'
#
# Overall: Script works as expected with -n 1 flag for single character input
