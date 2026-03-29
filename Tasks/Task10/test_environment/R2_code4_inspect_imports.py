imports = pe.get_imports()  # List of (dll_name, [(func_name, addr), ...])

for dll, funcs in imports:

    print(f"[{dll}]")

    for func, addr in funcs:

        print(f"  {func} @ {addr:#x}")

"""
Query: python run_tests.py  (statement-by-statement execution)

code: R2_code4_inspect_imports.py (verbatim, executed line by line)

excerpt:
  [ERROR] Line   1: imports = pe.get_imports()
               --> NameError: name 'pe' is not defined
  [ERROR] Line   3: for dll, funcs in imports: ...
               --> NameError: name 'imports' is not defined

summary: 0 ok, 2 errors
"""
