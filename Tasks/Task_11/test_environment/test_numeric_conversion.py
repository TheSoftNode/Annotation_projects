#!/usr/bin/env python3
"""Test if missing pd.to_numeric() on ref_positions causes issues"""

import pandas as pd
import bisect

# Load the actual test files
positions_df = pd.read_csv('positions.tsv', sep='\t')

# Line 89 from Response 1 - NO numeric conversion
ref_positions = sorted(positions_df['Positions'].dropna().unique())

print("=== Without pd.to_numeric() ===")
print(f"ref_positions type: {type(ref_positions)}")
print(f"ref_positions: {ref_positions}")
print(f"First element type: {type(ref_positions[0])}")
print(f"First element: {ref_positions[0]}")

# Test if str(int()) works
try:
    result = str(int(ref_positions[0]))
    print(f"str(int(ref_positions[0])): {result}")
except Exception as e:
    print(f"ERROR: {e}")

# Test sorting correctness
print("\n=== Test with string numbers (lexicographic sort) ===")
test_strings = ['100', '20', '300', '15']
sorted_strings = sorted(test_strings)
print(f"String sort: {sorted_strings}")  # ['100', '15', '20', '300'] - WRONG

sorted_numeric = sorted([int(x) for x in test_strings])
print(f"Numeric sort: {sorted_numeric}")  # [15, 20, 100, 300] - CORRECT

# Test with actual data
print("\n=== Binary search test ===")
q = 250  # derivative position
idx = bisect.bisect_right(ref_positions, q) - 1
print(f"Query: {q}")
print(f"Index: {idx}")
print(f"Result: {ref_positions[idx]}")
