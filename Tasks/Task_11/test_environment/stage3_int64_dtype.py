#!/usr/bin/env python3

"""
Find the closest upstream position from positions.tsv for each Position in derivative-filtered.tsv.
Output: Only one column 'Positions' with INTEGER values (no .0, no quotes).
"""

import argparse
import pandas as pd
import bisect

def main():
    parser = argparse.ArgumentParser(description="Find closest upstream position and output only that column as integers.")
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

    # Ensure required columns exist and convert to numeric
    if 'Position' not in derivative_df.columns:
        raise ValueError(f"Column 'Position' not found in {args.derivative_file}")
    if 'Positions' not in positions_df.columns:
        raise ValueError(f"Column 'Positions' not found in {args.positions_file}")

    # Convert to numeric (floats), then we'll clean later
    derivative_df['Position'] = pd.to_numeric(derivative_df['Position'], errors='raise')
    positions_df['Positions'] = pd.to_numeric(positions_df['Positions'], errors='raise')

    # Get sorted unique reference positions (as floats for now)
    ref_positions = sorted(positions_df['Positions'].dropna().unique())

    # If no reference positions, fill with NaN
    if not ref_positions:
        upstream_positions = [pd.NA] * len(derivative_df)
    else:
        # Use bisect for efficiency
        upstream_positions = []
        for q in derivative_df['Position']:
            idx = bisect.bisect_right(ref_positions, q) - 1
            if idx < 0:
                upstream_positions.append(pd.NA)
            else:
                upstream_positions.append(ref_positions[idx])

    # Convert to nullable integer dtype — this removes .0 and handles NaN cleanly
    upstream_series = pd.Series(upstream_positions, dtype='Int64')  # Note: Capital 'I' = nullable

    # Create output DataFrame with ONE column: 'Positions'
    output_df = pd.DataFrame({'Positions': upstream_series})

    # Write output — pandas will write integers without .0 and without quotes
    output_df.to_csv(args.output_file, sep='\t', index=False)
    print(f"Output written to: {args.output_file} (clean integers only)")

if __name__ == "__main__":
    main()
