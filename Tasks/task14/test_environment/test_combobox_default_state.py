"""
Test to verify the default state of ttk.Combobox widget.
This demonstrates whether Combobox is editable by default or readonly.
"""
import tkinter as tk
from tkinter import ttk

# Create root window
root = tk.Tk()
root.title("Combobox Default State Test")
root.geometry("400x200")

# Create Combobox WITHOUT specifying state parameter
combo = ttk.Combobox(root, values=["Option 1", "Option 2", "Option 3"])
combo.pack(pady=20)

# Check the default state
default_state = combo['state']
print(f"Default state of ttk.Combobox: '{default_state}'")

# Test if it's editable by checking if user can type
print(f"\nCan user type custom values? {default_state == 'normal'}")
print(f"Is readonly by default? {default_state == 'readonly'}")

# Create comparison: explicit readonly Combobox
combo_readonly = ttk.Combobox(root, values=["Option 1", "Option 2", "Option 3"], state='readonly')
combo_readonly.pack(pady=20)

readonly_state = combo_readonly['state']
print(f"\nExplicitly set readonly state: '{readonly_state}'")

# Add labels
label1 = tk.Label(root, text="Default Combobox (no state specified)")
label1.pack()

label2 = tk.Label(root, text="Try typing in the top box vs bottom box")
label2.pack()

print("\n" + "="*50)
print("RESULT:")
print("="*50)
if default_state == 'normal':
    print("✓ ttk.Combobox is EDITABLE by default (state='normal')")
    print("✓ Users can type custom values in addition to selecting from dropdown")
    print("✓ To make it readonly, you must explicitly set state='readonly'")
else:
    print("✗ ttk.Combobox is READONLY by default")

root.mainloop()
