#!/bin/bash
# Step C: Verify schedule_delayed_work() and delayed timing in jiffies
# Run in GitHub Codespaces, not Mac Terminal

echo "============================================================"
echo "R2 Step C: Verify schedule_delayed_work() and jiffies"
echo "============================================================"
echo

# Check if we're in the Linux kernel source directory
if [ ! -f "include/linux/workqueue.h" ]; then
    echo "ERROR: This must be run from Linux kernel source root"
    echo "Run test_step_B_schedule_work.sh setup instructions first"
    exit 1
fi

echo "Test 1: Find schedule_delayed_work() inline declaration"
echo "------------------------------------------------------------"
grep -n "static inline bool schedule_delayed_work" include/linux/workqueue.h
echo

echo "Test 2: Extract lines 506-531 showing delayed work implementation"
echo "------------------------------------------------------------"
sed -n '506,531p' include/linux/workqueue.h
echo

echo "============================================================"
echo "What this tests:"
echo "  - 'Schedules work to run after a specified delay (in jiffies)'"
echo "============================================================"
