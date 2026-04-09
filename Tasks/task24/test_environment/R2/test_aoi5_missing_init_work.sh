#!/bin/bash

echo "=========================================="
echo "R2 AOI #5 - Testing Missing INIT_WORK"
echo "=========================================="
echo ""
echo "This script tests R2's deferred interrupt processing example"
echo "with missing INIT_WORK initialization"
echo ""

# Create test file with the interrupt example missing INIT_WORK
cat > r2_aoi5_test.c << 'EOF'
#include <linux/workqueue.h>
#include <linux/module.h>
#include <linux/interrupt.h>

static struct work_struct irq_work;  // Declared but never initialized

// Dummy functions for the example
static void update_hardware_status(void) { }
static void process_data(void) { }
static void update_statistics(void) { }

static irqreturn_t my_interrupt(int irq, void *dev_id)
{
    /* Quick interrupt handling */
    update_hardware_status();

    /* Schedule heavier processing for later */
    schedule_work(&irq_work);  // BUG: irq_work was never initialized with INIT_WORK

    return IRQ_HANDLED;
}

static void process_irq_data(struct work_struct *work)
{
    /* This can take time and sleep */
    process_data();
    update_statistics();
}

static int __init my_init(void)
{
    printk(KERN_INFO "Module loaded - irq_work is NOT initialized\n");
    // NOTE: Missing INIT_WORK(&irq_work, process_irq_data);
    // If schedule_work(&irq_work) is called, it will use uninitialized data
    return 0;
}

static void __exit my_exit(void)
{
    printk(KERN_INFO "Module unloaded\n");
}

module_init(my_init);
module_exit(my_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Test missing INIT_WORK - R2 AOI #5");
EOF

echo "Created r2_aoi5_test.c (interrupt example missing INIT_WORK)"
echo ""

# Create Makefile in current directory
cat > Makefile << 'EOF'
obj-m += r2_aoi5_test.o
EOF

echo "Building kernel module with verbose output..."
echo ""

make -C /lib/modules/$(uname -r)/build M=$PWD modules V=1 2>&1

echo ""
echo "=========================================="
echo "Analyzing results..."
echo "=========================================="
echo ""

if [ -f r2_aoi5_test.ko ]; then
    echo "✓ MODULE BUILT (but contains uninitialized work_struct bug)"
    echo ""
    echo "The module compiles because the compiler doesn't know that"
    echo "work_struct needs initialization before use. The bug would"
    echo "only manifest at runtime when schedule_work(&irq_work) is"
    echo "called with an uninitialized work structure, leading to:"
    echo "  - Undefined behavior"
    echo "  - Kernel crashes"
    echo "  - System instability"
    echo ""
    echo "Expected initialization that's missing:"
    echo "  INIT_WORK(&irq_work, process_irq_data);"
else
    echo "✗ BUILD FAILED"
fi

# Clean up
make -C /lib/modules/$(uname -r)/build M=$PWD clean 2>&1 > /dev/null
rm -f Makefile

echo ""
echo "=========================================="
echo "R2 AOI #5 TEST COMPLETE"
echo "=========================================="
