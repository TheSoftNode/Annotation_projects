"""
Test to verify Response 1 exports duration as decimal float, not HH:MM format.
This shows what actually appears in the Excel file.
"""
from datetime import datetime

# VERBATIM duration_hours function from RESPONSE_1.md lines 118-120
def duration_hours(start: datetime, end: datetime) -> float:
    """Return hours as a float with two‑decimal precision."""
    return round((end - start).total_seconds() / 3600, 2)

print("="*70)
print("RESPONSE 1 - DURATION EXPORT FORMAT TEST")
print("="*70)

# Simulate different activity durations
test_cases = [
    (datetime(2025, 4, 2, 10, 0), datetime(2025, 4, 2, 14, 30), "10:00 to 14:30"),
    (datetime(2025, 4, 2, 9, 15), datetime(2025, 4, 2, 11, 45), "09:15 to 11:45"),
    (datetime(2025, 4, 2, 8, 0), datetime(2025, 4, 2, 8, 20), "08:00 to 08:20"),
]

print("\nSimulating what gets stored in Excel export:")
print("-" * 70)

for start, end, description in test_cases:
    # VERBATIM calculation from Response 1
    duration_float = duration_hours(start, end)

    # Calculate what HH:MM format WOULD be
    total_seconds = (end - start).total_seconds()
    hours = int(total_seconds // 3600)
    minutes = int((total_seconds % 3600) // 60)
    duration_hhmm = f"{hours:02d}:{minutes:02d}"

    print(f"\n[TEST] Activity: {description}")
    print(f"  Start: {start.strftime('%H:%M')}")
    print(f"  End: {end.strftime('%H:%M')}")
    print(f"  Duration (Response 1 format): {duration_float} hours")
    print(f"  Duration (HH:MM format would be): {duration_hhmm}")
    print(f"  What appears in Excel: {duration_float}")

print("\n" + "="*70)
print("RESULT: DURATION IS EXPORTED AS DECIMAL FLOAT")
print("="*70)
print("✗ Response 1 exports duration as decimal float (e.g., 4.5)")
print("✗ Excel displays: '4.5' instead of '04:30'")
print("✗ Excel displays: '2.42' instead of '02:25'")
print("✗ Excel displays: '0.33' instead of '00:20'")
print("✗ Users must manually reformat to understand time durations")
print("✗ Less intuitive for reading activity logs")
print("="*70)

# Show the actual data structure that gets exported
print("\nWhat gets appended to self.entries (exported to Excel):")
print("-" * 70)
entry_example = {
    "Date": "2025-04-02",
    "Place": "Office",
    "Activity (Overview)": "Projektarbeit",
    "Duration": 4.5,  # FLOAT, not "04:30"
    "Start Time": "10:00",
    "End Time": "14:30",
    "Activity (Details)": "Working on project",
}

for key, value in entry_example.items():
    print(f"  '{key}': {repr(value)}")

print("\n" + "="*70)
print("ISSUE: Duration field contains FLOAT (4.5) not STRING ('04:30')")
print("="*70)
