#!/bin/bash

echo "=========================================="
echo "R2 AOI #2 - Testing Missing module_exit"
echo "=========================================="
echo ""
echo "This script tests R2's Basic Example with msleep fixed but missing module_exit"
echo ""

# Create test file with fixed msleep but still missing module_exit
cat > r2_aoi2_test.c << 'EOF'
#include <linux/workqueue.h>
#include <linux/module.h>
#include <linux/delay.h>  // Fixed: Added missing header

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
// NOTE: Missing module_exit - this is the issue being tested

MODULE_LICENSE("GPL");
EOF

echo "Created r2_aoi2_test.c (with msleep fixed but missing module_exit)"
echo ""

# Create Makefile in current directory
cat > Makefile << 'EOF'
obj-m += r2_aoi2_test.o
EOF

echo "Building kernel module with verbose output..."
echo ""

make -C /lib/modules/$(uname -r)/build M=$PWD modules V=1 2>&1

echo ""
echo "=========================================="
echo "Analyzing results..."
echo "=========================================="
echo ""

if [ -f r2_aoi2_test.ko ]; then
    echo "✓ MODULE BUILT (but incomplete - missing module_exit)"
    echo ""
    echo "The module compiles successfully but is incomplete."
    echo "It has module_init but no module_exit function."
else
    echo "✗ BUILD FAILED"
fi

# Clean up
make -C /lib/modules/$(uname -r)/build M=$PWD clean 2>&1 > /dev/null
rm -f Makefile

echo ""
echo "=========================================="
echo "R2 AOI #2 TEST COMPLETE"
echo "=========================================="
