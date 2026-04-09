#!/usr/bin/env python3
"""
Test R2 Claim: MLKR algorithm exists and uses L-BFGS-B
Tests the metric-learn library
"""

print("=" * 60)
print("R2 Test 6: MLKR existence and optimizer")
print("=" * 60)
print()

print("Test 1: MLKR class exists")
print("-" * 60)

try:
    from metric_learn import MLKR
    print(f"✓ MLKR class found")
    print(f"  Class name: {MLKR.__name__}")
    print(f"  Docstring first line: {MLKR.__doc__.splitlines()[0]}")
    mlkr_exists = True
except ImportError as e:
    print(f"✗ Could not import: {e}")
    mlkr_exists = False

if not mlkr_exists:
    print()
    print("VERDICT: Cannot test further - metric-learn not installed")
    print("=" * 60)
    exit(0)

print()
print("Test 2: MLKR uses L-BFGS-B")
print("-" * 60)

try:
    import inspect
    src = inspect.getsource(MLKR.fit)
    has_lbfgsb = 'L-BFGS-B' in src
    print(f"'L-BFGS-B' found in MLKR.fit source: {has_lbfgsb}")

    if has_lbfgsb:
        print("✓ MLKR implementation uses L-BFGS-B")
        print("  VERDICT: R2's claim is SUPPORTED")
    else:
        print("✗ L-BFGS-B not found in source")
        print("  VERDICT: Claim DISPUTED")
except Exception as e:
    print(f"Could not check source: {e}")

print()
print("Test 3: Minimal MLKR fit")
print("-" * 60)

try:
    from sklearn.datasets import make_regression
    X, y = make_regression(n_samples=50, n_features=5, random_state=0)

    model = MLKR(max_iter=5)
    model.fit(X, y)

    print(f"✓ MLKR fit successful")
    print(f"  Model type: {type(model).__name__}")
    print(f"  Has components_: {hasattr(model, 'components_')}")
    print(f"  Has n_iter_: {hasattr(model, 'n_iter_')}")
except Exception as e:
    print(f"✗ Fit failed: {e}")

print()
print("=" * 60)
