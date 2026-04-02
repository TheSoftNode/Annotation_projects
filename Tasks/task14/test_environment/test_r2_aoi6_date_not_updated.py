"""
Test to prove Response 2's Date field is not updated for overnight activities.

Response 2 captures the Date at start_activity but never updates it in stop_activity.
For activities that cross midnight, the exported record shows the start date, not
reflecting that the activity ended on a different day.
"""

from datetime import datetime, timedelta

print("="*70)
print("RESPONSE 2 AOI #6: DATE FIELD NOT UPDATED FOR OVERNIGHT ACTIVITIES")
print("="*70)

# Simulate Response 2's behavior
class ActivitySimulation:
    def __init__(self):
        self.current_entry = None

    def start_activity(self, start_datetime):
        """VERBATIM logic from Response 2 start_activity"""
        print(f"\n[START_ACTIVITY] Called at {start_datetime}")

        # VERBATIM from RESPONSE_2.md: Date is captured once here
        self.current_entry = {
            "Date": start_datetime.strftime("%Y-%m-%d"),
            "Place": "Office",
            "Activity (Overview)": "Late night work",
            "Start Time": start_datetime.strftime("%H:%M"),
            "End Time": "",
            "Activity (Details)": "Working late"
        }

        print(f"  Date captured: {self.current_entry['Date']}")
        print(f"  Start Time: {self.current_entry['Start Time']}")

    def stop_activity(self, end_datetime):
        """VERBATIM logic from Response 2 stop_activity"""
        print(f"\n[STOP_ACTIVITY] Called at {end_datetime}")

        # VERBATIM from RESPONSE_2.md: Only End Time is updated, NOT Date
        end_time_str = end_datetime.strftime("%H:%M")
        self.current_entry["End Time"] = end_time_str

        print(f"  End Time updated: {end_time_str}")
        print(f"  Date field: {self.current_entry['Date']} (NOT UPDATED!)")

        # Calculate duration (Response 2's midnight logic works correctly)
        start_time = datetime.strptime(self.current_entry["Start Time"], "%H:%M")
        end_time = datetime.strptime(end_time_str, "%H:%M")
        diff_seconds = (end_time - start_time).total_seconds()
        if diff_seconds < 0:
            diff_seconds += 24 * 3600
        duration = diff_seconds / 3600

        print(f"  Duration calculated: {duration:.2f} hours")

        return self.current_entry

# TEST CASE: Overnight activity
print("\n" + "="*70)
print("TEST CASE: Activity crosses midnight")
print("="*70)

sim = ActivitySimulation()

# Start on April 1st at 23:45
start_dt = datetime(2025, 4, 1, 23, 45)
sim.start_activity(start_dt)

# Stop on April 2nd at 00:30 (next day!)
end_dt = datetime(2025, 4, 2, 0, 30)
final_entry = sim.stop_activity(end_dt)

print("\n" + "="*70)
print("WHAT GETS EXPORTED TO EXCEL:")
print("="*70)
for key, value in final_entry.items():
    print(f"  {key}: {value}")

print("\n" + "="*70)
print("THE PROBLEM:")
print("="*70)
print(f"✗ Activity started: {start_dt.strftime('%Y-%m-%d %H:%M')} (April 1st)")
print(f"✗ Activity ended: {end_dt.strftime('%Y-%m-%d %H:%M')} (April 2nd)")
print(f"✗ Date in export: {final_entry['Date']} (April 1st - WRONG!)")
print(f"✗ The Date field shows April 1st, not April 2nd when it ended")
print(f"✗ Excel record is INACCURATE for overnight activities")
print(f"✓ Duration is correct: {(end_dt - start_dt).total_seconds() / 3600:.2f} hours")
print("\n" + "="*70)
print("CONCLUSION:")
print("="*70)
print("Response 2 captures Date at start_activity but never updates it.")
print("For overnight activities, the exported record shows the WRONG date.")
print("="*70)
