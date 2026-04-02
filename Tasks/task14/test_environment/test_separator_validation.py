"""
Test to verify Response 1 lacks separator validation.
This demonstrates that selecting a separator passes validation and creates invalid data.

VERBATIM validation logic from RESPONSE_1.md lines 330-336:
    if not self.activity_overview.get():
        messagebox.showerror(
            "Fehlende Angabe",
            "Bitte wähle eine Aktivität aus der Dropdown‑Liste."
        )
        return
"""

def response1_validation(activity_value):
    """
    VERBATIM validation logic from Response 1
    Only checks: if not self.activity_overview.get()
    """
    print(f"    [VALIDATION LOG] Checking if activity_value is empty...")
    print(f"    [VALIDATION LOG] activity_value = '{activity_value}'")
    print(f"    [VALIDATION LOG] bool(activity_value) = {bool(activity_value)}")
    print(f"    [VALIDATION LOG] Evaluating: if not activity_value...")

    if not activity_value:
        print(f"    [VALIDATION LOG] Condition TRUE: activity_value is empty or falsy")
        print(f"    [VALIDATION LOG] Returning: FAILED")
        return False, "Empty selection - validation FAILED"

    print(f"    [VALIDATION LOG] Condition FALSE: activity_value is NOT empty")
    print(f"    [VALIDATION LOG] Returning: PASSED (no separator check!)")
    return True, "Non-empty string - validation PASSED"

# Separator definition from RESPONSE_1.md line 64
separator = "─" * 20  # VERBATIM: "─" * 20

print("="*70)
print("RESPONSE 1 - SEPARATOR VALIDATION TEST")
print("="*70)

# Test 1: Empty string (should fail)
print("\n[TEST 1] Empty string")
test1_value = ""
is_valid, message = response1_validation(test1_value)
print(f"  Value: '{test1_value}'")
print(f"  Validation result: {'PASS' if is_valid else 'FAIL'}")
print(f"  Message: {message}")
if not is_valid:
    print("  ✓ Correctly rejected")
else:
    print("  ✗ Incorrectly accepted")

# Test 2: Valid activity (should pass)
print("\n[TEST 2] Valid activity")
test2_value = "Projektarbeit"
is_valid, message = response1_validation(test2_value)
print(f"  Value: '{test2_value}'")
print(f"  Validation result: {'PASS' if is_valid else 'FAIL'}")
print(f"  Message: {message}")
if is_valid:
    print("  ✓ Correctly accepted")
else:
    print("  ✗ Incorrectly rejected")

# Test 3: Separator string (SHOULD fail but PASSES - this is the bug)
print("\n[TEST 3] Separator string (THE BUG)")
test3_value = separator
is_valid, message = response1_validation(test3_value)
print(f"  Value: '{test3_value}'")
print(f"  Validation result: {'PASS' if is_valid else 'FAIL'}")
print(f"  Message: {message}")
if is_valid:
    print("  ✗ INCORRECTLY ACCEPTED - This is invalid data!")
    print("  ✗ User can select separator and create invalid Excel entries")
else:
    print("  ✓ Correctly rejected")

print("\n" + "="*70)
print("RESULT: SEPARATOR VALIDATION IS MISSING")
print("="*70)
print(f"✗ Separator '{separator}' PASSES validation")
print("✗ The validation only checks: if not activity_value (empty check)")
print("✗ Separators are NON-EMPTY strings, so they pass")
print("✗ User can select separator from dropdown and create invalid data")
print("✗ Invalid data would appear in Excel export as activity name")
print("="*70)
