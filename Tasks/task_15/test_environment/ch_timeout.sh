#!/bin/bash

read -t 10 -p "Continue in 10 seconds? (y/N): " -n 1 -r

echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then

    echo "Timeout or 'No' selected. Aborting."

    exit 1

fi

echo "Proceeding..."

# ============================================================
# TEST RESULTS
# ============================================================
# Test 1: Input 'y' immediately
# Result: Proceeding...
# Status: ✅ PASS
#
# Test 2: Input 'n' immediately
# Result: Timeout or 'No' selected. Aborting.
# Status: ✅ PASS
#
# Test 3: No input (wait for timeout - 10 seconds)
# Result: Timeout or 'No' selected. Aborting.
# Status: ✅ PASS - Timeout works correctly
#
# Overall: -t flag for timeout works correctly, aborts on timeout or 'n'
