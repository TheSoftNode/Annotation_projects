#!/bin/bash
# Step I: Check the user-space-memory claim
# Run in GitHub Codespaces, not Mac Terminal

echo "============================================================"
echo "R2 Step I: Check user-space memory access claim"
echo "============================================================"
echo

# Check if we're in the Linux kernel source directory
if [ ! -d "Documentation" ]; then
    echo "ERROR: This must be run from Linux kernel source root"
    echo "Run test_step_B_schedule_work.sh setup instructions first"
    exit 1
fi

echo "Test 1: Find 'User context only' requirement for user-space access"
echo "------------------------------------------------------------"
grep -R -n "User context only" Documentation include | head -20
echo

echo "Test 2: Find kworker thread naming documentation"
echo "------------------------------------------------------------"
grep -R -n "kworker/%u:%d%s" Documentation
echo

echo "============================================================"
echo "What this tests:"
echo "  - R2 Claim: 'Access user-space memory (with proper precautions)'"
echo ""
echo "Expected interpretation:"
echo "  - This claim is the most SUSPICIOUS one in Response 2"
echo "  - User-access helpers require 'User context only'"
echo "  - Workqueue workers are kworker kernel threads"
echo "  - This is NOT a general property of schedule_work() callbacks"
echo "============================================================"
