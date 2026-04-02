"""
Interactive test to prove Response 2's comment is misleading about total_seconds().

Response 2's comment claims:
    "# total_seconds() handles crossing midnight correctly (e.g. 23:00 to 01:00)"

This interactive test lets you input times and see that total_seconds() DOES NOT
handle midnight crossing by itself. The actual fix is the "if diff_seconds < 0" check.
"""

import tkinter as tk
from tkinter import ttk
from datetime import datetime

class MidnightCommentTest:
    def __init__(self, root):
        self.root = root
        self.root.title("R2 AOI #3: Misleading Comment Test")
        self.root.geometry("800x600")

        print("\n" + "="*70)
        print("INTERACTIVE TEST - RESPONSE 2 AOI #3: MISLEADING COMMENT")
        print("="*70)
        print("\nResponse 2's comment claims:")
        print("  '# total_seconds() handles crossing midnight correctly'")
        print("\nThis test will prove that claim is MISLEADING\n")

        # Title
        title = tk.Label(root, text="Response 2 AOI #3: Misleading Comment Test",
                        font=("Arial", 14, "bold"), fg="darkred")
        title.pack(pady=10)

        # Instructions
        inst = tk.Label(root,
                       text="Enter start and end times to test if total_seconds() handles midnight crossing",
                       font=("Arial", 10))
        inst.pack(pady=5)

        # Input frame
        input_frame = tk.Frame(root)
        input_frame.pack(pady=20)

        tk.Label(input_frame, text="Start Time (HH:MM):", font=("Arial", 10)).grid(row=0, column=0, padx=5)
        self.start_entry = tk.Entry(input_frame, width=15, font=("Arial", 12))
        self.start_entry.insert(0, "23:00")
        self.start_entry.grid(row=0, column=1, padx=5)

        tk.Label(input_frame, text="End Time (HH:MM):", font=("Arial", 10)).grid(row=1, column=0, padx=5)
        self.end_entry = tk.Entry(input_frame, width=15, font=("Arial", 12))
        self.end_entry.insert(0, "01:00")
        self.end_entry.grid(row=1, column=1, padx=5)

        test_btn = tk.Button(input_frame, text="Test total_seconds()", command=self.test_comment,
                            bg="blue", fg="white", font=("Arial", 12, "bold"), width=20)
        test_btn.grid(row=2, column=0, columnspan=2, pady=15)

        # Results display
        result_label = tk.Label(root, text="Results:", font=("Arial", 11, "bold"))
        result_label.pack(pady=10)

        self.result_text = tk.Text(root, width=90, height=20, font=("Courier", 9))
        self.result_text.pack(pady=5)

        # Preload with default test
        self.test_comment()

    def test_comment(self):
        start_str = self.start_entry.get()
        end_str = self.end_entry.get()

        print(f"\n{'='*70}")
        print(f"[USER TEST] Start: {start_str}, End: {end_str}")
        print(f"{'='*70}")

        try:
            # Parse times
            start_time = datetime.strptime(start_str, "%H:%M")
            end_time = datetime.strptime(end_str, "%H:%M")

            print(f"\n[STEP 1] Parsed times:")
            print(f"  start_time: {start_time}")
            print(f"  end_time:   {end_time}")

            # Calculate timedelta
            delta = end_time - start_time

            print(f"\n[STEP 2] Timedelta calculation:")
            print(f"  delta = {delta}")
            print(f"  delta.days = {delta.days}")
            print(f"  delta.seconds = {delta.seconds}")

            # TEST: total_seconds()
            diff_seconds = delta.total_seconds()

            print(f"\n[STEP 3] Response 2's comment claims:")
            print(f"  '# total_seconds() handles crossing midnight correctly'")
            print(f"\n[TESTING] diff_seconds = total_seconds() = {diff_seconds}")

            # Display results
            output = f"{'='*80}\n"
            output += f"TEST CASE: {start_str} to {end_str}\n"
            output += f"{'='*80}\n\n"

            output += f"[STEP 1] Parse times:\n"
            output += f"  start_time: {start_time}\n"
            output += f"  end_time:   {end_time}\n"
            output += f"  (Note: Both default to same date - 1900-01-01)\n\n"

            output += f"[STEP 2] Calculate timedelta:\n"
            output += f"  delta = end_time - start_time = {delta}\n"
            output += f"  delta.days = {delta.days}\n"
            output += f"  delta.seconds = {delta.seconds}\n\n"

            output += f"[STEP 3] RESPONSE 2'S MISLEADING COMMENT:\n"
            output += f"  Comment: '# total_seconds() handles crossing midnight correctly'\n\n"

            output += f"[TESTING] Call total_seconds():\n"
            output += f"  diff_seconds = delta.total_seconds()\n"
            output += f"  diff_seconds = {diff_seconds}\n\n"

            if diff_seconds < 0:
                output += f"[RESULT] ✗ MISLEADING COMMENT!\n"
                output += f"  ✗ total_seconds() returned NEGATIVE: {diff_seconds}\n"
                output += f"  ✗ This is {diff_seconds / 3600} hours (NEGATIVE!)\n"
                output += f"  ✗ total_seconds() DOES NOT handle midnight by itself!\n\n"

                output += f"[STEP 4] THE ACTUAL FIX (from Response 2's code):\n"
                output += f"  if diff_seconds < 0:\n"
                output += f"      diff_seconds += 24 * 3600\n\n"

                output += f"[APPLYING THE ACTUAL FIX]:\n"
                output += f"  Before: {diff_seconds} seconds\n"
                fixed = diff_seconds + 24 * 3600
                output += f"  After:  {fixed} seconds\n"
                output += f"  Duration: {fixed / 3600} hours ✓ CORRECT\n\n"

                output += f"{'='*80}\n"
                output += f"CONCLUSION:\n"
                output += f"{'='*80}\n"
                output += f"✗ The comment is MISLEADING\n"
                output += f"✗ total_seconds() does NOT handle midnight - it returns negative\n"
                output += f"✗ The ACTUAL fix is the 'if diff_seconds < 0' check that adds 24 hours\n"
                output += f"✗ The comment incorrectly attributes midnight handling to the wrong line\n"

                print(f"\n[RESULT] ✗ Comment is MISLEADING!")
                print(f"  total_seconds() returned: {diff_seconds}")
                print(f"  Actual fix needed: if diff_seconds < 0: diff_seconds += 24*3600")

            else:
                output += f"[RESULT] ✓ No midnight crossing detected\n"
                output += f"  total_seconds() returned positive: {diff_seconds}\n"
                output += f"  Duration: {diff_seconds / 3600} hours\n"
                output += f"\nTry times that cross midnight (e.g., 23:00 to 01:00)\n"

                print(f"\n[RESULT] No midnight crossing in this test case")

            self.result_text.delete(1.0, tk.END)
            self.result_text.insert(1.0, output)

        except ValueError as e:
            error_msg = f"ERROR: Invalid time format. Use HH:MM (e.g., 23:00)\n{str(e)}"
            self.result_text.delete(1.0, tk.END)
            self.result_text.insert(1.0, error_msg)
            print(f"\n[ERROR] {e}")

root = tk.Tk()
app = MidnightCommentTest(root)
root.mainloop()
