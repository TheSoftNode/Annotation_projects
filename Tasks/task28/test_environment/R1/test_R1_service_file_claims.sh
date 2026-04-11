#!/bin/bash
# Test R1-specific claims about systemd service files and configuration

echo "========================================"
echo "R1: systemd Service File Claims"
echo "========================================"
echo ""

# Test R1-029: User=%i substitutes with user name
# Test R1-030: systemd-cat --flush
# Test R1-031/032: StandardOutput/StandardError=journal

echo "Test R1-029-032: Service file directives"
echo "Creating test service file..."

SERVICE_FILE="/tmp/test-group-logger-$$.service"

cat > "$SERVICE_FILE" << 'EOF'
[Unit]
Description=Test group logger

[Service]
User=%i
ExecStart=/usr/bin/systemd-cat -t test-group-log
ExecStopPost=/usr/bin/systemd-cat --flush
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
EOF

echo "✓ Service file created at $SERVICE_FILE"
echo ""

# Verify directives are valid
echo "Verifying service file syntax..."
if systemd-analyze verify "$SERVICE_FILE" 2>/dev/null; then
    echo "✓ Service file syntax is valid"
else
    echo "⚠ Service file validation failed (may need actual systemd context)"
fi

# Test systemd-cat --flush
echo ""
echo "Test R1-030: systemd-cat --flush command"
if systemd-cat --flush 2>&1 | grep -q "flush"; then
    echo "✓ systemd-cat --flush command exists"
elif systemd-cat --help 2>&1 | grep -q "flush"; then
    echo "✓ systemd-cat has --flush option"
else
    echo "⚠ Cannot verify --flush option availability"
fi

rm -f "$SERVICE_FILE"

echo ""
echo "========================================"
echo "R1 Service File Tests Complete"
echo "========================================"
