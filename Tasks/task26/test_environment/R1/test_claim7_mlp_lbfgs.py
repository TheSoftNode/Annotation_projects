#!/usr/bin/env python3
"""
Test R1 Claim 7: MLPClassifier/MLPRegressor support solver='lbfgs'

Tests both estimators with lbfgs solver
"""

from sklearn.datasets import load_iris, make_regression
from sklearn.neural_network import MLPClassifier, MLPRegressor

print("=" * 60)
print("R1 Claim 7: MLP* supports solver='lbfgs'")
print("=" * 60)
print()

print("Test 1: MLPClassifier with solver='lbfgs'")
print("-" * 60)

Xc, yc = load_iris(return_X_y=True)

try:
    clf = MLPClassifier(solver='lbfgs', hidden_layer_sizes=(5,), max_iter=200, random_state=0)
    clf.fit(Xc, yc)
    print("✓ MLPClassifier OK")
except Exception as e:
    print(f"✗ MLPClassifier failed: {e}")

print()
print("Test 2: MLPRegressor with solver='lbfgs'")
print("-" * 60)

Xr, yr = make_regression(n_samples=50, n_features=4, random_state=0)

try:
    reg = MLPRegressor(solver='lbfgs', hidden_layer_sizes=(5,), max_iter=200, random_state=0)
    reg.fit(Xr, yr)
    print("✓ MLPRegressor OK")
    print()
    print("VERDICT: Claim SUPPORTED")
except Exception as e:
    print(f"✗ MLPRegressor failed: {e}")
    print("  VERDICT: Claim DISPUTED")

print()
print("=" * 60)
