#!/usr/bin/env python3

"""
Testing Response 2's alternative suggestion: header=False
"""

import argparse
import pandas as pd
import bisect

def main():
    parser = argparse.ArgumentParser(description="Output closest upstream positions as clean integers.")
    parser.add_argument("--derivative-file", default="derivative-filtered.tsv",
                        help="Input TSV with column 'Position' (default: derivative-filtered.tsv)")
    parser.add_argument("--positions-file", default="positions.tsv",
                        help="Input TSV with column 'Positions' (default: positions.tsv)")
    parser.add_argument("--output-file", default="positions-dd-filtered.tsv",
                        help="Output TSV file (default: positions-dd-filtered.tsv)")

    args = parser.parse_args()

    # Load and validate data
    derivative_df = pd.read_csv(args.derivative_file, sep='\t')
    positions_df = pd.read_csv(args.positions_file, sep='\t')

    if 'Position' not in derivative_df.columns:
        raise ValueError(f"Missing 'Position' column in {args.derivative_file}")
    if 'Positions' not in positions_df.columns:
        raise ValueError(f"Missing 'Positions' column in {args.positions_file}")

    # Convert to numeric (handles strings → numbers)
    derivative_df['Position'] = pd.to_numeric(derivative_df['Position'], errors='raise')
    positions_df['Positions'] = pd.to_numeric(positions_df['Positions'], errors='raise')

    # Get sorted unique reference positions
    ref_positions = sorted(positions_df['Positions'].dropna().unique())

    # Find closest upstream for each query position
    upstream = []
    if not ref_positions:
        upstream = [pd.NA] * len(derivative_df)
    else:
        for q in derivative_df['Position']:
            idx = bisect.bisect_right(ref_positions, q) - 1
            upstream.append(ref_positions[idx] if idx >= 0 else pd.NA)

    # CRITICAL: Convert to nullable integer (Int64) → strips .0, handles NA cleanly
    result = pd.Series(upstream, dtype='Int64')

    # Response 2's alternative: header=False for no header
    result.to_csv(
        args.output_file,
        sep='\t',
        header=False,   # ← NO HEADER (Response 2's suggestion)
        index=False,
        quoting=3       # ← STILL NO QUOTES
    )

    print(f"✅ Output written (header=False version)")

if __name__ == "__main__":
    main()
