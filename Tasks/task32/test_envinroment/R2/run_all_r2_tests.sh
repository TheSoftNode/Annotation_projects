#!/usr/bin/env bash
set -u

COMPILER="${1:-g++}"

COMPILE_ONLY_FILES=(
  "02_r2_fixed_base.cpp"
  "03_r2_base_safe.cpp"
  "04_r2_pure_virtual_dtor.cpp"
  "05_r2_nonpoly.cpp"
)

RUNTIME_FILES=(
  "01_r2_bad_delete.cpp"
  "06_r2_supplement_destructor_order.cpp"
  "07_r2_supplement_rule_of_five.cpp"
  "08_r2_supplement_abstract_not_needing_pure_dtor.cpp"
  "09_r2_supplement_polymorphism_without_virtual_dtor.cpp"
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
