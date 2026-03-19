"""
Test script for Response 1 code from Task 2
This script sets up sample data and executes Response 1's code exactly as provided
"""

import pandas as pd
import numpy as np

print("=" * 80)
print("TESTING RESPONSE 1 CODE - Dynamic Pricing Analysis")
print("=" * 80)

# ============================================================================
# SETUP: Create sample data that simulates the user's scenario
# ============================================================================

print("\n1. Creating sample IT Scope data (multiple vendors for same SKUs)...")
it_scope_data = pd.DataFrame({
    'SKU': ['SKU001', 'SKU002', 'SKU003', 'SKU004', 'SKU005',
            'SKU001', 'SKU002', 'SKU003',  # Same SKUs, different vendors
            'SKU001', 'SKU004'],
    'Price': [100, 200, 150, 180, 220,
              105, 195, 155,  # Different prices from different vendors
              110, 175],
    'Vendor': ['VendorA', 'VendorA', 'VendorA', 'VendorA', 'VendorA',
               'VendorB', 'VendorB', 'VendorB',
               'VendorC', 'VendorC']
})

print("IT Scope Data (Price comparison portal data):")
print(it_scope_data)
print(f"\nTotal records: {len(it_scope_data)}")

print("\n2. Creating sample cost price data (EET Deutschland's costs)...")
cost_df = pd.DataFrame({
    'SKU': ['SKU001', 'SKU002', 'SKU003', 'SKU004', 'SKU005'],
    'Cost_Price': [90, 210, 140, 160, 200]  # Note: SKU002 cost > rank1 price
})

print("Cost Data:")
print(cost_df)

# ============================================================================
# METHOD 1: Response 1's First Method (Complex groupby with apply)
# ============================================================================

print("\n" + "=" * 80)
print("METHOD 1: Response 1's Complex Method (from explanation section)")
print("=" * 80)

try:
    print("\nExecuting:")
    print("rank_1_prices = it_scope_data.groupby('SKU').apply(lambda x: x.loc[x['Price'].idxmin()])[['Price']].rename(columns={'Price': 'Rank1_Price'})")

    rank_1_prices = it_scope_data.groupby('SKU').apply(
        lambda x: x.loc[x['Price'].idxmin()]
    )[['Price']].rename(columns={'Price': 'Rank1_Price'})

    print("\n✓ Method 1 executed successfully")
    print("\nRank 1 Prices (Lowest price per SKU):")
    print(rank_1_prices)

except Exception as e:
    print(f"\n✗ Method 1 failed with error: {e}")
    import traceback
    traceback.print_exc()

# ============================================================================
# METHOD 2: Response 1's Skeleton Method (Simple and recommended)
# ============================================================================

print("\n" + "=" * 80)
print("METHOD 2: Response 1's Skeleton Method (from code section)")
print("=" * 80)

try:
    print("\nExecuting:")
    print("rank_1 = it_scope_data.groupby('SKU')['Price'].min().reset_index()")
    print("rank_1.rename(columns={'Price': 'Rank1_Price'}, inplace=True)")

    # Step 1: Get rank #1 price per SKU
    rank_1 = it_scope_data.groupby('SKU')['Price'].min().reset_index()
    rank_1.rename(columns={'Price': 'Rank1_Price'}, inplace=True)

    print("\n✓ Method 2 executed successfully")
    print("\nRank 1 Prices:")
    print(rank_1)

    # Step 2: Merge with cost
    print("\n3. Merging with cost data...")
    df = pd.merge(cost_df, rank_1, on='SKU', how='left')
    print("Merged DataFrame:")
    print(df)

    # Step 3: Calculate key metrics
    print("\n4. Calculating key metrics...")
    df['Cost_GT_Rank1'] = df['Cost_Price'] > df['Rank1_Price']
    df['Required_Margin'] = (df['Rank1_Price'] - df['Cost_Price']) / df['Rank1_Price']
    df['Required_Margin'] = df['Required_Margin'].round(4)

    print("\nFinal Analysis Results:")
    print(df)

    # Summary stats
    print("\n" + "=" * 80)
    print("SUMMARY STATISTICS (Answering the user's questions)")
    print("=" * 80)

    total_skus = len(df)
    uncompetitive_cost = df['Cost_GT_Rank1'].sum()
    uncompetitive_pct = uncompetitive_cost / total_skus * 100

    print(f"\nTotal SKUs analyzed: {total_skus}")
    print(f"SKUs where Cost > Rank #1 Price: {uncompetitive_cost} ({uncompetitive_pct:.1f}%)")
    print(f"  → These items CANNOT match rank #1 without selling at a loss")

    competitive_skus = total_skus - uncompetitive_cost
    print(f"\nSKUs where you CAN compete: {competitive_skus} ({100-uncompetitive_pct:.1f}%)")

    # Show which SKUs are problematic
    print("\nProblematic SKUs (Cost > Rank #1 Price):")
    problematic = df[df['Cost_GT_Rank1'] == True]
    if len(problematic) > 0:
        for idx, row in problematic.iterrows():
            print(f"  - {row['SKU']}: Cost=€{row['Cost_Price']}, Rank1=€{row['Rank1_Price']}, Loss=€{row['Cost_Price']-row['Rank1_Price']:.2f}")
    else:
        print("  None! All items can potentially be priced competitively.")

    print(f"\nAverage Required Margin to Be #1: {df['Required_Margin'].mean():.1%}")
    print(f"  (Note: Negative margins indicate you'd lose money at rank #1 price)")

    # Optional: Add current sales price simulation
    print("\n5. Simulating with current sales prices (as Response 1 recommended)...")
    df['Current_Price'] = df['Cost_Price'] * 1.20  # Assume 20% markup currently
    df['Current_Margin'] = (df['Current_Price'] - df['Cost_Price']) / df['Current_Price']
    df['Price_Gap'] = df['Current_Price'] - df['Rank1_Price']

    print("\nWith Current Sales Prices (20% markup assumed):")
    print(df[['SKU', 'Cost_Price', 'Current_Price', 'Rank1_Price', 'Price_Gap', 'Current_Margin', 'Required_Margin']])

    price_competitive = (df['Current_Price'] <= df['Rank1_Price']).sum()
    print(f"\nSKUs already competitive (Current Price ≤ Rank1): {price_competitive}")
    print(f"SKUs that need price reduction: {total_skus - price_competitive}")

    print("\n" + "=" * 80)
    print("✓ RESPONSE 1 CODE EXECUTION COMPLETE")
    print("=" * 80)

    print("\nDoes this answer the user's questions?")
    print("✓ Can identify rank #1 prices: YES")
    print("✓ Can compare with cost prices: YES")
    print("✓ Can calculate margins needed: YES")
    print("✓ Can identify items where cost > rank1: YES")
    print("✓ Code is executable and produces results: YES")

except Exception as e:
    print(f"\n✗ Method 2 failed with error: {e}")
    import traceback
    traceback.print_exc()

# ============================================================================
# TEST: Dynamic Pricing Function (Part 2)
# ============================================================================

print("\n" + "=" * 80)
print("TESTING RESPONSE 1's DYNAMIC PRICING FUNCTION (Part 2)")
print("=" * 80)

print("\nResponse 1 provided this function:")
print("""
def calculate_new_price(row):
    if row['Cost_GT_Rank1']:
        return row['Cost_Price'] * (1 + min_profit_margin)  # e.g., 5%
    else:
        # Match or beat rank #1 by 1% or €0.01
        return max(row['Rank1_Price'] * 0.99, row['Cost_Price'] * (1 + target_margin))
""")

print("\nTesting with defined variables...")

# Define the missing variables
min_profit_margin = 0.05  # 5%
target_margin = 0.10  # 10%

def calculate_new_price(row):
    if row['Cost_GT_Rank1']:
        return row['Cost_Price'] * (1 + min_profit_margin)  # e.g., 5%
    else:
        # Match or beat rank #1 by 1% or €0.01
        return max(row['Rank1_Price'] * 0.99, row['Cost_Price'] * (1 + target_margin))

try:
    df['New_Price'] = df.apply(calculate_new_price, axis=1)
    print("\n✓ Dynamic pricing function executed successfully")
    print("\nNew Pricing Recommendations:")
    print(df[['SKU', 'Cost_Price', 'Rank1_Price', 'New_Price', 'Cost_GT_Rank1']])

    print("\nNote: Function uses undefined variables 'min_profit_margin' and 'target_margin'")
    print("      which must be defined by user before function will work.")

except Exception as e:
    print(f"\n✗ Dynamic pricing function failed: {e}")
    import traceback
    traceback.print_exc()

print("\n" + "=" * 80)
print("END OF RESPONSE 1 CODE TESTING")
print("=" * 80)
