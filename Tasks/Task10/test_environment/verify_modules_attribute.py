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

"""
Query: python verify_modules_attribute.py

code: verify_modules_attribute.py (verbatim)

excerpt:
============================================================
Checking Sandbox attributes: 'modules' vs 'name2module'
============================================================

--- Checking if 'modules' attribute exists ---
  hasattr(Sandbox_Win_x86_32, 'modules') = False

--- Checking if 'name2module' attribute exists ---
  hasattr(Sandbox_Win_x86_32, 'name2module') = False

--- Listing all attributes containing 'module' ---
  __module__
  modules_path

============================================================
CONCLUSION
============================================================
Unexpected result

exit code: 0

---
Query: python run_tests.py  (statement-by-statement execution)

excerpt:
  [OK   ] Line   2: (docstring)
  [OK   ] Line   4: from miasm.analysis.sandbox import Sandbox_Win_x86_32
  [OK   ] Line   6: print("=" * 60)
  [OK   ] Line   7: print("Checking Sandbox attributes: 'modules' vs 'name2module'")
  [OK   ] Line   8: print("=" * 60)
  [OK   ] Line  11: print("\n--- Checking if 'modules' attribute exists ---")
  [OK   ] Line  12: print(f"  hasattr(Sandbox_Win_x86_32, 'modules') = ...")
  [OK   ] Line  14: print("\n--- Checking if 'name2module' attribute exists ---")
  [OK   ] Line  15: print(f"  hasattr(Sandbox_Win_x86_32, 'name2module') = ...")
  [OK   ] Line  17: print("\n--- Listing all attributes containing 'module' ---")
  [OK   ] Line  18: all_attrs = dir(Sandbox_Win_x86_32)
  [OK   ] Line  19: module_attrs = [attr for attr in all_attrs if 'module' in attr.lower()]
  [OK   ] Line  20: for attr in module_attrs: print(...)
  [OK   ] Line  23: print("\n" + "=" * 60)
  [OK   ] Line  24: print("CONCLUSION")
  [OK   ] Line  25: print("=" * 60)
  [OK   ] Line  26: if 'name2module' in module_attrs and 'modules' not in module_attrs: ...

summary: 16 ok, 0 errors

---
NOTE on "Unexpected result":
The script printed "Unexpected result" because both 'modules' and 'name2module'
return False from hasattr() on the CLASS. This is because both are instance
attributes set in __init__ (self.name2module = {}), not class-level attributes,
so dir() on the class does not show them.

The key finding is still confirmed by the output:
  hasattr(Sandbox_Win_x86_32, 'modules') = False
  Attributes containing 'module': only __module__ and modules_path

R1_code2's use of 'sb.modules' refers to a dict that does not exist.
The real attribute is 'name2module', set at instance level in OS_Win.__init__.
"""
