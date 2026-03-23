# Golden Annotation - Task 5: Manually Installing PyHackRF Without Pip

## Task Flagging

**Selected Flags:**
- ✅ Task requires expert computer science knowledge

**Rationale:** The task involves manual software installation from source, understanding build systems (CMake vs autotools), managing system dependencies, library linking, and troubleshooting compilation issues, requiring expert-level computer science and systems programming knowledge.

---

## Conversation History
N/A

## System Prompt
No system prompt for this task

## Prompt

manually installing pyhackrf without using pip

---

# Response 1 Annotation

## Verification of Quality

**Tool Type:** Repository URL Checker

**Query:**
```bash
curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/mossmann/pyhackrf"
```

**URL:**

**Source Excerpt:**
```
HTTP 404 - Repository Not Found
```

## Strengths

The response provides comprehensive OS coverage including Linux, macOS, and Windows with specific instructions for each platform.

The response emphasizes the critical prerequisite of installing HackRF driver/libraries first, correctly identifying that PyHackRF is a Python wrapper dependent on libhackrf.

The response includes a detailed troubleshooting table with common errors and their solutions, covering ImportError, device detection issues, and compilation problems.

The response provides macOS-specific notes about library symlinking and environment variables (DYLD_FALLBACK_LIBRARY_PATH), addressing platform-specific challenges.

The response includes device permission instructions for Linux (plugdev group) with proper commands for adding users and refreshing group membership.

The response suggests using virtual environments to avoid system Python conflicts, demonstrating awareness of Python best practices.

The response provides verification commands to test both basic import and device functionality, ensuring users can confirm successful installation.

## Areas of Improvement

**[AOI #1 - Substantial]**

**Response Excerpt:**
```bash
git clone https://github.com/mossmann/pyhackrf.git
cd pyhackrf
```

**Description:** The response provides a non-existent repository URL for PyHackRF, causing the installation to fail at the clone step in Step 3, making it impossible to proceed with the manual installation.

**Severity:** Substantial

**Verification of Issue:**

**Tool Type:** Repository URL Checker

**Query:**
```bash
curl -s "https://api.github.com/repos/mossmann/pyhackrf"
```

**URL:**

**Source Excerpt:**
```json
{
  "message": "Not Found",
  "documentation_url": "https://docs.github.com/rest/repos/repos#get-a-repository"
}
```

**Correct Information:**
The correct PyHackRF repository is `https://github.com/dressel/pyhackrf`, as documented in the PyPI package description (https://pypi.org/project/pyhackrf/), which states "based on [this](https://github.com/dressel/pyhackrf)".

---

**[AOI #2 - Substantial]**

**Response Excerpt:**
```bash
cd hackrf/host

# Prepare build
./bootstrap
./configure

# Compile & install
make
sudo make install
```

**Description:** The response uses incorrect build commands for HackRF, specifying autotools-based commands (./bootstrap, ./configure) when HackRF actually uses CMake as its build system, causing the build to fail because these scripts don't exist in the HackRF repository.

**Severity:** Substantial

**Verification of Issue:**

**Tool Type:** Documentation Reference

**Query:**
Check official HackRF build documentation at https://hackrf.readthedocs.io/en/latest/installing_hackrf_software.html

**URL:** https://hackrf.readthedocs.io/en/latest/installing_hackrf_software.html

**Source Excerpt:**
```
Building on Linux

cd hackrf/host
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig
```

**Correct Information:**
HackRF uses CMake, not autotools. The correct build sequence is: `mkdir build && cd build && cmake .. && make && sudo make install`

---

**[AOI #3 - Minor]**

**Response Excerpt:**
```
use prebuilt PyHackRF wheels (https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyhackrf)
```

**Description:** The response references a URL for prebuilt PyHackRF wheels that returns HTTP 404, providing users with a broken link for an alternative Windows installation method.

**Severity:** Minor

**Verification of Issue:**

**Tool Type:** URL Checker

**Query:**
```bash
curl -s -o /dev/null -w "%{http_code}" "https://www.lfd.uci.edu/~gohlke/pythonlibs/"
```

**URL:**

**Source Excerpt:**
```
HTTP 404 - Not Found
```

---

**[AOI #4 - Minor]**

**Response Excerpt:**
```python
python3 -c "import pyhackrf; print(pyhackrf.__version__)"
```

**Expected Output:**
`0.6` (or similar version number)

**Description:** The response claims the expected PyHackRF version is 0.6, but the current version available on PyPI is 0.2.0, creating confusion about what version users should expect to see.

**Severity:** Minor

**Verification of Issue:**

**Tool Type:** PyPI Package Checker

**Query:**
```bash
curl -s "https://pypi.org/pypi/pyhackrf/json" | python3 -c "import sys, json; print(json.load(sys.stdin)['info']['version'])"
```

**URL:**

**Source Excerpt:**
```
0.2.0
```

---

## Overall Quality Score: 2

**Justification:**

The response contains two substantial errors that make it impossible to follow successfully. The PyHackRF repository URL is completely wrong (returns 404), and the HackRF build commands use the wrong build system (autotools instead of CMake). While the response demonstrates comprehensive knowledge of installation workflows with detailed troubleshooting and multi-OS coverage, these critical factual errors prevent users from completing the installation. The broken prebuilt wheels URL and version mismatch are minor issues but add to the overall inaccuracy.

---

# Response 2 Annotation

## Verification of Quality

**Tool Type:** Repository URL Checker

**Query:**
```bash
curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/atech/pyhackrf"
```

**URL:**

**Source Excerpt:**
```
HTTP 404 - Repository Not Found
```

## Strengths

The response uses a simpler package manager approach for installing libhackrf rather than building from source, making the installation process more straightforward and less error-prone for users.

The response provides multi-distribution support with specific package installation commands for Ubuntu/Debian, Fedora, and Arch Linux, accommodating users across different Linux distributions.

The response includes proper verification steps with hackrf_info to check device detection before testing the Python package, following a logical troubleshooting sequence.

The response correctly identifies libhackrf-dev as the development headers package and explains why build-essential is needed despite pyhackrf being pure Python, showing understanding of the dependency chain.

The response provides device permissions configuration with plugdev group instructions and the newgrp command to refresh group membership without requiring a reboot.

The response includes troubleshooting for common errors like ImportError: libhackrf.so.0 with the correct solution (sudo ldconfig), demonstrating awareness of typical installation issues.

## Areas of Improvement

**[AOI #1 - Substantial]**

**Response Excerpt:**
```bash
git clone https://github.com/atech/pyhackrf.git
cd pyhackrf
```

**Description:** The response provides a non-existent repository URL for PyHackRF, causing the installation to fail immediately at the clone step in Step 2, making it impossible to proceed with the manual installation.

**Severity:** Substantial

**Verification of Issue:**

**Tool Type:** Repository URL Checker

**Query:**
```bash
curl -s "https://api.github.com/repos/atech/pyhackrf"
```

**URL:**

**Source Excerpt:**
```json
{
  "message": "Not Found",
  "documentation_url": "https://docs.github.com/rest/repos/repos#get-a-repository"
}
```

**Correct Information:**
The correct PyHackRF repository is `https://github.com/dressel/pyhackrf`, as documented in the PyPI package description (https://pypi.org/project/pyhackrf/).

---

**[AOI #2 - Minor]**

**Response Excerpt:**
```
[pyhackrf GitHub Repository](https://github.com/atech/pyhackrf)
[pyhackrf issues page](https://github.com/atech/pyhackrf/issues)
```

**Description:** The response provides broken links in the Official Resources section, with both the repository and issues page URLs pointing to the non-existent atech/pyhackrf repository, leaving users without valid reference links.

**Severity:** Minor

**Verification of Issue:**

**Tool Type:** URL Checker

**Query:**
```bash
curl -s -o /dev/null -w "%{http_code}" "https://github.com/atech/pyhackrf"
curl -s -o /dev/null -w "%{http_code}" "https://github.com/atech/pyhackrf/issues"
```

**URL:**

**Source Excerpt:**
```
HTTP 404 - Not Found
HTTP 404 - Not Found
```

---

**[AOI #3 - Minor]**

**Response Excerpt:**
```python
print(pyhackrf.__version__)  # Should output a version (e.g., 0.1.0)
```

**Description:** The response claims the expected PyHackRF version is 0.1.0, but the current version available on PyPI is 0.2.0, potentially confusing users about whether their installation succeeded.

**Severity:** Minor

**Verification of Issue:**

**Tool Type:** PyPI Package Checker

**Query:**
```bash
curl -s "https://pypi.org/pypi/pyhackrf/json" | python3 -c "import sys, json; print(json.load(sys.stdin)['info']['version'])"
```

**URL:**

**Source Excerpt:**
```
0.2.0
```

---

## Overall Quality Score: 3

**Justification:**

The response contains one substantial error (wrong repository URL) that prevents successful installation, but the overall approach is more sound than Response 1. The package manager method for installing libhackrf is simpler and more reliable than building from source, and the multi-distribution support adds practical value. Once the repository URL is corrected, the remaining instructions would work correctly. The broken reference links and version mismatch are minor issues that don't prevent installation if users can find the correct repository independently.

---

# Preference Ranking

**Ranking:** Response 2 is better than Response 1

**Justification:**

R2 uses the simpler package manager approach for libhackrf and provides multi-distro instructions. While both have wrong PyHackRF repository URLs, R2 has fewer critical errors (1 vs 3). R1's autotools/CMake build system error and broken prebuilt wheels URL make it harder to salvage.

---

**Document Created:** 2026-03-23
**Annotator Notes:** Both responses were thoroughly verified with automated testing. Repository URLs were tested via GitHub API, package names verified on respective platforms, and build commands checked against official HackRF documentation. All verification scripts and detailed reports are available in the test_environment directory.
