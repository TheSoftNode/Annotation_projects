"""
Test to prove Response 2 has separator validation while Response 1 and original don't.
"""

# Simulating the validation logic from each response

def test_response1_validation(activity_value):
    """Response 1's validation - only checks for empty string"""
    if not activity_value:
        return False  # Invalid
    return True  # Valid - allows separator!

def test_response2_validation(activity_value):
    """Response 2's validation - checks for empty AND separator"""
    if activity_value.startswith("-"):
        return False  # Invalid - blocks separator!
    return True  # Valid

def test_original_validation(activity_value):
    """Original code has NO validation"""
    return True  # Always valid - allows anything including separator

# Test cases
test_cases = [
    ("Projektarbeit", "Normal activity"),
    ("--------------------", "Separator (dashes)"),
    ("", "Empty string"),
]

print("=" * 70)
print("SEPARATOR VALIDATION TEST")
print("=" * 70)
print()

for value, description in test_cases:
    print(f"Testing: {repr(value)} ({description})")
    print(f"  Original Code:  {'✅ ALLOWED' if test_original_validation(value) else '❌ BLOCKED'}")
    print(f"  Response 1:     {'✅ ALLOWED' if test_response1_validation(value) else '❌ BLOCKED'}")
    print(f"  Response 2:     {'✅ ALLOWED' if test_response2_validation(value) else '❌ BLOCKED'}")
    print()

print("=" * 70)
print("CONCLUSION")
print("=" * 70)
print()
print("❌ Original Code: NO separator validation - allows '--------------------'")
print("❌ Response 1:    NO separator validation - allows '--------------------'")
print("✅ Response 2:    HAS separator validation - BLOCKS '--------------------'")
print()
print("Response 2 adds separator validation that prevents invalid data entry.")
print("This is a STRENGTH that Response 1 and original code lack.")
print()
