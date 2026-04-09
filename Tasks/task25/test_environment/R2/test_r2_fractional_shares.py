#!/usr/bin/env python3
# Test for R2 Claim 25: "You can't buy 1.5 shares (usually)."
# FINRA explicitly describes fractional-share investing.
# https://www.finra.org/investors/insights/investing-fractional-shares

print("============================================================")
print("R2 Claim 25: 'You can't buy 1.5 shares (usually)'")
print("============================================================")
print()

print("FINRA states:")
print("  'With fractional shares, you can buy a portion of a share")
print("   of stock... For example, if a share of stock costs $100,")
print("   but you only have $50 to invest, fractional shares would")
print("   allow you to buy half a share.'")
print()
print("Source: https://www.finra.org/investors/insights/investing-fractional-shares")
print()

print("Platforms supporting fractional shares include:")
print("  - Robinhood")
print("  - Fidelity")
print("  - Charles Schwab")
print("  - Interactive Brokers")
print()

print("Demonstration: fractional share quantities")
print("------------------------------------------------------------")
# Show that quantities are not always whole numbers
quantities = [0.5, 1.5, 0.1, 2.75, 0.001]
price_per_share = 150.00  # e.g., a stock at $150

for qty in quantities:
    cost = qty * price_per_share
    print(f"  Buy {qty} shares @ ${price_per_share:.2f} = ${cost:.2f}")

print()
print("If using int64_t for quantities (as R2 suggests),")
print("fractional shares would need scaled integer representation")
print("(e.g., 1.5 shares = 1500 milli-shares).")
print()

# Show the integer approach for fractional shares
print("Integer representation of fractional quantities:")
print("------------------------------------------------------------")
SHARE_SCALE = 1000  # milli-shares

for qty in quantities:
    int_qty = int(qty * SHARE_SCALE)
    print(f"  {qty} shares -> {int_qty} milli-shares (int)")

print()
print("CONCLUSION:")
print("  R2's claim 'You can't buy 1.5 shares (usually)' is")
print("  increasingly inaccurate. Fractional shares are now common")
print("  in retail trading. The '(usually)' qualifier helps but")
print("  understates how widespread fractional trading has become.")
print()

print("============================================================")
print("What this tests:")
print("  - R2 Claim 25: 'You can't buy 1.5 shares (usually)'")
print("  - Source: FINRA fractional shares documentation")
print("============================================================")
