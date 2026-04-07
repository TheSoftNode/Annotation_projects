#!/bin/bash
# Run all R2 tests in sequence

echo "=========================================="
echo "R2 COMPLETE TEST SUITE"
echo "=========================================="
echo ""

for i in {1..13}; do
    test_file="test${i}_*.sh"
    script=$(ls test${i}_*.sh 2>/dev/null | head -1)
    if [ -n "$script" ]; then
        echo "Running: $script"
        ./"$script"
        echo ""
        echo "=========================================="
        echo ""
    fi
done

echo "ALL R2 TESTS COMPLETED"
