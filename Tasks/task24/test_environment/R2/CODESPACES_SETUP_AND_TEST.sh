#!/bin/bash

echo "=========================================="
echo "R2 KERNEL MODULE BUILD TEST (Codespaces)"
echo "=========================================="
echo ""
echo "This script tests R2's basic example code"
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

# Step 3: Create r2_test.c with EXACT code from response
echo "STEP 3: Creating r2_test.c with exact code from R2..."
echo "----------------------------------------"
cat > r2_test.c << 'ENDCODE'
#include <linux/workqueue.h>

#include <linux/module.h>

static struct work_struct my_work;

/* Work function to be executed later */

static void my_work_func(struct work_struct *work)

{

    printk(KERN_INFO "Work function executing in process context\n");

    /* Can sleep here if needed */

    msleep(100);

}

static int __init my_init(void)

{

    /* Initialize the work structure */

    INIT_WORK(&my_work, my_work_func);



    /* Schedule the work for execution */

    schedule_work(&my_work);



    return 0;

}

module_init(my_init);
ENDCODE

echo "r2_test.c created"
echo ""

# Step 4: Create Makefile
echo "STEP 4: Creating Makefile..."
echo "----------------------------------------"
cat > Makefile << 'ENDMAKE'
obj-m += r2_test.o
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

if [ $BUILD_STATUS -eq 0 ] && [ -f "r2_test.ko" ]; then
    echo "✓ BUILD SUCCESSFUL - r2_test.ko created"
    echo ""
    echo "Module info:"
    modinfo r2_test.ko
    echo ""

    echo "WARNING: This module has no module_exit - incomplete!"
    echo ""

    echo "RUNTIME TEST (risky without cleanup):"
    echo "  sudo insmod r2_test.ko"
    echo "  dmesg | tail -n 20"
    echo "  # Module cannot be safely unloaded - missing module_exit"
else
    echo "✗ BUILD FAILED"
    echo ""
    echo "Checking for expected errors:"
    echo ""

    # Check for msleep error
    echo "1. Checking for msleep() without <linux/delay.h>:"
    grep -i "msleep\|delay\.h" build_output.txt | head -5
    echo ""

    # Check for missing module_exit
    echo "2. Checking for module_exit issues:"
    grep -i "module_exit" build_output.txt | head -5
    echo ""

    echo "Full build log saved to: build_output.txt"
fi

echo ""
echo "=========================================="
echo "R2 BUILD TEST COMPLETE"
echo "=========================================="
