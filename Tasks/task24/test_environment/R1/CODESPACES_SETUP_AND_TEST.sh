#!/bin/bash

echo "=========================================="
echo "R1 KERNEL MODULE BUILD TEST (Codespaces)"
echo "=========================================="
echo ""
echo "This script follows GPT Factual R1 instructions exactly"
echo ""

# Step 1: Check dependencies
echo "STEP 1: Checking dependencies..."
echo "----------------------------------------"
echo "Kernel version:"
uname -r
echo ""

echo "Checking for kernel build directory:"
ls -ld /lib/modules/$(uname -r)/build 2>&1
BUILD_DIR_EXISTS=$?
echo ""

echo "GCC version:"
gcc --version 2>&1 | head -1
GCC_EXISTS=$?
echo ""

echo "Make version:"
make --version 2>&1 | head -1
MAKE_EXISTS=$?
echo ""

# Step 2: Install dependencies if missing
if [ $GCC_EXISTS -ne 0 ] || [ $MAKE_EXISTS -ne 0 ]; then
    echo "STEP 2: Installing build-essential..."
    echo "----------------------------------------"
    sudo apt-get update
    sudo apt-get install -y build-essential
    echo ""
fi

if [ $BUILD_DIR_EXISTS -ne 0 ]; then
    echo "STEP 2b: Installing kernel headers..."
    echo "----------------------------------------"
    sudo apt-get update
    sudo apt-get install -y linux-headers-$(uname -r)
    echo ""

    echo "Verifying kernel headers installation:"
    ls -ld /lib/modules/$(uname -r)/build 2>&1
    if [ $? -ne 0 ]; then
        echo "ERROR: Kernel headers could not be installed"
        echo "This Codespace cannot build kernel modules"
        exit 1
    fi
fi

# Step 3: Create work_test.c with EXACT code from response
echo "STEP 3: Creating work_test.c with exact code from R1..."
echo "----------------------------------------"
cat > work_test.c << 'ENDCODE'
#include <linux/workqueue.h>

#include <linux/slab.h>

#include <linux/module.h>

static struct work_struct my_work;

// Work function — runs in process context

static void my_work_handler(struct work_struct *work)

{

    printk(KERN_INFO "Executing deferred work\n");

    // Can sleep, allocate memory, etc.

    msleep(100);

}

// Module initialization

static int __init init_module(void)

{

    // Initialize the work item

    INIT_WORK(&my_work, my_work_handler);

    // Schedule the work

    schedule_work(&my_work);

    return 0;

}

static void __exit cleanup_module(void)

{

    // Flush any pending work

    flush_scheduled_work();  // Deprecated; use cancel_work_sync instead

    // Or: cancel_work_sync(&my_work);

}

module_init(init_module);

module_exit(cleanup_module);
ENDCODE

echo "work_test.c created"
echo ""

# Step 4: Create Makefile
echo "STEP 4: Creating Makefile..."
echo "----------------------------------------"
cat > Makefile << 'ENDMAKE'
obj-m += work_test.o
ENDMAKE

echo "Makefile created"
echo ""

# Step 5: Build test with verbose output
echo "STEP 5: Building kernel module (with verbose output)..."
echo "----------------------------------------"
echo "Command: make -C /lib/modules/\$(uname -r)/build M=\$PWD modules V=1"
echo ""

make -C /lib/modules/$(uname -r)/build M=$PWD modules V=1 2>&1 | tee build_output.txt

BUILD_STATUS=$?
echo ""

# Step 6: Check build results
echo "STEP 6: Analyzing build results..."
echo "----------------------------------------"

if [ $BUILD_STATUS -eq 0 ] && [ -f "work_test.ko" ]; then
    echo "✓ BUILD SUCCESSFUL - work_test.ko created"
    echo ""
    echo "Module info:"
    modinfo work_test.ko
    echo ""

    echo "NEXT STEPS FOR RUNTIME TEST:"
    echo "  sudo insmod work_test.ko"
    echo "  dmesg | tail -n 20"
    echo "  sudo rmmod work_test"
    echo "  dmesg | tail -n 20"
    echo ""
    echo "Expected: Should see 'Executing deferred work' in dmesg"
else
    echo "✗ BUILD FAILED"
    echo ""
    echo "Checking for expected errors mentioned in GPT Factual:"
    echo ""

    # Check for msleep error
    echo "1. Checking for msleep() without <linux/delay.h>:"
    grep -i "msleep\|delay\.h" build_output.txt | head -5
    echo ""

    # Check for init_module/cleanup_module naming conflict
    echo "2. Checking for init_module/cleanup_module naming conflict:"
    grep -i "init_module\|cleanup_module" build_output.txt | head -5
    echo ""

    echo "Full build log saved to: build_output.txt"
fi

echo ""
echo "=========================================="
echo "R1 BUILD TEST COMPLETE"
echo "=========================================="
