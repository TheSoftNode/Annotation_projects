#!/usr/bin/env python3
"""
Test R1 Claim 3: scikit-learn-contrib/mkl exists

Tests whether the GitHub URL provided in the response actually exists
"""

import subprocess

print("=" * 60)
print("R1 Claim 3: scikit-learn-contrib/mkl repo check")
print("=" * 60)
print()

url = "https://github.com/scikit-learn-contrib/mkl"

print(f"Testing URL: {url}")
print("-" * 60)

result = subprocess.run(
    ["curl", "-I", "-s", url],
    capture_output=True,
    text=True
)

if "404" in result.stdout or "Not Found" in result.stdout:
    print("✗ HTTP 404 - Repository NOT FOUND")
    print("  VERDICT: R1's claim about this specific repo is DISPUTED")
    print("           The cited GitHub URL returns 404")
elif "200" in result.stdout:
    print("✓ HTTP 200 - Repository exists")
    print("  VERDICT: Claim SUPPORTED")
else:
    print(f"? Got response: {result.stdout[:200]}")

print()
print("=" * 60)
