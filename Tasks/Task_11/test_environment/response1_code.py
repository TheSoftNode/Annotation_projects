#!/usr/bin/env python3

"""

Output ONLY the closest upstream integer positions (no header, no quotes, no .0) to a TSV file.

"""

import argparse

import pandas as pd

import bisect

def main():

    parser = argparse.ArgumentParser(description="Output ONLY the closest upstream integer positions — raw, clean, no headers or quotes.")

    parser.add_argument("--derivative-file", default="derivative-filtered.tsv",

                        help="Input TSV with column 'Position'")

    parser.add_argument("--positions-file", default="positions.tsv",

                        help="Input TSV with column 'Positions'")

    parser.add_argument("--output-file", default="positions-dd-filtered.tsv",

                        help="Output TSV file")

    args = parser.parse_args()

    # Load data

    derivative_df = pd.read_csv(args.derivative_file, sep='\t')

    positions_df = pd.read_csv(args.positions_file, sep='\t')

    # Validate columns

    if 'Position' not in derivative_df.columns or 'Positions' not in positions_df.columns:

        raise ValueError("Missing required columns 'Position' or 'Positions'")

    # Convert to integers (ensures no floats)

    ref_positions = sorted(positions_df['Positions'].dropna().unique())

    derivative_positions = pd.to_numeric(derivative_df['Position'], errors='raise')

    # Find closest upstream position for each

    results = []

    for q in derivative_positions:

        idx = bisect.bisect_right(ref_positions, q) - 1

        if idx < 0:

            results.append("")  # or skip? but we want no .0 — so use empty if none

        else:

            results.append(str(int(ref_positions[idx])))  # Force integer → no .0, no quotes

    # Write ONLY the values — one per line, no header, no quotes

    with open(args.output_file, 'w') as f:

        for val in results:

            f.write(f"{val}\n" if val != pd.NA else "\n")  # Write empty line for NA

    print(f"✅ Output written to: {args.output_file} (clean integers, no headers, no quotes, no .0)")

if __name__ == "__main__":

    main()
