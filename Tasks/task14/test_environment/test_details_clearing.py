"""
Test to verify if original user code clears details field in stop_activity method.
Response 1 claims: "Details entry is not cleared after a stop"
"""

print("=" * 70)
print("VERIFICATION: Does stop_activity clear the details field?")
print("=" * 70)
print()

# Read and extract the stop_activity method from original code
with open('original_user_code.py', 'r') as f:
    lines = f.readlines()

# Find stop_activity method (starts at line 121)
print("VERBATIM CODE FROM ORIGINAL (lines 121-135):")
print("-" * 70)
for i in range(120, 135):  # lines 121-135 (0-indexed: 120-134)
    print(lines[i], end='')
print("-" * 70)
print()

# Check if line 131 contains details.delete
line_131 = lines[130]  # 0-indexed
print(f"Line 131: {line_131.strip()}")
print()

if 'self.details.delete(0, tk.END)' in line_131:
    print("✅ VERIFIED: Original code DOES clear details field")
    print()
    print("Response 1's claim is FALSE")
else:
    print("❌ NOT FOUND: Original code does NOT clear details field")
    print()
    print("Response 1's claim is TRUE")

print("=" * 70)
