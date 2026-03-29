jitter, pe = vm_load_pe_and_dependencies(

    "target.exe",

    use_stubs=True,

    dll_dir="/path/to/your/stubs",  # Folder containing .dll stubs

    load_tls=False                  # Disable if TLS breaks your analysis

)

"""
Query: python run_tests.py  (statement-by-statement execution)

code: R2_code3_custom_stubs.py (verbatim, executed line by line)

excerpt:
  [ERROR] Line   1: jitter, pe = vm_load_pe_and_dependencies(...)
               --> NameError: name 'vm_load_pe_and_dependencies' is not defined

summary: 0 ok, 1 error
"""
