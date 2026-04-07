#!/bin/bash
# Run all R1 tests in sequence

echo "=========================================="
echo "R1 COMPLETE TEST SUITE"
echo "=========================================="
echo ""

./test1_verify_tools.sh
echo ""
echo "=========================================="
echo ""

./test2_baseline_ground_truth.sh
echo ""
echo "=========================================="
echo ""

./test3_main_command_running_only.sh
echo ""
echo "=========================================="
echo ""

./test4_docker_ps_vs_docker_ps_a.sh
echo ""
echo "=========================================="
echo ""

./test5_table_format_verification.sh
echo ""
echo "=========================================="
echo ""

./test6_image_vs_config_image.sh
echo ""
echo "=========================================="
echo ""

./test7_variation_include_stopped.sh
echo ""
echo "=========================================="
echo ""

./test8_variation_ids_only.sh
echo ""
echo "=========================================="
echo ""

./test9_variation_awk_tag_only.sh
echo ""
echo "=========================================="
echo ""

echo "ALL TESTS COMPLETED"
