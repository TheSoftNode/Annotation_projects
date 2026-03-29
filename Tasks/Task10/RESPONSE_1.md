The function `vm_load_pe_and_dependencies` is a method of the **Sandbox** classes in Miasm (e.g., `Sandbox_Win_x86_32`). It is designed to map a Windows PE binary into the virtual machine’s memory, allocate a stack, and—crucially—resolve its **imports (dependencies)** by loading associated DLLs and populating the Import Address Table (IAT).

Here is how to use it properly, ranging from the standard usage to a more manual approach.

### **1\. The Standard Approach (Recommended)**

Usually, you do not need to call `vm_load_pe_and_dependencies` directly. The `Sandbox`’s `run()` method calls it automatically if the binary hasn’t been loaded yet.

from miasm.analysis.sandbox import Sandbox\_Win\_x86\_32  
from miasm.analysis.binary import Container  
from miasm.core.locationdb import LocationDB

\# 1\. Parse the PE file  
filename \= "my\_target.exe"  
with open(filename, "rb") as f:  
    container \= Container.from\_stream(f)

\# 2\. Initialize LocationDB (used to track labels/addresses)  
loc\_db \= LocationDB()

\# 3\. Create the Sandbox  
\# This initializes the Jitter (VM), sets up Windows API handlers, etc.  
sb \= Sandbox\_Win\_x86\_32(loc\_db, filename, {}, globals(), None)

\# 4\. Run  
\# Internally, this calls sb.vm\_load\_pe\_and\_dependencies(sb.jitter, sb.parsed\_binaries\[0\])  
\# It then starts execution at the Entry Point.  
sb.run(container)

---

### **2\. The Manual Approach (Calling it directly)**

If you are building a custom script and want to load the PE, inspect the state, or manipulate the VM **before** execution starts, you can call `vm_load_pe_and_dependencies` explicitly.

You must ensure:

1. You have a `Container` (parsed PE).  
2. You have a `Sandbox` instance (to handle OS specifics).  
3. The dependent DLLs are accessible (Miasm looks for them in the current folder).

from miasm.analysis.sandbox import Sandbox\_Win\_x86\_32  
from miasm.analysis.binary import Container  
from miasm.core.locationdb import LocationDB

\# \--- Setup \---  
filename \= "my\_target.exe"  
with open(filename, "rb") as f:  
    \# Parse the PE to get sections, imports, etc.  
    pe\_container \= Container.from\_stream(f)

loc\_db \= LocationDB()

\# Create the sandbox  
\# The jitter (VM) is created inside the sandbox (sb.jitter)  
sb \= Sandbox\_Win\_x86\_32(loc\_db, filename, {}, globals(), None)

\# \--- Manual Loading \---  
\# Call the specific function to load PE and dependencies into the VM  
\# Arguments:  
\# 1\. vm: The jitter instance (sb.jitter)  
\# 2\. parsed\_pe: The container object holding the PE info  
\# 3\. \*\*kwargs: Optional (e.g., custom DLL paths)

print("Loading PE and resolving dependencies...")  
sb.vm\_load\_pe\_and\_dependencies(sb.jitter, pe\_container)

\# \--- Verification \---  
\# At this point, memory is mapped and imports are resolved.  
\# We can check the state before running.

print(f"Entry Point: {hex(sb.jitter.pc)}")  
print(f"Stack Pointer: {hex(sb.jitter.sp)}")

\# Example: Check a specific import address (IAT)  
\# Assuming 'kernel32.dll' is loaded and 'ExitProcess' is imported  
if "kernel32.dll" in sb.modules:  
    kernel32 \= sb.modules\["kernel32.dll"\]  
    \# Check if Export 'ExitProcess' is mapped  
    if "ExitProcess" in kernel32.export:  
        print(f"ExitProcess is at: {hex(kernel32.export\['ExitProcess'\])}")

\# \--- Execution \---  
\# Now run the binary manually  
sb.jitter.continue\_run()

### **Key Parameters Explained**

When calling `vm_load_pe_and_dependencies(vm, parsed_pe, **kwargs)`:

1. **`vm`**: The Jitter instance (e.g., `JitterX86`). This is where memory is written.  
2. **`parsed_pe`**: The `Container` object representing your binary.  
3. **`load_libs`** (optional, inside kwargs): A list of libraries to force load.  
4. **`custom_load`** (optional): A dictionary to map specific DLL names to custom implementations or fake binaries.

### **Troubleshooting Dependencies**

`vm_load_pe_and_dependencies` works by recursively loading DLLs listed in the PE’s Import Table.

* **Missing DLLs**: If Miasm cannot find a DLL (e.g., `msvcrt.dll`) in the current directory, it will raise an error or fail to resolve those imports. Ensure your working directory contains the required DLLs.  
* **System Libraries**: Miasm has basic implementations for some Windows DLLs, but often relies on having the actual `.dll` files available to parse exports.  
* **32-bit vs 64-bit**: Use `Sandbox_Win_x86_32` for 32-bit binaries and `Sandbox_Win_x86_64` for 64-bit binaries. The jitter architecture must match the PE architecture.

