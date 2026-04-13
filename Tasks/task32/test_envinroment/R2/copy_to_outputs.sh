#!/usr/bin/env bash
set -u

# Create outputs directory if it doesn't exist
mkdir -p ../../../outputs/R2

# Copy the merged report to outputs
if [ -f "all_r2_reports.txt" ]; then
  cp all_r2_reports.txt ../../../outputs/R2/
  echo "Copied all_r2_reports.txt to outputs/R2/"
else
  echo "all_r2_reports.txt not found. Run merge_reports.sh first."
  exit 1
fi

# Copy the test matrix
if [ -f "R2_TEST_MATRIX.txt" ]; then
  cp R2_TEST_MATRIX.txt ../../../outputs/R2/
  echo "Copied R2_TEST_MATRIX.txt to outputs/R2/"
fi

echo "Done!"
