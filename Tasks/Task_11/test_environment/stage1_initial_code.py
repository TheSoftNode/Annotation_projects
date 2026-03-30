#!/usr/bin/env python3

"""
Find the closest upstream position from positions.tsv for each Position in derivative-filtered.tsv.
Output: positions-dd-filtered.tsv
"""

import argparse
import pandas as pd

def main():
    parser = argparse.ArgumentParser(description="Find closest upstream position.")
    parser.add_argument("--derivative-file", default="derivative-filtered.tsv",
                        help="Input TSV with column 'Position' (default: derivative-filtered.tsv)")
    parser.add_argument("--positions-file", default="positions.tsv",
                        help="Input TSV with column 'Positions' (default: positions.tsv)")
    parser.add_argument("--output-file", default="positions-dd-filtered.tsv",
                        help="Output TSV file (default: positions-dd-filtered.tsv)")

    args = parser.parse_args()

    # Load data
    print(f"Loading derivative positions from: {args.derivative_file}")
    derivative_df = pd.read_csv(args.derivative_file, sep='\t')

    print(f"Loading reference positions from: {args.positions_file}")
    positions_df = pd.read_csv(args.positions_file, sep='\t')

    # Ensure required columns exist
    if 'Position' not in derivative_df.columns:
        raise ValueError(f"Column 'Position' not found in {args.derivative_file}")
    if 'Positions' not in positions_df.columns:
        raise ValueError(f"Column 'Positions' not found in {args.positions_file}")

    # Convert to numeric (in case they're strings)
    derivative_df['Position'] = pd.to_numeric(derivative_df['Position'], errors='raise')
    positions_df['Positions'] = pd.to_numeric(positions_df['Positions'], errors='raise')

    # Sort reference positions (required for efficient upstream lookup)
    ref_positions = sorted(positions_df['Positions'].dropna().unique())

    # If no reference positions, fill with NaN
    if not ref_positions:
        derivative_df['ClosestUpstreamPosition'] = pd.NA
    else:
        # For each query position, find the largest reference position <= query
        upstream_positions = []
        for q in derivative_df['Position']:
            # Find the rightmost position <= q
            # We want the largest reference position that is <= q
            idx = -1
            for i, ref in enumerate(ref_positions):
                if ref <= q:
                    idx = i
                else:
                    break

            if idx == -1:
                upstream_positions.append(pd.NA)  # No upstream position found
            else:
                upstream_positions.append(ref_positions[idx])

        derivative_df['ClosestUpstreamPosition'] = upstream_positions

    # Save output
    derivative_df.to_csv(args.output_file, sep='\t', index=False)
    print(f"Output written to: {args.output_file}")

if __name__ == "__main__":
    main()
