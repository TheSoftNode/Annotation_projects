from miasm.analysis.sandbox import Sandbox_Win_x86_32  
from miasm.analysis.binary import Container  
from miasm.core.locationdb import LocationDB

# --- Setup ---  
filename = "my_target.exe"  
with open(filename, "rb") as f:  
    # Parse the PE to get sections, imports, etc.  
    pe_container = Container.from_stream(f)

loc_db = LocationDB()

# Create the sandbox  
# The jitter (VM) is created inside the sandbox (sb.jitter)  
sb = Sandbox_Win_x86_32(loc_db, filename, {}, globals(), None)

# --- Manual Loading ---  
# Call the specific function to load PE and dependencies into the VM  
# Arguments:  
# 1. vm: The jitter instance (sb.jitter)  
# 2. parsed_pe: The container object holding the PE info  
# 3. **kwargs: Optional (e.g., custom DLL paths)

print("Loading PE and resolving dependencies...")  
sb.vm_load_pe_and_dependencies(sb.jitter, pe_container)

# --- Verification ---  
# At this point, memory is mapped and imports are resolved.  
# We can check the state before running.

print(f"Entry Point: {hex(sb.jitter.pc)}")  
print(f"Stack Pointer: {hex(sb.jitter.sp)}")

# Example: Check a specific import address (IAT)  
# Assuming 'kernel32.dll' is loaded and 'ExitProcess' is imported  
if "kernel32.dll" in sb.modules:  
    kernel32 = sb.modules["kernel32.dll"]  
    # Check if Export 'ExitProcess' is mapped  
    if "ExitProcess" in kernel32.export:  
        print(f"ExitProcess is at: {hex(kernel32.export['ExitProcess'])}")

# --- Execution ---  
# Now run the binary manually  
sb.jitter.continue_run()

"""
Query: python run_tests.py  (statement-by-statement execution)

code: R1_code2_manual_approach.py (verbatim, executed line by line)

excerpt:
  [OK   ] Line   1: from miasm.analysis.sandbox import Sandbox_Win_x86_32
  [OK   ] Line   2: from miasm.analysis.binary import Container
  [OK   ] Line   3: from miasm.core.locationdb import LocationDB
  [OK   ] Line   6: filename = "my_target.exe"
  [ERROR] Line   7: with open(filename, "rb") as f:
               --> TypeError: Container.from_stream() missing 1 required positional argument: 'loc_db'
  [OK   ] Line  11: loc_db = LocationDB()
  [ERROR] Line  15: sb = Sandbox_Win_x86_32(loc_db, filename, {}, globals(), None)
               --> TypeError: Sandbox.__init__() takes from 4 to 5 positional arguments but 6 were given
  [OK   ] Line  24: print("Loading PE and resolving dependencies...")
  [ERROR] Line  25: sb.vm_load_pe_and_dependencies(sb.jitter, pe_container)
               --> NameError: name 'sb' is not defined
  [ERROR] Line  31: print(f"Entry Point: {hex(sb.jitter.pc)}")
               --> NameError: name 'sb' is not defined
  [ERROR] Line  32: print(f"Stack Pointer: {hex(sb.jitter.sp)}")
               --> NameError: name 'sb' is not defined
  [ERROR] Line  36: if "kernel32.dll" in sb.modules:
               --> NameError: name 'sb' is not defined
  [ERROR] Line  44: sb.jitter.continue_run()
               --> NameError: name 'sb' is not defined

summary: 6 ok, 7 errors
"""
