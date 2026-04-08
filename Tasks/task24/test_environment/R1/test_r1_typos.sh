#!/bin/bash

echo "=== Testing R1 for Typos ==="

# Check for "schedle_work" typo
grep -n "schedle_work" /Users/apple/Desktop/Applyloop-project3/Tasks/task24/extractions/RESPONSE_1.md

if [ $? -eq 0 ]; then
    echo "FOUND: Typo 'schedle_work' instead of 'schedule_work'"
else
    echo "No 'schedle_work' typo found"
fi

echo ""
echo "=== R1 Typo Test Complete ==="
