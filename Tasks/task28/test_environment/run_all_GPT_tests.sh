#!/bin/bash
# Master test runner for all GPT Factual tests (Task 28)
# Runs R1 and R2 GPT tests sequentially

echo "==========================================================================="
echo "Task 28 - GPT Factual Tests - Master Test Runner"
echo "==========================================================================="
echo ""

# Pre-flight check
echo "Pre-flight check: Verifying systemd environment"
echo ""

echo "Checking for required commands..."
command -v bash systemd-cat journalctl logger

echo ""
echo "Checking if systemd is PID 1..."
INIT_PROC=$(ps -p 1 -o comm= 2>/dev/null || echo "unknown")
echo "PID 1 process: $INIT_PROC"

if [ "$INIT_PROC" != "systemd" ]; then
    echo ""
    echo "⚠ WARNING: PID 1 is NOT systemd"
    echo "   This environment may not be suitable for systemd-cat/journalctl tests"
    echo "   Consider using:"
    echo "     • GitHub Codespaces (with systemd)"
    echo "     • Azure Ubuntu VM"
    echo "     • WSL2 with systemd enabled"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✓ systemd is PID 1"
fi

echo ""
echo "Checking journalctl version..."
journalctl --version

echo ""
echo "==========================================================================="
echo ""

# R1 Tests
echo "========================================"
echo "Running R1 GPT Factual Tests (10 tests)"
echo "========================================"
echo ""

R1_TESTS=(
    "GPT_test_01_basic_systemd_cat.sh"
    "GPT_test_02_UID_filtering.sh"
    "GPT_test_03_unit_vs_user.sh"
    "GPT_test_04_flock_snippet.sh"
    "GPT_test_05_systemd_cat_flush.sh"
    "GPT_test_06_service_unit_verbatim.sh"
    "GPT_test_07_user_unit_loop.sh"
    "GPT_test_08_group_logger_script.sh"
    "GPT_test_09_template_unit.sh"
    "GPT_test_10_chmod_6640.sh"
)

for test in "${R1_TESTS[@]}"; do
    echo ""
    echo "Running R1/$test..."
    echo ""

    if [ -f "R1/$test" ]; then
        bash "R1/$test"
        TEST_EXIT=$?

        if [ $TEST_EXIT -ne 0 ]; then
            echo ""
            echo "⚠ Test exited with code $TEST_EXIT"
        fi
    else
        echo "✗ Test not found: R1/$test"
    fi

    echo ""
    echo "---"
    echo ""
done

echo ""
echo "==========================================================================="
echo ""

# R2 Tests
echo "========================================"
echo "Running R2 GPT Factual Tests (8 tests)"
echo "========================================"
echo ""

R2_TESTS=(
    "GPT_test_01_basic_systemd_cat.sh"
    "GPT_test_02_current_boot.sh"
    "GPT_test_03_logger_alternative.sh"
    "GPT_test_04_metadata_filtering.sh"
    "GPT_test_05_UID_filter.sh"
    "GPT_test_06_authorized_readers.sh"
    "GPT_test_07_atomic_concurrent.sh"
    "GPT_test_08_shared_file_risks.sh"
)

for test in "${R2_TESTS[@]}"; do
    echo ""
    echo "Running R2/$test..."
    echo ""

    if [ -f "R2/$test" ]; then
        bash "R2/$test"
        TEST_EXIT=$?

        if [ $TEST_EXIT -ne 0 ]; then
            echo ""
            echo "⚠ Test exited with code $TEST_EXIT"
        fi
    else
        echo "✗ Test not found: R2/$test"
    fi

    echo ""
    echo "---"
    echo ""
done

echo ""
echo "==========================================================================="
echo "All GPT Factual Tests Complete"
echo "==========================================================================="
echo ""
echo "Summary:"
echo "  • R1 tests: ${#R1_TESTS[@]} tests run"
echo "  • R2 tests: ${#R2_TESTS[@]} tests run"
echo "  • Total: $((${#R1_TESTS[@]} + ${#R2_TESTS[@]})) tests"
echo ""
echo "Review outputs above to verify claims"
echo ""
