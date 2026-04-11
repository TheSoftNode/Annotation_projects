#!/bin/bash
# GPT Factual Test 7: Verify per-user setup loop exactly as written
# Tests R1's per-user setup commands from section 2.3

echo "=========================================="
echo "GPT Test 7: Per-User Setup Loop Test"
echo "=========================================="
echo ""

echo "This test verifies R1's per-user setup loop exactly as written"
echo "Testing claims about creating /var/log/myapp and setting up systemd units"
echo ""

# Test 1: Verify the loop commands exactly as written
echo "Test 1: Running R1's exact per-user setup loop"
echo ""

# Create test users if they don't exist
TEST_USERS="alice bob"
echo "Setting up test users: $TEST_USERS"
echo ""

for user in $TEST_USERS; do
    if ! id "$user" >/dev/null 2>&1; then
        echo "Creating test user: $user"
        sudo useradd -m "$user" 2>/dev/null || echo "User $user already exists"
    fi
done

echo ""
echo "Running R1's exact commands for each user:"
echo ""

for user in $TEST_USERS; do
    echo "--- Processing user: $user ---"

    # Command 1: Create log directory
    echo "Command: sudo mkdir -p /var/log/myapp"
    sudo mkdir -p /var/log/myapp

    # Command 2: systemctl enable
    echo "Command: sudo systemctl enable group-logger@$user.service"
    ENABLE_OUTPUT=$(sudo systemctl enable group-logger@$user.service 2>&1)
    ENABLE_EXIT=$?

    echo "$ENABLE_OUTPUT"

    if [ $ENABLE_EXIT -ne 0 ]; then
        echo "✗ systemctl enable FAILED for $user"
        echo "  Reason: Unit file group-logger@.service doesn't exist yet"
    else
        echo "✓ systemctl enable succeeded for $user"
    fi

    # Command 3: systemctl start
    echo "Command: sudo systemctl start group-logger@$user.service"
    START_OUTPUT=$(sudo systemctl start group-logger@$user.service 2>&1)
    START_EXIT=$?

    echo "$START_OUTPUT"

    if [ $START_EXIT -ne 0 ]; then
        echo "✗ systemctl start FAILED for $user"
        echo "  Reason: Unit file group-logger@.service doesn't exist yet"
    else
        echo "✓ systemctl start succeeded for $user"
    fi

    echo ""
done

echo ""
echo "---"
echo ""
echo "Issue identified in R1's instructions:"
echo ""
echo "Problem 1: Missing prerequisite"
echo "  The loop tries to enable/start group-logger@USER.service"
echo "  But the template unit group-logger@.service hasn't been created yet"
echo "  This is mentioned in section 2.4, but the loop runs in section 2.3"
echo ""
echo "Problem 2: mkdir creates directory not file"
echo "  Command: sudo mkdir -p /var/log/myapp"
echo "  This creates a DIRECTORY at /var/log/myapp"
echo "  But later sections expect /var/log/myapp to be a LOG FILE"
echo "  Correct command should be: sudo touch /var/log/myapp/app.log"
echo ""

# Test 2: Demonstrate the directory vs file issue
echo "Test 2: Verify /var/log/myapp is a directory (not a file)"
echo ""

if [ -d /var/log/myapp ]; then
    echo "✓ /var/log/myapp exists and is a DIRECTORY"
    ls -ld /var/log/myapp
    echo ""
    echo "✗ This is WRONG - it should be a log FILE, not a directory"
elif [ -f /var/log/myapp ]; then
    echo "✓ /var/log/myapp exists and is a FILE"
else
    echo "? /var/log/myapp doesn't exist"
fi

echo ""

# Cleanup
echo "Cleaning up test artifacts..."
sudo rm -rf /var/log/myapp

echo ""
echo "Expected result: The loop has ordering and semantic issues"
echo "This is a VERBATIM test - tests R1's exact commands as-is"
echo ""
echo "=========================================="
echo "GPT Test 7 Complete"
echo "=========================================="
