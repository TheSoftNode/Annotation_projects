"""
Test to prove Response 2's NameError bug claim is FALSE.

Response 2 claims: "on_close() tries to use logger, but logger isn't defined
until after the function is defined. This will crash the app when you try to
close it."

This test proves that claim is WRONG. Python uses LATE BINDING for global
variables - functions look up global names when EXECUTED, not when DEFINED.

Since logger is defined BEFORE the user closes the window (and thus BEFORE
on_close() executes), NO NameError occurs. The original code works correctly.

VERBATIM structure from original user code:
1. on_close() is defined (references logger inside)
2. root and logger are created
3. root.protocol registers on_close
4. When user closes window, on_close() executes and finds logger in globals
"""

import tkinter as tk
from tkinter import ttk, messagebox
from datetime import datetime
import pandas as pd
import os

class HourlyLogger:
    def __init__(self, root):
        self.root = root
        self.root.title("Hourly Activity Logger")
        self.entries = []

        # UI Elements
        tk.Label(root, text="Activity (Overview):").grid(row=0, column=0)
        self.activity_overview = ttk.Combobox(root, values=[
            "Projektarbeit", "Entwicklung", "Dokumentation", "Forschung & Analyse", "Testing/QA", "Code-Review",
            "Support", "Kundenservice",
            "--------------------",
            "Besprechung", "Meeting", "Team-Update", "Koordination", "Abstimmung", "Präsentation",
            "E-Mail-Kommunikation", "Video-Konferenz",
            "--------------------",
            "Pause", "Mittagspause", "Sport / Bewegung", "Meditation / Entspannung",
            "--------------------",
            "Software-Installation", "Systemwartung", "Datenbank-Management", "Sicherheitsprüfung",
            "--------------------",
            "Verwaltung", "Berichte schreiben", "Zeiterfassung", "Planung & Organisation",
            "--------------------",
            "Schulung / Weiterbildung", "Recherche", "Telefonat", "Sonstiges"
        ])
        self.activity_overview.grid(row=0, column=1)

        tk.Label(root, text="Place:").grid(row=1, column=0)
        self.place = ttk.Combobox(root, values=["Büro", "Homeoffice", "Unterwegs"])
        self.place.grid(row=1, column=1)

        tk.Label(root, text="Details:").grid(row=2, column=0)
        self.details = tk.Entry(root, width=30)
        self.details.grid(row=2, column=1)

        self.start_button = tk.Button(root, text="Start Activity", command=self.start_activity)
        self.start_button.grid(row=3, column=0, columnspan=2)

        self.stop_button = tk.Button(root, text="Stop Activity", command=self.stop_activity, state=tk.DISABLED)
        self.stop_button.grid(row=4, column=0, columnspan=2)

        # Summary Table
        self.summary = tk.Text(root, height=10, width=60)
        self.summary.grid(row=5, column=0, columnspan=2)

    def start_activity(self):
        self.current_entry = {
            "Date": datetime.now().strftime("%Y-%m-%d"),
            "Place": self.place.get(),
            "Activity (Overview)": self.activity_overview.get(),
            "Start Time": datetime.now().strftime("%H:%M"),
            "End Time": "",
            "Activity (Details)": self.details.get()
        }
        self.stop_button.config(state=tk.NORMAL)
        self.start_button.config(state=tk.DISABLED)
        self.summary.insert(tk.END,
                            f"Started: {self.current_entry['Activity (Overview)']} at {self.current_entry['Start Time']}\n")

    def stop_activity(self):
        self.current_entry["End Time"] = datetime.now().strftime("%H:%M")
        self.entries.append(self.current_entry)
        self.stop_button.config(state=tk.DISABLED)
        self.start_button.config(state=tk.NORMAL)
        self.details.delete(0, tk.END)
        duration = self.calculate_duration(self.current_entry["Start Time"], self.current_entry["End Time"])
        self.summary.insert(tk.END, f"Stopped: Duration: {duration} hours\n\n")

    def calculate_duration(self, start, end):
        start_time = datetime.strptime(start, "%H:%M")
        end_time = datetime.strptime(end, "%H:%M")
        duration = (end_time - start_time).seconds / 3600
        return round(duration, 2)

    def export_to_excel(self):
        if not self.entries:
            messagebox.showwarning("No Data", "No entries to export!")
            return
        df = pd.DataFrame(self.entries)
        df["Duration"] = df.apply(lambda row: self.calculate_duration(row["Start Time"], row["End Time"]), axis=1)
        df = df[["Date", "Place", "Activity (Overview)", "Duration", "Start Time", "End Time", "Activity (Details)"]]
        output_path = os.path.join(os.getcwd(), "weekly_protocol.xlsx")
        df.to_excel(output_path, index=False)
        messagebox.showinfo("Exported", f"Saved to {output_path}")

# VERBATIM original user code structure: on_close() defined BEFORE logger
def on_close():
    print("\n[EXECUTION] on_close() is now executing...")
    print("[LATE BINDING] Looking up 'logger' in global namespace...")
    print(f"[LATE BINDING] Found logger: {logger}")
    print("[LATE BINDING] No NameError! Python's late binding works.")

    if messagebox.askyesno("Exit", "Export data before exiting?"):
        print("[ACTION] User clicked 'Yes' - calling logger.export_to_excel()")
        logger.export_to_excel()
    else:
        print("[ACTION] User clicked 'No' - skipping export")

    print("[RESULT] ✓ on_close() executed successfully with NO NameError")
    root.destroy()

print("\n" + "="*70)
print("TESTING RESPONSE 2'S FALSE NAMEERROR CLAIM")
print("="*70)
print("\n[STEP 1] Defining on_close() function...")
print("           (function references 'logger' which doesn't exist yet)")

# Run the app
root = tk.Tk()
print("\n[STEP 2] Created tk.Tk() root window")

logger = HourlyLogger(root)
print("[STEP 3] Created HourlyLogger instance - 'logger' NOW EXISTS in globals")

root.protocol("WM_DELETE_WINDOW", on_close)
print("[STEP 4] Registered on_close() as window close handler")

print("\n" + "="*70)
print("APP LAUNCHED SUCCESSFULLY - NO ERROR SO FAR")
print("="*70)
print("\n[INSTRUCTION] Close the window to test if NameError occurs...")
print("[PREDICTION] NO NameError will occur - late binding will find 'logger'")
print("="*70 + "\n")

root.mainloop()
