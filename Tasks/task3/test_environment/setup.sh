#!/bin/bash

echo "=========================================="
echo "Task 3 Test Environment Setup"
echo "=========================================="
echo ""

# Make test scripts executable
echo "Making test scripts executable..."
chmod +x test_response1_code.sh
chmod +x test_response2_code.sh
chmod +x run_all_tests.sh 2>/dev/null || true
echo "✓ Scripts are now executable"
echo ""

# Check for required tools
echo "Checking for required tools..."
echo ""

# Check for git
if command -v git &> /dev/null; then
    echo "✓ git is installed ($(git --version))"
else
    echo "✗ git is NOT installed"
    echo "  Install with: brew install git"
    exit 1
fi

# Check for gcc
if command -v gcc &> /dev/null; then
    echo "✓ gcc is installed ($(gcc --version | head -1))"
else
    echo "✗ gcc is NOT installed"
    echo "  Install Xcode Command Line Tools: xcode-select --install"
    exit 1
fi

# Check for pkg-config
if command -v pkg-config &> /dev/null; then
    echo "✓ pkg-config is installed"
else
    echo "✗ pkg-config is NOT installed"
    echo "  Install with: brew install pkg-config"
    exit 1
fi

echo ""
echo "Checking for GTK libraries..."

# Check for GTK 2.0 (optional but helpful)
if pkg-config --exists gtk+-2.0; then
    GTK2_VERSION=$(pkg-config --modversion gtk+-2.0)
    echo "✓ GTK+ 2.0 is installed (version $GTK2_VERSION)"
    echo "  This allows full compilation testing"
else
    echo "⚠ GTK+ 2.0 is NOT installed"
    echo "  Tests will still verify API compatibility via source inspection"
    echo "  To install GTK+ 2.0: brew install gtk+"
fi

# Check for GTK 4.0 (optional)
if pkg-config --exists gtk4; then
    GTK4_VERSION=$(pkg-config --modversion gtk4)
    echo "✓ GTK 4 is installed (version $GTK4_VERSION)"
    echo "  This helps demonstrate Response 2's API incompatibility"
else
    echo "⚠ GTK 4 is NOT installed"
    echo "  Tests will still verify via API inspection"
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "You can now run the tests:"
echo ""
echo "  ./run_all_tests.sh           # Run all tests"
echo "  ./test_response1_code.sh     # Test Response 1 only"
echo "  ./test_response2_code.sh     # Test Response 2 only"
echo ""
echo "What the tests verify:"
echo "  ✓ Response 1 uses gtkmm C++ (incompatible with xtor's C)"
echo "  ✓ Response 2 uses GTK 4 API (incompatible with xtor's GTK 2.16)"
echo "  ✓ Both issues are Substantial (code unusable)"
echo ""
