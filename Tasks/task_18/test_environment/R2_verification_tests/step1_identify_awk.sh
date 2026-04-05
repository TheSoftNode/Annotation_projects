#!/bin/bash

echo "=== R2 Step 1: Identify your awk ==="
echo ""

echo "Command path:"
command -v awk

echo ""
echo "AWK version:"
awk --version 2>&1 || awk -W version 2>&1 || awk -V 2>&1

echo ""
echo "gawk available:"
command -v gawk || echo "not found"
