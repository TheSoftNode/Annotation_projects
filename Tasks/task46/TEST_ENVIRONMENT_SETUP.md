# Task 46 Test Environment Setup Guide

Based on the factual analysis in `helpers/Factual_R1_Task46.md`, here's what we need for proper testing:

## ⚠️ CRITICAL REQUIREMENTS

### 1. **Use a Linux VM - NOT macOS Terminal**

**Why:**
- `udevil` is a Linux-only program
- Response assumes Linux-specific concepts: `udev`, `devtmpfs`, `/dev/sda1`, runit service directories
- macOS doesn't have these components

**Recommended Options:**
- **Multipass VM** (lightweight, Ubuntu-based)
- **VirtualBox** with Ubuntu/Debian
- **UTM** (ARM-based Macs)
- **Docker container** with systemd disabled (for basic syntax checks only)

### 2. **NOT GitHub Codespaces for Full Testing**

**Why:**
- Codespaces runs inside Docker container on a VM
- Limited access to real block devices
- Cannot test real device mounting behavior
- **OK for:** Syntax/help checks only
- **NOT OK for:** Real device mounting, hotplug events

---

## Required Packages

Install these on your Linux VM:

```bash
# 1. udevil (the tool being tested)
sudo apt-get install udevil

# 2. runit (process supervisor mentioned in conversation)
sudo apt-get install runit

# 3. udev or eudev (dependency of udevil)
# Ubuntu/Debian usually have udev by default
sudo apt-get install udev

# 4. sudo (for permission testing)
sudo apt-get install sudo
```

---

## Test Environment Verification

Before testing R1 claims, verify the environment:

```bash
# Check udevil installation
which udevil
udevil --help

# Check runit installation
which sv
sv --help

# Check udev installation
which udevadm
udevadm --version

# Check devtmpfs is mounted
mount | grep devtmpfs

# List /dev structure
ls -la /dev/ | head -20
```

---

## Specific Tests to Run

### TEST 1: Verify udev is userspace, NOT kernel-level

**R1 Claim (DISPUTED):** "udev: A kernel-level framework for handling devices"

**Test:**
```bash
# Check udev man page
man udev | grep -A5 "DESCRIPTION"

# Check if udevd is a daemon (userspace process)
ps aux | grep udevd

# Check netlink socket usage (proves userspace communication)
sudo strace -e socket udevadm monitor 2>&1 | grep -i netlink
```

**Expected Result:** Should confirm udev is a **userspace daemon**, not kernel-level.

---

### TEST 2: Verify udevadm does NOT create/remove device nodes directly

**R1 Claim (DISPUTED):** "udevadm: It can be used to create, remove, or query device nodes"

**Test:**
```bash
# Check udevadm man page for commands
man udevadm | grep -A10 "COMMANDS"

# List actual udevadm subcommands
udevadm --help

# Try to create a device node with udevadm (should fail)
sudo udevadm create /dev/testnode 2>&1
```

**Expected Result:** udevadm has `info`, `trigger`, `control`, `monitor`, `test` - but NOT `create` or `remove` device nodes.

---

### TEST 3: Test udevil command syntax (CRITICAL ERROR)

**R1 Claim (INCORRECT):** `udevil -a /mnt/my_mount_point`

**Test:**
```bash
# Check udevil help for correct syntax
udevil --help

# Try the R1's exact command (should fail)
udevil -a /mnt/my_mount_point 2>&1

# Check for -a flag
udevil --help | grep -i "\-a"
```

**Expected Result:**
- `-a` flag does NOT exist
- Correct syntax is `udevil mount [OPTIONS] DEVICE [DIR]`
- Command will fail with error

---

### TEST 4: Test chmod 755 for udevil permissions

**R1 Claim (INCOMPLETE):** "chmod 755 /usr/bin/udevil"

**Test:**
```bash
# Check current udevil permissions
ls -l /usr/bin/udevil

# Check if udevil is setuid
file /usr/bin/udevil

# Read udevil.conf for permission requirements
cat /etc/udevil/udevil.conf | grep -A10 "allowed_users"

# Check group ownership requirements
ls -l /usr/bin/udevil | awk '{print $3, $4}'
```

**Expected Result:** udevil.conf mentions setuid and group ownership - `chmod 755` alone is incomplete.

---

### TEST 5: Test runit service directory structure

**R1 Claim (PLAUSIBLE):** `/etc/sv/my_udevil_service`

**Test:**
```bash
# Check if /etc/sv/ exists
ls -la /etc/sv/ 2>&1

# Read runit FAQ about service directories
# (Already confirmed in factual file: /etc/sv/ is correct)

# Check where runit looks for services
ls -la /service/ 2>&1 || ls -la /etc/service/ 2>&1
```

**Expected Result:** `/etc/sv/` is the correct location (verified by runit docs).

---

### TEST 6: Verify devtmpfs auto-creates device nodes

**R1 Claim (SUPPORTED):** "devtmpfs auto-creates device nodes"

**Test:**
```bash
# Check if devtmpfs is mounted
mount | grep devtmpfs

# Check kernel config for devtmpfs
cat /boot/config-$(uname -r) | grep CONFIG_DEVTMPFS

# Watch device nodes appear when USB is plugged in
# (requires actual USB device)
ls -la /dev/disk/by-id/ | wc -l
# Plug in USB
sleep 2
ls -la /dev/disk/by-id/ | wc -l
```

**Expected Result:** devtmpfs auto-creates nodes; confirmed by kernel source.

---

## Test Execution Order

1. **Environment Verification** (check all packages installed)
2. **TEST 1** (udev userspace vs kernel)
3. **TEST 2** (udevadm capabilities)
4. **TEST 3** (udevil syntax - CRITICAL)
5. **TEST 4** (permissions model)
6. **TEST 5** (runit directories)
7. **TEST 6** (devtmpfs behavior)

---

## Safety Warnings

### ⚠️ DO NOT test `/dev/sda1` on a real system!

- `/dev/sda1` is often your actual boot partition
- Use a **throwaway Linux VM** where you control all disks
- Or use a test USB drive that you can format

### ⚠️ DO NOT run `chmod` on system files without understanding

- `chmod 755 /usr/bin/udevil` changes system binary permissions
- Test in a VM, not on your production system

---

## Test Result Documentation Format

For each test, document:

```
CLAIM: "[exact quote from R1]"
WHAT I RAN: `[exact command]`
OUTPUT:
```
[paste output]
```
OBSERVATION: [your analysis]
VERDICT: CORRECT / INCORRECT / PARTIALLY CORRECT
```

---

## Quick Start Script

```bash
#!/bin/bash
# Save as: test_r1_claims.sh

echo "=== Task 46 R1 Testing ==="
echo ""

echo "TEST 1: Is udev kernel-level?"
man udev | grep -A5 "DESCRIPTION"
echo ""

echo "TEST 2: udevadm commands"
udevadm --help | grep -A20 "Commands:"
echo ""

echo "TEST 3: udevil -a flag (should FAIL)"
udevil -a /mnt/test 2>&1 || echo "FAILED AS EXPECTED"
echo ""

echo "TEST 3b: udevil correct syntax"
udevil --help | head -20
echo ""

echo "TEST 4: udevil permissions"
ls -l /usr/bin/udevil
cat /etc/udevil/udevil.conf | grep -A5 "allowed_users"
echo ""

echo "TEST 5: runit service location"
ls -la /etc/sv/ | head -10
echo ""

echo "TEST 6: devtmpfs"
mount | grep devtmpfs
echo ""

echo "=== Testing Complete ==="
```

---

## Summary

**MUST HAVE:**
- ✅ Linux VM (Ubuntu/Debian recommended)
- ✅ udevil installed
- ✅ runit installed
- ✅ udev/eudev installed
- ✅ sudo access

**CRITICAL TESTS:**
- ✅ TEST 3: udevil -a flag (proves syntax error)
- ✅ TEST 1: udev is userspace (proves fundamental error)
- ✅ TEST 2: udevadm capabilities (proves misunderstanding)

**OUTCOME:**
These tests will provide concrete evidence for AOIs in R1 showing:
1. Fundamental misunderstanding of udev (kernel vs userspace)
2. Incorrect command syntax for udevil
3. Incomplete permission model explanation
