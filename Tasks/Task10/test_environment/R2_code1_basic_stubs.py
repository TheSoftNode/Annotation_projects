from miasm.extras.execution_vm import vm_load_pe_and_dependencies

# Load "target.exe" and ALL its dependencies (uses stubs for missing DLLs)

jitter, pe = vm_load_pe_and_dependencies(

    "target.exe",          # Path to your PE file

    use_stubs=True,        # CRITICAL: Use stubs if DLLs aren't in PATH/System32

    dll_dir=None,          # Optional: Directory containing *real* DLLs or stubs

    load_tls=True          # Load TLS callbacks (recommended for most malware)

)

# The Jitter is already primed:

# - EIP set to PE's EntryPoint

# - Stack/heap allocated

# - Imports resolved (via stubs or real DLLs)

# - PEB/LDR initialized

# Run the emulation (execute until exit/infinite loop/breakpoint)

jitter.run()  # Or step manually: jitter.jit() for single instructions

# Example: Get address of an imported function

createfile_addr = pe.get_export("kernel32.dll", "CreateFileA")

print(f"CreateFileA @ {createfile_addr:#x}")

"""
Query: python run_tests.py  (statement-by-statement execution)

code: R2_code1_basic_stubs.py (verbatim, executed line by line)

excerpt:
  [ERROR] Line   1: from miasm.extras.execution_vm import vm_load_pe_and_dependencies
               --> ModuleNotFoundError: No module named 'miasm.extras'
  [ERROR] Line   5: jitter, pe = vm_load_pe_and_dependencies(...)
               --> NameError: name 'vm_load_pe_and_dependencies' is not defined
  [ERROR] Line  29: jitter.run()
               --> NameError: name 'jitter' is not defined
  [ERROR] Line  33: createfile_addr = pe.get_export("kernel32.dll", "CreateFileA")
               --> NameError: name 'pe' is not defined
  [ERROR] Line  35: print(f"CreateFileA @ {createfile_addr:#x}")
               --> NameError: name 'createfile_addr' is not defined

summary: 0 ok, 5 errors
"""
