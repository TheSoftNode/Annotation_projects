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
