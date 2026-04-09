#!/usr/bin/env python3
"""
Test R1 Claim 2: sklearn does NOT include built-in MKL implementations

Tests whether SVC supports kernel='mkl' (it shouldn't)
"""

from sklearn.svm import SVC

print("=" * 60)
print("R1 Claim 2: MKL not in core sklearn")
print("=" * 60)
print()

print("Test 1: Attempting to use kernel='mkl' with SVC")
print("-" * 60)

X = [[0,0],[1,1]]
y = [0,1]

try:
    SVC(kernel='mkl').fit(X, y)
    print("✗ UNEXPECTED: kernel='mkl' was accepted")
    print("  VERDICT: Claim DISPUTED")
except ValueError as e:
    print(f"✓ kernel='mkl' rejected with ValueError: {e}")
    print("  VERDICT: Claim SUPPORTED")
except Exception as e:
    print(f"? Got unexpected error type: {type(e).__name__}: {e}")

print()
print("=" * 60)
