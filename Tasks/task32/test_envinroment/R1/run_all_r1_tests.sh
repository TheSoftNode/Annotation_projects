#!/usr/bin/env bash
set -u

COMPILER="${1:-g++}"

COMPILE_ONLY_FILES=(
  "01_r1_verbatim_correct_example.cpp"
  "02_r1_verbatim_avoid_example.cpp"
  "03_r1_verbatim_replacement_line.cpp"
  "04_r1_verbatim_final_example.cpp"
  "08_r1_supplement_protected_nonvirtual_delete.cpp"
)

RUNTIME_FILES=(
  "05_r1_supplement_virtual_delete_order.cpp"
  "06_r1_supplement_nonvirtual_delete_ub.cpp"
  "07_r1_supplement_size_compare.cpp"
  "09_r1_supplement_slicing_still_happens.cpp"
)

for f in "${COMPILE_ONLY_FILES[@]}"; do
  if [ -f "$f" ]; then
    echo "Running compile-only test for $f ..."
    ./run_compile_only_test.sh "$f" "$COMPILER"
    echo
  else
    echo "Skipping missing file: $f"
    echo
  fi
done

for f in "${RUNTIME_FILES[@]}"; do
  if [ -f "$f" ]; then
    echo "Running runtime test for $f ..."
    ./run_runtime_test.sh "$f" "$COMPILER"
    echo
  else
    echo "Skipping missing file: $f"
    echo
  fi
done
