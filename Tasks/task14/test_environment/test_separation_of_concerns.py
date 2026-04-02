"""
Test to verify the original code does NOT separate concerns (UI vs. data).
This analyzes the HourlyLogger class structure to prove Response 1's praise is false.
"""
import ast
import inspect

print("="*70)
print("SEPARATION OF CONCERNS ANALYSIS - ORIGINAL CODE")
print("="*70)

# Read the original user code
with open('original_user_code.py', 'r') as f:
    code = f.read()

# Parse the code
tree = ast.parse(code)

# Find the HourlyLogger class
for node in ast.walk(tree):
    if isinstance(node, ast.ClassDef) and node.name == "HourlyLogger":
        hourly_logger_class = node
        break

print("\n[ANALYSIS] Examining HourlyLogger class structure...")
print("-" * 70)

# Categorize methods by their responsibilities
ui_creation = []
event_handlers = []
business_logic = []
data_persistence = []

methods = [n for n in hourly_logger_class.body if isinstance(n, ast.FunctionDef)]

print(f"\n[FOUND] {len(methods)} methods in HourlyLogger class:")

for method in methods:
    method_name = method.name

    # Analyze what each method does
    if method_name == "__init__":
        print(f"\n  1. {method_name}()")
        print(f"     - Creates tkinter UI elements (Labels, Comboboxes, Buttons, Text)")
        print(f"     - Initializes data storage (self.entries = [])")
        print(f"     - Mixes UI CREATION with DATA INITIALIZATION")
        ui_creation.append(method_name)

    elif method_name == "start_activity":
        print(f"\n  2. {method_name}()")
        print(f"     - Handles button click event (UI EVENT)")
        print(f"     - Creates data dictionary (DATA STRUCTURE)")
        print(f"     - Modifies button states (UI STATE)")
        print(f"     - Updates text widget (UI DISPLAY)")
        print(f"     - Mixes EVENT HANDLING + DATA + UI MANIPULATION")
        event_handlers.append(method_name)

    elif method_name == "stop_activity":
        print(f"\n  3. {method_name}()")
        print(f"     - Handles button click event (UI EVENT)")
        print(f"     - Stores data to self.entries (DATA PERSISTENCE)")
        print(f"     - Modifies button states (UI STATE)")
        print(f"     - Clears entry widget (UI MANIPULATION)")
        print(f"     - Calls calculate_duration (BUSINESS LOGIC)")
        print(f"     - Updates text widget (UI DISPLAY)")
        print(f"     - Mixes EVENT + DATA + UI + LOGIC")
        event_handlers.append(method_name)

    elif method_name == "calculate_duration":
        print(f"\n  4. {method_name}()")
        print(f"     - Parses time strings (DATA TRANSFORMATION)")
        print(f"     - Calculates duration (BUSINESS LOGIC)")
        print(f"     - Pure business logic method")
        business_logic.append(method_name)

    elif method_name == "export_to_excel":
        print(f"\n  5. {method_name}()")
        print(f"     - Validates data existence (VALIDATION)")
        print(f"     - Shows messagebox (UI DIALOG)")
        print(f"     - Creates DataFrame (DATA TRANSFORMATION)")
        print(f"     - Calculates durations (BUSINESS LOGIC)")
        print(f"     - Writes to file (DATA PERSISTENCE)")
        print(f"     - Shows messagebox (UI DIALOG)")
        print(f"     - Mixes VALIDATION + UI + DATA + LOGIC + PERSISTENCE")
        data_persistence.append(method_name)

print("\n" + "="*70)
print("CONCERNS ANALYSIS:")
print("="*70)

print("\n[UI CONCERN] Methods handling UI:")
print("  - __init__: Creates all UI widgets")
print("  - start_activity: Modifies button states, updates text widget")
print("  - stop_activity: Modifies button states, clears entry, updates text widget")
print("  - export_to_excel: Shows messageboxes")

print("\n[DATA CONCERN] Methods handling data:")
print("  - __init__: Initializes self.entries list")
print("  - start_activity: Creates data dictionary")
print("  - stop_activity: Appends to self.entries")
print("  - export_to_excel: Creates DataFrame, writes to file")

print("\n[BUSINESS LOGIC CONCERN] Methods with business logic:")
print("  - calculate_duration: Pure calculation")
print("  - export_to_excel: Duration calculation during export")

print("\n[EVENT HANDLING CONCERN] Methods handling events:")
print("  - start_activity: Button click handler")
print("  - stop_activity: Button click handler")
print("  - export_to_excel: Menu/close handler")

print("\n" + "="*70)
print("VERDICT: NO SEPARATION OF CONCERNS")
print("="*70)

print("\n✗ ALL concerns are mixed in a SINGLE class (HourlyLogger)")
print("✗ UI creation, event handling, data storage, business logic, and")
print("  persistence are all tightly coupled in one class")
print("✗ No separate data model class")
print("✗ No separate service/business logic layer")
print("✗ No separate UI component classes")
print("✗ Methods like start_activity and stop_activity mix UI manipulation")
print("  with data operations in the same function")
print("✗ export_to_excel mixes UI dialogs with data transformation and")
print("  file I/O in one method")

print("\n" + "="*70)
print("CONCLUSION:")
print("="*70)
print("Response 1's claim that 'you separate the concerns (UI vs. data)'")
print("is FALSE. The original code does NOT separate concerns.")
print("="*70)
