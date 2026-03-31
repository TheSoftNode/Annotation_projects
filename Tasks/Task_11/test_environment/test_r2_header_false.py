#!/usr/bin/env python3
"""Test Response 2 code with header=False"""

import pandas as pd
import bisect

# Load files
derivative_df = pd.read_csv('derivative-filtered.tsv', sep='\t')
positions_df = pd.read_csv('positions.tsv', sep='\t')

# Build reference positions
ref_positions = sorted(positions_df['Positions'].dropna().unique())

# Find upstream positions
upstream = []
for q in derivative_df['Position']:
    idx = bisect.bisect_right(ref_positions, q) - 1
    upstream.append(ref_positions[idx] if idx >= 0 else pd.NA)

# Create result series
result = pd.Series(upstream, dtype='Int64')

# Write with header=False
result.to_csv('test_no_header.tsv', sep='\t', header=False, index=False, quoting=3)
