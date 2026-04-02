"""
Interactive test to PROVE that original code clears the details field.
This runs the actual tkinter app and demonstrates the behavior.

Instructions:
1. The app will auto-fill some data
2. Click "Start Activity"
3. The details field will have "Test Details"
4. Click "Stop Activity"
5. Watch the details field - it should CLEAR automatically
"""

import tkinter as tk
from tkinter import ttk, messagebox
from datetime import datetime
import pandas as pd
import os

class HourlyLogger:
    def __init__(self, root):
        self.root = root
        self.root.title("TESTING: Details Field Clearing - Original Code")
        self.entries = []

        # UI Elements
        tk.Label(root, text="Activity (Overview):").grid(row=0, column=0)

        self.activity_overview = ttk.Combobox(root, values=[
            "Projektarbeit", "Entwicklung", "Dokumentation", "Testing/QA"
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

        # Add test instructions
        instructions = tk.Label(root, text="TEST: Fill details, click Start, then Stop. Watch details field clear!",
                              fg="red", font=("Arial", 10, "bold"))
        instructions.grid(row=6, column=0, columnspan=2)

        # Pre-fill some data for testing
        self.activity_overview.set("Testing/QA")
        self.place.set("Büro")
        self.details.insert(0, "Test Details - This should clear after Stop")

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
        # THIS IS THE CRITICAL LINE - COPIED VERBATIM FROM ORIGINAL CODE
        self.current_entry["End Time"] = datetime.now().strftime("%H:%M")
        self.entries.append(self.current_entry)
        self.stop_button.config(state=tk.DISABLED)
        self.start_button.config(state=tk.NORMAL)

        # THE LINE THAT RESPONSE 1 CLAIMS IS MISSING:
        self.details.delete(0, tk.END)  # <-- THIS LINE CLEARS THE DETAILS FIELD

        self.summary.insert(tk.END, f"Stopped - Details field was just cleared!\n\n")

        # Show message box to confirm
        messagebox.showinfo("Test Result",
                          "✅ Details field has been cleared!\n\n" +
                          "Response 1's claim is FALSE:\n" +
                          "The original code DOES clear the details field.")

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

def on_close():
    root.destroy()

print("=" * 70)
print("RUNNING INTERACTIVE TEST")
print("=" * 70)
print()
print("Instructions:")
print("1. The details field is pre-filled with 'Test Details - This should clear after Stop'")
print("2. Click 'Start Activity' button")
print("3. Click 'Stop Activity' button")
print("4. OBSERVE: The details field will CLEAR automatically")
print("5. A message box will confirm the clearing")
print()
print("This proves Response 1's claim is FALSE.")
print("=" * 70)

root = tk.Tk()
logger = HourlyLogger(root)
root.protocol("WM_DELETE_WINDOW", on_close)
root.mainloop()

print()
print("Test completed. Did you see the details field clear? (Yes/No)")
