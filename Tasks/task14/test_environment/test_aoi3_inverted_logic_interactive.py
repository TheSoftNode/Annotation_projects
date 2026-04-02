"""
Interactive GUI test to PROVE Response 1's inverted boolean logic.
YOU will click the buttons yourself and see what happens!
"""

import tkinter as tk
from tkinter import messagebox

class InvertedLogicDemo:
    def __init__(self, root):
        self.root = root
        self.root.title("AOI #3: Testing Inverted Boolean Logic")
        self.entries = [{"test": "data"}]  # Simulate having entries

        # Instructions
        instructions = tk.Label(root, text="RESPONSE 1's INVERTED LOGIC TEST",
                              font=("Arial", 14, "bold"), fg="red")
        instructions.pack(pady=10)

        info = tk.Label(root, text="Click the button below. You'll see a dialog asking:\n'Do you want to export?'",
                       font=("Arial", 12))
        info.pack(pady=10)

        # Code display
        code_label = tk.Label(root, text="VERBATIM CODE FROM RESPONSE_1.md:",
                            font=("Arial", 11, "bold"))
        code_label.pack(pady=5)

        code = tk.Text(root, height=6, width=70, font=("Courier", 10))
        code.insert("1.0", """def on_closing(self):
    if self.entries and not messagebox.askyesno(
            "Exportieren?",
            "Möchtest du die aktuellen Einträge..."
    ):
        self.export_to_excel()""")
        code.config(state="disabled")
        code.pack(pady=5)

        # Test button
        test_btn = tk.Button(root, text="TEST: Click to Close Window",
                            command=self.on_closing_inverted,
                            bg="#ff6666", fg="white", font=("Arial", 12, "bold"),
                            height=2, width=30)
        test_btn.pack(pady=20)

        # Result display
        self.result_label = tk.Label(root, text="", font=("Arial", 12, "bold"),
                                     wraplength=500)
        self.result_label.pack(pady=10)

    def on_closing_inverted(self):
        """VERBATIM LOGIC FROM RESPONSE_1.md - with 'not' (INVERTED)"""

        # Ask user if they want to export
        user_response = messagebox.askyesno(
            "Exportieren?",
            "Möchtest du die aktuellen Einträge vor dem Beenden exportieren?\n\n" +
            "Do you want to export before closing?"
        )

        print("\n" + "=" * 70)
        print(f"You clicked: {'YES' if user_response else 'NO'}")
        print(f"messagebox.askyesno returned: {user_response}")

        # VERBATIM FROM RESPONSE 1: Uses "not messagebox.askyesno"
        if self.entries and not user_response:
            print("Condition 'not messagebox.askyesno' evaluates to: True")
            print("Result: EXPORT HAPPENS")
            result_text = f"❌ WRONG BEHAVIOR!\n\n" + \
                         f"You clicked: {'YES' if user_response else 'NO'}\n" + \
                         f"messagebox.askyesno returned: {user_response}\n" + \
                         f"'not {user_response}' = {not user_response}\n\n" + \
                         f"Export HAPPENED (because condition was True)\n\n" + \
                         f"{'If you clicked YES, export should happen - but it did NOT!' if user_response else 'If you clicked NO, export should NOT happen - but it DID!'}"
            self.result_label.config(text=result_text, fg="red")
        else:
            print("Condition 'not messagebox.askyesno' evaluates to: False")
            print("Result: EXPORT DOES NOT HAPPEN")
            result_text = f"❌ WRONG BEHAVIOR!\n\n" + \
                         f"You clicked: {'YES' if user_response else 'NO'}\n" + \
                         f"messagebox.askyesno returned: {user_response}\n" + \
                         f"'not {user_response}' = {not user_response}\n\n" + \
                         f"Export DID NOT HAPPEN (because condition was False)\n\n" + \
                         f"{'If you clicked YES, export should happen - but it did NOT!' if user_response else 'If you clicked NO, export should NOT happen - but it DID!'}"
            self.result_label.config(text=result_text, fg="red")

        print("=" * 70)

print("=" * 70)
print("INTERACTIVE TEST: Response 1's Inverted Boolean Logic")
print("=" * 70)
print("Instructions:")
print("1. A window will open")
print("2. Click 'TEST: Click to Close Window' button")
print("3. A dialog will ask: 'Do you want to export?'")
print("4. Click either 'Yes' or 'No'")
print("5. See what happens (the behavior will be WRONG)")
print()
print("Try clicking 'Yes' first, then run again and click 'No'")
print("You'll see the logic is inverted!")
print("=" * 70)
print()

root = tk.Tk()
demo = InvertedLogicDemo(root)
root.mainloop()
