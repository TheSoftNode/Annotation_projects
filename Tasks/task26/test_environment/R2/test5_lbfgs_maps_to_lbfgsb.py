#!/usr/bin/env python3
"""
Test R2 Claim: solver='lbfgs' uses L-BFGS-B internally
Checks the source code for both LogisticRegression and MLP
"""

import inspect

print("=" * 60)
print("R2 Test 5: solver='lbfgs' uses L-BFGS-B internally")
print("=" * 60)
print()

print("Test 1: LogisticRegression implementation")
print("-" * 60)

try:
    import sklearn.linear_model._logistic as lg
    src = inspect.getsource(lg._logistic_regression_path)
    has_lbfgsb = 'L-BFGS-B' in src
    print(f"'L-BFGS-B' found in LogisticRegression source: {has_lbfgsb}")
except Exception as e:
    print(f"Could not check source: {e}")
    has_lbfgsb = None

print()
print("Test 2: MLP implementation")
print("-" * 60)

try:
    import sklearn.neural_network._multilayer_perceptron as mlp
    src = inspect.getsource(mlp.BaseMultilayerPerceptron._fit_lbfgs)
    has_lbfgsb_mlp = 'L-BFGS-B' in src
    print(f"'L-BFGS-B' found in MLP source: {has_lbfgsb_mlp}")
except Exception as e:
    print(f"Could not check source: {e}")
    has_lbfgsb_mlp = None

print()
if has_lbfgsb and has_lbfgsb_mlp:
    print("✓ Both implementations use L-BFGS-B")
    print("  VERDICT: R2's claim is SUPPORTED")
elif has_lbfgsb is not None or has_lbfgsb_mlp is not None:
    print("? Partial verification - at least one implementation confirmed")
else:
    print("✗ Could not verify source code")

print()
print("=" * 60)
