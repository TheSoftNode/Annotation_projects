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
