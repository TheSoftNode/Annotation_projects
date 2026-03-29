"""
Test runner for Task 10 RLHF evaluation.
Executes each code snippet file verbatim, statement by statement,
so ALL errors are surfaced instead of stopping at the first one.
Code files are never modified.
"""

import ast
import sys
import os

os.chdir(os.path.dirname(os.path.abspath(__file__)))


def run_all_errors(filepath):
    """
    Parse the code file into individual top-level statements and execute
    each one in a shared namespace. Errors are caught and reported but
    execution continues to the next statement.
    """
    with open(filepath, "r") as f:
        source = f.read()

    # Strip the appended results block (everything from triple-quote onwards)
    # so we only execute the original verbatim code
    code_only = source.split('"""\nQuery:')[0].strip()

    try:
        tree = ast.parse(code_only, filename=filepath)
    except SyntaxError as e:
        return [{"line": e.lineno, "stmt": "", "error": f"SyntaxError: {e}"}]

    namespace = {}
    results = []

    for node in tree.body:
        stmt_source = ast.get_source_segment(code_only, node) or ast.unparse(node)
        entry = {"line": node.lineno, "stmt": stmt_source, "error": None, "output": None}

        module = ast.Module(body=[node], type_ignores=[])
        code_obj = compile(module, filepath, "exec")

        try:
            exec(code_obj, namespace)
        except Exception as e:
            entry["error"] = f"{type(e).__name__}: {e}"

        results.append(entry)

    return results


files = [
    "R1_code1_standard_approach.py",
    "R1_code2_manual_approach.py",
    "R2_code1_basic_stubs.py",
    "R2_code2_real_dlls.py",
    "R2_code3_custom_stubs.py",
    "R2_code4_inspect_imports.py",
    "R2_code5_breakpoint.py",
    "R2_code6_logging.py",
]

all_results = {}

for fname in files:
    print(f"\n{'='*60}")
    print(f"RUNNING: {fname}")
    print("="*60)

    results = run_all_errors(fname)
    all_results[fname] = results

    for r in results:
        status = "ERROR" if r["error"] else "OK   "
        print(f"  [{status}] Line {r['line']:>3}: {r['stmt'][:70]}")
        if r["error"]:
            print(f"           --> {r['error']}")

# ── Summary ──────────────────────────────────────────────────────────────
print("\n\n" + "="*60)
print("SUMMARY — all errors per file")
print("="*60)
for fname, results in all_results.items():
    errors = [r for r in results if r["error"]]
    ok     = [r for r in results if not r["error"]]
    print(f"\n{fname}  ({len(ok)} ok, {len(errors)} error(s))")
    if not errors:
        print("  All statements passed.")
    for r in errors:
        print(f"  Line {r['line']}: {r['error']}")
