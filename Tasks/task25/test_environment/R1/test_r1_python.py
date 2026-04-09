#!/usr/bin/env python3
"""
Task 25 - R1 Python Tests
Tests Python-based claims from Response 1 about floating-point behavior
"""

print("=" * 60)
print("R1 - Python Floating-Point Tests")
print("=" * 60)
print()

# Test A: Exact representation and equality failure
print("TEST A: Float Equality Failure")
print("-" * 60)
result1 = 0.1 + 0.1 + 0.1 == 0.3
print(f"0.1 + 0.1 + 0.1 == 0.3: {result1}")

import math
result2 = math.isclose(0.1 + 0.1 + 0.1, 0.3)
print(f"math.isclose(0.1 + 0.1 + 0.1, 0.3): {result2}")

hex_repr = (0.1).hex()
print(f"(0.1).hex(): {hex_repr}")
print()

# Test B: $1M resolution claim
print("TEST B: $1M Resolution Claim")
print("-" * 60)

from decimal import Decimal

decimal_repr = Decimal.from_float(1000000.01)
print(f"Decimal.from_float(1000000.01):")
print(f"  {decimal_repr}")

ulp_value = math.ulp(1_000_000.0)
print(f"math.ulp(1_000_000.0): {ulp_value}")
print(f"  (This is the spacing, not 0.001 / 0.1 cent)")

result3 = 1000000.0 + 0.0001 == 1000000.0001
print(f"1000000.0 + 0.0001 == 1000000.0001: {result3}")

result4 = 1000000.01 + 0.01 == 1000000.02
print(f"1000000.01 + 0.01 == 1000000.02: {result4}")
print()

# Test C: Non-associativity
print("TEST C: Non-Associativity")
print("-" * 60)
expr1 = (1e16 + -1e16) + 1.0
print(f"(1e16 + -1e16) + 1.0 = {expr1}")

expr2 = 1e16 + (-1e16 + 1.0)
print(f"1e16 + (-1e16 + 1.0) = {expr2}")
print(f"Results are different: {expr1 != expr2}")
print()

print("=" * 60)
print("Python tests complete!")
print("=" * 60)
