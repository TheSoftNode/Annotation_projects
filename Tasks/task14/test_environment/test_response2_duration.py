"""
Test Response 2's duration calculation to verify it handles midnight correctly
"""

from datetime import datetime

def calculate_duration_str(start, end):
    """Response 2's calculate_duration_str method"""
    fmt = "%H:%M"
    start_time = datetime.strptime(start, fmt)
    end_time = datetime.strptime(end, fmt)

    # total_seconds() handles crossing midnight correctly (e.g. 23:00 to 01:00)
    diff_seconds = (end_time - start_time).total_seconds()

    # Handle negative diff (if end time is technically next day but date didn't change)
    # Note: Since Date column is the same, this logic assumes single-day sessions mostly.
    # For robustness, if diff < 0, add 24 hours.
    if diff_seconds < 0:
        diff_seconds += 24 * 3600

    hours = int(diff_seconds // 3600)
    minutes = int((diff_seconds % 3600) // 60)
    return f"{hours:02d}:{minutes:02d}"

print("=" * 70)
print("RESPONSE 2 DURATION CALCULATION TEST")
print("=" * 70)

# Test Case 1: Same day
print("\n✅ TEST 1: Same day (10:00 to 14:30)")
result1 = calculate_duration_str("10:00", "14:30")
print(f"   Result: {result1}")
print(f"   Expected: 04:30")
print(f"   Status: {'PASS ✅' if result1 == '04:30' else 'FAIL ❌'}")

# Test Case 2: Midnight rollover
print("\n🌙 TEST 2: Midnight rollover (23:30 to 00:30)")
result2 = calculate_duration_str("23:30", "00:30")
print(f"   Result: {result2}")
print(f"   Expected: 01:00")
print(f"   Status: {'PASS ✅' if result2 == '01:00' else 'FAIL ❌'}")

# Test Case 3: Another midnight rollover
print("\n🌙 TEST 3: Midnight rollover (23:00 to 01:00)")
result3 = calculate_duration_str("23:00", "01:00")
print(f"   Result: {result3}")
print(f"   Expected: 02:00")
print(f"   Status: {'PASS ✅' if result3 == '02:00' else 'FAIL ❌'}")

# Test Case 4: Exact match (should be 0)
print("\n✅ TEST 4: Same time (10:00 to 10:00)")
result4 = calculate_duration_str("10:00", "10:00")
print(f"   Result: {result4}")
print(f"   Expected: 00:00")
print(f"   Status: {'PASS ✅' if result4 == '00:00' else 'FAIL ❌'}")

print("\n" + "=" * 70)
print("EXPLANATION:")
print("=" * 70)
print("""
Response 2's approach keeps time strings but properly handles midnight rollover:

1. Parses start and end as "%H:%M" (still uses default 1900-01-01 date)
2. Calculates diff_seconds = (end - start).total_seconds()
3. Checks if diff_seconds < 0 (indicating midnight crossing)
4. If negative, adds 24 * 3600 seconds to get correct duration
5. Converts to HH:MM format instead of float hours

This correctly handles midnight crossing despite using time-only parsing
because it explicitly checks for negative duration and adds 24 hours.

Result: ✅ CORRECT - Response 2 fixes the midnight bug properly
       ✅ BONUS - Returns HH:MM format which may be better for Excel
""")
