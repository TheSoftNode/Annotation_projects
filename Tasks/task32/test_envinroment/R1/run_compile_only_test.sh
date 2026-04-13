#!/usr/bin/env bash
set -u

if [ $# -lt 1 ]; then
  echo "Usage: ./run_compile_only_test.sh path/to/file.cpp [compiler]"
  exit 1
fi

SRC="$1"
COMPILER="${2:-g++}"

if [ ! -f "$SRC" ]; then
  echo "Source file not found: $SRC"
  exit 1
fi

BASENAME="$(basename "$SRC" .cpp)"
OUTDIR="test_reports"
OBJDIR="test_objs"
mkdir -p "$OUTDIR" "$OBJDIR"

OBJFILE="$OBJDIR/${BASENAME}.o"
REPORT_FILE="$OUTDIR/${BASENAME}_report.txt"

COMPILE_CMD="$COMPILER -std=c++20 -Wall -Wextra -Wdelete-non-virtual-dtor -Wnon-virtual-dtor -pedantic -c \"$SRC\" -o \"$OBJFILE\""

TMP_COMPILE="$(mktemp)"
compile_ok=0

bash -lc "$COMPILE_CMD" >"$TMP_COMPILE" 2>&1
compile_status=$?
if [ $compile_status -eq 0 ]; then
  compile_ok=1
fi

if [ $compile_ok -eq 1 ]; then
  if [ -s "$TMP_COMPILE" ]; then
    OBSERVATION="Compilation succeeded, but the compiler emitted warnings or notes."
  else
    OBSERVATION="Compilation succeeded with no compiler diagnostics."
  fi
else
  OBSERVATION="Compilation failed. Check the compiler output for the exact error."
fi

{
  echo "FILE:"
  echo "$SRC"
  echo
  echo "Compile command:"
  echo "$COMPILE_CMD"
  echo
  echo "Compiler output:"
  cat "$TMP_COMPILE"
  echo
  echo "Run command:"
  echo "Skipped because this is a compile-only test."
  echo
  echo "Run output:"
  echo "Skipped because this is a compile-only test."
  echo
  echo "Sanitizer command:"
  echo "Skipped because this is a compile-only test."
  echo
  echo "Sanitizer output:"
  echo "Skipped because this is a compile-only test."
  echo
  echo "Observation:"
  echo "$OBSERVATION"
} >"$REPORT_FILE"

rm -f "$TMP_COMPILE"

echo "Report written to: $REPORT_FILE"
