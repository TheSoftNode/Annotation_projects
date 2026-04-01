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

        self.current_entry = {}

        # --- UI Elements ---



        # 1. Activity (Overview)

        tk.Label(root, text="Activity (Overview):").grid(row=0, column=0, sticky="w", padx=5, pady=5)

        self.activity_overview = ttk.Combobox(root, values=[

            # Work Types

            "Projektarbeit", "Entwicklung", "Dokumentation", "Forschung & Analyse", "Testing/QA", "Code-Review",

            "Support", "Kundenservice",

            "--------------------",

            # Meetings & Communication

            "Besprechung", "Meeting", "Team-Update", "Koordination", "Abstimmung", "Präsentation",

            "E-Mail-Kommunikation", "Video-Konferenz",

            "--------------------",

            # Personal / Wellness

            "Pause", "Mittagspause", "Sport / Bewegung", "Meditation / Entspannung",

            "--------------------",

            # Technical Tasks

            "Software-Installation", "Systemwartung", "Datenbank-Management", "Sicherheitsprüfung",

            "--------------------",

            # Administrative Tasks

            "Verwaltung", "Berichte schreiben", "Zeiterfassung", "Planung & Organisation",

            "--------------------",

            # General / Other

            "Schulung / Weiterbildung", "Recherche", "Telefonat", "Sonstiges"

        ], state="readonly", width=40) # readonly prevents typos

        self.activity_overview.grid(row=0, column=1, sticky="ew", padx=5, pady=5)

        self.activity_overview.current(0) # Set a default value

        # 2. Place

        tk.Label(root, text="Place:").grid(row=1, column=0, sticky="w", padx=5, pady=5)

        self.place = ttk.Combobox(root, values=["Büro", "Homeoffice", "Unterwegs"], state="readonly", width=40)

        self.place.grid(row=1, column=1, sticky="ew", padx=5, pady=5)

        self.place.current(0) # Set a default value

        # 3. Details

        tk.Label(root, text="Details:").grid(row=2, column=0, sticky="w", padx=5, pady=5)

        self.details = tk.Entry(root, width=43)

        self.details.grid(row=2, column=1, sticky="ew", padx=5, pady=5)

        # 4. Buttons

        self.start_button = tk.Button(root, text="Start Activity", command=self.start_activity, bg="#dddddd")

        self.start_button.grid(row=3, column=0, columnspan=2, sticky="ew", padx=5, pady=5)

        self.stop_button = tk.Button(root, text="Stop Activity", command=self.stop_activity, state=tk.DISABLED, bg="#ffcccc")

        self.stop_button.grid(row=4, column=0, columnspan=2, sticky="ew", padx=5, pady=5)

        # 5. Export Button (New!)

        self.export_button = tk.Button(root, text="Export to Excel", command=self.export_to_excel, bg="#ccffcc")

        self.export_button.grid(row=5, column=0, columnspan=2, sticky="ew", padx=5, pady=5)

        # 6. Summary Log

        self.summary_label = tk.Label(root, text="Today's Log:", font=("Arial", 10, "bold"))

        self.summary_label.grid(row=6, column=0, columnspan=2, sticky="w", padx=5)



        self.summary = tk.Text(root, height=10, width=55, state='disabled')

        self.summary.grid(row=7, column=0, columnspan=2, padx=5, pady=5)

    def log_message(self, message):

        """Helper to append text to the summary box safely."""

        self.summary.config(state='normal')

        self.summary.insert(tk.END, message + "\n")

        self.summary.see(tk.END) # Auto-scroll

        self.summary.config(state='disabled')

    def start_activity(self):

        # Check for separators in the dropdown

        activity = self.activity_overview.get()

        if activity.startswith("-"):

            messagebox.showwarning("Invalid Selection", "Please select a real activity, not a separator.")

            return

        self.current_entry = {

            "Date": datetime.now().strftime("%Y-%m-%d"),

            "Place": self.place.get(),

            "Activity (Overview)": activity,

            "Start Time": datetime.now().strftime("%H:%M"),

            "End Time": "",

            "Activity (Details)": self.details.get()

        }



        self.stop_button.config(state=tk.NORMAL)

        self.start_button.config(state=tk.DISABLED)



        self.log_message(f"Started: {self.current_entry['Activity (Overview)']} at {self.current_entry['Start Time']}")

    def stop_activity(self):

        if not self.current_entry:

            return

        end_time_str = datetime.now().strftime("%H:%M")

        self.current_entry["End Time"] = end_time_str



        # Calculate duration string (HH:MM)

        duration_str = self.calculate_duration_str(self.current_entry["Start Time"], end_time_str)



        # Store duration with the entry so we don't have to recalc later

        self.current_entry["Duration"] = duration_str



        self.entries.append(self.current_entry)



        self.stop_button.config(state=tk.DISABLED)

        self.start_button.config(state=tk.NORMAL)



        self.details.delete(0, tk.END)

        self.log_message(f"Stopped: Duration {duration_str}\n")

        self.current_entry = {} # Clear current entry

    def calculate_duration_str(self, start, end):

        """Calculates duration and returns HH:MM string. Handles midnight."""

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

    def export_to_excel(self):

        if not self.entries:

            messagebox.showwarning("No Data", "No entries to export!")

            return

        # Create DataFrame

        df = pd.DataFrame(self.entries)



        # Reorder columns to match your template exactly

        columns_order = [

            "Date",

            "Place",

            "Activity (Overview)",

            "Duration",

            "Start Time",

            "End Time",

            "Activity (Details)"

        ]



        # Ensure all columns exist (in case of old data)

        for col in columns_order:

            if col not in df.columns:

                df[col] = "" # or None



        df = df[columns_order]

        # Export

        output_path = os.path.join(os.getcwd(), "weekly_protocol.xlsx")

        try:

            df.to_excel(output_path, index=False)

            messagebox.showinfo("Export Success", f"Saved to:\n{output_path}")

        except Exception as e:

            messagebox.showerror("Export Error", f"Could not save file:\n{e}")

# --- Main Execution ---

def on_close():

    if messagebox.askyesno("Exit", "Export data before exiting?"):

        # Check if logger exists before trying to export

        if 'logger' in globals() and logger.entries:

            logger.export_to_excel()

    root.destroy()

root = tk.Tk()

logger = HourlyLogger(root)

# Fix the NameError by defining on_close AFTER logger exists,

# or using a lambda. Here is the safe way:

def safe_on_close():

    if messagebox.askyesno("Exit", "Export data before exiting?"):

        logger.export_to_excel()

    root.destroy()

root.protocol("WM_DELETE_WINDOW", safe_on_close)

root.mainloop()
