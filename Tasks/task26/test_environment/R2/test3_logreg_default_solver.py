#!/usr/bin/env python3
"""
Test R2 Claim: "Default is usually lbfgs" for LogisticRegression
"""

from sklearn.linear_model import LogisticRegression

print("=" * 60)
print("R2 Test 3: LogisticRegression default solver")
print("=" * 60)
print()

print("Checking default solver for LogisticRegression")
print("-" * 60)

model = LogisticRegression()
default_solver = model.get_params()['solver']

print(f"Default solver: {default_solver}")

if default_solver == 'lbfgs':
    print("✓ Default is 'lbfgs'")
    print("  VERDICT: R2's claim 'default is usually lbfgs' is SUPPORTED")
else:
    print(f"✗ Default is '{default_solver}', not 'lbfgs'")
    print("  VERDICT: Claim DISPUTED")

print()
print("=" * 60)
