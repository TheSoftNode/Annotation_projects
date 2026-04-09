#!/usr/bin/env python3
# Test E: Epsilon comparison requirement for floats

print("============================================================")
print("R2 Test E: Float Equality Trap")
print("============================================================")
print()

print("Test 1: Price calculation that should be equal")
print("------------------------------------------------------------")
price1 = 100.10
price2 = 50.05 * 2.0

print(f"price1: {price1:.20f}")
print(f"price2: {price2:.20f}")
print(f"price1 == price2: {price1 == price2}")
print(f"Difference: {abs(price1 - price2):.20e}")
print()

print("Test 2: Epsilon comparison workaround")
print("------------------------------------------------------------")
epsilon = 0.000001
print(f"Using epsilon: {epsilon}")
print(f"abs(price1 - price2) < epsilon: {abs(price1 - price2) < epsilon}")
print()

print("Test 3: Different calculation paths, same logical result")
print("------------------------------------------------------------")
# Simulating accumulated calculations
path1 = 0.1 + 0.1 + 0.1
path2 = 0.3

print(f"path1 (0.1 + 0.1 + 0.1): {path1:.20f}")
print(f"path2 (0.3): {path2:.20f}")
print(f"path1 == path2: {path1 == path2}")
print(f"abs(path1 - path2) < epsilon: {abs(path1 - path2) < epsilon}")
print()

print("Test 4: Integer comparison (always exact)")
print("------------------------------------------------------------")
int_price1 = 10010  # $100.10 in cents
int_price2 = 5005 * 2  # $50.05 * 2 in cents

print(f"int_price1: {int_price1}")
print(f"int_price2: {int_price2}")
print(f"int_price1 == int_price2: {int_price1 == int_price2}")
print(f"No epsilon needed: True")
print()

print("============================================================")
print("What this tests:")
print("  - R2 Claim 6: Float equality is dangerous due to rounding")
print("  - R2 Claim 7: Epsilon comparison pattern")
print("  - R2 Claim 5: Integer equality is reliable")
print("============================================================")
