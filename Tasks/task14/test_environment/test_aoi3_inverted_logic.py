"""
Test AOI #3: Prove that Response 1's on_closing method has inverted boolean logic.
This uses VERBATIM code from Response 1.
"""

import tkinter as tk
from tkinter import messagebox

# VERBATIM CODE FROM RESPONSE_1.md on_closing method
# The issue: uses "not messagebox.askyesno(...)" which inverts the logic

print("=" * 70)
print("TESTING RESPONSE 1: on_closing METHOD - INVERTED LOGIC")
print("=" * 70)
print()

# Simulate the inverted logic
def test_inverted_logic():
    """
    VERBATIM CODE FROM RESPONSE_1.md lines 576-584:

    def on_closing(self):
        if self.entries and not messagebox.askyesno(
                "Exportieren?",
                "Möchtest du die aktuellen Einträge vor dem Beenden exportieren?"
        ):
            self.export_to_excel()
    """

    print("VERBATIM CODE FROM RESPONSE_1.md (lines 576-584):")
    print("-" * 70)
    print("""def on_closing(self):
    if self.entries and not messagebox.askyesno(
            "Exportieren?",
            "Möchtest du die aktuellen Einträge vor dem Beenden exportieren?"
    ):
        self.export_to_excel()""")
    print("-" * 70)
    print()

    print("TESTING THE LOGIC:")
    print()

    # Simulate user clicking "Yes"
    user_clicks_yes = True  # messagebox.askyesno returns True when user clicks Yes
    condition = not user_clicks_yes  # Response 1 uses "not"

    print("CASE 1: User clicks 'Yes' (wants to export)")
    print(f"  messagebox.askyesno returns: {user_clicks_yes}")
    print(f"  'not messagebox.askyesno' evaluates to: {condition}")
    print(f"  if condition is True, export happens: {'YES' if condition else 'NO'}")
    print(f"  Result: Export {'HAPPENS' if condition else 'DOES NOT HAPPEN'} ❌ WRONG!")
    print()

    # Simulate user clicking "No"
    user_clicks_no = False  # messagebox.askyesno returns False when user clicks No
    condition = not user_clicks_no  # Response 1 uses "not"

    print("CASE 2: User clicks 'No' (does NOT want to export)")
    print(f"  messagebox.askyesno returns: {user_clicks_no}")
    print(f"  'not messagebox.askyesno' evaluates to: {condition}")
    print(f"  if condition is True, export happens: {'YES' if condition else 'NO'}")
    print(f"  Result: Export {'HAPPENS' if condition else 'DOES NOT HAPPEN'} ❌ WRONG!")
    print()

def test_correct_logic():
    print("=" * 70)
    print("CORRECT LOGIC (without 'not'):")
    print("=" * 70)
    print()

    # Correct logic - WITHOUT the "not"
    print("CASE 1: User clicks 'Yes' (wants to export)")
    user_clicks_yes = True
    condition = user_clicks_yes  # No "not" - correct logic
    print(f"  messagebox.askyesno returns: {user_clicks_yes}")
    print(f"  condition evaluates to: {condition}")
    print(f"  Result: Export {'HAPPENS' if condition else 'DOES NOT HAPPEN'} ✅ CORRECT!")
    print()

    print("CASE 2: User clicks 'No' (does NOT want to export)")
    user_clicks_no = False
    condition = user_clicks_no  # No "not" - correct logic
    print(f"  messagebox.askyesno returns: {user_clicks_no}")
    print(f"  condition evaluates to: {condition}")
    print(f"  Result: Export {'HAPPENS' if condition else 'DOES NOT HAPPEN'} ✅ CORRECT!")
    print()

test_inverted_logic()
test_correct_logic()

print("=" * 70)
print("CONCLUSION:")
print("=" * 70)
print("Response 1's use of 'not messagebox.askyesno(...)' causes:")
print("  - Clicking 'Yes' → Export DOES NOT happen (WRONG)")
print("  - Clicking 'No'  → Export HAPPENS (WRONG)")
print()
print("The logic is inverted!")
print("=" * 70)
