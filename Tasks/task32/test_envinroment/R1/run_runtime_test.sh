#!/usr/bin/env bash
set -u

if [ $# -lt 1 ]; then
  echo "Usage: ./run_runtime_test.sh path/to/file.cpp [compiler]"
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
BINDIR="test_bins"
mkdir -p "$OUTDIR" "$BINDIR"

NORMAL_BIN="$BINDIR/${BASENAME}"
ASAN_BIN="$BINDIR/${BASENAME}_asan"
REPORT_FILE="$OUTDIR/${BASENAME}_report.txt"

COMPILE_CMD="$COMPILER -std=c++20 -Wall -Wextra -Wdelete-non-virtual-dtor -Wnon-virtual-dtor -pedantic -O0 \"$SRC\" -o \"$NORMAL_BIN\""
RUN_CMD="./$NORMAL_BIN"
SANITIZER_CMD="$COMPILER -std=c++20 -Wall -Wextra -Wdelete-non-virtual-dtor -Wnon-virtual-dtor -pedantic -O0 -fsanitize=address,undefined -fno-omit-frame-pointer -g \"$SRC\" -o \"$ASAN_BIN\""

TMP_COMPILE="$(mktemp)"
TMP_RUN="$(mktemp)"
TMP_SAN="$(mktemp)"

compile_ok=0
run_ok=0
san_compile_ok=0
san_issue=0

bash -lc "$COMPILE_CMD" >"$TMP_COMPILE" 2>&1
compile_status=$?
if [ $compile_status -eq 0 ]; then
  compile_ok=1
fi

if [ $compile_ok -eq 1 ]; then
  bash -lc "$RUN_CMD" >"$TMP_RUN" 2>&1
  run_status=$?
  if [ $run_status -eq 0 ]; then
    run_ok=1
  fi
else
  echo "Skipped because normal compilation failed." >"$TMP_RUN"
fi

bash -lc "$SANITIZER_CMD" >"$TMP_SAN" 2>&1
san_compile_status=$?
if [ $san_compile_status -eq 0 ]; then
  san_compile_ok=1
  {
    echo
    echo "----- SANITIZER RUN OUTPUT -----"
    bash -lc "./$ASAN_BIN"
    echo
    echo "----- SANITIZER EXIT CODE: $? -----"
  } >>"$TMP_SAN" 2>&1

  if grep -Eq "ERROR: AddressSanitizer|runtime error:|UndefinedBehaviorSanitizer|new-delete-type-mismatch" "$TMP_SAN"; then
    san_issue=1
  fi
else
  echo >>"$TMP_SAN"
  echo "Sanitizer compile failed, so sanitizer run was skipped." >>"$TMP_SAN"
fi

if [ $compile_ok -eq 0 ]; then
  OBSERVATION="Normal compilation failed. Check compiler output first."
elif [ $run_ok -eq 0 ]; then
  OBSERVATION="Normal compilation succeeded, but the program did not exit cleanly."
elif [ $san_compile_ok -eq 0 ]; then
  OBSERVATION="Normal compilation and run succeeded. Sanitizer build failed, so sanitizer behavior is not available."
elif [ $san_issue -eq 1 ]; then
  OBSERVATION="Normal compilation and run succeeded, but the sanitizer output shows a problem or undefined-behavior signal."
elif [ -s "$TMP_COMPILE" ]; then
  OBSERVATION="Compilation and execution succeeded, but the compiler emitted warnings or notes."
else
  OBSERVATION="Normal compilation, normal run, and sanitizer run all completed without reported errors."
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
  echo "$RUN_CMD"
  echo
  echo "Run output:"
  cat "$TMP_RUN"
  echo
  echo "Sanitizer command:"
  echo "$SANITIZER_CMD"
  echo
  echo "Sanitizer output:"
  cat "$TMP_SAN"
  echo
  echo "Observation:"
  echo "$OBSERVATION"
} >"$REPORT_FILE"

rm -f "$TMP_COMPILE" "$TMP_RUN" "$TMP_SAN"

echo "Report written to: $REPORT_FILE"
