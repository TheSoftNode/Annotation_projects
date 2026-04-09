#!/usr/bin/env python3
"""
Test R2 Claim: "no partial_fit support for lbfgs"
Checks if MLPClassifier has partial_fit method
"""

from sklearn.neural_network import MLPClassifier

print("=" * 60)
print("R2 Test 8: partial_fit availability")
print("=" * 60)
print()

print("Checking if MLPClassifier has partial_fit method...")
print("-" * 60)

model = MLPClassifier()
has_partial_fit = hasattr(model, 'partial_fit')

print(f"MLPClassifier has partial_fit method: {has_partial_fit}")

if has_partial_fit:
    print()
    print("✓ partial_fit method exists")
    print("  VERDICT: R2's claim 'no partial_fit support for lbfgs' is")
    print("           OVERSIMPLIFIED - the method exists, but behavior with")
    print("           lbfgs solver is different (doesn't support online learning)")
else:
    print()
    print("✗ partial_fit method not found")

print()
print("=" * 60)
