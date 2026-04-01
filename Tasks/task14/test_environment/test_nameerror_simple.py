"""
Simple test to demonstrate the NameError bug without GUI interaction.
"""

import tkinter as tk
from tkinter import messagebox

class HourlyLogger:
    def __init__(self, root):
        self.root = root
        self.entries = []

    def export_to_excel(self):
        print("Export called")

# BUG: on_close() is defined BEFORE logger is created
def on_close():
    print("on_close() called - trying to access logger...")
    logger.export_to_excel()  # NameError will occur here
    root.destroy()

# Setup
root = tk.Tk()
logger = HourlyLogger(root)
root.protocol("WM_DELETE_WINDOW", on_close)

# Simulate closing the window immediately
print("Simulating window close...")
on_close()
