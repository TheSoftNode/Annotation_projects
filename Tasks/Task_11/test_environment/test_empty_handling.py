#!/usr/bin/env python3
"""Test the inconsistent empty value handling"""

import pandas as pd

# Simulate the results list
results = ["50", "", "200"]  # Line 103: results.append("")

# Test the check from line 115
for val in results:
    print(f"val = {repr(val)}")
    print(f"val != pd.NA = {val != pd.NA}")
    print(f"Type of (val != pd.NA): {type(val != pd.NA)}")

    # What the ternary does
    try:
        output = f"{val}\n" if val != pd.NA else "\n"
        print(f"Output: {repr(output)}")
    except Exception as e:
        print(f"ERROR: {e}")
    print()
