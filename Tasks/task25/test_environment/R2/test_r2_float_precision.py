#!/usr/bin/env python3
# Test A: Float precision issues (0.1 + 0.2)

print("============================================================")
print("R2 Test A: Float Precision Issues")
print("============================================================")
print()

print("Test 1: The classic 0.1 + 0.2 problem")
print("------------------------------------------------------------")
result = 0.1 + 0.2
print(f"0.1 + 0.2 = {result}")
print(f"0.1 + 0.2 == 0.3: {result == 0.3}")
print(f"Exact representation: {result:.20f}")
print()

print("Test 2: Integer equivalent")
print("------------------------------------------------------------")
int_result = 10 + 20
print(f"Integer: 10 + 20 = {int_result}")
print(f"10 + 20 == 30: {int_result == 30}")
print()

print("Test 3: Accumulation of small errors")
print("------------------------------------------------------------")
# Simulate many small additions
total_float = 0.0
for _ in range(1000):
    total_float += 0.1

total_int = 0
for _ in range(1000):
    total_int += 10  # Representing 0.1 in tenths

print(f"Float: 0.1 added 1000 times = {total_float}")
print(f"Expected: 100.0")
print(f"Match: {total_float == 100.0}")
print()
print(f"Integer: 10 added 1000 times = {total_int}")
print(f"Expected: 10000 (representing 100.0)")
print(f"Match: {total_int == 10000}")
print()

print("============================================================")
print("What this tests:")
print("  - R2 Claim 1: 'Float: 0.1 + 0.2 often equals 0.30000000000000004'")
print("  - R2 Claim 2: 'Int: 10 + 20 always equals 30'")
print("  - R2 Claim 6: Float precision issues with equality")
print("============================================================")
