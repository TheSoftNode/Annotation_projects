#!/usr/bin/env python3

"""
Find the closest upstream position from positions.tsv for each Position in derivative-filtered.tsv.
Output: Only one column 'Positions' (the closest upstream reference position) to positions-dd-filtered.tsv
"""

import argparse
import pandas as pd

def main():
    parser = argparse.ArgumentParser(description="Find closest upstream position and output only that column.")
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

    derivative_df['Position'] = pd.to_numeric(derivative_df['Position'], errors='raise')
    positions_df['Positions'] = pd.to_numeric(positions_df['Positions'], errors='raise')

    # Get sorted unique reference positions
    ref_positions = sorted(positions_df['Positions'].dropna().unique())

    # If no reference positions, fill with NaN
    if not ref_positions:
        upstream_positions = [pd.NA] * len(derivative_df)
    else:
        # Use bisect for efficiency (O(log n) per query)
        import bisect
        upstream_positions = []
        for q in derivative_df['Position']:
            idx = bisect.bisect_right(ref_positions, q) - 1
            upstream_positions.append(ref_positions[idx] if idx >= 0 else pd.NA)

    # Create output DataFrame with ONLY the 'Positions' column
    output_df = pd.DataFrame({'Positions': upstream_positions})

    # Write output
    output_df.to_csv(args.output_file, sep='\t', index=False)
    print(f"Output written to: {args.output_file} (single column: 'Positions')")

if __name__ == "__main__":
    main()
