#!/bin/bash
# Step D: Verify queue_work() takes a custom workqueue
# Run in GitHub Codespaces, not Mac Terminal

echo "============================================================"
echo "R2 Step D: Verify queue_work() custom workqueue parameter"
echo "============================================================"
echo

# Check if we're in the Linux kernel source directory
if [ ! -f "include/linux/workqueue.h" ]; then
    echo "ERROR: This must be run from Linux kernel source root"
    echo "Run test_step_B_schedule_work.sh setup instructions first"
    exit 1
fi

echo "Test 1: Find queue_work() inline declaration"
echo "------------------------------------------------------------"
grep -n "static inline bool queue_work" include/linux/workqueue.h
echo

echo "Test 2: Extract lines 408-436 showing queue_work implementation"
echo "------------------------------------------------------------"
sed -n '408,436p' include/linux/workqueue.h
echo

echo "============================================================"
echo "What this tests:"
echo "  - 'Similar to schedule_work() but lets you specify a custom workqueue'"
echo "============================================================"
