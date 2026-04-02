"""
Test to verify the default state of ttk.Combobox widget.
This demonstrates whether Combobox is editable by default or readonly.
"""
import tkinter as tk
from tkinter import ttk

# Create root window
root = tk.Tk()
root.title("Combobox Default State Test")
root.geometry("500x300")

print("\n" + "="*60)
print("COMBOBOX STATE TEST - LIVE INTERACTION LOG")
print("="*60)

# Create Combobox WITHOUT specifying state parameter
combo = ttk.Combobox(root, values=["Option 1", "Option 2", "Option 3"])
combo.pack(pady=20)

# Check the default state
default_state = combo['state']
print(f"\n[SETUP] Default Combobox created")
print(f"[SETUP] Default state of ttk.Combobox: '{default_state}'")

# Create comparison: explicit readonly Combobox
combo_readonly = ttk.Combobox(root, values=["Option 1", "Option 2", "Option 3"], state='readonly')
combo_readonly.pack(pady=20)

readonly_state = combo_readonly['state']
print(f"[SETUP] Readonly Combobox created")
print(f"[SETUP] Explicitly set readonly state: '{readonly_state}'")

# Add labels
label1 = tk.Label(root, text="TOP: Default Combobox (no state specified)", font=("Arial", 10, "bold"))
label1.pack()

label2 = tk.Label(root, text="BOTTOM: Readonly Combobox (state='readonly')", font=("Arial", 10, "bold"))
label2.pack()

instruction = tk.Label(root, text="Try typing in both boxes and watch the terminal!", fg="blue")
instruction.pack(pady=10)

# Add event handlers to log user interactions
def on_default_key(event):
    print(f"[TOP BOX - EDITABLE] Key pressed: '{event.char}' | Current value: '{combo.get()}'")

def on_readonly_key(event):
    print(f"[BOTTOM BOX - READONLY] Attempted to type: '{event.char}' | BLOCKED - Value unchanged: '{combo_readonly.get()}'")

def on_default_change(event):
    print(f"[TOP BOX - EDITABLE] Content changed to: '{combo.get()}'")

def on_readonly_change(event):
    print(f"[BOTTOM BOX - READONLY] Selection changed to: '{combo_readonly.get()}'")

# Bind events
combo.bind('<KeyRelease>', on_default_key)
combo_readonly.bind('<KeyPress>', on_readonly_key)
combo.bind('<<ComboboxSelected>>', on_default_change)
combo_readonly.bind('<<ComboboxSelected>>', on_readonly_change)

print("\n" + "="*60)
print("ANALYSIS:")
print("="*60)
if default_state == 'normal':
    print("✓ ttk.Combobox is EDITABLE by default (state='normal')")
    print("✓ Users can type custom values in addition to selecting from dropdown")
    print("✓ To make it readonly, you must explicitly set state='readonly'")
else:
    print("✗ ttk.Combobox is READONLY by default")

print("\n" + "="*60)
print("INTERACTIVE TEST - Try typing in both boxes now!")
print("="*60 + "\n")

root.mainloop()
