msgbox_addr = pe.get_export("user32.dll", "MessageBoxA")

jitter.add_breakpoint(msgbox_addr, callback=lambda jit: print("MessageBoxA called!"))

jitter.run()

"""
Query: python run_tests.py  (statement-by-statement execution)

code: R2_code5_breakpoint.py (verbatim, executed line by line)

excerpt:
  [ERROR] Line   1: msgbox_addr = pe.get_export("user32.dll", "MessageBoxA")
               --> NameError: name 'pe' is not defined
  [ERROR] Line   3: jitter.add_breakpoint(msgbox_addr, callback=lambda jit: print("MessageBoxA called!"))
               --> NameError: name 'jitter' is not defined
  [ERROR] Line   5: jitter.run()
               --> NameError: name 'jitter' is not defined

summary: 0 ok, 3 errors
"""
