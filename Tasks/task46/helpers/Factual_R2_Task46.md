Best test target: a **throwaway Linux VM on your Mac**. Do **not** use macOS Terminal alone for this, because `udevil` is documented as a **Linux** program. GitHub Codespaces is okay for quick **build/link/help-text checks**, but it runs inside a **dev container on a VM**, so it is not a fair place to test real `/dev`, hotplug, removable-device events, or mount behavior. ([ignorantguru.github.io](https://ignorantguru.github.io/udevil/))

Install dependencies first on that Linux VM. For **libudev-zero**, the project lists a **C99 compiler**, **POSIX make**, **POSIX & XSI libc**, and **Linux \>= 2.6.39**. For **udevil** builds, its configure script checks for **GLib 2.0** development headers and **libudev \>= 143** development headers. ([GitHub](https://github.com/illiliti/libudev-zero))

I’m excluding pure judgment lines like **“Recommended”**, **“exactly what you need”**, and **“path of least resistance”**, because those are recommendations, not factual claims you can verify directly.

## **Claim breakdown**

1. Claim: `"udevil (the lightweight automounter)"`  
   * Assessment: **Partly supported**  
   * What to verify: whether upstream describes `udevil` as lightweight, and whether `udevil` itself is the automounter or whether that role is handled by `devmon`.  
   * Why: upstream describes `udevil` as **“Lightweight”**, but also says it **includes the devmon automounting daemon** and the help text says **“For automounting with udevil run 'devmon \--help'”**. So the “lightweight” part is supported; calling `udevil` itself “the automounter” is a little loose. ([ignorantguru.github.io](https://ignorantguru.github.io/udevil/))  
2. Claim: `"udevil links against \`libudev\` to monitor kernel events (hotplug, device changes)."\`  
   * Assessment: **Supported in substance**  
   * What to verify: whether upstream build files require `libudev`, whether the source includes `<libudev.h>`, and whether upstream says it monitors device changes.  
   * Why: `udevil`’s build system requires `libudev >= 143`, the source includes `<libudev.h>`, and upstream docs say it “monitors device changes.” ([GitHub](https://github.com/IgnorantGuru/udevil/blob/master/configure.ac))  
3. Claim: `"It's a drop-in replacement for \`libudev\` that **does not require \`udevd\`** (the eudev daemon) to be running."\`  
   * Assessment: **Supported with a caveat**  
   * What to verify: whether libudev-zero calls itself a drop-in replacement / daemonless replacement, and whether its README adds any hotplug caveats.  
   * Why: the repo says **“Drop-in replacement for `libudev`”** and **“Daemonless replacement for libudev.”** But for hotplugging it also says you must configure your device manager to **rebroadcast kernel uevents**, because libudev-zero cannot simply listen to kernel uevents directly. ([GitHub](https://github.com/illiliti/libudev-zero))  
4. Claim: `"Implements the \`libudev\` API by listening to kernel netlink sockets directly."\`  
   * Assessment: **Disputed**  
   * What to verify: read libudev-zero’s hotplug section.  
   * Why: the README says the opposite of the simple version here: **“libudev-zero can't simply listen to kernel uevents due to potential race conditions”** and instead needs rebroadcasting to a particular netlink group. That makes this claim too strong or wrong as written. ([GitHub](https://github.com/illiliti/libudev-zero))  
5. Claim: `"It maintains an in-memory device database without the heavy rules-processing daemon."`  
   * Assessment: **Unsupported from the primary sources I found**  
   * What to verify: look for upstream docs explicitly saying “in-memory device database.”  
   * Why: the repo clearly says daemonless replacement and describes missing pieces and hotplug requirements, but I did not find upstream text supporting this exact “in-memory device database” wording. ([GitHub](https://github.com/illiliti/libudev-zero))  
6. Claim: `"Udevil will work unchanged because it just needs \`libudev.so\` to exist."\`  
   * Assessment: **Disputed**  
   * What to verify: compare udevil’s dependency on `libudev` with libudev-zero’s own warning that many functions/interfaces are still unimplemented and may break programs.  
   * Why: `udevil` does require `libudev`, but libudev-zero explicitly says **many functions and interfaces still aren't implemented, which may lead to breakage in some programs**. So “will work unchanged” is not established by the sources. ([GitHub](https://github.com/IgnorantGuru/udevil/blob/master/configure.ac))  
7. Claim: `"You replace eudev's libudev with libudev-zero, kill udevd, and udevil continues to detect and mount devices."`  
   * Assessment: **Disputed / incomplete**  
   * What to verify: separate **detect** from **mount**.  
   * Why: `udevil` can **monitor** device changes, but its help text separately says **“For automounting with udevil run 'devmon \--help'”**. Also libudev-zero’s hotplug section says extra rebroadcast configuration is needed. So this claim overstates how automatic the outcome is. ([ignorantguru.github.io](https://ignorantguru.github.io/udevil/udevil--help.html))  
8. Claim: `"Removes the udevd daemon while keeping hotplug support."`  
   * Assessment: **Supported with a caveat**  
   * What to verify: whether libudev-zero supports hotplug, and under what conditions.  
   * Why: libudev-zero has a **Hotplugging** section, but it says support is optional and requires rebroadcasted uevents or device-manager integration. So the broad direction is right, but the response leaves out the setup requirement. ([GitHub](https://github.com/illiliti/libudev-zero))  
9. Claim: `"Some obscure udev features (complex rules, \`udevadm\` commands) won't work, but udevil doesn't use those anyway."\`  
   * Assessment: **First half partly supported, second half unsupported**  
   * What to verify: libudev-zero’s missing features list, then whether there is any primary source proving udevil avoids those missing interfaces.  
   * Why: libudev-zero does say **udev rules must be converted to shell script**, **udev hwdb interface isn't implemented**, and many interfaces are missing. But I did not find a primary source proving that `udevil` avoids every missing area. ([GitHub](https://github.com/illiliti/libudev-zero))  
10. Claim: `"# Ensure /dev is mounted with devtmpfs (kernel creates nodes)"`  
    * Assessment: **Supported**  
    * What to verify: the kernel’s `devtmpfs` source/documentation.  
    * Why: the kernel source says **“devtmpfs \- kernel-maintained tmpfs-based /dev”** and **“Every driver-core device which requests a device node, will add a node in this filesystem.”** ([GitHub](https://github.com/torvalds/linux/blob/master/drivers/base/devtmpfs.c))  
11. Claim: `"If you're purging eudev entirely (including libudev), udevil will break because it depends on that library."`  
    * Assessment: **Supported in the normal dynamic-link case**  
    * What to verify: udevil’s build-time dependency and source include.  
    * Why: the build system requires `libudev`, and the source includes `<libudev.h>`. In a normal dynamic-link setup, removing the library breaks the program. ([GitHub](https://github.com/IgnorantGuru/udevil/blob/master/configure.ac))  
12. Claim: `"mdevd (skarnet) | Daemonized device manager (not BusyBox). Handles hotplug via netlink."`  
    * Assessment: **Supported in substance**  
    * What to verify: mdevd’s official description.  
    * Why: skarnet describes `mdevd` as **“a small daemon managing kernel hotplug events, similarly to udevd”** and says it is **“a daemon listening to the netlink.”** ([skarnet.org](https://skarnet.org/software/mdevd/))  
13. Claim: `"nldev (suckless) | Minimal netlink listener + device node creator."`  
    * Assessment: **Partly supported**  
    * What to verify: nldev’s official page.  
    * Why: the official page says `nldev` is **“a netlink frontend for mdev, replacing the over-engineered udevd.”** That supports the netlink part. I did not find a primary source using the exact words “device node creator” on the nldev page itself. ([core.suckless.org](https://core.suckless.org/nldev/))  
14. Claim: `"smdev (suckless) | Similar to mdev but standalone."`  
    * Assessment: **Supported in substance**  
    * What to verify: smdev’s README.  
    * Why: the README says `smdev` is **“a simple program to manage device nodes”** and **“mostly compatible with mdev.”** ([git.suckless.org](https://git.suckless.org/smdev/file/README.html))  
15. Claim: `"Write a small C program or script using \`/sys/class/net\` or \`NETLINK\_KOBJECT\_UEVENT\` to listen for "add" events and mount manually."\`  
    * Assessment: **Mixed: NETLINK part supported, `/sys/class/net` part disputed**  
    * What to verify: what `/sys/class/net` actually is, and what `NETLINK_KOBJECT_UEVENT` is used for.  
    * Why: `/sys/class/net` is the kernel’s sysfs class for **network interfaces**, so it is not a general source for removable-storage “add” events. `NETLINK_KOBJECT_UEVENT` is the right family for kernel uevents. ([Kernel.org](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-net))  
16. Claim: `"You lose udevil's convenience (policy handling, user permissions, etc.) and have to manage mount logic yourself."`  
    * Assessment: **Supported**  
    * What to verify: whether udevil upstream advertises policy/user-control/security features.  
    * Why: upstream says admins can adjust **allowed users, groups, fstypes, devices**, set defaults, and use custom auth/notification scripts. That supports the claim that replacing it with a raw script means you take those responsibilities back on yourself. ([ignorantguru.github.io](https://ignorantguru.github.io/udevil/))  
17. Claim: `"Pre-mount all filesystems in \`/etc/fstab\`"\`  
    * Assessment: **Supported as a Linux mechanism**  
    * What to verify: the `fstab(5)` and `mount(8)` man pages.  
    * Why: `fstab` contains descriptive information about filesystems the system can mount, and `mount` follows filesystem entries from `fstab`. ([man7.org](https://man7.org/linux/man-pages/man5/fstab.5.html))  
18. Claim: `"Remove udevil (use \`mount\` directly or \`pmount\`)"\`  
    * Assessment: **Supported as an available alternative**  
    * What to verify: whether `pmount` is a real mount wrapper for removable devices.  
    * Why: `pmount` is documented as a wrapper around the standard mount program that lets normal users mount removable devices without a matching `/etc/fstab` entry. ([Debian Manpages](https://manpages.debian.org/testing/pmount/pmount.1.en.html))  
19. Claim: `"evdev (input events) is kernel-space."`  
    * Assessment: **Disputed / misleading**  
    * What to verify: the Linux input documentation.  
    * Why: the kernel docs describe `evdev` as **“the generic input event interface”** and **“the preferred interface for userspace to consume user input.”** So calling it simply “kernel-space” is misleading. ([Kernel Documentation](https://docs.kernel.org/input/input.html))  
20. Claim: `"It doesn't care about eudev, libudev-zero, or any device manager."`  
    * Assessment: **Broadly supported**  
    * What to verify: whether evdev is consumed through `/dev/input/event*` and whether the interface itself depends on libudev.  
    * Why: the kernel docs present `evdev` as a userspace interface exposed through `/dev/input/event*`. The interface itself is not described as depending on `libudev`; what matters is that the device nodes exist and are accessible. ([Kernel Documentation](https://docs.kernel.org/input/input.html))  
21. Claim: `"As long as \`/dev/input/event\*\` nodes exist (created by \`devtmpfs\` or manually), evdev works."\`  
    * Assessment: **Supported in substance**  
    * What to verify: the evdev docs and devtmpfs docs.  
    * Why: the kernel input docs show evdev devices under `/dev/input/event*`, and `devtmpfs` is the kernel mechanism that creates device nodes for driver-core devices. ([Kernel Documentation](https://docs.kernel.org/input/input.html))  
22. Claim: `"(Remove eudev package, install libudev-zero, devtmpfs handles /dev nodes)"`  
    * Assessment: **Mixed**  
    * What to verify: `devtmpfs` definitely handles device nodes; replacing the package stack cleanly is distro-specific and should be tested in a throwaway VM.  
    * Why: the `devtmpfs` part is well-supported by the kernel source; the package-replacement part is not a universal one-line fact across distros. ([GitHub](https://github.com/torvalds/linux/blob/master/drivers/base/devtmpfs.c))

## **Code / manual testing**

There is **no real runnable code block** in RESPONSE 2\. The block under **Migration** is just a **comment-only sketch**, and the `nldev -s | while read...; do mount...` line is an illustrative shell sketch, not a documented full script. So the fair way to test RESPONSE 2 is to test the **claims behind those snippets**, not to treat them as a complete program.

### **Use this environment**

Use a **Linux VM on your Mac** with root access. Codespaces is fine only for lightweight compile/help checks, not for real device/hotplug tests. ([ignorantguru.github.io](https://ignorantguru.github.io/udevil/))

### **Install first**

If you are building from source:

* For **libudev-zero**: C99 compiler, POSIX make, POSIX/XSI libc. ([GitHub](https://github.com/illiliti/libudev-zero))  
* For **udevil**: GLib 2.0 development headers, `libudev` development headers, `pkg-config`. ([GitHub](https://github.com/IgnorantGuru/udevil/blob/master/configure.ac))

### **Test 1: verify the `udevil` ↔ `libudev` dependency claim**

Run:

command \-v udevil

ldd "$(command \-v udevil)" | grep libudev

Expected result:

* You should see `udevil`’s path.  
* On a normal dynamic build, `ldd` should show a `libudev` dependency.

What this tests:

* It tests the claim that `udevil` depends on `libudev` in your build.  
* It does **not** prove hotplug works after swapping in libudev-zero. ([GitHub](https://github.com/IgnorantGuru/udevil/blob/master/configure.ac))

### **Test 2: verify the `devtmpfs` claim from the comment block**

Run:

mount | grep ' on /dev '

Expected result:

* On a system using devtmpfs for `/dev`, you should see `/dev` mounted as `devtmpfs`.

Optional extra check:

ls \-l /dev/input/event\* /dev/sd\* 2\>/dev/null

Expected result:

* If those devices exist on your VM, the nodes should be present under `/dev`.

What this tests:

* It tests the claim **“kernel creates nodes”** via `devtmpfs`. ([GitHub](https://github.com/torvalds/linux/blob/master/drivers/base/devtmpfs.c))

### **Test 3: verify that `udevil` has monitoring and mounting as separate behaviors**

Run:

udevil \--help

Expected result:

* You should see:  
  * `udevil monitor|--monitor`  
  * and a line saying `For automounting with udevil run 'devmon --help'`

What this tests:

* It helps you check whether RESPONSE 2 blurred together **monitoring** and **automounting**. Upstream help clearly separates them. ([ignorantguru.github.io](https://ignorantguru.github.io/udevil/udevil--help.html))

### **Test 4: verify the hotplug/detection claim before and after replacing `libudev`**

Do this only in a throwaway VM.

Terminal 1:

udevil monitor

Then, in the VM:

* attach/remove a USB device, or  
* add/remove a second virtual disk from the VM settings.

Expected result:

* On a working setup, `udevil monitor` should print device events.

Then repeat the same test **after** replacing the `libudev` implementation with libudev-zero in that VM.

How to interpret results:

* If monitoring still works, that supports the “detect” half.  
* If it stops working, that fits libudev-zero’s own warning that hotplug needs rebroadcasted uevents / extra setup. ([ignorantguru.github.io](https://ignorantguru.github.io/udevil/udevil--help.html))

### **Test 5: verify the “drop-in replacement” claim at the library/build level**

If your distro has a `libudev-zero` package, install it in the VM. If not, build it from the upstream repo using the upstream install steps:

make

sudo make PREFIX=/usr install

Expected result:

* The build/install should complete if your VM has the listed prerequisites.

What this tests:

* It tests that the project is buildable and intended as a replacement library.  
* It does **not** prove every libudev consumer will work unchanged. The README explicitly warns that some interfaces are missing. ([GitHub](https://github.com/illiliti/libudev-zero))

### **Test 6: verify the “udevil continues to detect and mount devices” claim**

Detection and mounting should be tested separately.

Detection:

udevil monitor

Mounting:

udevil mount /dev/WHATEVER\_DEVICE

Expected result:

* Detection success means monitor events are reaching `udevil`.  
* Mount success depends on having a real mountable device and the right permissions/config.

Important note:

* Upstream `udevil` documentation says **automounting** is associated with `devmon`, not just `udevil` itself. So if RESPONSE 2 is read as “udevil alone will automount everything after the swap,” that is not what the upstream help text says. ([ignorantguru.github.io](https://ignorantguru.github.io/udevil/udevil--help.html))

### **Test 7: verify the `evdev` claim**

Run:

ls \-l /dev/input/event\*

Expected result:

* You should see one or more `/dev/input/event*` nodes on a normal Linux desktop/laptop VM with input devices.

What this tests:

* It verifies the node-existence part of the evdev claim.  
* It does **not** prove the wording **“evdev is kernel-space”**; the kernel docs actually describe it as the preferred **userspace** interface for input consumption. ([Kernel Documentation](https://docs.kernel.org/input/input.html))

When you send your test results back, use this format and I’ll compare each result against the original response without rewriting it:

1. Claim: `"..."`  
   What I ran: `...`  
   Output: `...`  
   Expected result: `...`  
   My observation: `...`

