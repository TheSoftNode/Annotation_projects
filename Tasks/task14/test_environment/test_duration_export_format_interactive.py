"""
Interactive GUI test to verify Response 1 exports duration as decimal float, not HH:MM.
Start and stop activities to see what format gets exported to Excel.
"""
import tkinter as tk
from tkinter import ttk
from datetime import datetime

# VERBATIM duration_hours function from RESPONSE_1.md lines 118-120
def duration_hours(start: datetime, end: datetime) -> float:
    """Return hours as a float with two‑decimal precision."""
    return round((end - start).total_seconds() / 3600, 2)

class DurationFormatTest:
    def __init__(self, root):
        self.root = root
        self.root.title("Response 1 - Duration Export Format Test")
        self.root.geometry("700x500")

        self.start_time = None
        self.entries = []

        print("\n" + "="*70)
        print("INTERACTIVE DURATION EXPORT FORMAT TEST - RESPONSE 1")
        print("="*70)
        print("\n[SETUP] Creating GUI to test duration export format...")

        # Title
        title = tk.Label(root, text="Response 1 - Duration Export Format Test",
                        font=("Arial", 14, "bold"), fg="darkblue")
        title.pack(pady=10)

        # Instructions
        instructions = tk.Label(root,
                               text="Start an activity, wait a few seconds, then stop it.\n"
                                    "Watch the terminal to see the export format!",
                               font=("Arial", 10), fg="blue")
        instructions.pack(pady=5)

        # Activity input
        frame = tk.Frame(root)
        frame.pack(pady=20)

        tk.Label(frame, text="Activity:", font=("Arial", 10)).grid(row=0, column=0, padx=5)
        self.activity_entry = tk.Entry(frame, width=30)
        self.activity_entry.insert(0, "Test Activity")
        self.activity_entry.grid(row=0, column=1, padx=5)

        # Timer display
        self.timer_label = tk.Label(root, text="Not started", font=("Arial", 12, "bold"))
        self.timer_label.pack(pady=10)

        # Buttons
        btn_frame = tk.Frame(root)
        btn_frame.pack(pady=20)

        self.start_btn = tk.Button(btn_frame, text="▶ Start", command=self.start_activity,
                                   bg="green", fg="white", font=("Arial", 12, "bold"), width=15)
        self.start_btn.grid(row=0, column=0, padx=10)

        self.stop_btn = tk.Button(btn_frame, text="⏹ Stop", command=self.stop_activity,
                                 bg="red", fg="white", font=("Arial", 12, "bold"), width=15, state=tk.DISABLED)
        self.stop_btn.grid(row=0, column=1, padx=10)

        # Export preview
        preview_label = tk.Label(root, text="What would be exported to Excel:",
                                font=("Arial", 10, "bold"))
        preview_label.pack(pady=10)

        self.export_text = tk.Text(root, width=80, height=10, font=("Courier", 9))
        self.export_text.pack(pady=5)

        print("[SETUP COMPLETE] Start an activity and stop it to see export format")
        print("="*70 + "\n")

    def start_activity(self):
        self.start_time = datetime.now()
        activity = self.activity_entry.get()

        print(f"\n[USER ACTION] Started activity: '{activity}'")
        print(f"[LOG] Start time: {self.start_time.strftime('%H:%M:%S')}")
        print(f"[LOG] Timer started...")

        self.start_btn.config(state=tk.DISABLED)
        self.stop_btn.config(state=tk.NORMAL)
        self.update_timer()

    def update_timer(self):
        if self.start_time:
            elapsed = (datetime.now() - self.start_time).total_seconds()
            minutes = int(elapsed // 60)
            seconds = int(elapsed % 60)
            self.timer_label.config(text=f"Running: {minutes:02d}:{seconds:02d}")
            self.root.after(1000, self.update_timer)

    def stop_activity(self):
        if not self.start_time:
            return

        end_time = datetime.now()
        activity = self.activity_entry.get()

        # VERBATIM calculation from RESPONSE_1.md
        duration_float = duration_hours(self.start_time, end_time)

        # Calculate what HH:MM would be
        total_seconds = (end_time - self.start_time).total_seconds()
        hours = int(total_seconds // 3600)
        minutes = int((total_seconds % 3600) // 60)
        duration_hhmm = f"{hours:02d}:{minutes:02d}"

        print(f"\n[USER ACTION] Stopped activity: '{activity}'")
        print(f"[LOG] End time: {end_time.strftime('%H:%M:%S')}")
        print(f"[LOG] Calculating duration using VERBATIM Response 1 code...")
        print(f"[LOG] duration_hours(start, end) = {duration_float}")

        # VERBATIM entry structure from RESPONSE_1.md lines 420-427
        entry = {
            "Date": self.start_time.strftime("%Y-%m-%d"),
            "Place": "Office",
            "Activity (Overview)": activity,
            "Duration": duration_float,  # THIS IS THE ISSUE - FLOAT not HH:MM
            "Start Time": self.start_time.strftime("%H:%M"),
            "End Time": end_time.strftime("%H:%M"),
            "Activity (Details)": "Test entry",
        }

        self.entries.append(entry)

        print("\n" + "="*70)
        print("WHAT GETS EXPORTED TO EXCEL:")
        print("="*70)
        for key, value in entry.items():
            print(f"  '{key}': {repr(value)}")

        print("\n" + "="*70)
        print("ISSUE DEMONSTRATION:")
        print("="*70)
        print(f"✗ Duration field contains: {repr(duration_float)} (FLOAT)")
        print(f"✗ Excel will display: '{duration_float}' hours")
        print(f"✗ HH:MM format would be: '{duration_hhmm}'")
        print(f"✗ User sees '{duration_float}' instead of '{duration_hhmm}' in Excel")
        print("✗ Less intuitive - requires manual mental conversion")
        print("="*70 + "\n")

        # Update GUI display
        self.export_text.delete(1.0, tk.END)
        export_display = f"EXPORTED TO EXCEL:\n{'-'*70}\n"
        for i, e in enumerate(self.entries, 1):
            export_display += f"\nEntry {i}:\n"
            export_display += f"  Date: {e['Date']}\n"
            export_display += f"  Activity: {e['Activity (Overview)']}\n"
            export_display += f"  Duration: {e['Duration']} hours  ← DECIMAL FLOAT\n"
            export_display += f"  Start: {e['Start Time']}, End: {e['End Time']}\n"

            # Show what HH:MM would be
            total_sec = e['Duration'] * 3600
            hrs = int(total_sec // 3600)
            mins = int((total_sec % 3600) // 60)
            export_display += f"  (Would be {hrs:02d}:{mins:02d} in HH:MM format)\n"

        export_display += f"\n{'-'*70}\n"
        export_display += "ISSUE: Duration shown as decimal (4.5) not HH:MM (04:30)\n"

        self.export_text.insert(1.0, export_display)

        self.timer_label.config(text=f"Stopped - Duration: {duration_float} hours ({duration_hhmm} in HH:MM)")
        self.start_btn.config(state=tk.NORMAL)
        self.stop_btn.config(state=tk.DISABLED)
        self.start_time = None

root = tk.Tk()
app = DurationFormatTest(root)
root.mainloop()
