"""
Test Response 1's duration calculation to verify it handles midnight correctly
"""

from datetime import datetime

def duration_hours(start: datetime, end: datetime) -> float:
    """Response 1's helper function"""
    return round((end - start).total_seconds() / 3600, 2)

print("=" * 70)
print("RESPONSE 1 DURATION CALCULATION TEST")
print("=" * 70)

# Test Case 1: Same day
print("\n✅ TEST 1: Same day (10:00 to 14:30)")
start1 = datetime(2025, 4, 1, 10, 0)
end1 = datetime(2025, 4, 1, 14, 30)
result1 = duration_hours(start1, end1)
print(f"   Result: {result1} hours")
print(f"   Expected: 4.5 hours")
print(f"   Status: {'PASS ✅' if result1 == 4.5 else 'FAIL ❌'}")

# Test Case 2: Midnight rollover
print("\n🌙 TEST 2: Midnight rollover (23:30 to 00:30)")
start2 = datetime(2025, 4, 1, 23, 30)
end2 = datetime(2025, 4, 2, 0, 30)  # Next day!
result2 = duration_hours(start2, end2)
print(f"   Result: {result2} hours")
print(f"   Expected: 1.0 hour")
print(f"   Status: {'PASS ✅' if result2 == 1.0 else 'FAIL ❌'}")

# Test Case 3: Another midnight rollover
print("\n🌙 TEST 3: Midnight rollover (23:00 to 01:00)")
start3 = datetime(2025, 4, 1, 23, 0)
end3 = datetime(2025, 4, 2, 1, 0)  # Next day!
result3 = duration_hours(start3, end3)
print(f"   Result: {result3} hours")
print(f"   Expected: 2.0 hours")
print(f"   Status: {'PASS ✅' if result3 == 2.0 else 'FAIL ❌'}")

print("\n" + "=" * 70)
print("EXPLANATION:")
print("=" * 70)
print("""
Response 1's approach stores FULL datetime objects (Start DateTime, End DateTime)
instead of just time strings. This means:

1. start_activity() stores: self.active["Start DateTime"] = datetime.now()
2. stop_activity() stores: self.active["End DateTime"] = datetime.now()
3. duration_hours() calculates: (end - start).total_seconds() / 3600

This correctly handles midnight crossing because the datetime objects include
the DATE component. So 2025-04-01 23:30 - 2025-04-02 00:30 = 1 hour.

Result: ✅ CORRECT - Response 1 fixes the midnight bug properly
""")
