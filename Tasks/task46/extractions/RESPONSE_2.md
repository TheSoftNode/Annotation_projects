**RESPONSE 2:**

#### If you use **udevil** (the lightweight automounter) and want to drop **eudev**, you have one critical constraint: **udevil links against `libudev`** to monitor kernel events (hotplug, device changes).

#### Here are your realistic options, ranked from "minimal change" to "nuclear option":

#### ---

### **Option 1: libudev-zero (Recommended)**

#### This is exactly what you need. It's a drop-in replacement for `libudev` that **does not require `udevd`** (the eudev daemon) to be running.

* #### **How it works**: Implements the `libudev` API by listening to kernel netlink sockets directly. It maintains an in-memory device database without the heavy rules-processing daemon.

* #### **With udevil**: Udevil will work unchanged because it just needs `libudev.so` to exist. You replace eudev's libudev with libudev-zero, kill `udevd`, and udevil continues to detect and mount devices.

* #### **Pros**: Zero changes to your runit services or udevil setup. Removes the udevd daemon while keeping hotplug support.

* #### **Cons**: Some obscure udev features (complex rules, `udevadm` commands) won't work, but udevil doesn't use those anyway.

#### **Migration**:

#### \# Remove eudev, install libudev-zero

#### \# Ensure /dev is mounted with devtmpfs (kernel creates nodes)

#### \# udevil runs as usual, linked against libudev-zero

####

#### ---

### **Option 2: Replace udevil \+ eudev together**

#### If you're purging eudev entirely (including libudev), udevil will break because it depends on that library. You'd need to replace the automounter too:

| Replacement | Notes |
| ----- | ----- |
| **mdevd** (skarnet) | Daemonized device manager (not BusyBox). Handles hotplug via netlink. You'd write a small helper script to call `mount` when mdevd detects a block device. |
| **nldev** (suckless) | Minimal netlink listener \+ device node creator. Pair it with a custom mount script (like \`nldev \-s |
| **smdev** (suckless) | Similar to mdev but standalone. |
| **Custom netlink script** | Write a small C program or script using `/sys/class/net` or `NETLINK_KOBJECT_UEVENT` to listen for "add" events and mount manually. |

#### **Trade-off**: You lose udevil's convenience (policy handling, user permissions, etc.) and have to manage mount logic yourself.

#### ---

### **Option 3: Static /dev (Not recommended)**

#### If you only use fixed, internal storage (no USB, no hotplug), you could:

* #### Mount `devtmpfs` at boot (kernel auto-creates `/dev` nodes)

* #### Pre-mount all filesystems in `/etc/fstab`

* #### **Remove eudev entirely**

* #### **Remove udevil** (use `mount` directly or `pmount`)

#### This only works if you never plug/unplug storage while running.

#### ---

### **Key Point About `evdev`**

#### **evdev** (input events) is kernel-space. It doesn't care about eudev, libudev-zero, or any device manager. As long as `/dev/input/event*` nodes exist (created by `devtmpfs` or manually), evdev works. Your input handling is safe regardless of which option you choose.

#### ---

### **Summary Decision Tree**

#### Want to keep udevil?

#### ├── Yes → Use libudev-zero (drop-in replacement)

#### │         (Remove eudev package, install libudev-zero,

#### │          devtmpfs handles /dev nodes)

#### └── No  → Use mdevd \+ custom mount scripts

####           (Full stack replacement, no libudev dependency)

####

#### **Recommendation**: Go with **libudev-zero**. It solves your "replace eudev" requirement while preserving your existing `runit` \+ `udevil` \+ `evdev` workflow. It's the path of least resistance for your specific setup.
