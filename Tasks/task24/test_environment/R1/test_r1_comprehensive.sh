#!/bin/bash

echo "=== R1 COMPREHENSIVE TESTS (Run in GitHub Codespaces) ==="
echo ""

# Test 1: Check for typo "schedle_work"
echo "TEST 1: Checking for typo 'schedle_work'"
grep -n "schedle_work" ../../extractions/RESPONSE_1.md
if [ $? -eq 0 ]; then
    echo "FOUND: Typo 'schedle_work' instead of 'schedule_work'"
else
    echo "No typo found"
fi
echo ""

# Test 2: Check for emojis
echo "TEST 2: Checking for emojis in section headings"
grep -n "🔹" ../../extractions/RESPONSE_1.md | head -5
if [ $? -eq 0 ]; then
    echo "FOUND: Emojis in section headings"
else
    echo "No emojis found"
fi
echo ""

# Test 3: Extract code and create test file
echo "TEST 3: Extracting code for build test"
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

echo "Code extracted to work_test.c"
echo ""

# Test 4: Check for msleep without delay.h
echo "TEST 4: Checking if msleep is used without including <linux/delay.h>"
grep -n "msleep" work_test.c
grep -n "#include <linux/delay.h>" work_test.c
if [ $? -ne 0 ]; then
    echo "ISSUE: msleep() used but <linux/delay.h> not included"
else
    echo "OK: <linux/delay.h> is included"
fi
echo ""

# Test 5: Check module_init/module_exit naming conflict
echo "TEST 5: Checking for potential module_init/module_exit naming conflict"
grep -n "init_module\|cleanup_module" work_test.c | grep -v "module_init\|module_exit"
if [ $? -eq 0 ]; then
    echo "POTENTIAL ISSUE: Using init_module/cleanup_module names may conflict with module_init/module_exit macros"
fi
echo ""

# Test 6: Create Makefile for build attempt
echo "TEST 6: Creating Makefile for kernel module build"
cat > Makefile << 'ENDMAKE'
obj-m += work_test.o
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

echo "=== R1 COMPREHENSIVE TESTS COMPLETE ==="
