This is a great start\! It’s functional and covers the main logic. However, there are a few **critical bugs** (like the `NameError` on exit) and some **UX/Data improvements** (handling midnight rollovers, formatting for Excel) that will make it robust.

Here are the key corrections and suggestions, followed by the polished code.

### **Key Corrections & Suggestions**

1. **Critical Bug (`NameError`):** In your current script, `on_close()` tries to use `logger`, but `logger` isn’t defined until *after* the function is defined. This will crash the app when you try to close it. **Fix:** Move the function definition *after* `logger` is created, or pass `logger` as an argument.  
2. **Midnight Rollover:** Using `.seconds` on a `timedelta` breaks if a task goes past midnight (e.g., 23:00 to 01:00). **Fix:** Use `.total_seconds()`.  
3. **Excel Duration Format:** Excel handles `1.5` (floats) differently than `1:30` (time string). Since your manual template likely expects a time format, I updated the export to write it as `HH:MM`.  
4. **UI Improvements:**  
   * Added `state="readonly"` to the dropdowns so users can’t accidentally type typos.  
   * Added an **“Export Now” button** so you don’t have to close the app to save your work.  
   * Added `padx` and `pady` to make the layout breathe a bit.  
5. **Data Persistence:** Right now, if the app crashes, you lose the list. For a simple tool, clicking “Export” often is the safety net. (I didn’t add SQLite here to keep your code simple, but it’s the next logical step).

### **Polished Code**

import tkinter as tk

from tkinter import ttk, messagebox

from datetime import datetime

import pandas as pd

import os

class HourlyLogger:

    def \_\_init\_\_(self, root):

        self.root \= root

        self.root.title("Hourly Activity Logger")

        self.entries \= \[\]

        self.current\_entry \= {}

        \# \--- UI Elements \---

        

        \# 1\. Activity (Overview)

        tk.Label(root, text="Activity (Overview):").grid(row=0, column=0, sticky="w", padx=5, pady=5)

        self.activity\_overview \= ttk.Combobox(root, values=\[

            \# Work Types

            "Projektarbeit", "Entwicklung", "Dokumentation", "Forschung & Analyse", "Testing/QA", "Code-Review",

            "Support", "Kundenservice",

            "--------------------",

            \# Meetings & Communication

            "Besprechung", "Meeting", "Team-Update", "Koordination", "Abstimmung", "Präsentation",

            "E-Mail-Kommunikation", "Video-Konferenz",

            "--------------------",

            \# Personal / Wellness

            "Pause", "Mittagspause", "Sport / Bewegung", "Meditation / Entspannung",

            "--------------------",

            \# Technical Tasks

            "Software-Installation", "Systemwartung", "Datenbank-Management", "Sicherheitsprüfung",

            "--------------------",

            \# Administrative Tasks

            "Verwaltung", "Berichte schreiben", "Zeiterfassung", "Planung & Organisation",

            "--------------------",

            \# General / Other

            "Schulung / Weiterbildung", "Recherche", "Telefonat", "Sonstiges"

        \], state="readonly", width=40) \# readonly prevents typos

        self.activity\_overview.grid(row=0, column=1, sticky="ew", padx=5, pady=5)

        self.activity\_overview.current(0) \# Set a default value

        \# 2\. Place

        tk.Label(root, text="Place:").grid(row=1, column=0, sticky="w", padx=5, pady=5)

        self.place \= ttk.Combobox(root, values=\["Büro", "Homeoffice", "Unterwegs"\], state="readonly", width=40)

        self.place.grid(row=1, column=1, sticky="ew", padx=5, pady=5)

        self.place.current(0) \# Set a default value

        \# 3\. Details

        tk.Label(root, text="Details:").grid(row=2, column=0, sticky="w", padx=5, pady=5)

        self.details \= tk.Entry(root, width=43)

        self.details.grid(row=2, column=1, sticky="ew", padx=5, pady=5)

        \# 4\. Buttons

        self.start\_button \= tk.Button(root, text="Start Activity", command=self.start\_activity, bg="\#dddddd")

        self.start\_button.grid(row=3, column=0, columnspan=2, sticky="ew", padx=5, pady=5)

        self.stop\_button \= tk.Button(root, text="Stop Activity", command=self.stop\_activity, state=tk.DISABLED, bg="\#ffcccc")

        self.stop\_button.grid(row=4, column=0, columnspan=2, sticky="ew", padx=5, pady=5)

        \# 5\. Export Button (New\!)

        self.export\_button \= tk.Button(root, text="Export to Excel", command=self.export\_to\_excel, bg="\#ccffcc")

        self.export\_button.grid(row=5, column=0, columnspan=2, sticky="ew", padx=5, pady=5)

        \# 6\. Summary Log

        self.summary\_label \= tk.Label(root, text="Today's Log:", font=("Arial", 10, "bold"))

        self.summary\_label.grid(row=6, column=0, columnspan=2, sticky="w", padx=5)

        

        self.summary \= tk.Text(root, height=10, width=55, state='disabled')

        self.summary.grid(row=7, column=0, columnspan=2, padx=5, pady=5)

    def log\_message(self, message):

        """Helper to append text to the summary box safely."""

        self.summary.config(state='normal')

        self.summary.insert(tk.END, message \+ "\\n")

        self.summary.see(tk.END) \# Auto-scroll

        self.summary.config(state='disabled')

    def start\_activity(self):

        \# Check for separators in the dropdown

        activity \= self.activity\_overview.get()

        if activity.startswith("-"):

            messagebox.showwarning("Invalid Selection", "Please select a real activity, not a separator.")

            return

        self.current\_entry \= {

            "Date": datetime.now().strftime("%Y-%m-%d"),

            "Place": self.place.get(),

            "Activity (Overview)": activity,

            "Start Time": datetime.now().strftime("%H:%M"),

            "End Time": "",

            "Activity (Details)": self.details.get()

        }

        

        self.stop\_button.config(state=tk.NORMAL)

        self.start\_button.config(state=tk.DISABLED)

        

        self.log\_message(f"Started: {self.current\_entry\['Activity (Overview)'\]} at {self.current\_entry\['Start Time'\]}")

    def stop\_activity(self):

        if not self.current\_entry:

            return

        end\_time\_str \= datetime.now().strftime("%H:%M")

        self.current\_entry\["End Time"\] \= end\_time\_str

        

        \# Calculate duration string (HH:MM)

        duration\_str \= self.calculate\_duration\_str(self.current\_entry\["Start Time"\], end\_time\_str)

        

        \# Store duration with the entry so we don't have to recalc later

        self.current\_entry\["Duration"\] \= duration\_str

        

        self.entries.append(self.current\_entry)

        

        self.stop\_button.config(state=tk.DISABLED)

        self.start\_button.config(state=tk.NORMAL)

        

        self.details.delete(0, tk.END)

        self.log\_message(f"Stopped: Duration {duration\_str}\\n")

        self.current\_entry \= {} \# Clear current entry

    def calculate\_duration\_str(self, start, end):

        """Calculates duration and returns HH:MM string. Handles midnight."""

        fmt \= "%H:%M"

        start\_time \= datetime.strptime(start, fmt)

        end\_time \= datetime.strptime(end, fmt)

        

        \# total\_seconds() handles crossing midnight correctly (e.g. 23:00 to 01:00)

        diff\_seconds \= (end\_time \- start\_time).total\_seconds()

        

        \# Handle negative diff (if end time is technically next day but date didn't change)

        \# Note: Since Date column is the same, this logic assumes single-day sessions mostly.

        \# For robustness, if diff \< 0, add 24 hours.

        if diff\_seconds \< 0:

            diff\_seconds \+= 24 \* 3600

        hours \= int(diff\_seconds // 3600\)

        minutes \= int((diff\_seconds % 3600\) // 60\)

        return f"{hours:02d}:{minutes:02d}"

    def export\_to\_excel(self):

        if not self.entries:

            messagebox.showwarning("No Data", "No entries to export\!")

            return

        \# Create DataFrame

        df \= pd.DataFrame(self.entries)

        

        \# Reorder columns to match your template exactly

        columns\_order \= \[

            "Date", 

            "Place", 

            "Activity (Overview)", 

            "Duration", 

            "Start Time", 

            "End Time", 

            "Activity (Details)"

        \]

        

        \# Ensure all columns exist (in case of old data)

        for col in columns\_order:

            if col not in df.columns:

                df\[col\] \= "" \# or None

                

        df \= df\[columns\_order\]

        \# Export

        output\_path \= os.path.join(os.getcwd(), "weekly\_protocol.xlsx")

        try:

            df.to\_excel(output\_path, index=False)

            messagebox.showinfo("Export Success", f"Saved to:\\n{output\_path}")

        except Exception as e:

            messagebox.showerror("Export Error", f"Could not save file:\\n{e}")

\# \--- Main Execution \---

def on\_close():

    if messagebox.askyesno("Exit", "Export data before exiting?"):

        \# Check if logger exists before trying to export

        if 'logger' in globals() and logger.entries:

            logger.export\_to\_excel()

    root.destroy()

root \= tk.Tk()

logger \= HourlyLogger(root)

\# Fix the NameError by defining on\_close AFTER logger exists, 

\# or using a lambda. Here is the safe way:

def safe\_on\_close():

    if messagebox.askyesno("Exit", "Export data before exiting?"):

        logger.export\_to\_excel()

    root.destroy()

root.protocol("WM\_DELETE\_WINDOW", safe\_on\_close)

root.mainloop()

