#!/bin/bash

echo "=== R1 Step 1: Identify which awk we are testing ==="
echo ""
echo "Command path:"
command -v awk

echo ""
echo "AWK version:"
awk --version 2>&1 || awk -W version 2>&1 || awk -V 2>&1

echo ""
echo "Available implementations:"
echo -n "mawk: "
command -v mawk || echo "not found"
echo -n "busybox: "
command -v busybox || echo "not found"
echo -n "gawk: "
command -v gawk || echo "not found"
