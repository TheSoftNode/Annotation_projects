#!/usr/bin/env python3
# Test for R2 Claim 16: "If your integer math overflows, it means your
# price or quantity is impossibly large (e.g., a price of $10 billion per share)."
#
# This claim is too simplistic. Overflow can happen with normal-sized
# values if the scaling factor is aggressive or intermediate formulas
# produce large products.

import struct

print("============================================================")
print("R2 Claim 16: Integer Overflow = 'Impossibly Large' Prices?")
print("============================================================")
print()

INT64_MAX = (2**63) - 1
print(f"int64_t max value: {INT64_MAX}")
print(f"                 = {INT64_MAX:.2e}")
print()

# Scenario 1: Normal prices that overflow with aggressive scaling
print("Scenario 1: Normal prices with micro-unit scaling (10^6)")
print("------------------------------------------------------------")
scale = 1_000_000
price_10k = 10_000 * scale     # $10,000 in micro-units = 10^10
price_100k = 100_000 * scale   # $100,000 in micro-units = 10^11

product = price_10k * price_100k
print(f"  $10,000 in micro-units:  {price_10k}")
print(f"  $100,000 in micro-units: {price_100k}")
print(f"  Product (Python bigint):  {product}")
print(f"  Fits in int64_t? {product <= INT64_MAX}")
print(f"  int64_t max:              {INT64_MAX}")
print()
print(f"  These are NOT 'impossibly large' prices, yet the raw")
print(f"  product ({product:.2e}) exceeds int64_t max ({INT64_MAX:.2e}).")
print()

# Scenario 2: Variance / sum-of-squares with modest prices
print("Scenario 2: Sum of squares (variance calculation)")
print("------------------------------------------------------------")
# If computing variance of prices, you need sum(price^2)
# Even $1000 squared in micro-units = (10^9)^2 = 10^18
price_1k = 1_000 * scale  # $1,000 in micro-units = 10^9
squared = price_1k * price_1k
print(f"  $1,000 in micro-units: {price_1k}")
print(f"  Squared: {squared}")
print(f"  Fits in int64_t? {squared <= INT64_MAX}")
print(f"  Sum of 10 squared values: {squared * 10}")
print(f"  Fits in int64_t? {squared * 10 <= INT64_MAX}")
print()

# Scenario 3: The actual $10B claim
print("Scenario 3: R2's $10B per share claim")
print("------------------------------------------------------------")
price_10b = 10_000_000_000 * scale  # $10B in micro-units
print(f"  $10B in micro-units: {price_10b}")
print(f"  Fits in int64_t? {price_10b <= INT64_MAX}")
print(f"  But overflow happens MUCH sooner than $10B prices!")
print()

print("CONCLUSION:")
print("  Overflow is NOT just about 'impossibly large' prices.")
print("  It can happen with normal financial values when:")
print("    1. Scaling factors are aggressive (micro-units)")
print("    2. Intermediate products are formed (a * b)")
print("    3. Statistical calculations involve squares or cubes")
print("  R2's claim oversimplifies the real overflow risk.")
print()

print("============================================================")
print("What this tests:")
print("  - R2 Claim 16: 'If your integer math overflows, it means")
print("    your price or quantity is impossibly large'")
print("============================================================")
