#!/bin/bash
# GPT Factual Test 9: Verify template unit exactly
# Tests R1's template service unit from section 2.4

echo "=========================================="
echo "GPT Test 9: Template Service Unit Test"
echo "=========================================="
echo ""

SERVICE_FILE="/tmp/group-logger@.service"

echo "Creating R1's EXACT template unit from Section 2.4..."
echo ""

sudo tee "$SERVICE_FILE" >/dev/null <<'EOF'
[Unit]
Description=Group logger for user %i
After=network.target

[Service]
Type=simple
User=%i
Group=loggroup
StandardInput=socket
ExecStart=/usr/local/bin/group-logger
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo "✓ Template service file created at: $SERVICE_FILE"
echo ""
echo "Service file contents:"
cat "$SERVICE_FILE"
echo ""

# Test 1: Verify syntax with systemd-analyze
echo "Test 1: systemd-analyze verify"
echo ""

VERIFY_OUTPUT=$(sudo systemd-analyze verify "$SERVICE_FILE" 2>&1)
VERIFY_EXIT=$?

echo "$VERIFY_OUTPUT"
echo ""

if [ $VERIFY_EXIT -eq 0 ]; then
    echo "✓ Service file passed systemd-analyze verify"
elif echo "$VERIFY_OUTPUT" | grep -qi "error"; then
    echo "✗ Service file has ERRORS"
elif echo "$VERIFY_OUTPUT" | grep -qi "warning"; then
    echo "⚠ Service file has WARNINGS"
fi

echo ""

# Test 2: Analyze the template variables
echo "Test 2: Template variable analysis"
echo ""

echo "Template variables used:"
echo "  %i = instance name (the part after @)"
echo ""
echo "Example instantiation:"
echo "  group-logger@alice.service → User=alice"
echo "  group-logger@bob.service → User=bob"
echo ""

# Test 3: Check for the group-logger script dependency
echo "Test 3: Dependency check"
echo ""

if [ -f /usr/local/bin/group-logger ]; then
    echo "✓ /usr/local/bin/group-logger exists"
else
    echo "✗ /usr/local/bin/group-logger NOT FOUND"
    echo "  This service unit depends on the script from Section 2.4"
    echo "  The script must be created first"
fi

echo ""

# Test 4: Check for the loggroup group
echo "Test 4: Group dependency check"
echo ""

if getent group loggroup >/dev/null 2>&1; then
    echo "✓ Group 'loggroup' exists"
else
    echo "✗ Group 'loggroup' NOT FOUND"
    echo "  This service requires: sudo groupadd loggroup"
fi

echo ""

# Test 5: Analyze StandardInput=socket
echo "Test 5: StandardInput=socket analysis"
echo ""

echo "The directive 'StandardInput=socket' is used"
echo ""
echo "What this means:"
echo "  • The service expects input from a socket activation"
echo "  • This requires a corresponding .socket unit"
echo "  • Without a .socket unit, the service won't receive input"
echo ""
echo "Issue: R1 provides NO .socket unit file"
echo "  Result: The service unit is INCOMPLETE"
echo "  It won't work as intended without the socket unit"
echo ""

# Test 6: Test instantiation (if dependencies exist)
echo "Test 6: Test instantiation (dry run)"
echo ""

if id alice >/dev/null 2>&1; then
    echo "Testing: sudo systemctl status group-logger@alice.service"
    sudo systemctl status group-logger@alice.service 2>&1 | head -15
else
    echo "⊘ User 'alice' doesn't exist, skipping instantiation test"
fi

echo ""

# Analysis
echo "---"
echo ""
echo "Critical issues in R1's template unit design:"
echo ""
echo "Issue 1: Missing .socket unit"
echo "  Directive: StandardInput=socket"
echo "  Problem: No corresponding group-logger@.socket file provided"
echo "  Result: Service won't receive input properly"
echo ""
echo "Issue 2: Dependency ordering"
echo "  Section 2.3 tries to enable/start this unit BEFORE it's created (Section 2.4)"
echo "  This creates confusion about installation order"
echo ""
echo "Issue 3: No socket activation setup instructions"
echo "  Template units with StandardInput=socket need:"
echo "    • A .socket unit file"
echo "    • Socket configuration (ListenStream, Accept=yes, etc.)"
echo "  R1 provides none of this"
echo ""

# Cleanup
sudo rm -f "$SERVICE_FILE"

echo "Expected result: Template unit is syntactically valid but functionally incomplete"
echo "This is a VERBATIM test - tests R1's exact unit file as-is"
echo ""
echo "=========================================="
echo "GPT Test 9 Complete"
echo "=========================================="
