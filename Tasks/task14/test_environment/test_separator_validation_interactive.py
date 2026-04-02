"""
Interactive GUI test to verify Response 1 lacks separator validation.
You can select items from dropdown and see validation behavior in real-time.
"""
import tkinter as tk
from tkinter import ttk, messagebox

root = tk.Tk()
root.title("Separator Validation Test - Response 1")
root.geometry("600x400")

print("\n" + "="*70)
print("INTERACTIVE SEPARATOR VALIDATION TEST - RESPONSE 1")
print("="*70)
print("\n[SETUP] Creating GUI with dropdown containing separator...")

# Activity list with separator (VERBATIM from RESPONSE_1.md line 64)
activities = [
    "Projektarbeit",
    "Entwicklung",
    "Dokumentation",
    "─" * 20,  # VERBATIM separator from Response 1
    "Besprechung",
    "Meeting",
    "Team-Update",
]

print(f"[SETUP] Activities list includes separator: '{activities[3]}'")

# Create UI
title_label = tk.Label(root, text="Response 1 - Missing Separator Validation",
                       font=("Arial", 14, "bold"), fg="red")
title_label.pack(pady=10)

instruction = tk.Label(root, text="Select an activity from the dropdown and click 'Start Activity'",
                       font=("Arial", 10))
instruction.pack(pady=5)

frame = tk.Frame(root)
frame.pack(pady=20)

tk.Label(frame, text="Activity:", font=("Arial", 10)).grid(row=0, column=0, padx=5)
activity_combo = ttk.Combobox(frame, values=activities, width=30, state='readonly')
activity_combo.grid(row=0, column=1, padx=5)

# VERBATIM validation from RESPONSE_1.md lines 330-336
def start_activity():
    selected = activity_combo.get()

    print(f"\n[USER ACTION] Selected: '{selected}'")
    print(f"[VALIDATION LOG] Running Response 1's validation...")
    print(f"[VALIDATION LOG] Checking: if not self.activity_overview.get()...")
    print(f"[VALIDATION LOG] Value: '{selected}'")
    print(f"[VALIDATION LOG] bool(value): {bool(selected)}")

    # VERBATIM validation from Response 1
    if not activity_combo.get():
        print(f"[VALIDATION LOG] Condition TRUE - value is empty")
        print(f"[VALIDATION RESULT] FAILED - Showing error dialog")
        messagebox.showerror(
            "Fehlende Angabe",
            "Bitte wähle eine Aktivität aus der Dropdown‑Liste."
        )
        return

    print(f"[VALIDATION LOG] Condition FALSE - value is NOT empty")
    print(f"[VALIDATION RESULT] PASSED - Validation succeeded")

    # Check if separator was selected
    if selected == "─" * 20:
        print(f"[BUG DETECTED] ✗ Separator PASSED validation!")
        print(f"[BUG DETECTED] ✗ This is INVALID DATA that would go to Excel!")
        print(f"[BUG DETECTED] ✗ User would see '{selected}' as activity name in export")
        messagebox.showwarning(
            "BUG DETECTED!",
            f"Separator '{selected}' PASSED validation!\n\n"
            "This is invalid data that Response 1 fails to block.\n"
            "It would appear in Excel export as an activity name."
        )
    else:
        print(f"[VALIDATION RESULT] ✓ Valid activity accepted: '{selected}'")
        messagebox.showinfo(
            "Success",
            f"Activity '{selected}' accepted.\n"
            "This would be logged normally."
        )

start_btn = tk.Button(frame, text="Start Activity", command=start_activity,
                     bg="green", fg="white", font=("Arial", 10, "bold"))
start_btn.grid(row=1, column=0, columnspan=2, pady=20)

# Status display
status_label = tk.Label(root, text="Watch the terminal for detailed validation logs!",
                        font=("Arial", 9), fg="blue")
status_label.pack(pady=10)

explanation = tk.Label(root,
                      text="The separator (────) is in the dropdown.\n"
                           "Response 1 only checks 'if not value' (empty check).\n"
                           "Separators are NON-EMPTY, so they PASS validation!",
                      font=("Arial", 9), justify="left", fg="darkred")
explanation.pack(pady=10)

print("\n[SETUP COMPLETE] GUI ready - select items and click 'Start Activity'")
print("[INSTRUCTIONS] Try selecting the separator line and see what happens!")
print("="*70 + "\n")

root.mainloop()
