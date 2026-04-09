#!/usr/bin/env python3
"""
Test R1 Claim 6: LogisticRegression supports solver='lbfgs'

Tests that LogisticRegression accepts and uses lbfgs solver
"""

from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression

print("=" * 60)
print("R1 Claim 6: LogisticRegression(solver='lbfgs')")
print("=" * 60)
print()

X, y = load_iris(return_X_y=True)

print("Testing LogisticRegression with solver='lbfgs'")
print("-" * 60)

try:
    clf = LogisticRegression(solver='lbfgs', max_iter=200)
    clf.fit(X, y)
    print(f"✓ Model trained successfully")
    print(f"  Iterations: {clf.n_iter_}")
    print(f"  Classes: {clf.classes_}")
    print("  VERDICT: Claim SUPPORTED")
except Exception as e:
    print(f"✗ Error: {e}")
    print("  VERDICT: Claim DISPUTED")

print()
print("=" * 60)
