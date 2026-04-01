# --------------------------------------------------------------
# hourly_logger.py
# --------------------------------------------------------------
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
from datetime import datetime, timedelta
import pandas as pd
import os
from pathlib import Path

# ------------------------------------------------------------------
# 1️⃣  Static data – keep it out of the UI class for readability
# ------------------------------------------------------------------
ACTIVITY_OVERVIEW = [
    # Work Types
    "Projektarbeit", "Entwicklung", "Dokumentation", "Forschung & Analyse",
    "Testing/QA", "Code-Review", "Support", "Kundenservice",
    "─" * 20,   # visual separator (will be shown as a disabled entry)
    # Meetings & Communication
    "Besprechung", "Meeting", "Team-Update", "Koordination",
    "Abstimmung", "Präsentation", "E-Mail-Kommunikation", "Video-Konferenz",
    "─" * 20,
    # Personal / Wellness
    "Pause", "Mittagspause", "Sport / Bewegung",
    "Meditation / Entspannung",
    "─" * 20,
    # Technical Tasks
    "Software-Installation", "Systemwartung", "Datenbank-Management",
    "Sicherheitsprüfung",
    "─" * 20,
    # Administrative Tasks
    "Verwaltung", "Berichte schreiben", "Zeiterfassung",
    "Planung & Organisation",
    "─" * 20,
    # General / Other
    "Schulung / Weiterbildung", "Recherche", "Telefonat", "Sonstiges"
]

PLACE_OPTIONS = ["Büro", "Homeoffice", "Unterwegs", "Meetingraum", "Kundensite", "Sonstiger Ort"]

# ------------------------------------------------------------------
# 2️⃣  Helper utilities
# ------------------------------------------------------------------
def fmt_dt(dt: datetime) -> str:
    """String used for UI / Excel – keep a single format."""
    return dt.strftime("%Y-%m-%d %H:%M")

def parse_dt(s: str) -> datetime:
    """Inverse of fmt_dt – raises ValueError on bad format."""
    return datetime.strptime(s, "%Y-%m-%d %H:%M")

def duration_hours(start: datetime, end: datetime) -> float:
    """Return hours as a float with two‑decimal precision."""
    return round((end - start).total_seconds() / 3600, 2)

def iso_week_label(dt: datetime) -> str:
    """YYYY‑Www – handy for file names."""
    year, week, _dt = dt.isocalendar()
    return f"{year}_W{week:02d}"

# ------------------------------------------------------------------
# 3️⃣  Main application class
# ------------------------------------------------------------------
class HourlyLogger(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Hourly Activity Logger")
        self.resizable(False, False)

        # ----- internal state -------------------------------------------------
        self.entries: list[dict] = []          # finished rows
        self.active: dict | None = None        # the row we are currently filling

        # ----- UI ------------------------------------------------------------
        self._build_widgets()
        self._apply_style()

    # ------------------------------------------------------------------
    def _build_widgets(self):
        pad = {"padx": 5, "pady": 4}

        # Activity Overview
        ttk.Label(self, text="Activity (Overview):").grid(
            row=0, column=0, sticky="e", **pad
        )
        self.activity_overview = ttk.Combobox(
            self,
            values=ACTIVITY_OVERVIEW,
            width=38,
            state="readonly",
        )
        self.activity_overview.grid(row=0, column=1, **pad, sticky="w")
        self.activity_overview.set("")   # start with no selection

        # Place
        ttk.Label(self, text="Place:").grid(row=1, column=0, sticky="e", **pad)
        self.place = ttk.Combobox(
            self,
            values=PLACE_OPTIONS,
            width=20,
            state="readonly",
        )
        self.place.grid(row=1, column=1, **pad, sticky="w")
        self.place.set("")

        # Details
        ttk.Label(self, text="Details:").grid(row=2, column=0, sticky="e", **pad)
        self.details = ttk.Entry(self, width=40)
        self.details.grid(row=2, column=1, **pad, sticky="w")
        self.details.insert(0, "Kurz beschreiben …")   # placeholder
        self.details.bind("<FocusIn>", self._clear_placeholder)
        self.details.bind("<FocusOut>", self._restore_placeholder)

        # Buttons
        btn_frame = ttk.Frame(self)
        btn_frame.grid(row=3, column=0, columnspan=2, **pad)

        self.start_btn = ttk.Button(
            btn_frame, text="▶ Start", command=self.start_activity, width=12
        )
        self.start_btn.grid(row=0, column=0, padx=4)

        self.stop_btn = ttk.Button(
            btn_frame, text="⏹ Stop", command=self.stop_activity,
            width=12, state=tk.DISABLED
        )
        self.stop_btn.grid(row=0, column=1, padx=4)

        self.export_btn = ttk.Button(
            btn_frame, text="💾 Export", command=self.export_to_excel,
            width=12
        )
        self.export_btn.grid(row=0, column=2, padx=4)

        # Summary (with scrollbar)
        sum_frame = ttk.Frame(self)
        sum_frame.grid(row=4, column=0, columnspan=2, **pad, sticky="nsew")

        self.summary = tk.Text(sum_frame, height=10, width=55, wrap="word")
        self.summary.pack(side="left", fill="both", expand=True)

        scroll = ttk.Scrollbar(sum_frame, orient="vertical", command=self.summary.yview)
        scroll.pack(side="right", fill="y")
        self.summary.config(yscrollcommand=scroll.set)

        # Make the grid expand nicely
        self.columnconfigure(1, weight=1)
        self.rowconfigure(4, weight=1)

    # ------------------------------------------------------------------
    def _apply_style(self):
        style = ttk.Style()
        # Slightly larger padding inside comboboxes – looks nicer on HiDPI
        style.configure("TCombobox", padding=4)
        style.configure("TButton", padding=4)

    # ------------------------------------------------------------------
    # Placeholder handling for the Details entry
    # ------------------------------------------------------------------
    def _clear_placeholder(self, *_):
        if self.details.get() == "Kurz beschreiben …":
            self.details.delete(0, tk.END)
            self.details.configure(foreground="black")

    def _restore_placeholder(self, *_):
        if not self.details.get():
            self.details.insert(0, "Kurz beschreiben …")
            self.details.configure(foreground="grey")

    # ------------------------------------------------------------------
    # Core logic
    # ------------------------------------------------------------------
    def start_activity(self):
        # ---- validation -------------------------------------------------
        if not self.activity_overview.get():
            messagebox.showerror(
                "Fehlende Angabe",
                "Bitte wähle eine Aktivität aus der Dropdown‑Liste."
            )
            return

        if not self.place.get():
            messagebox.showerror(
                "Fehlende Angabe",
                "Bitte wähle einen Ort."
            )
            return

        details = self.details.get()
        if details == "" or details == "Kurz beschreiben …":
            if not messagebox.askyesno(
                    "Details leer",
                    "Möchtest du wirklich ohne Details starten?"
            ):
                return

        # ---- create a new entry ----------------------------------------
        now = datetime.now()
        self.active = {
            "Date": now.date().isoformat(),          # just the date part (YYYY‑MM‑DD)
            "Place": self.place.get(),
            "Activity (Overview)": self.activity_overview.get(),
            "Start Time": now.time().isoformat(timespec="minutes"),  # HH:MM
            "Start DateTime": now,                    # keep full object for calc
            "Activity (Details)": details,
        }

        # ---- UI feedback ------------------------------------------------
        self.start_btn.config(state=tk.DISABLED)
        self.stop_btn.config(state=tk.NORMAL)
        self._log_summary(
            f"▶ Started: {self.active['Activity (Overview)']} "
            f"({self.active['Place']}) at {self.active['Start Time']}"
        )

    def stop_activity(self):
        if not self.active:
            messagebox.showwarning("Nichts läuft", "Es gibt keine laufende Aktivität.")
            return

        now = datetime.now()
        self.active["End Time"] = now.time().isoformat(timespec="minutes")
        self.active["End DateTime"] = now
        self.active["Duration (h)"] = duration_hours(
            self.active["Start DateTime"], self.active["End DateTime"]
        )

        # Store a copy that is Excel‑friendly (strip the internal datetime objects)
        self.entries.append({
            "Date": self.active["Date"],
            "Place": self.active["Place"],
            "Activity (Overview)": self.active["Activity (Overview)"],
            "Duration": self.active["Duration (h)"],
            "Start Time": self.active["Start Time"],
            "End Time": self.active["End Time"],
            "Activity (Details)": self.active["Activity (Details)"],
        })

        # ---- UI reset ---------------------------------------------------
        self.start_btn.config(state=tk.NORMAL)
        self.stop_btn.config(state=tk.DISABLED)
        self._log_summary(
            f"⏹ Stopped: Duration {self.active['Duration (h)']} h "
            f"(Details: {self.active['Activity (Details)'][:30]})"
        )

        self.active = None
        self.details.delete(0, tk.END)
        self._restore_placeholder()

    # ------------------------------------------------------------------
    def _log_summary(self, msg: str):
        """Append a line to the summary widget, keep only the last 30 lines."""
        self.summary.insert(tk.END, msg + "\n")
        self.summary.see(tk.END)

        # Trim if we grew too much (optional)
        lines = int(self.summary.index('end-1c').split('.')[0])
        if lines > 30:
            self.summary.delete("1.0", f"{lines-30}.0")

    # ------------------------------------------------------------------
    def export_to_excel(self):
        if not self.entries:
            messagebox.showwarning("Keine Daten", "Nichts zum Exportieren vorhanden.")
            return

        # Build DataFrame – keep the column order you showed in the template
        df = pd.DataFrame(self.entries)
        df = df[
            [
                "Date",
                "Place",
                "Activity (Overview)",
                "Duration",
                "Start Time",
                "End Time",
                "Activity (Details)",
            ]
        ]

        # Ask the user where to save – include ISO week in the default name
        default_name = f"protocol_{iso_week_label(datetime.now())}.xlsx"
        file_path = filedialog.asksaveasfilename(
            defaultextension=".xlsx",
            filetypes=[("Excel‑Datei", "*.xlsx")],
            initialfile=default_name,
            title="Wochenprotokoll speichern",
        )

        if not file_path:
            return  # user cancelled

        try:
            df.to_excel(file_path, index=False, engine="openpyxl")
            messagebox.showinfo(
                "Export erfolgreich",
                f"Datei gespeichert unter:\n{file_path}"
            )
        except Exception as exc:
            messagebox.showerror(
                "Export fehlgeschlagen",
                f"Konnte die Datei nicht schreiben:\n{exc}"
            )

    # ------------------------------------------------------------------
    def on_closing(self):
        if self.active:
            if not messagebox.askyesno(
                    "Laufende Aktivität",
                    "Es gibt eine nicht gestoppte Aktivität. "
                    "Wirklich beenden und verwerfen?"
            ):
                return

        if self.entries and not messagebox.askyesno(
                "Exportieren?",
                "Möchtest du die aktuellen Einträge vor dem Beenden exportieren?"
        ):
            self.export_to_excel()

        self.destroy()

# ------------------------------------------------------------------
# 4️⃣  Entry point
# ------------------------------------------------------------------
if __name__ == "__main__":
    app = HourlyLogger()
    app.protocol("WM_DELETE_WINDOW", app.on_closing)
    app.mainloop()
