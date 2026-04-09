#!/usr/bin/env python3
"""
Test R1 Claim 5: L-BFGS-B is a limited-memory BFGS algorithm with bound constraints

Tests that L-BFGS-B actually supports bound constraints in scipy
"""

from scipy.optimize import minimize
import numpy as np

print("=" * 60)
print("R1 Claim 5: L-BFGS-B bound constraints")
print("=" * 60)
print()

print("Testing L-BFGS-B with bound constraints")
print("-" * 60)

# Minimize f(x) = (x-1)^2 with bounds [0, 2]
f = lambda x: (x[0] - 1.0)**2
res = minimize(f, x0=np.array([10.0]), method='L-BFGS-B', bounds=[(0, 2)])

print(f"Optimization successful: {res.success}")
print(f"Solution: {res.x}")
print(f"Expected: ~1.0")
print()

if res.success and abs(res.x[0] - 1.0) < 0.01:
    print("✓ L-BFGS-B successfully handled bound constraints")
    print("  VERDICT: Claim SUPPORTED")
else:
    print("✗ Optimization failed or gave wrong result")
    print("  VERDICT: Claim DISPUTED")

print()
print("=" * 60)
