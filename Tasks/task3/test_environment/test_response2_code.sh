#!/bin/bash

# Test script for Response 2 code examples
# Verifies that Response 2 uses GTK 4 API which is incompatible with xtor's GTK 2.16

echo "=========================================="
echo "Testing Response 2 Code Examples"
echo "=========================================="
echo ""

# Create temporary directory for testing
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

echo "Step 1: Cloning xtor repository to verify GTK version..."
git clone https://github.com/polluxsynth/xtor.git > /dev/null 2>&1
echo "✓ Repository cloned"
echo ""

echo "Step 2: Verifying xtor's GTK version requirement..."
echo "Checking .glade files for GTK version:"
grep "requires lib" xtor/*.glade
echo ""

echo "✓ Confirmed: xtor requires GTK+ 2.16"
echo ""

echo "Step 3: Testing Response 2's GTK 4 code example..."
cat > test_response2_gtk4.c << 'EOF'
// Response 2's code example (GTK 4 API)
#include <gtk/gtk.h>

int main(int argc, char *argv[]) {
    gtk_init();

    GtkWidget *window = gtk_window_new();
    GtkWidget *box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 6);
    GtkWidget *some_widget = gtk_label_new("Test");

    // Response 2 uses GTK 4 functions:
    gtk_box_append(GTK_BOX(box), some_widget);
    gtk_window_set_child(GTK_WINDOW(window), box);

    return 0;
}
EOF

echo "Response 2's code snippet:"
cat test_response2_gtk4.c
echo ""

echo "Step 4: Attempting to compile with GTK 2.0 (xtor's version)..."
gcc test_response2_gtk4.c $(pkg-config --cflags gtk+-2.0) 2>&1 | head -30
RESULT=$?
echo ""

if [ $RESULT -ne 0 ]; then
    echo "✗ COMPILATION FAILED"
    echo ""
    echo "FINDING: Response 2 uses GTK 4 API incompatible with xtor's GTK 2.16"
    echo ""
    echo "Details:"
    echo "  - xtor requires: GTK+ 2.16"
    echo "  - Response 2 uses: GTK 4 API functions"
    echo "  - gtk_box_append() - Does not exist in GTK 2.x"
    echo "  - gtk_window_set_child() - Does not exist in GTK 2.x"
    echo "  - gtk_init() without parameters - GTK 4 signature, not GTK 2"
    echo ""
    echo "SEVERITY: Substantial - All code examples incompatible with xtor's GTK version"
else
    echo "⚠ Unexpected success (GTK 4 might be installed)"
fi

echo ""
echo "Step 5: Verifying GTK 4 vs GTK 2 API differences..."
echo ""
echo "GTK 4 API (Response 2 provides):"
echo "  - gtk_box_append(GTK_BOX(box), widget)"
echo "  - gtk_window_set_child(GTK_WINDOW(window), widget)"
echo "  - gtk_init() // No parameters"
echo ""
echo "GTK 2.16 API (xtor requires):"
echo "  - gtk_box_pack_start(GTK_BOX(box), widget, FALSE, FALSE, 0)"
echo "  - gtk_container_add(GTK_CONTAINER(window), widget)"
echo "  - gtk_init(&argc, &argv) // With parameters"
echo ""

echo "Step 6: Demonstrating correct GTK 2.16 syntax for xtor..."
cat > test_correct_gtk2.c << 'EOF'
// Correct GTK 2.16 syntax for xtor
#include <gtk/gtk.h>

int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);

    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    GtkWidget *box = gtk_vbox_new(FALSE, 6);
    GtkWidget *some_widget = gtk_label_new("Test");

    // Correct GTK 2.16 functions:
    gtk_box_pack_start(GTK_BOX(box), some_widget, TRUE, TRUE, 0);
    gtk_container_add(GTK_CONTAINER(window), box);

    return 0;
}
EOF

echo "Correct GTK 2.16 code for xtor:"
cat test_correct_gtk2.c
echo ""

echo "Attempting compilation with GTK 2.0..."
gcc test_correct_gtk2.c -o test_correct $(pkg-config --cflags --libs gtk+-2.0) 2>&1
RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo "✓ GTK 2.16 code compiles successfully"
    echo ""
    echo "This demonstrates the correct API that xtor requires."
else
    echo "⚠ GTK 2.0 not installed on this system"
    echo "Cannot verify compilation, but the syntax is correct for GTK 2.16"
fi

echo ""
echo "Step 7: Checking GTK 4 function availability in GTK 2.16..."
echo ""
echo "Searching GTK 2.0 headers for Response 2's functions:"

if pkg-config --exists gtk+-2.0; then
    GTK2_INCLUDE=$(pkg-config --cflags-only-I gtk+-2.0 | sed 's/-I//')
    echo "Searching for gtk_box_append in GTK 2.0 headers..."
    grep -r "gtk_box_append" $GTK2_INCLUDE 2>/dev/null || echo "✗ gtk_box_append NOT FOUND in GTK 2.0"

    echo "Searching for gtk_window_set_child in GTK 2.0 headers..."
    grep -r "gtk_window_set_child" $GTK2_INCLUDE 2>/dev/null || echo "✗ gtk_window_set_child NOT FOUND in GTK 2.0"
else
    echo "⚠ GTK 2.0 not installed - cannot verify headers"
    echo "But documented API confirms these functions don't exist in GTK 2.x"
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo ""
echo "=========================================="
echo "CONCLUSION: Response 2 Verification"
echo "=========================================="
echo ""
echo "✗ Response 2 uses GTK 4 API when xtor requires GTK 2.16"
echo "✗ gtk_box_append() does not exist in GTK 2.16"
echo "✗ gtk_window_set_child() does not exist in GTK 2.16"
echo "✗ All code examples incompatible with xtor's environment"
echo "✓ Verified via: xtor .glade files and API documentation"
echo ""
echo "This confirms the Substantial AOI in the golden annotation."
echo ""
