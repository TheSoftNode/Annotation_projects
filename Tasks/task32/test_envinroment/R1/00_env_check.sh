#!/usr/bin/env bash
set -euo pipefail
echo "== OS =="
uname -a
echo
echo "== g++ =="
g++ --version || true
echo
echo "== clang++ =="
clang++ --version || true
echo
echo "== paths =="
which g++ || true
which clang++ || true
