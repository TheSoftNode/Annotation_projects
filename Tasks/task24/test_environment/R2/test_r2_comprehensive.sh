#!/bin/bash

echo "=== R2 COMPREHENSIVE TESTS (Run in GitHub Codespaces) ==="
echo ""

# Test 1: Check for typos
echo "TEST 1: Checking for common typos"
grep -n "schedle" ../../extractions/RESPONSE_2.md
if [ $? -eq 0 ]; then
    echo "FOUND: Typo detected"
else
    echo "No major typos found"
fi
echo ""

# Test 2: Check for emojis
echo "TEST 2: Checking for emojis"
grep -E "🔹|✅|⚠️|📝" ../../extractions/RESPONSE_2.md | head -3
if [ $? -eq 0 ]; then
    echo "FOUND: Emojis in response"
else
    echo "No emojis found"
fi
echo ""

# Test 3: Extract basic example code
echo "TEST 3: Extracting basic example code"
cat > r2_basic.c << 'ENDCODE'
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

echo "Code extracted to r2_basic.c"
echo ""

# Test 4: Check for msleep without delay.h
echo "TEST 4: Checking if msleep is used without including <linux/delay.h>"
grep -n "msleep" r2_basic.c
grep -n "#include <linux/delay.h>" r2_basic.c
if [ $? -ne 0 ]; then
    echo "ISSUE: msleep() used but <linux/delay.h> not included"
else
    echo "OK: <linux/delay.h> is included"
fi
echo ""

# Test 5: Check for module_exit
echo "TEST 5: Checking for module_exit (cleanup function)"
grep -n "module_exit" r2_basic.c
if [ $? -ne 0 ]; then
    echo "ISSUE: No module_exit defined (incomplete module)"
else
    echo "OK: module_exit is defined"
fi
echo ""

# Test 6: Create Makefile for build attempt
echo "TEST 6: Creating Makefile for kernel module build"
cat > Makefile << 'ENDMAKE'
obj-m += r2_basic.o
ENDMAKE
echo "Makefile created"
echo ""

# Test 7: Build attempt (only if in Linux with kernel headers)
echo "TEST 7: Attempting kernel module build (requires Linux with kernel headers)"
if [ -d "/lib/modules/$(uname -r)/build" ]; then
    echo "Kernel headers found, attempting build..."
    make -C /lib/modules/$(uname -r)/build M=$PWD modules 2>&1 | head -50
else
    echo "SKIPPED: Not in Linux environment or kernel headers not installed"
    echo "To install headers in Codespaces: sudo apt-get install linux-headers-\$(uname -r)"
fi
echo ""

echo "=== R2 COMPREHENSIVE TESTS COMPLETE ==="
