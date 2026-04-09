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
