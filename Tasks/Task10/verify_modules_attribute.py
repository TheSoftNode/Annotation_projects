#!/usr/bin/env python3
"""Verify that Sandbox does not have 'modules' attribute, only 'name2module'"""

from miasm.analysis.sandbox import Sandbox_Win_x86_32

print("=" * 60)
print("Checking Sandbox attributes: 'modules' vs 'name2module'")
print("=" * 60)

# Check class attributes
print("\n--- Checking if 'modules' attribute exists ---")
print(f"  hasattr(Sandbox_Win_x86_32, 'modules') = {hasattr(Sandbox_Win_x86_32, 'modules')}")

print("\n--- Checking if 'name2module' attribute exists ---")
print(f"  hasattr(Sandbox_Win_x86_32, 'name2module') = {hasattr(Sandbox_Win_x86_32, 'name2module')}")

print("\n--- Listing all attributes containing 'module' ---")
all_attrs = dir(Sandbox_Win_x86_32)
module_attrs = [attr for attr in all_attrs if 'module' in attr.lower()]
for attr in module_attrs:
    print(f"  {attr}")

print("\n" + "=" * 60)
print("CONCLUSION")
print("=" * 60)
if 'name2module' in module_attrs and 'modules' not in module_attrs:
    print("✓ Sandbox uses 'name2module', NOT 'modules'")
    print("✓ Response 1's code: if 'kernel32.dll' in sb.modules:")
    print("  would cause: AttributeError: 'Sandbox_Win_x86_32' object has no attribute 'modules'")
else:
    print("Unexpected result")
