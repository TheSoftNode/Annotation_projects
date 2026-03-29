"""
Targeted proof for R1_code2's central claim:
  "sb.vm_load_pe_and_dependencies(sb.jitter, pe_container)"

R1 states vm_load_pe_and_dependencies is a METHOD on the Sandbox class.
This script proves or disproves that without needing to instantiate the
Sandbox (which requires compiled C extensions).
"""

import inspect
from miasm.analysis.sandbox import Sandbox_Win_x86_32, Sandbox
from miasm.jitter.loader.pe import vm_load_pe_and_dependencies as real_fn

print("=" * 60)
print("CLAIM: vm_load_pe_and_dependencies is a method on Sandbox")
print("=" * 60)

# 1. Check the class and its entire MRO (Method Resolution Order)
print("\n--- All classes in Sandbox_Win_x86_32 MRO ---")
for cls in Sandbox_Win_x86_32.__mro__:
    print(f"  {cls}")

print("\n--- All public methods on Sandbox_Win_x86_32 ---")
methods = [m for m in dir(Sandbox_Win_x86_32) if not m.startswith("_")]
for m in methods:
    print(f"  {m}")

print("\n--- Checking for vm_load_pe_and_dependencies specifically ---")
exists_on_class = hasattr(Sandbox_Win_x86_32, "vm_load_pe_and_dependencies")
print(f"  hasattr(Sandbox_Win_x86_32, 'vm_load_pe_and_dependencies') = {exists_on_class}")

# Search every class in the MRO
print("\n--- Searching every class in MRO ---")
found_in = []
for cls in Sandbox_Win_x86_32.__mro__:
    if "vm_load_pe_and_dependencies" in vars(cls):
        found_in.append(cls)
        print(f"  FOUND in: {cls}")
if not found_in:
    print("  NOT FOUND in any class in the MRO")

# 2. Show where the function actually lives
print("\n" + "=" * 60)
print("WHERE vm_load_pe_and_dependencies ACTUALLY LIVES")
print("=" * 60)
print(f"  Module : {real_fn.__module__}")
print(f"  Signature: {inspect.signature(real_fn)}")
print(f"  Docstring: {real_fn.__doc__.strip()[:200]}")

"""
Query: python prove_r1_method_claim.py

code: prove_r1_method_claim.py (verbatim)

excerpt:
============================================================
CLAIM: vm_load_pe_and_dependencies is a method on Sandbox
============================================================

--- All classes in Sandbox_Win_x86_32 MRO ---
  <class 'miasm.analysis.sandbox.Sandbox_Win_x86_32'>
  <class 'miasm.analysis.sandbox.Sandbox'>
  <class 'miasm.analysis.sandbox.Arch_x86_32'>
  <class 'miasm.analysis.sandbox.Arch_x86'>
  <class 'miasm.analysis.sandbox.Arch'>
  <class 'miasm.analysis.sandbox.OS_Win'>
  <class 'miasm.analysis.sandbox.OS'>
  <class 'object'>

--- All public methods on Sandbox_Win_x86_32 ---
  ALL_IMP_DLL
  CALL_FINISH_ADDR
  STACK_BASE
  STACK_SIZE
  call
  classes
  code_sentinelle
  modules_path
  parser
  run
  update_parser

--- Checking for vm_load_pe_and_dependencies specifically ---
  hasattr(Sandbox_Win_x86_32, 'vm_load_pe_and_dependencies') = False

--- Searching every class in MRO ---
  NOT FOUND in any class in the MRO

============================================================
WHERE vm_load_pe_and_dependencies ACTUALLY LIVES
============================================================
  Module : miasm.jitter.loader.pe
  Signature: (vm, fname, name2module, runtime_lib, lib_path_base, **kwargs)
  Docstring: Load a binary and all its dependencies. Returns a dictionary containing
the association between binaries names and it's pe object

@vm: virtual memory manager instance
@fname: full path of the binary

exit code: 0
"""
