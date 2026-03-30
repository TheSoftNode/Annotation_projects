#!/usr/bin/env python3

"""

Find closest upstream position. Output: ONLY integers in 'Positions' column.

Guaranteed: No quotes, no .0, no extra columns.

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

    # Then force output as raw integers (no formatting, no quotes)

    result = pd.Series(upstream, dtype='Int64')



    # Write as TSV with ABSOLUTELY NO QUOTING (even if data had tabs, it's safe here since we have pure integers)

    result.to_csv(

        args.output_file,

        sep='\t',

        header=True,          # Keep header 'Positions' (remove if you want no header)

        index=False,

        quoting=3             # csv.QUOTE_NONE → NEVER quote anything, under any circumstance

    )



    print(f"✅ Clean integer output written to: {args.output_file}")

    print("   (View with: head -5 positions-dd-filtered.tsv | cat -A to verify no quotes)")

if __name__ == "__main__":

    main()
