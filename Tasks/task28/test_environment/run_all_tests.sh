#!/bin/bash
# Master test runner for Task 28

echo "=========================================="
echo "Task 28: Comprehensive Test Suite"
echo "systemd-cat vs Shared Log File"
echo "=========================================="
echo ""

# Check environment
if ! command -v systemd-cat &> /dev/null; then
    echo "ERROR: systemd-cat not found. Run on Linux with systemd."
    exit 1
fi

echo "Environment:"
echo "  $(uname -s) $(uname -r)"
echo "  systemd: $(systemctl --version | head -1)"
echo "  User: $USER (UID: $(id -u))"
echo ""

# Create output directories
mkdir -p outputs/{R1,R2}

# Make all scripts executable
chmod +x R1/*.sh R2/*.sh test_shared_*.sh 2>/dev/null

# ==========================================
# R1 Tests
# ==========================================
echo "=========================================="
echo "RESPONSE 1 Tests"
echo "=========================================="
echo ""

for script in R1/test_*.sh; do
    if [ -f "$script" ]; then
        NAME=$(basename "$script" .sh)
        echo "Running: $NAME"
        bash "$script" 2>&1 | tee "outputs/R1/${NAME}_output.txt"
        echo ""
    fi
done

# ==========================================
# R2 Tests
# ==========================================
echo "=========================================="
echo "RESPONSE 2 Tests"
echo "=========================================="
echo ""

for script in R2/test_*.sh; do
    if [ -f "$script" ]; then
        NAME=$(basename "$script" .sh)
        echo "Running: $NAME"
        bash "$script" 2>&1 | tee "outputs/R2/${NAME}_output.txt"
        echo ""
    fi
done

# ==========================================
# Shared Tests
# ==========================================
echo "=========================================="
echo "SHARED Tests (Both Responses)"
echo "=========================================="
echo ""

for script in test_shared_*.sh; do
    if [ -f "$script" ]; then
        NAME=$(basename "$script" .sh)
        echo "Running: $NAME"
        bash "$script" 2>&1 | tee "outputs/${NAME}_output.txt"
        echo ""
    fi
done

# ==========================================
# Summary
# ==========================================
echo "=========================================="
echo "Test Suite Complete"
echo "=========================================="
echo ""
echo "Output files:"
ls -lh outputs/**/*.txt outputs/*.txt 2>/dev/null | awk '{print "  "$9" ("$5")"}'
echo ""
echo "Review outputs for ✓ (pass) and ✗ (fail) markers"
echo ""
