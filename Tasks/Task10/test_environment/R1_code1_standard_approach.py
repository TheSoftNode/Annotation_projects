from miasm.analysis.sandbox import Sandbox_Win_x86_32  
from miasm.analysis.binary import Container  
from miasm.core.locationdb import LocationDB

# 1. Parse the PE file  
filename = "my_target.exe"  
with open(filename, "rb") as f:  
    container = Container.from_stream(f)

# 2. Initialize LocationDB (used to track labels/addresses)  
loc_db = LocationDB()

# 3. Create the Sandbox  
# This initializes the Jitter (VM), sets up Windows API handlers, etc.  
sb = Sandbox_Win_x86_32(loc_db, filename, {}, globals(), None)

# 4. Run  
# Internally, this calls sb.vm_load_pe_and_dependencies(sb.jitter, sb.parsed_binaries[0])  
# It then starts execution at the Entry Point.  
sb.run(container)

"""
Query: python run_tests.py  (statement-by-statement execution)

code: R1_code1_standard_approach.py (verbatim, executed line by line)

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
  [ERROR] Line  20: sb.run(container)
               --> NameError: name 'sb' is not defined

summary: 5 ok, 3 errors
"""
