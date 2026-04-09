#!/bin/bash
# Step B: Verify the exact schedule_work() declaration and wrapper behavior
# Run in GitHub Codespaces, not Mac Terminal

echo "============================================================"
echo "R2 Step B: Verify schedule_work() declaration and wrapper"
echo "============================================================"
echo

# Check if we're in the Linux kernel source directory
if [ ! -f "include/linux/workqueue.h" ]; then
    echo "ERROR: This must be run from Linux kernel source root"
    echo "Expected file: include/linux/workqueue.h"
    echo ""
    echo "To set up:"
    echo "  sudo apt update"
    echo "  sudo apt install -y git build-essential bc flex bison libelf-dev libssl-dev"
    echo "  git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
    echo "  cd linux"
    echo ""
    exit 1
fi

echo "Test 1: Find schedule_work() inline declaration"
echo "------------------------------------------------------------"
grep -n "static inline bool schedule_work" include/linux/workqueue.h
echo

echo "Test 2: Find queue_work(system_wq, work) implementation"
echo "------------------------------------------------------------"
grep -n "return queue_work(system_wq, work);" include/linux/workqueue.h
echo

echo "Test 3: Find system_wq documentation comment"
echo "------------------------------------------------------------"
grep -n "system_wq is the one used by schedule" include/linux/workqueue.h
echo

echo "============================================================"
echo "What this tests:"
echo "  - 'It's declared in <linux/workqueue.h>:'"
echo "  - 'bool schedule_work(struct work_struct *work);'"
echo "  - 'Uses the kernel's system workqueue (system_wq)'"
echo "  - 'schedule_work(work) is equivalent to queue_work(system_wq, work)'"
echo "============================================================"
