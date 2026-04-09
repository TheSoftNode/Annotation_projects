#!/usr/bin/env python3
"""
Test R1 Claim 8: SVMs use LIBSVM/LIBLINEAR (not L-BFGS-B)

Checks documentation strings for mentions of libsvm and liblinear
"""

from sklearn.svm import SVC, LinearSVC

print("=" * 60)
print("R1 Claim 8: SVMs use LIBSVM/LIBLINEAR")
print("=" * 60)
print()

print("Test 1: SVC mentions libsvm")
print("-" * 60)
svc_has_libsvm = "libsvm" in SVC.__doc__.lower()
print(f"'libsvm' in SVC docstring: {svc_has_libsvm}")

print()
print("Test 2: LinearSVC mentions liblinear")
print("-" * 60)
linear_has_liblinear = "liblinear" in LinearSVC.__doc__.lower()
print(f"'liblinear' in LinearSVC docstring: {linear_has_liblinear}")

print()
if svc_has_libsvm and linear_has_liblinear:
    print("✓ Both SVC and LinearSVC mention their respective libraries")
    print("  VERDICT: Claim SUPPORTED")
else:
    print("✗ One or both libraries not mentioned in docstrings")
    print("  VERDICT: Partially disputed")

print()
print("=" * 60)
