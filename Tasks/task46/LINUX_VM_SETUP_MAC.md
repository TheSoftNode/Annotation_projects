# Quick Linux VM Setup on Mac

## 🚀 Easiest Option: Multipass (Recommended)

**Best for:** Quick, lightweight Ubuntu VMs on Mac

### Install Multipass

```bash
# Install via Homebrew
brew install multipass
```

### Launch Ubuntu VM

```bash
# Launch a basic Ubuntu VM (default: 22.04 LTS)
multipass launch --name task46-test

# Launch with specific specs
multipass launch --name task46-test --cpus 2 --memory 2G --disk 10G
```

### Access the VM

```bash
# Shell into the VM
multipass shell task46-test
```

### Install Required Packages

```bash
# Inside the VM
sudo apt-get update
sudo apt-get install -y udevil runit udev
```

### Manage the VM

```bash
# Stop the VM
multipass stop task46-test

# Start the VM
multipass start task46-test

# Delete the VM when done
multipass delete task46-test
multipass purge
```

**Pros:**
- ✅ Fastest setup (1 command)
- ✅ Lightweight
- ✅ Easy to create/destroy
- ✅ Good for testing

**Cons:**
- ❌ Limited to Ubuntu/Debian variants
- ❌ Less control over hardware

---

## 🎯 Option 2: UTM (Best for Apple Silicon Macs)

**Best for:** M1/M2/M3 Macs, GUI-based VM management

### Install UTM

```bash
# Install via Homebrew
brew install --cask utm
```

Or download from: https://mac.getutm.app/

### Setup Steps

1. **Download Ubuntu ARM image** (for Apple Silicon):
   - Go to: https://ubuntu.com/download/server/arm
   - Download Ubuntu Server 22.04 LTS (ARM64)

2. **Create VM in UTM:**
   - Open UTM
   - Click "Create a New Virtual Machine"
   - Choose "Virtualize" (faster on M-series chips)
   - Select "Linux"
   - Browse to downloaded Ubuntu ISO
   - Set Memory: 2048 MB
   - Set Storage: 10 GB
   - Click "Save"

3. **Install Ubuntu:**
   - Start the VM
   - Follow Ubuntu installation prompts
   - Create user/password
   - Wait for installation to complete
   - Reboot

4. **Install packages:**
   ```bash
   sudo apt-get update
   sudo apt-get install -y udevil runit udev
   ```

**Pros:**
- ✅ Great for Apple Silicon
- ✅ GUI interface
- ✅ Full VM control
- ✅ Can save snapshots

**Cons:**
- ❌ Requires downloading ISO
- ❌ More setup steps

---

## 🔧 Option 3: Docker (Quick Syntax Checks ONLY)

**WARNING:** Not suitable for full device testing, but OK for syntax checks

### Install Docker

```bash
# Install via Homebrew
brew install --cask docker
```

Open Docker Desktop and wait for it to start.

### Run Ubuntu Container

```bash
# Run Ubuntu container with interactive shell
docker run -it --name task46-test ubuntu:22.04 /bin/bash

# Inside container, install packages
apt-get update
apt-get install -y udevil runit udev man-db

# Exit container
exit

# Restart container later
docker start -i task46-test

# Remove container when done
docker rm task46-test
```

**Pros:**
- ✅ Very fast startup
- ✅ Lightweight
- ✅ Good for command/syntax testing

**Cons:**
- ❌ **Cannot test real device mounting**
- ❌ **Cannot test hotplug events**
- ❌ Limited /dev access
- ❌ Not suitable for full verification

---

## 🖥️ Option 4: VirtualBox (Traditional VM)

**Best for:** Intel Macs, full VM control

### Install VirtualBox

```bash
# Install via Homebrew
brew install --cask virtualbox
```

### Download Ubuntu ISO

```bash
# Download Ubuntu Desktop (easier with GUI)
# Or use: https://ubuntu.com/download/desktop
```

### Create VM

1. Open VirtualBox
2. Click "New"
3. Name: task46-test
4. Type: Linux
5. Version: Ubuntu (64-bit)
6. Memory: 2048 MB
7. Create virtual hard disk: 10 GB
8. Start VM and select Ubuntu ISO
9. Follow installation prompts

**Pros:**
- ✅ Full VM control
- ✅ Good documentation
- ✅ Snapshots supported

**Cons:**
- ❌ Slower on Apple Silicon
- ❌ Requires more setup
- ❌ Heavier resource usage

---

## 📊 Quick Comparison

| Option | Setup Time | Best For | Device Testing | Apple Silicon |
|--------|------------|----------|----------------|---------------|
| **Multipass** | 1 min | Quick tests | ✅ Yes | ✅ Yes |
| **UTM** | 15 min | Full control | ✅ Yes | ✅✅ Best |
| **Docker** | 2 min | Syntax only | ❌ No | ✅ Yes |
| **VirtualBox** | 20 min | Intel Macs | ✅ Yes | ⚠️ Slow |

---

## 🎯 Recommended Workflow for Task 46

### Step 1: Install Multipass (Fastest)

```bash
brew install multipass
multipass launch --name task46-test --cpus 2 --memory 2G
multipass shell task46-test
```

### Step 2: Setup Test Environment

```bash
# Inside the VM
sudo apt-get update
sudo apt-get install -y udevil runit udev man-db

# Verify installations
which udevil
which sv
which udevadm
```

### Step 3: Transfer Test Scripts

```bash
# From your Mac (in another terminal)
# Create the test script
cat > /tmp/test_r1_claims.sh << 'EOF'
#!/bin/bash
echo "=== Task 46 R1 Testing ==="

echo "TEST 1: Is udev kernel-level?"
man udev | grep -A5 "DESCRIPTION"

echo "TEST 2: udevadm commands"
udevadm --help 2>&1 | head -30

echo "TEST 3: udevil -a flag (should FAIL)"
udevil -a /mnt/test 2>&1 || echo "FAILED AS EXPECTED"

echo "TEST 3b: udevil correct syntax"
udevil --help | head -30

echo "TEST 4: udevil permissions"
ls -l /usr/bin/udevil 2>&1
cat /etc/udevil/udevil.conf 2>&1 | grep -A5 "allowed_users" || echo "Config not found"

echo "TEST 5: runit service location"
ls -la /etc/sv/ 2>&1 | head -10

echo "TEST 6: devtmpfs"
mount | grep devtmpfs
EOF

# Transfer to VM
multipass transfer /tmp/test_r1_claims.sh task46-test:/tmp/

# Inside VM, make executable and run
chmod +x /tmp/test_r1_claims.sh
/tmp/test_r1_claims.sh
```

### Step 4: Run Tests

```bash
# Inside the VM
sudo /tmp/test_r1_claims.sh > /tmp/test_results.txt 2>&1

# View results
cat /tmp/test_results.txt
```

### Step 5: Get Results Back to Mac

```bash
# From your Mac terminal
multipass transfer task46-test:/tmp/test_results.txt ~/Desktop/
```

### Step 6: Cleanup When Done

```bash
# From your Mac
multipass stop task46-test
multipass delete task46-test
multipass purge
```

---

## 🆘 Troubleshooting

### Multipass won't start VM

```bash
# Check status
multipass list

# View logs
multipass logs task46-test

# Restart multipass daemon
sudo multipass restart
```

### Can't install packages in VM

```bash
# Inside VM
sudo apt-get update
sudo apt-get upgrade

# If still failing, check network
ping google.com
```

### Docker container can't install udevil

```bash
# udevil might not be in default Ubuntu repos
# Add universe repository
apt-get install -y software-properties-common
add-apt-repository universe
apt-get update
apt-get install -y udevil
```

---

## ✅ Ready to Test?

Once you have Multipass or UTM running, you can:

1. **Run the test script** I provided in TEST_ENVIRONMENT_SETUP.md
2. **Document the results** using the format specified
3. **Create AOIs** based on concrete test evidence

**Next step:** Run this command to get started:

```bash
brew install multipass && multipass launch --name task46-test
```

Then let me know when you're ready to run the tests!
