# Response 1 - Complete Verification Report

## Response 1 Text (Verbatim)

**RESPONSE 1:**

Here's a **step-by-step guide to manually install PyHackRF without using `pip`**, covering Linux/macOS (Windows is significantly more complex and not recommended for manual installation). **Critical prerequisite: You MUST install the HackRF driver/libraries first**, as PyHackRF is just a Python wrapper that depends on them.
---

### **⚠️ Important Notes Before Starting**

1. **HackRF driver/libraries are required** – PyHackRF **will not work** without `libhackrf` installed system-wide.
2. **OS Focus**: This guide assumes **Linux (Ubuntu/Debian)** or **macOS**. Manual installation on Windows is error-prone (requires MSYS2/Visual Studio) – consider using [prebuilt binaries](https://github.com/mossmann/hackrf/releases) instead.
3. **Root Access**: Some steps require `sudo`.
4. **Verify Hardware**: Ensure your HackRF One is connected and detected by `hackrf_info` *before* installing PyHackRF.

---

### **🔧 Step 1: Install System Dependencies**

#### **Ubuntu/Debian**

sudo apt update
sudo apt install \-y build-essential pkg-config libusb-1.0-0-dev python3-dev git

#### **macOS (using Homebrew)**

brew install pkg-config libusb python3 git
\# Xcode Command Line Tools must be installed: xcode-select \--install

💡 **Why these?**

* `build-essential`/`Xcode`: Compilation tools
* `pkg-config`: Helps find libraries
* `libusb-1.0-0-dev`/`libusb`: Required for HackRF
* `python3-dev`: Python headers for building extensions
* `git`: To clone repositories

---

### **📦 Step 2: Build & Install HackRF Driver (MOST CRITICAL STEP)**

PyHackRF **depends on `libhackrf`**. If this isn't installed, PyHackRF will fail to build/run.

#### **Clone & Build HackRF from Source**

git clone https://github.com/mossmann/hackrf.git
cd hackrf/host

\# Prepare build
./bootstrap
./configure

\# Compile & install
make
sudo make install  \# Installs libhackrf.so to /usr/local/lib

\# Update library cache (Linux ONLY)
sudo ldconfig

#### **Verify HackRF Installation**

hackrf\_info  \# Should show device details (e.g., "Found HackRF board...")

✅ **Success**: If `hackrf_info` works, `libhackrf` is properly installed.
❌ **Failure**: If you get `error: No devices found`, check USB permissions or reinstall HackRF.

---

### **🐍 Step 3: Manually Install PyHackRF**

#### **Clone PyHackRF Repository**

git clone https://github.com/mossmann/pyhackrf.git
cd pyhackrf

#### **Build & Install (NO PIP\!)**

\# Use system Python (ensure it's Python 3\)
python3 setup.py build
sudo python3 setup.py install

#### **Key Details**

* `setup.py build` compiles the Cython extension (`_hackrf.so`).
* `setup.py install` copies files to Python's `site-packages`.
* **No `pip` involved** – uses pure `setuptools` (bundled with Python).

---

### **✅ Step 4: Verify Installation**

python3 \-c "import pyhackrf; print(pyhackrf.\_\_version\_\_)"

**Expected Output**:
`0.6` (or similar version number)

#### **Test Basic Functionality**

python3 \-c "
import pyhackrf
sdr \= pyhackrf.HackRF()
print('Device opened:', sdr.board\_id)
sdr.close()
"

✅ **Success**: No errors, prints board ID (e.g., `Device opened: 0`).
❌ **Failure**:

* `ImportError: libhackrf.so.0`: HackRF not installed/library path issue → Run `sudo ldconfig` again.
* `OSError: [Errno 2] No such file or directory`: HackRF not detected → Check USB connection/permissions.

---

### **🛠️ Troubleshooting Tips**

| Issue | Solution |
| ----- | ----- |
| `ImportError: libhackrf.so.0` | Run `sudo ldconfig` (Linux) or check `DYLD_LIBRARY_PATH` (macOS). |
| `hackrf_info: No devices found` | Add user to `plugdev` group: `sudo usermod -aG plugdev $USER` → **REBOOT**. |
| Compilation errors in PyHackRF | Ensure `python3-dev` is installed. Clean build: `rm -rf build/ && python3 setup.py build`. |
| macOS: `Library not loaded` | Set `export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/lib:$DYLD_FALLBACK_LIBRARY_PATH` |

---

### **🌐 OS-Specific Notes**

#### **macOS**

After `make install`, you may need to symlink libraries:
ln \-s /usr/local/lib/libhackrf.0.dylib /usr/local/lib/libhackrf.dylib

*
* If using Python from Homebrew, ensure `brew link python` is run.

#### **Windows (Not Recommended for Manual Install)**

1. Install [MSYS2](https://www.msys2.org/).

In MSYS2 terminal:
pacman \-S mingw-w64-x86\_64-toolchain mingw-w64-x86\_64-libusb git
git clone https://github.com/mossmann/hackrf.git
cd hackrf/host
./bootstrap
./configure \--host=x86\_64-w64-mingw32
make
make install

2.
3. Repeat for PyHackRF using MSYS2 Python.

⚠️ **Strongly advise against this** – use [prebuilt PyHackRF wheels](https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyhackrf) instead.

---

### **📌 Why This Works**

* PyHackRF's `setup.py` **dynamically links** to `libhackrf` at compile time. By installing HackRF first, you provide the necessary headers (`hackrf.h`) and libraries (`libhackrf.so`/`.dylib`).
* Manual `setup.py install` bypasses PyPI entirely, using your locally built HackRF.

---

### **💡 Pro Tip**

If you plan to use this regularly, create a **virtual environment** to avoid system Python conflicts:

python3 \-m venv hf\_env
source hf\_env/bin/activate
cd pyhackrf
python setup.py install  \# No sudo needed\!

Let me know if you hit specific errors – I'll help debug\! 🛠️

---

## VERIFICATION CHECKLIST

### URLs and Links

1. **GitHub - HackRF Releases**: `https://github.com/mossmann/hackrf/releases`
2. **GitHub - HackRF Repository**: `https://github.com/mossmann/hackrf.git`
3. **GitHub - PyHackRF Repository**: `https://github.com/mossmann/pyhackrf.git`
4. **MSYS2 Website**: `https://www.msys2.org/`
5. **Prebuilt PyHackRF Wheels**: `https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyhackrf`

### Build Commands

1. `./bootstrap`
2. `./configure`
3. `make`
4. `sudo make install`

### Package Names

1. Ubuntu/Debian: `build-essential`, `pkg-config`, `libusb-1.0-0-dev`, `python3-dev`, `git`
2. macOS (Homebrew): `pkg-config`, `libusb`, `python3`, `git`

### Python Commands

1. `python3 setup.py build`
2. `sudo python3 setup.py install`
3. `python3 -c "import pyhackrf; print(pyhackrf.__version__)"`

### File Paths

1. Library installation path: `/usr/local/lib`
2. Library name: `libhackrf.so` (Linux) or `libhackrf.dylib` (macOS)

---

## DETAILED VERIFICATION (To be completed)

*Starting verification of each claim...*
