"""
Test AOI #2: Verify how original code's calculate_duration handles midnight crossing.
This uses VERBATIM code from original_user_code.py calculate_duration method.
"""

from datetime import datetime

# VERBATIM CODE FROM original_user_code.py lines 137-145
def calculate_duration(start, end):

    start_time = datetime.strptime(start, "%H:%M")

    end_time = datetime.strptime(end, "%H:%M")

    duration = (end_time - start_time).seconds / 3600

    return round(duration, 2)

print("=" * 70)
print("TESTING ORIGINAL CODE: calculate_duration METHOD")
print("=" * 70)
print()
print("VERBATIM CODE FROM ORIGINAL (lines 137-145):")
print("-" * 70)
print("""def calculate_duration(start, end):

    start_time = datetime.strptime(start, "%H:%M")

    end_time = datetime.strptime(end, "%H:%M")

    duration = (end_time - start_time).seconds / 3600

    return round(duration, 2)""")
print("-" * 70)
print()

# Test Case 1: Same day (normal case)
print("TEST CASE 1: Same day - 10:00 to 14:30")
result1 = calculate_duration("10:00", "14:30")
print(f"Result: {result1} hours")
print(f"Expected: 4.5 hours")
print(f"Status: {'✅ PASS' if result1 == 4.5 else '❌ FAIL'}")
print()

# Test Case 2: Midnight crossing - 23:30 to 00:30
print("TEST CASE 2: Midnight crossing - 23:30 to 00:30")
start_str, end_str = "23:30", "00:30"

# Show what happens step by step
start_time = datetime.strptime(start_str, "%H:%M")
end_time = datetime.strptime(end_str, "%H:%M")
print(f"start_time parsed: {start_time}")
print(f"end_time parsed: {end_time}")

delta = end_time - start_time
print(f"timedelta: {delta}")
print(f"  delta.days: {delta.days}")
print(f"  delta.seconds: {delta.seconds}")
print(f"  delta.total_seconds(): {delta.total_seconds()}")

result2 = calculate_duration(start_str, end_str)
print(f"\nResult using original code: {result2} hours")
print(f"Expected: 1.0 hours (from 23:30 to 00:30 next day)")
print()

# Explain the issue
print("=" * 70)
print("ANALYSIS:")
print("=" * 70)
print()
print("When parsing '23:30' and '00:30' as '%H:%M', both get date 1900-01-01:")
print(f"  start_time = {start_time}")
print(f"  end_time   = {end_time}")
print()
print("Since 00:30 < 23:30 on the SAME DAY, timedelta is NEGATIVE:")
print(f"  timedelta = {delta} (which is -1 day + 1 hour)")
print()
print("The .seconds attribute returns ONLY the seconds component (ignoring days):")
print(f"  .seconds = {delta.seconds} seconds = {delta.seconds / 3600} hours")
print()
print("This gives 1.0 hours, which LOOKS correct but for the WRONG reason!")
print("It's only correct by accident because we're using .seconds instead of .total_seconds()")
print()
print("Response 1's explanation is IMPRECISE:")
print("  It says 'calculate_duration ignores the date' - TRUE")
print("  It says 'assumes the same day for start & end' - TRUE")
print("  But it doesn't explain WHY this accidentally works with .seconds")
print()
print("=" * 70)
