#!/usr/bin/env python3
"""
Test R1 Claim 1: "MLKR" (likely meant as MKL/Multiple Kernel Learning) isn't natively implemented in scikit-learn

This tests whether MLKR actually exists in metric-learn, contradicting the response's assumption
that MLKR is a typo for MKL.
"""

print("=" * 60)
print("R1 Claim 1: Testing MLKR existence")
print("=" * 60)
print()

try:
    from metric_learn import MLKR
    print("✓ MLKR class found in metric-learn")
    print(f"  Class name: {MLKR.__name__}")
    print(f"  First line of docstring: {MLKR.__doc__.splitlines()[0]}")
    print()
    print("VERDICT: R1's assumption that 'MLKR' is likely a typo for 'MKL' is DISPUTED")
    print("         MLKR is a real algorithm: Metric Learning for Kernel Regression")
except ImportError as e:
    print(f"✗ Could not import MLKR: {e}")
    print("  (metric-learn may not be installed)")

print()
print("=" * 60)
