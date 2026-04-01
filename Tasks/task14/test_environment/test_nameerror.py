"""
Test script to verify the NameError bug in original user code.

The bug occurs because on_close() is defined BEFORE logger is created,
but it references 'logger' inside the function.

When the user clicks the close button, Python tries to execute on_close(),
which then tries to access 'logger', but logger doesn't exist in the
on_close() function's scope.
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

# **BUG IS HERE: on_close() is defined BEFORE logger is created**
# When Python tries to execute on_close(), 'logger' doesn't exist in its scope
def on_close():
    if messagebox.askyesno("Exit", "Export data before exiting?"):
        logger.export_to_excel()  # ❌ NameError: name 'logger' is not defined
    root.destroy()

# **Run the app**
root = tk.Tk()
logger = HourlyLogger(root)
root.protocol("WM_DELETE_WINDOW", on_close)

print("✅ App launched successfully!")
print("🐛 BUG TEST: Try closing the window - you should see a NameError")
print("   Error will be: NameError: name 'logger' is not defined")

root.mainloop()
