jitter, pe = vm_load_pe_and_dependencies(

    "target.exe",

    use_stubs=False,       # Try to load REAL DLLs first

    dll_dir=r"C:\Windows\System32",  # Point to your Windows DLLs

    load_tls=True

)

"""
Query: python run_tests.py  (statement-by-statement execution)

code: R2_code2_real_dlls.py (verbatim, executed line by line)

excerpt:
  [ERROR] Line   1: jitter, pe = vm_load_pe_and_dependencies(...)
               --> NameError: name 'vm_load_pe_and_dependencies' is not defined

summary: 0 ok, 1 error
"""
