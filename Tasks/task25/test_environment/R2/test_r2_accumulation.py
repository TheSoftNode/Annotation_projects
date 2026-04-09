#!/usr/bin/env python3
# Test 3 (from GPT factual): Float accumulation errors
# Tests R2 Claim 8: "If you calculate PnL using floats, tiny rounding errors accumulate."
# Tests R2 Claim 11: "With integers, $0.00 discrepancy is guaranteed."

print("============================================================")
print("R2 Test 3: Float Accumulation vs Integer Exactness")
print("============================================================")
print()

# --- Part A: sum([0.1] * 10) test from GPT factual ---
print("Part A: sum([0.1] * 10)")
print("------------------------------------------------------------")
result = sum([0.1] * 10)
print(f"  sum([0.1] * 10) = {result}")
print(f"  Expected: 1.0")
print(f"  Equal to 1.0? {result == 1.0}")
print(f"  Difference: {result - 1.0:.20e}")
print()

# --- Part B: Simulated PnL accumulation over a trading day ---
print("Part B: Simulated PnL accumulation (10,000 trades)")
print("------------------------------------------------------------")
# Simulate adding $0.01 profit per trade, 10000 trades
float_pnl = 0.0
int_pnl = 0  # in cents

for _ in range(10000):
    float_pnl += 0.01
    int_pnl += 1  # 1 cent

expected = 100.00  # $100.00
int_pnl_dollars = int_pnl / 100.0

print(f"  Float PnL after 10,000 x $0.01: ${float_pnl:.20f}")
print(f"  Integer PnL (cents): {int_pnl} -> ${int_pnl_dollars:.2f}")
print(f"  Expected: ${expected:.2f}")
print(f"  Float matches expected? {float_pnl == expected}")
print(f"  Integer matches expected? {int_pnl == 10000}")
print(f"  Float error: ${abs(float_pnl - expected):.20e}")
print()

# --- Part C: Larger accumulation (1,000,000 trades) ---
print("Part C: Larger accumulation (1,000,000 trades)")
print("------------------------------------------------------------")
float_pnl_large = 0.0
int_pnl_large = 0

for _ in range(1000000):
    float_pnl_large += 0.01
    int_pnl_large += 1

expected_large = 10000.00
print(f"  Float PnL after 1M x $0.01: ${float_pnl_large:.20f}")
print(f"  Integer PnL: {int_pnl_large} cents -> ${int_pnl_large / 100.0:.2f}")
print(f"  Expected: ${expected_large:.2f}")
print(f"  Float matches? {float_pnl_large == expected_large}")
print(f"  Integer matches? {int_pnl_large == 1000000}")
print(f"  Float error: ${abs(float_pnl_large - expected_large):.20e}")
print()

# --- Part D: Does integer guarantee $0.00 discrepancy? ---
print("Part D: Testing R2 Claim 11 - '$0.00 discrepancy is guaranteed' with integers")
print("------------------------------------------------------------")
# Case where integer scaling can introduce its own rounding issue
# Dividing 1/3 in cents: 100 cents / 3 = 33 cents (truncated)
# 33 * 3 = 99 cents, not 100 cents
amount = 100  # 100 cents = $1.00
split_3 = amount // 3  # integer division = 33
reassembled = split_3 * 3  # 99 cents

print(f"  $1.00 split 3 ways (integer): {split_3} cents each")
print(f"  Reassembled: {reassembled} cents")
print(f"  Lost: {amount - reassembled} cent(s)")
print(f"  $0.00 discrepancy? {reassembled == amount}")
print()
print("  CONCLUSION: Integers eliminate BINARY REPRESENTATION error,")
print("  but integer division/rounding can still cause discrepancies.")
print("  R2's claim of '$0.00 discrepancy is guaranteed' is too absolute.")
print()

print("============================================================")
print("What this tests:")
print("  - R2 Claim 8:  Float rounding errors accumulate over many ops")
print("  - R2 Claim 11: 'With integers, $0.00 discrepancy is guaranteed'")
print("    (shown to be too absolute when division is involved)")
print("============================================================")
