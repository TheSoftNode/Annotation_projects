#!/usr/bin/env python3
# Test B: Float overflow to infinity

import sys

print("============================================================")
print("R2 Test B: Float Overflow Behavior")
print("============================================================")
print()

print("Test 1: Float overflow produces infinity")
print("------------------------------------------------------------")
large = 1.7e308
print(f"Large float: {large}")
result = large * 10.0
print(f"Large * 10: {result}")
print(f"Is infinity: {result == float('inf')}")
print(f"Is finite: {result != float('inf')}")
print()

print("Test 2: Infinity arithmetic (silent continuation)")
print("------------------------------------------------------------")
inf = float('inf')
print(f"inf + 1000: {inf + 1000}")
print(f"inf * 2: {inf * 2}")
print(f"inf - inf: {inf - inf} (NaN)")
print(f"System continues running with inf/NaN: True")
print()

print("Test 3: Integer overflow comparison")
print("------------------------------------------------------------")
print(f"sys.maxsize: {sys.maxsize}")
print(f"Integer overflow behavior is platform-dependent:")
print(f"  - Python: Arbitrary precision (no overflow)")
print(f"  - C int64_t: Undefined behavior or wrapping")
print(f"  - Result: More explicit failure than float's silent inf")
print()

print("============================================================")
print("What this tests:")
print("  - R2 Claim 8: 'With floats, the numbers just get bigger")
print("                 or turn into inf, and the system might keep")
print("                 running silently with garbage data.'")
print("============================================================")
