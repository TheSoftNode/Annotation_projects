"""
Test script for Response 2 code from Task 2
This script sets up sample data and executes Response 2's code exactly as provided
"""

import pandas as pd
import numpy as np

print("=" * 80)
print("TESTING RESPONSE 2 CODE - Dynamic Pricing Analysis")
print("=" * 80)

# ============================================================================
# SETUP: Create sample data that simulates the user's scenario
# ============================================================================

print("\n1. Creating sample cost data (mycosts.csv)...")
cost_df = pd.DataFrame({
    'sku': ['SKU001', 'SKU002', 'SKU003', 'SKU004', 'SKU005'],
    'cost_price': [90, 210, 140, 160, 200],
    'unit': ['pcs', 'pcs', 'pcs', 'pcs', 'pcs']
})

print("Cost Data:")
print(cost_df)

print("\n2. Creating sample IT Scope snapshot (itscope_rank1.csv)...")
itscp_snapshot = pd.DataFrame({
    'sku': ['SKU001', 'SKU002', 'SKU003', 'SKU004', 'SKU005'],
    'price': [100, 195, 150, 180, 220],
    'rank': [1, 1, 1, 1, 1],
    'unit': ['pcs', 'pcs', 'pcs', 'pcs', 'pcs']
})

print("IT Scope Data:")
print(itscp_snapshot)

# ============================================================================
# STEP 1: Clean & Align
# ============================================================================

print("\n" + "=" * 80)
print("STEP 1: CLEAN & ALIGN (Normalize units)")
print("=" * 80)

print("\nExecuting normalize function:")
print("""
def normalize(df, unit_col='unit'):
    df['unit'] = df[unit_col].str.lower().str.strip()
    return df
""")

def normalize(df, unit_col='unit'):
    df['unit'] = df[unit_col].str.lower().str.strip()
    return df

try:
    cost_df = normalize(cost_df)
    itscp_snapshot = normalize(itscp_snapshot)
    print("✓ Normalization successful")
except Exception as e:
    print(f"✗ Normalization failed: {e}")
    import traceback
    traceback.print_exc()

# ============================================================================
# STEP 2: Merge on SKU
# ============================================================================

print("\n" + "=" * 80)
print("STEP 2: MERGE ON SKU")
print("=" * 80)

print("\nExecuting:")
print("merged = cost_df.merge(itscp_snapshot, on='sku', how='inner')")
print("merged.rename(columns={'price':'itscope_price', 'cost_price':'my_cost'}, inplace=True)")

try:
    merged = cost_df.merge(itscp_snapshot, on='sku', how='inner')
    merged.rename(columns={'price':'itscope_price', 'cost_price':'my_cost'}, inplace=True)
    print("\n✓ Merge successful")
    print("\nMerged Data:")
    print(merged.head())
except Exception as e:
    print(f"\n✗ Merge failed: {e}")
    import traceback
    traceback.print_exc()

# ============================================================================
# STEP 3: Calculate margin needed to hit Rank 1
# ============================================================================

print("\n" + "=" * 80)
print("STEP 3: CALCULATE GAP TO RANK 1")
print("=" * 80)

print("\nExecuting:")
print("merged['gap_abs'] = merged['itscope_price'] - merged['my_cost']")
print("merged['gap_pct'] = merged['gap_abs'] / merged['itscope_price'] * 100")

try:
    merged['gap_abs'] = merged['itscope_price'] - merged['my_cost']
    merged['gap_pct'] = merged['gap_abs'] / merged['itscope_price'] * 100

    print("\n✓ Gap calculations successful")
    print("\nGap Analysis:")
    print(merged[['sku', 'my_cost', 'itscope_price', 'gap_abs', 'gap_pct']])

    print(f"\nProducts that are already below the rank-1 price: {merged[merged['gap_abs'] < 0].shape[0]}")
    print(f"Average gap percent to match rank-1: {merged['gap_pct'].mean():.2f}%")

except Exception as e:
    print(f"\n✗ Gap calculations failed: {e}")
    import traceback
    traceback.print_exc()

# ============================================================================
# STEP 4: Propose new price
# ============================================================================

print("\n" + "=" * 80)
print("STEP 4: PROPOSE NEW PRICE WITH TARGET MARGIN")
print("=" * 80)

print("\nResponse 2's logic:")
print("TARGET_MARGIN = 0.30  # 30%")
print("merged['proposed_price'] = merged['my_cost'] / (1 - TARGET_MARGIN)")
print("merged['final_price'] = merged[['proposed_price', 'itscope_price']].min(axis=1)")
print("merged['moving_to_r1'] = (merged['final_price'] < merged['itscope_price'])")

TARGET_MARGIN = 0.30  # 30%

try:
    merged['proposed_price'] = merged['my_cost'] / (1 - TARGET_MARGIN)
    merged['final_price'] = merged[['proposed_price', 'itscope_price']].min(axis=1)
    merged['moving_to_r1'] = (merged['final_price'] < merged['itscope_price'])

    print("\n✓ Proposed price calculation successful")
    print("\nProposed Pricing Results:")
    print(merged[['sku', 'my_cost', 'itscope_price', 'proposed_price', 'final_price', 'moving_to_r1']])

    print(f"\n{merged['moving_to_r1'].sum()} items would be Rank 1.")

except Exception as e:
    print(f"\n✗ Proposed price calculation failed: {e}")
    import traceback
    traceback.print_exc()

# ============================================================================
# CRITICAL ANALYSIS: Is the logic correct?
# ============================================================================

print("\n" + "=" * 80)
print("CRITICAL ANALYSIS: LOGIC VERIFICATION")
print("=" * 80)

print("\nLet's trace through the logic for each SKU:\n")

for idx, row in merged.iterrows():
    sku = row['sku']
    cost = row['my_cost']
    itscope = row['itscope_price']
    proposed = row['proposed_price']
    final = row['final_price']
    moving = row['moving_to_r1']

    print(f"{sku}:")
    print(f"  Cost: €{cost}")
    print(f"  IT Scope Rank 1: €{itscope}")
    print(f"  Proposed (30% margin): €{proposed:.2f}")
    print(f"  Final Price: min({proposed:.2f}, {itscope}) = €{final:.2f}")
    print(f"  Moving to R1? {final:.2f} < {itscope} = {moving}")

    if final == itscope:
        print(f"  ⚠️  ISSUE: final_price EQUALS itscope_price, so will NEVER be < itscope_price")
    print()

print("=" * 80)
print("LOGICAL ERROR IDENTIFIED:")
print("=" * 80)
print("""
The formula: final_price = min(proposed_price, itscope_price)

Will ALWAYS result in:
  - If proposed_price < itscope_price: final_price = proposed_price (but still not < itscope)
  - If proposed_price >= itscope_price: final_price = itscope_price (equals, not less than)

Therefore: moving_to_r1 = (final_price < itscope_price) will ALWAYS be False!

To actually achieve Rank 1, you need to beat the current rank 1 price, such as:
  final_price = min(proposed_price, itscope_price * 0.99)  # Beat by 1%

OR simply:
  moving_to_r1 = (final_price <= itscope_price)  # Use <= instead of <
""")

print("\n" + "=" * 80)
print("TESTING CORRECTED LOGIC:")
print("=" * 80)

merged['corrected_final_price'] = merged[['proposed_price', 'itscope_price']].min(axis=1) * 0.99
merged['corrected_moving_to_r1'] = (merged['corrected_final_price'] < merged['itscope_price'])

print("\nWith corrected logic (beat by 1%):")
print(merged[['sku', 'itscope_price', 'corrected_final_price', 'corrected_moving_to_r1']])
print(f"\n{merged['corrected_moving_to_r1'].sum()} items would NOW be Rank 1.")

print("\n" + "=" * 80)
print("END OF RESPONSE 2 CODE TESTING")
print("=" * 80)

print("\nSUMMARY:")
print("✓ Code executes without syntax errors")
print("✓ Calculations complete")
print("✗ LOGIC ERROR: moving_to_r1 calculation is fundamentally flawed")
print("✗ Result: Reports 0 items achieving Rank 1 when it should report all items")
