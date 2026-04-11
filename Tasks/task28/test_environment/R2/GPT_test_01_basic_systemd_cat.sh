#!/bin/bash
# GPT Factual Test 1 (R2): Verify the systemd-cat example exactly
# Tests R2's Code Test 1 from GPT_FACTUAL_R2_TASK28.md (lines 266-290)

echo "=========================================="
echo "GPT Test 1 (R2): systemd-cat Basic Example"
echo "=========================================="
echo ""

echo "Creating R2's exact myscript.sh from Code Test 1..."
echo ""

cat > myscript.sh <<'EOF'
#!/bin/bash
# myscript.sh
echo "Script started by $USER" | systemd-cat -t myscript -p info
# ... do work ...
echo "Processing complete" | systemd-cat -t myscript -p info
EOF

chmod +x myscript.sh

echo "✓ Script created: myscript.sh"
echo ""
echo "Script contents:"
cat myscript.sh
echo ""

# Run the script
echo "Executing: ./myscript.sh"
./myscript.sh

# Give journald a moment
sleep 1

echo ""
echo "Querying journal: journalctl -t myscript --no-pager -n 20"
echo ""

journalctl -t myscript --no-pager -n 20

echo ""
echo "---"
echo ""
echo "Expected result (from GPT document):"
echo "  You should see at least two entries tagged 'myscript':"
echo "    • One containing 'Script started by ...'"
echo "    • One containing 'Processing complete'"
echo ""
echo "Claims tested:"
echo "  • systemd-cat writes to journal"
echo "  • -t sets identifier (SYSLOG_IDENTIFIER)"
echo "  • -p sets priority level"
echo "  • journalctl -t retrieves by identifier"
echo ""

# Cleanup
rm -f myscript.sh

echo "=========================================="
echo "GPT Test 1 (R2) Complete"
echo "=========================================="
