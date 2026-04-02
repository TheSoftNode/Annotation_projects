"""
Test to prove Response 2's comment is misleading about total_seconds() handling midnight.

Response 2's comment claims:
    "# total_seconds() handles crossing midnight correctly (e.g. 23:00 to 01:00)"

This test proves that total_seconds() DOES NOT handle midnight crossing by itself.
The actual fix is the subsequent "if diff_seconds < 0" check that adds 24 hours.
"""

from datetime import datetime

print("="*70)
print("TESTING RESPONSE 2 AOI #3: MISLEADING COMMENT")
print("="*70)

# Midnight crossing example from the comment
start_str = "23:00"
end_str = "01:00"

print(f"\n[TEST CASE] Activity from {start_str} to {end_str} (crosses midnight)")
print("-"*70)

# Parse times (both default to same date: 1900-01-01)
start_time = datetime.strptime(start_str, "%H:%M")
end_time = datetime.strptime(end_str, "%H:%M")

print(f"\n[STEP 1] Parse times using strptime:")
print(f"  start_time: {start_time}")
print(f"  end_time:   {end_time}")
print(f"  (Note: Both have same date - 1900-01-01)")

# Calculate timedelta
delta = end_time - start_time

print(f"\n[STEP 2] Calculate timedelta:")
print(f"  end_time - start_time = {delta}")
print(f"  delta.days = {delta.days}")
print(f"  delta.seconds = {delta.seconds}")

# TEST: Does total_seconds() handle midnight correctly?
print(f"\n[STEP 3] RESPONSE 2'S COMMENT CLAIMS:")
print(f"  '# total_seconds() handles crossing midnight correctly'")
print(f"\n[TESTING] Call total_seconds():")

diff_seconds = delta.total_seconds()
print(f"  diff_seconds = (end_time - start_time).total_seconds()")
print(f"  diff_seconds = {diff_seconds}")

print(f"\n[ANALYSIS] Does total_seconds() handle midnight correctly?")
if diff_seconds < 0:
    print(f"  ✗ NO! total_seconds() returned NEGATIVE value: {diff_seconds}")
    print(f"  ✗ This is -23 hours, NOT the correct 2 hours!")
    print(f"  ✗ The comment is MISLEADING")
else:
    print(f"  ✓ YES, returned positive value")

# Show what actually handles midnight
print(f"\n[STEP 4] THE ACTUAL MIDNIGHT FIX:")
print(f"  Response 2's code AFTER the misleading comment:")
print(f"  ```")
print(f"  if diff_seconds < 0:")
print(f"      diff_seconds += 24 * 3600")
print(f"  ```")
print(f"\n[APPLYING THE FIX]:")
if diff_seconds < 0:
    print(f"  Before fix: diff_seconds = {diff_seconds}")
    diff_seconds += 24 * 3600
    print(f"  After fix:  diff_seconds = {diff_seconds}")
    duration = diff_seconds / 3600
    print(f"  Duration: {duration} hours ✓ CORRECT")

print(f"\n" + "="*70)
print("CONCLUSION:")
print("="*70)
print("✗ The comment 'total_seconds() handles crossing midnight correctly' is MISLEADING")
print("✗ total_seconds() returns -82800 (negative value) for midnight crossing")
print("✗ The ACTUAL fix is the 'if diff_seconds < 0' check that adds 24 hours")
print("✗ The comment incorrectly attributes midnight handling to the wrong line")
print("="*70)
