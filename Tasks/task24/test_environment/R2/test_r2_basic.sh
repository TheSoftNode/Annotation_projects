#!/bin/bash

echo "=== Testing R2 Basic Checks ==="

# Check for common typos
echo "Checking for typos..."
grep -n "schedle_work" /Users/apple/Desktop/Applyloop-project3/Tasks/task24/extractions/RESPONSE_2.md
if [ $? -eq 0 ]; then
    echo "FOUND: Typo detected"
else
    echo "No major typos found"
fi

echo ""
echo "=== R2 Basic Test Complete ==="
