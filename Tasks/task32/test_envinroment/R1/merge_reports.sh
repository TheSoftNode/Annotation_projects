#!/usr/bin/env bash
set -u

OUTFILE="all_r1_reports.txt"
: > "$OUTFILE"

if [ ! -d "test_reports" ]; then
  echo "test_reports directory not found."
  exit 1
fi

for f in test_reports/*_report.txt; do
  [ -e "$f" ] || continue
  {
    echo "=================================================="
    echo "$(basename "$f")"
    echo "=================================================="
    cat "$f"
    echo
  } >> "$OUTFILE"
done

echo "Merged report written to: $OUTFILE"
