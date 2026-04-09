#!/bin/bash
# Step E: Verify flush_work() and flush_scheduled_work()
# Run in GitHub Codespaces, not Mac Terminal

echo "============================================================"
echo "R2 Step E: Verify flush_work() and flush_scheduled_work()"
echo "============================================================"
echo

# Check if we're in the Linux kernel source directory
if [ ! -f "include/linux/workqueue.h" ]; then
    echo "ERROR: This must be run from Linux kernel source root"
    echo "Run test_step_B_schedule_work.sh setup instructions first"
    exit 1
fi

echo "Test 1: Find flush_work() declaration"
echo "------------------------------------------------------------"
grep -n "flush_work(" include/linux/workqueue.h
echo

echo "Test 2: Find flush_scheduled_work() wrapper"
echo "------------------------------------------------------------"
grep -n "flush_scheduled_work" include/linux/workqueue.h
echo

echo "Test 3: Extract lines 478-504 showing flush APIs and warnings"
echo "------------------------------------------------------------"
sed -n '478,504p' include/linux/workqueue.h
echo

echo "============================================================"
echo "What this tests:"
echo "  - 'flush_work(&my_work); /* Wait for specific work */'"
echo "  - 'flush_scheduled_work(); /* Wait for all work on system_wq */'"
echo "  - Whether the response omitted risk around flush_scheduled_work()"
echo "============================================================"
