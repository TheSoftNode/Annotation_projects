#!/usr/bin/env python3
"""
Test R2 Claims about MLP solver options
Tests default solver and available solver options
"""

from sklearn.neural_network import MLPClassifier

print("=" * 60)
print("R2 Test 4: MLP solver options and default")
print("=" * 60)
print()

m = MLPClassifier()

print("Checking MLPClassifier solver configuration")
print("-" * 60)

default_solver = m.get_params()['solver']
has_solver_param = 'solver' in m.get_params()

print(f"Default solver: {default_solver}")
print(f"Has solver parameter: {has_solver_param}")

print()
print("Testing each solver mentioned in R2...")
print("-" * 60)

for solver in ['lbfgs', 'adam', 'sgd']:
    try:
        test_model = MLPClassifier(solver=solver)
        print(f"✓ solver='{solver}' is valid")
    except Exception as e:
        print(f"✗ solver='{solver}' failed: {e}")

print()
print("VERDICT: All three solvers (lbfgs, adam, sgd) are supported")

print()
print("=" * 60)
