#!/bin/bash
# Step F: Verify cancel APIs
# Run in GitHub Codespaces, not Mac Terminal

echo "============================================================"
echo "R2 Step F: Verify cancel APIs"
echo "============================================================"
echo

# Check if we're in the Linux kernel source directory
if [ ! -f "include/linux/workqueue.h" ]; then
    echo "ERROR: This must be run from Linux kernel source root"
    echo "Run test_step_B_schedule_work.sh setup instructions first"
    exit 1
fi

echo "Test 1: Find cancel_delayed_work()"
echo "------------------------------------------------------------"
grep -n "cancel_delayed_work(" include/linux/workqueue.h
echo

echo "Test 2: Find cancel_delayed_work_sync()"
echo "------------------------------------------------------------"
grep -n "cancel_delayed_work_sync(" include/linux/workqueue.h
echo

echo "Test 3: Find cancel_work_sync()"
echo "------------------------------------------------------------"
grep -n "cancel_work_sync(" include/linux/workqueue.h
echo

echo "============================================================"
echo "What this tests:"
echo "  - The cancel calls shown in the response"
echo "============================================================"
