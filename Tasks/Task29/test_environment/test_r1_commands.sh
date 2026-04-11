#!/bin/bash
# Test commands from RESPONSE 1

echo "===== Testing R1 Commands ====="

echo ""
echo "Command 1: grep --version"
grep --version

echo ""
echo "Command 2: Clone GNU grep repo (dry-run)"
echo "git clone https://git.savannah.gnu.org/git/grep.git"
echo "(Not actually cloning, just showing command)"

echo ""
echo "Command 3: dpkg -L grep | grep -E '\\.(c|h|cc|cpp)$' | head"
if command -v dpkg &> /dev/null; then
    dpkg -L grep 2>/dev/null | grep -E '\.(c|h|cc|cpp)$' | head || echo "grep package not found via dpkg"
else
    echo "dpkg not available on this system"
fi

echo ""
echo "Command 4: rpm -ql grep | grep -E '\\.(c|h|cc|cpp)$' | head"
if command -v rpm &> /dev/null; then
    rpm -ql grep 2>/dev/null | grep -E '\.(c|h|cc|cpp)$' | head || echo "grep package not found via rpm"
else
    echo "rpm not available on this system"
fi

echo ""
echo "===== R1 Commands Test Complete ====="
