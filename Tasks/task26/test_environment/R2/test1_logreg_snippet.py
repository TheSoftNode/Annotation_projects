#!/usr/bin/env python3
"""
Test R2 Code Snippet 1: LogisticRegression code verbatim
Tests if the exact code from R2 is syntactically valid
"""

print("=" * 60)
print("R2 Test 1: LogisticRegression snippet (verbatim)")
print("=" * 60)
print()

try:
    # For Logistic Regression (Default is usually lbfgs)
    from sklearn.linear_model import LogisticRegression

    model = LogisticRegression(solver='lbfgs', max_iter=1000)

    print("✓ Code is syntactically valid and API exists")
    print(f"  Model created: {type(model).__name__}")
    print(f"  Solver: {model.solver}")
    print("  VERDICT: Snippet is valid (but incomplete - no fit call)")
except Exception as e:
    print(f"✗ Error: {e}")
    print("  VERDICT: Snippet has issues")

print()
print("=" * 60)
