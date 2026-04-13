#!/bin/bash

cat > 00_env_check.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "== OS =="
uname -a
echo
echo "== g++ =="
g++ --version || true
echo
echo "== clang++ =="
clang++ --version || true
echo
echo "== paths =="
which g++ || true
which clang++ || true
EOF

cat > run_compile_only_test.sh <<'EOF'
#!/usr/bin/env bash
set -u

if [ $# -lt 1 ]; then
  echo "Usage: ./run_compile_only_test.sh path/to/file.cpp [compiler]"
  exit 1
fi

SRC="$1"
COMPILER="${2:-g++}"

if [ ! -f "$SRC" ]; then
  echo "Source file not found: $SRC"
  exit 1
fi

BASENAME="$(basename "$SRC" .cpp)"
OUTDIR="test_reports"
OBJDIR="test_objs"
mkdir -p "$OUTDIR" "$OBJDIR"

OBJFILE="$OBJDIR/${BASENAME}.o"
REPORT_FILE="$OUTDIR/${BASENAME}_report.txt"

COMPILE_CMD="$COMPILER -std=c++20 -Wall -Wextra -Wdelete-non-virtual-dtor -Wnon-virtual-dtor -pedantic -c \"$SRC\" -o \"$OBJFILE\""

TMP_COMPILE="$(mktemp)"
compile_ok=0

bash -lc "$COMPILE_CMD" >"$TMP_COMPILE" 2>&1
compile_status=$?
if [ $compile_status -eq 0 ]; then
  compile_ok=1
fi

if [ $compile_ok -eq 1 ]; then
  if [ -s "$TMP_COMPILE" ]; then
    OBSERVATION="Compilation succeeded, but the compiler emitted warnings or notes."
  else
    OBSERVATION="Compilation succeeded with no compiler diagnostics."
  fi
else
  OBSERVATION="Compilation failed. Check the compiler output for the exact error."
fi

{
  echo "FILE:"
  echo "$SRC"
  echo
  echo "Compile command:"
  echo "$COMPILE_CMD"
  echo
  echo "Compiler output:"
  cat "$TMP_COMPILE"
  echo
  echo "Run command:"
  echo "Skipped because this is a compile-only test."
  echo
  echo "Run output:"
  echo "Skipped because this is a compile-only test."
  echo
  echo "Sanitizer command:"
  echo "Skipped because this is a compile-only test."
  echo
  echo "Sanitizer output:"
  echo "Skipped because this is a compile-only test."
  echo
  echo "Observation:"
  echo "$OBSERVATION"
} >"$REPORT_FILE"

rm -f "$TMP_COMPILE"

echo "Report written to: $REPORT_FILE"
EOF

cat > run_runtime_test.sh <<'EOF'
#!/usr/bin/env bash
set -u

if [ $# -lt 1 ]; then
  echo "Usage: ./run_runtime_test.sh path/to/file.cpp [compiler]"
  exit 1
fi

SRC="$1"
COMPILER="${2:-g++}"

if [ ! -f "$SRC" ]; then
  echo "Source file not found: $SRC"
  exit 1
fi

BASENAME="$(basename "$SRC" .cpp)"
OUTDIR="test_reports"
BINDIR="test_bins"
mkdir -p "$OUTDIR" "$BINDIR"

NORMAL_BIN="$BINDIR/${BASENAME}"
ASAN_BIN="$BINDIR/${BASENAME}_asan"
REPORT_FILE="$OUTDIR/${BASENAME}_report.txt"

COMPILE_CMD="$COMPILER -std=c++20 -Wall -Wextra -Wdelete-non-virtual-dtor -Wnon-virtual-dtor -pedantic -O0 \"$SRC\" -o \"$NORMAL_BIN\""
RUN_CMD="./$NORMAL_BIN"
SANITIZER_CMD="$COMPILER -std=c++20 -Wall -Wextra -Wdelete-non-virtual-dtor -Wnon-virtual-dtor -pedantic -O0 -fsanitize=address,undefined -fno-omit-frame-pointer -g \"$SRC\" -o \"$ASAN_BIN\""

TMP_COMPILE="$(mktemp)"
TMP_RUN="$(mktemp)"
TMP_SAN="$(mktemp)"

compile_ok=0
run_ok=0
san_compile_ok=0
san_issue=0

bash -lc "$COMPILE_CMD" >"$TMP_COMPILE" 2>&1
compile_status=$?
if [ $compile_status -eq 0 ]; then
  compile_ok=1
fi

if [ $compile_ok -eq 1 ]; then
  bash -lc "$RUN_CMD" >"$TMP_RUN" 2>&1
  run_status=$?
  if [ $run_status -eq 0 ]; then
    run_ok=1
  fi
else
  echo "Skipped because normal compilation failed." >"$TMP_RUN"
fi

bash -lc "$SANITIZER_CMD" >"$TMP_SAN" 2>&1
san_compile_status=$?
if [ $san_compile_status -eq 0 ]; then
  san_compile_ok=1
  {
    echo
    echo "----- SANITIZER RUN OUTPUT -----"
    bash -lc "./$ASAN_BIN"
    echo
    echo "----- SANITIZER EXIT CODE: $? -----"
  } >>"$TMP_SAN" 2>&1

  if grep -Eq "ERROR: AddressSanitizer|runtime error:|UndefinedBehaviorSanitizer|new-delete-type-mismatch" "$TMP_SAN"; then
    san_issue=1
  fi
else
  echo >>"$TMP_SAN"
  echo "Sanitizer compile failed, so sanitizer run was skipped." >>"$TMP_SAN"
fi

if [ $compile_ok -eq 0 ]; then
  OBSERVATION="Normal compilation failed. Check compiler output first."
elif [ $run_ok -eq 0 ]; then
  OBSERVATION="Normal compilation succeeded, but the program did not exit cleanly."
elif [ $san_compile_ok -eq 0 ]; then
  OBSERVATION="Normal compilation and run succeeded. Sanitizer build failed, so sanitizer behavior is not available."
elif [ $san_issue -eq 1 ]; then
  OBSERVATION="Normal compilation and run succeeded, but the sanitizer output shows a problem or undefined-behavior signal."
elif [ -s "$TMP_COMPILE" ]; then
  OBSERVATION="Compilation and execution succeeded, but the compiler emitted warnings or notes."
else
  OBSERVATION="Normal compilation, normal run, and sanitizer run all completed without reported errors."
fi

{
  echo "FILE:"
  echo "$SRC"
  echo
  echo "Compile command:"
  echo "$COMPILE_CMD"
  echo
  echo "Compiler output:"
  cat "$TMP_COMPILE"
  echo
  echo "Run command:"
  echo "$RUN_CMD"
  echo
  echo "Run output:"
  cat "$TMP_RUN"
  echo
  echo "Sanitizer command:"
  echo "$SANITIZER_CMD"
  echo
  echo "Sanitizer output:"
  cat "$TMP_SAN"
  echo
  echo "Observation:"
  echo "$OBSERVATION"
} >"$REPORT_FILE"

rm -f "$TMP_COMPILE" "$TMP_RUN" "$TMP_SAN"

echo "Report written to: $REPORT_FILE"
EOF

cat > run_all_r1_tests.sh <<'EOF'
#!/usr/bin/env bash
set -u

COMPILER="${1:-g++}"

COMPILE_ONLY_FILES=(
  "01_r1_verbatim_correct_example.cpp"
  "02_r1_verbatim_avoid_example.cpp"
  "03_r1_verbatim_replacement_line.cpp"
  "04_r1_verbatim_final_example.cpp"
  "08_r1_supplement_protected_nonvirtual_delete.cpp"
)

RUNTIME_FILES=(
  "05_r1_supplement_virtual_delete_order.cpp"
  "06_r1_supplement_nonvirtual_delete_ub.cpp"
  "07_r1_supplement_size_compare.cpp"
  "09_r1_supplement_slicing_still_happens.cpp"
)

for f in "${COMPILE_ONLY_FILES[@]}"; do
  if [ -f "$f" ]; then
    echo "Running compile-only test for $f ..."
    ./run_compile_only_test.sh "$f" "$COMPILER"
    echo
  else
    echo "Skipping missing file: $f"
    echo
  fi
done

for f in "${RUNTIME_FILES[@]}"; do
  if [ -f "$f" ]; then
    echo "Running runtime test for $f ..."
    ./run_runtime_test.sh "$f" "$COMPILER"
    echo
  else
    echo "Skipping missing file: $f"
    echo
  fi
done
EOF

cat > merge_reports.sh <<'EOF'
#!/usr/bin/env bash
set -u

OUTFILE="all_r1_reports.txt"
: > "$OUTFILE"

if [ ! -d "test_reports" ]; then
  echo "test_reports directory not found."
  exit 1
fi

for f in test_reports/*_report.txt; do
  [ -e "$f" ] || continue
  {
    echo "=================================================="
    echo "$(basename "$f")"
    echo "=================================================="
    cat "$f"
    echo
  } >> "$OUTFILE"
done

echo "Merged report written to: $OUTFILE"
EOF

cat > R1_TEST_MATRIX.txt <<'EOF'
R1 TEST MATRIX

Verbatim compile-only tests
1) 01_r1_verbatim_correct_example.cpp
   Purpose: Check the exact "Example (Correct)" snippet exactly as written.
   Key point: It contains executable statements at namespace scope, so this is a standalone-snippet fairness check.

2) 02_r1_verbatim_avoid_example.cpp
   Purpose: Check that the exact "Example (Avoid)" snippet is accepted as syntax.
   Key point: Compile success does not prove the design comment is correct.

3) 03_r1_verbatim_replacement_line.cpp
   Purpose: Check the exact standalone replacement line exactly as written.
   Key point: It is expected to fail because the line is not inside a class definition.

4) 04_r1_verbatim_final_example.cpp
   Purpose: Check that the exact final class snippet is accepted as syntax.
   Key point: Compile success does not prove the design guidance in the comment.

Supplemental language-rule and design-pattern tests
5) 05_r1_supplement_virtual_delete_order.cpp
   Purpose: Show observable derived-then-base destruction order when deletion goes through a base pointer with a virtual destructor.

6) 06_r1_supplement_nonvirtual_delete_ub.cpp
   Purpose: Probe compiler warnings and sanitizer behavior for deleting through a base pointer with a non-virtual destructor.
   Key point: A single normal run does not prove safety because the language rule is undefined behavior.

7) 07_r1_supplement_size_compare.cpp
   Purpose: Compare size and polymorphism traits for a class with a virtual destructor and one without.
   Key point: This is an implementation probe, not a standard guarantee.

8) 08_r1_supplement_protected_nonvirtual_delete.cpp
   Purpose: Show the protected non-virtual base-destructor pattern from the guidelines by making delete through base pointer fail to compile.
   Key point: This directly checks the claim that virtual is "necessary in base classes."

9) 09_r1_supplement_slicing_still_happens.cpp
   Purpose: Show that a virtual destructor does not prevent object slicing.
   Key point: This checks the mixed claim about "prevent slicing or enable polymorphic deletion."

Claims that remain documentation-heavy even after tests
- "often useful"
- "clear"
- "efficient"
- "adds a vtable entry"
- "slight performance cost"

These are not all hard language rules. Some are guidelines, and some are implementation-dependent.
EOF

cat > 01_r1_verbatim_correct_example.cpp <<'EOF'
class Base {
public:
    virtual ~Base() = default; // Empty but virtual
};

class Derived : public Base {
public:
    ~Derived() { /* cleanup */ }
};

// Later:
Base* ptr = new Derived();
delete ptr; // ✅ Calls ~Derived() then ~Base()
EOF

cat > 02_r1_verbatim_avoid_example.cpp <<'EOF'
class Point {
public:
    double x, y;
    virtual ~Point() {} // ❌ Unnecessary if not polymorphic
};
EOF

cat > 03_r1_verbatim_replacement_line.cpp <<'EOF'
~Point() = default; // Non-virtual, empty
EOF

cat > 04_r1_verbatim_final_example.cpp <<'EOF'
class MyType final {
    ~MyType() = default; // Safe, no need for virtual
};
EOF

cat > 05_r1_supplement_virtual_delete_order.cpp <<'EOF'
#include <iostream>

class Base {
public:
    virtual ~Base() { std::cout << "Base::~Base\n"; }
};

class Derived : public Base {
public:
    ~Derived() override { std::cout << "Derived::~Derived\n"; }
};

int main() {
    Base* ptr = new Derived();
    delete ptr;
}
EOF

cat > 06_r1_supplement_nonvirtual_delete_ub.cpp <<'EOF'
#include <iostream>

class Base {
public:
    virtual void foo() {}
    ~Base() { std::cout << "Base::~Base\n"; }
};

class Derived : public Base {
    int* data = new int[100];
public:
    ~Derived() { 
        std::cout << "Derived::~Derived\n";
        delete[] data;
    }
};

int main() {
    Base* ptr = new Derived();
    delete ptr;
}
EOF

cat > 07_r1_supplement_size_compare.cpp <<'EOF'
#include <iostream>
#include <type_traits>

class Point {
public:
    double x, y;
    virtual ~Point() {}
};

class PlainPoint {
public:
    double x, y;
    ~PlainPoint() = default;
};

int main() {
    std::cout << std::boolalpha;
    std::cout << "std::is_polymorphic_v<Point>=" << std::is_polymorphic_v<Point> << '\n';
    std::cout << "std::has_virtual_destructor_v<Point>=" << std::has_virtual_destructor_v<Point> << '\n';
    std::cout << "std::is_polymorphic_v<PlainPoint>=" << std::is_polymorphic_v<PlainPoint> << '\n';
    std::cout << "std::has_virtual_destructor_v<PlainPoint>=" << std::has_virtual_destructor_v<PlainPoint> << '\n';
    std::cout << "sizeof(Point)=" << sizeof(Point) << '\n';
    std::cout << "sizeof(PlainPoint)=" << sizeof(PlainPoint) << '\n';
}
EOF

cat > 08_r1_supplement_protected_nonvirtual_delete.cpp <<'EOF'
class Base {
public:
    virtual void foo() {}
protected:
    ~Base() = default;
};

class Derived : public Base {
public:
    ~Derived() = default;
};

int main() {
    Base* ptr = new Derived();
    delete ptr;
}
EOF

cat > 09_r1_supplement_slicing_still_happens.cpp <<'EOF'
#include <iostream>

struct Base {
    int b = 1;
    virtual ~Base() = default;
};

struct Derived : Base {
    int d = 2;
};

void take_by_value(Base x) {
    std::cout << "take_by_value(Base): x.b=" << x.b << '\n';
}

int main() {
    Derived obj;
    Base sliced = obj;

    std::cout << "sizeof(Base)=" << sizeof(Base) << '\n';
    std::cout << "sizeof(Derived)=" << sizeof(Derived) << '\n';
    std::cout << "sliced.b=" << sliced.b << '\n';

    take_by_value(obj);
}
EOF

chmod +x 00_env_check.sh run_compile_only_test.sh run_runtime_test.sh run_all_r1_tests.sh merge_reports.sh

echo "Setup complete in: $(pwd)"
echo "Files created:"
ls -1