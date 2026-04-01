"""
Detailed test to understand timedelta behavior with midnight rollover
"""

from datetime import datetime

print("=" * 70)
print("DETAILED TIMEDELTA ANALYSIS")
print("=" * 70)

# Test Case: Midnight rollover
start_str, end_str = "23:30", "00:30"
start_time = datetime.strptime(start_str, "%H:%M")
end_time = datetime.strptime(end_str, "%H:%M")

print(f"\nStart time: {start_str} → {start_time}")
print(f"End time: {end_str} → {end_time}")

# Calculate timedelta
delta = end_time - start_time
print(f"\nTimedelta: {delta}")
print(f"  days: {delta.days}")
print(f"  seconds: {delta.seconds}")
print(f"  total_seconds(): {delta.total_seconds()}")

# Calculate durations using both methods
duration_seconds = delta.seconds / 3600
duration_total = delta.total_seconds() / 3600

print(f"\nUsing .seconds / 3600: {duration_seconds} hours")
print(f"Using .total_seconds() / 3600: {duration_total} hours")

# The issue
print("\n" + "=" * 70)
print("THE ISSUE:")
print("=" * 70)
print(f"""
When parsing "23:30" and "00:30" as "%H:%M", datetime assumes 1900-01-01:
  start_time = 1900-01-01 23:30:00
  end_time   = 1900-01-01 00:30:00

Since 00:30 < 23:30 on the SAME DAY, the timedelta is NEGATIVE:
  delta = -1 day, 3600 seconds

This means: -86400 + 3600 = -82800 seconds total

.seconds returns ONLY the seconds component (ignoring days): 3600 seconds = 1 hour
.total_seconds() correctly calculates: -82800 seconds = -23 hours

BUT WAIT! In the original user code, they DON'T handle negative durations.
So if a user actually crosses midnight, they get:
  - Using .seconds: 3600 / 3600 = 1.0 (LOOKS correct but for WRONG reason)
  - Using .total_seconds(): -82800 / 3600 = -23.0 (NEGATIVE!)

The REAL fix needs to:
1. Use .total_seconds() to get accurate calculation
2. Check if result is negative (midnight crossing)
3. Add 24 hours to handle the rollover

Without step 3, BOTH methods fail for midnight crossing!
""")

# Correct fix
print("=" * 70)
print("CORRECT FIX:")
print("=" * 70)

def calculate_duration_correct(start, end):
    """Correct version that handles midnight rollover"""
    start_time = datetime.strptime(start, "%H:%M")
    end_time = datetime.strptime(end, "%H:%M")
    diff_seconds = (end_time - start_time).total_seconds()
    if diff_seconds < 0:
        diff_seconds += 24 * 3600  # Add 24 hours for midnight rollover
    return round(diff_seconds / 3600, 2)

result = calculate_duration_correct("23:30", "00:30")
print(f"Correct duration: {result} hours ✅")
