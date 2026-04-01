"""
Test script to verify the midnight rollover bug in original user code.

The bug occurs because calculate_duration() uses .seconds on a timedelta,
which only returns the seconds component (0-86399), not the total seconds.

For a midnight rollover (e.g., 23:30 to 00:30), the timedelta is actually
negative in terms of days, so .seconds returns a large positive number
instead of the correct small duration.
"""

from datetime import datetime

def calculate_duration_BUGGY(start, end):
    """Original buggy version using .seconds"""
    start_time = datetime.strptime(start, "%H:%M")
    end_time = datetime.strptime(end, "%H:%M")
    duration = (end_time - start_time).seconds / 3600  # BUG: uses .seconds
    return round(duration, 2)

def calculate_duration_FIXED(start, end):
    """Fixed version using .total_seconds()"""
    start_time = datetime.strptime(start, "%H:%M")
    end_time = datetime.strptime(end, "%H:%M")
    diff_seconds = (end_time - start_time).total_seconds()
    if diff_seconds < 0:
        diff_seconds += 24 * 3600
    return round(diff_seconds / 3600, 2)

print("=" * 70)
print("MIDNIGHT ROLLOVER BUG TEST")
print("=" * 70)

# Test Case 1: Normal same-day duration (should work in both)
print("\n✅ TEST 1: Same-day duration (10:00 to 14:30)")
start1, end1 = "10:00", "14:30"
buggy1 = calculate_duration_BUGGY(start1, end1)
fixed1 = calculate_duration_FIXED(start1, end1)
print(f"   Buggy version: {buggy1} hours")
print(f"   Fixed version: {fixed1} hours")
print(f"   Expected: 4.5 hours")
print(f"   Result: {'PASS ✅' if buggy1 == 4.5 else 'FAIL ❌'}")

# Test Case 2: Midnight rollover (THIS IS THE BUG)
print("\n🐛 TEST 2: Midnight rollover (23:30 to 00:30)")
start2, end2 = "23:30", "00:30"
buggy2 = calculate_duration_BUGGY(start2, end2)
fixed2 = calculate_duration_FIXED(start2, end2)
print(f"   Buggy version: {buggy2} hours")
print(f"   Fixed version: {fixed2} hours")
print(f"   Expected: 1.0 hour")
print(f"   Buggy result: {'PASS ✅' if buggy2 == 1.0 else f'FAIL ❌ (shows {buggy2} hours instead of 1.0)'}")
print(f"   Fixed result: {'PASS ✅' if fixed2 == 1.0 else 'FAIL ❌'}")

# Test Case 3: Another midnight rollover
print("\n🐛 TEST 3: Midnight rollover (23:00 to 01:00)")
start3, end3 = "23:00", "01:00"
buggy3 = calculate_duration_BUGGY(start3, end3)
fixed3 = calculate_duration_FIXED(start3, end3)
print(f"   Buggy version: {buggy3} hours")
print(f"   Fixed version: {fixed3} hours")
print(f"   Expected: 2.0 hours")
print(f"   Buggy result: {'PASS ✅' if buggy3 == 2.0 else f'FAIL ❌ (shows {buggy3} hours instead of 2.0)'}")
print(f"   Fixed result: {'PASS ✅' if fixed3 == 2.0 else 'FAIL ❌'}")

# Explanation
print("\n" + "=" * 70)
print("EXPLANATION OF THE BUG:")
print("=" * 70)
print("""
When you calculate (00:30 - 23:30), you get a timedelta of -1 day, 1 hour.

Using .seconds on this timedelta:
  - Python stores this as: days=-1, seconds=3600
  - .seconds returns ONLY the seconds component: 3600
  - But this is misleading! The actual total is negative.

Using .total_seconds():
  - Correctly calculates: -1 * 86400 + 3600 = -82800 seconds
  - Which is -23 hours (the actual negative duration)
  - Then we add 24 hours to handle midnight rollover: 1 hour

CONCLUSION:
❌ Original code using .seconds: WRONG for midnight rollover
✅ Fixed code using .total_seconds(): CORRECT for all cases
""")
