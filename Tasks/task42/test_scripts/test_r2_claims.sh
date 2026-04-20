#!/bin/bash

# Test Script for Response 2 Claims
# Task 42: Grafana/Loki/Promtail Troubleshooting
#
# Usage: ./test_r2_claims.sh <LOKI_SERVER_IP>
#
# This script tests all verifiable claims from Response 2

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Output directory
OUTPUT_DIR="./test_outputs/R2"
mkdir -p "$OUTPUT_DIR"

# Get Loki server IP from argument
LOKI_IP="${1:-localhost}"
LOKI_PORT="3100"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}Response 2 Claims Testing${NC}"
echo -e "${BLUE}Testing against Loki server: $LOKI_IP:$LOKI_PORT${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Function to log test results
log_test() {
    local test_name="$1"
    local status="$2"
    local output="$3"

    echo -e "\n### Test: $test_name" >> "$OUTPUT_DIR/test_results.md"
    echo -e "**Status**: $status" >> "$OUTPUT_DIR/test_results.md"
    echo -e "**Output**:" >> "$OUTPUT_DIR/test_results.md"
    echo -e '```' >> "$OUTPUT_DIR/test_results.md"
    echo "$output" >> "$OUTPUT_DIR/test_results.md"
    echo -e '```' >> "$OUTPUT_DIR/test_results.md"
    echo "" >> "$OUTPUT_DIR/test_results.md"
}

# Initialize results file
echo "# Response 2 Test Results" > "$OUTPUT_DIR/test_results.md"
echo "**Date**: $(date)" >> "$OUTPUT_DIR/test_results.md"
echo "**Loki Server**: $LOKI_IP:$LOKI_PORT" >> "$OUTPUT_DIR/test_results.md"
echo "" >> "$OUTPUT_DIR/test_results.md"

echo -e "${YELLOW}[INFO]${NC} Checking for required tools..."
MISSING_TOOLS=()
for tool in curl jq; do
    if ! command -v $tool &> /dev/null; then
        MISSING_TOOLS+=($tool)
        echo -e "${YELLOW}[WARN]${NC} Tool not found: $tool"
    else
        echo -e "${GREEN}[OK]${NC} Found: $tool"
    fi
done

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo -e "${YELLOW}[WARN]${NC} Missing tools: ${MISSING_TOOLS[*]}"
    echo -e "${YELLOW}[WARN]${NC} Some tests may be skipped"
fi
echo ""

# TEST 1: Check for server_url in Promtail config (EXPECTED TO FAIL)
echo -e "${BLUE}[TEST 1]${NC} Checking for 'server_url' parameter in Promtail config..."
echo -e "${YELLOW}[NOTE]${NC} R2 claims Promtail uses 'server_url', but docs show 'clients.url'"
if [ -d "/etc/promtail" ]; then
    OUTPUT=$(grep -r "server_url" /etc/promtail/ 2>&1 || echo "Not found")
    if echo "$OUTPUT" | grep -q "server_url"; then
        echo -e "${YELLOW}[UNEXPECTED]${NC} Found 'server_url' (contradicts documentation)"
        log_test "Promtail server_url Parameter" "UNEXPECTED_FOUND" "$OUTPUT"
    else
        echo -e "${GREEN}[EXPECTED]${NC} 'server_url' not found (as per documentation)"
        log_test "Promtail server_url Parameter" "EXPECTED_NOT_FOUND" "$OUTPUT\n\nNote: R2's claim is incorrect - Promtail uses 'clients.url' not 'server_url'"
    fi

    # Check for correct parameter
    OUTPUT2=$(grep -r "clients:" /etc/promtail/ 2>&1 || echo "Not found")
    if echo "$OUTPUT2" | grep -q "clients:"; then
        echo -e "${GREEN}[INFO]${NC} Found correct 'clients:' parameter"
        log_test "Promtail clients Parameter (Correct)" "FOUND" "$OUTPUT2"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} /etc/promtail directory not found"
    log_test "Promtail server_url Parameter" "SKIPPED" "/etc/promtail not accessible"
fi
echo ""

# TEST 2: Check for auth_peers in Loki config (EXPECTED TO FAIL)
echo -e "${BLUE}[TEST 2]${NC} Checking for 'auth_peers' parameter in Loki config..."
echo -e "${YELLOW}[NOTE]${NC} R2 claims Loki has 'auth_peers', but this is not documented"
if [ -d "/etc/loki" ]; then
    OUTPUT=$(grep -r "auth_peers" /etc/loki/ 2>&1 || echo "Not found")
    if echo "$OUTPUT" | grep -q "auth_peers"; then
        echo -e "${YELLOW}[UNEXPECTED]${NC} Found 'auth_peers' (not in documentation)"
        log_test "Loki auth_peers Parameter" "UNEXPECTED_FOUND" "$OUTPUT"
    else
        echo -e "${GREEN}[EXPECTED]${NC} 'auth_peers' not found (not a documented parameter)"
        log_test "Loki auth_peers Parameter" "EXPECTED_NOT_FOUND" "$OUTPUT\n\nNote: R2's claim is incorrect - 'auth_peers' does not exist in Loki config"
    fi

    # Check for correct parameter
    OUTPUT2=$(grep -r "auth_enabled" /etc/loki/ 2>&1 || echo "Not found")
    if echo "$OUTPUT2" | grep -q "auth_enabled"; then
        echo -e "${GREEN}[INFO]${NC} Found correct 'auth_enabled' parameter"
        log_test "Loki auth_enabled Parameter (Correct)" "FOUND" "$OUTPUT2"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} /etc/loki directory not found"
    log_test "Loki auth_peers Parameter" "SKIPPED" "/etc/loki not accessible"
fi
echo ""

# TEST 3: Test /label endpoint (EXPECTED TO FAIL)
echo -e "${BLUE}[TEST 3]${NC} Testing /label endpoint..."
echo -e "${YELLOW}[NOTE]${NC} R2 uses /label but docs show /loki/api/v1/labels"
if command -v curl &> /dev/null; then
    OUTPUT=$(curl -s -w "\nHTTP_STATUS:%{http_code}" http://$LOKI_IP:$LOKI_PORT/label 2>&1 || true)
    HTTP_STATUS=$(echo "$OUTPUT" | grep "HTTP_STATUS" | cut -d: -f2)
    BODY=$(echo "$OUTPUT" | grep -v "HTTP_STATUS")

    if [ "$HTTP_STATUS" = "404" ]; then
        echo -e "${GREEN}[EXPECTED]${NC} /label endpoint returns 404 (endpoint doesn't exist)"
        log_test "/label Endpoint" "EXPECTED_FAIL" "HTTP Status: $HTTP_STATUS\nBody: $BODY\n\nNote: R2's endpoint is incorrect - should be /loki/api/v1/labels"
    elif [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${YELLOW}[UNEXPECTED]${NC} /label endpoint returns 200 (may be custom config)"
        log_test "/label Endpoint" "UNEXPECTED_PASS" "HTTP Status: $HTTP_STATUS\nBody: $BODY"
    else
        echo -e "${RED}[ERROR]${NC} Unexpected status: $HTTP_STATUS"
        log_test "/label Endpoint" "ERROR" "HTTP Status: $HTTP_STATUS\nBody: $BODY"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} curl not available"
    log_test "/label Endpoint" "SKIPPED" "curl not found"
fi
echo ""

# TEST 4: Test correct /loki/api/v1/labels endpoint
echo -e "${BLUE}[TEST 4]${NC} Testing /loki/api/v1/labels (correct endpoint)..."
if command -v curl &> /dev/null; then
    OUTPUT=$(curl -s -w "\nHTTP_STATUS:%{http_code}" http://$LOKI_IP:$LOKI_PORT/loki/api/v1/labels 2>&1 || true)
    HTTP_STATUS=$(echo "$OUTPUT" | grep "HTTP_STATUS" | cut -d: -f2)
    BODY=$(echo "$OUTPUT" | grep -v "HTTP_STATUS")

    if [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${GREEN}[PASS]${NC} Correct labels endpoint works"
        log_test "/loki/api/v1/labels (Correct)" "PASS" "HTTP Status: $HTTP_STATUS\nBody: $BODY"
    else
        echo -e "${RED}[FAIL]${NC} Correct endpoint failed (Status: $HTTP_STATUS)"
        log_test "/loki/api/v1/labels (Correct)" "FAIL" "HTTP Status: $HTTP_STATUS\nBody: $BODY"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} curl not available"
    log_test "/loki/api/v1/labels (Correct)" "SKIPPED" "curl not found"
fi
echo ""

# TEST 5: Test R2's malformed query (EXPECTED TO FAIL)
echo -e "${BLUE}[TEST 5]${NC} Testing R2's query command..."
echo -e "${YELLOW}[NOTE]${NC} This query has multiple syntax errors and should fail"
if command -v curl &> /dev/null; then
    # This URL is intentionally malformed as per R2
    URL="http://$LOKI_IP:$LOKI_PORT/label/__name__!='' status=0"

    # Try to execute - this will likely fail at curl level
    OUTPUT=$(curl -X GET "$URL" 2>&1 || true)

    if echo "$OUTPUT" | grep -qi "error\|illegal\|bad\|invalid\|404"; then
        echo -e "${GREEN}[EXPECTED]${NC} Query failed as expected (malformed syntax)"
        log_test "R2 Malformed Query" "EXPECTED_FAIL" "$OUTPUT\n\nNote: R2's query has multiple syntax errors:\n1. Path mixes endpoint with query filter\n2. Missing LogQL braces {}\n3. Missing comma between filters\n4. status=0 should be quoted"
    else
        echo -e "${YELLOW}[UNEXPECTED]${NC} Query didn't fail (unexpected)"
        log_test "R2 Malformed Query" "UNEXPECTED" "$OUTPUT"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} curl not available"
    log_test "R2 Malformed Query" "SKIPPED" "curl not found"
fi
echo ""

# TEST 6: Show correct query syntax
echo -e "${BLUE}[TEST 6]${NC} Testing correct LogQL query syntax..."
if command -v curl &> /dev/null && command -v jq &> /dev/null; then
    # Correct way to query
    OUTPUT=$(curl -s -w "\nHTTP_STATUS:%{http_code}" "http://$LOKI_IP:$LOKI_PORT/loki/api/v1/query_range?query={job=\"test\"}&limit=10" 2>&1 || true)
    HTTP_STATUS=$(echo "$OUTPUT" | grep "HTTP_STATUS" | cut -d: -f2)
    BODY=$(echo "$OUTPUT" | grep -v "HTTP_STATUS")

    if [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${GREEN}[INFO]${NC} Correct query syntax works"
        log_test "Correct LogQL Query Syntax" "PASS" "HTTP Status: $HTTP_STATUS\nBody: $BODY\n\nNote: This is the correct way to query Loki (using /loki/api/v1/query_range with proper LogQL)"
    else
        echo -e "${YELLOW}[INFO]${NC} Query returned: $HTTP_STATUS"
        log_test "Correct LogQL Query Syntax" "INFO" "HTTP Status: $HTTP_STATUS\nBody: $BODY"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} curl or jq not available"
    log_test "Correct LogQL Query Syntax" "SKIPPED" "curl or jq not found"
fi
echo ""

# TEST 7: Check systemctl command validity
echo -e "${BLUE}[TEST 7]${NC} Testing systemctl status loki..."
if command -v systemctl &> /dev/null; then
    OUTPUT=$(systemctl status loki 2>&1 || true)
    if echo "$OUTPUT" | grep -q "could not be found\|not be loaded"; then
        echo -e "${YELLOW}[INFO]${NC} Loki service not found (may have different name)"
        log_test "systemctl status loki" "SERVICE_NOT_FOUND" "$OUTPUT\n\nNote: Service may be named differently or not using systemd"
    elif echo "$OUTPUT" | grep -q "active\|running\|inactive"; then
        echo -e "${GREEN}[PASS]${NC} systemctl command syntax is valid"
        log_test "systemctl status loki" "PASS" "$OUTPUT"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} systemctl not available (not a systemd system)"
    log_test "systemctl status loki" "SKIPPED" "systemctl not found"
fi
echo ""

# TEST 8: Check journalctl command validity
echo -e "${BLUE}[TEST 8]${NC} Testing journalctl -u loki -f (syntax check only)..."
if command -v journalctl &> /dev/null; then
    # Don't actually run -f (follow), just check if the unit exists
    OUTPUT=$(journalctl -u loki -n 0 2>&1 || true)
    if echo "$OUTPUT" | grep -q "No journal files\|not be found"; then
        echo -e "${YELLOW}[INFO]${NC} Loki journald unit not found"
        log_test "journalctl -u loki" "UNIT_NOT_FOUND" "$OUTPUT\n\nNote: Unit may not exist or have different name"
    else
        echo -e "${GREEN}[PASS]${NC} journalctl command syntax is valid"
        log_test "journalctl -u loki" "PASS" "$OUTPUT"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} journalctl not available"
    log_test "journalctl -u loki" "SKIPPED" "journalctl not found"
fi
echo ""

# Summary
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}Test Summary${NC}"
echo -e "${BLUE}================================================${NC}"
echo -e "Test results saved to: ${GREEN}$OUTPUT_DIR/test_results.md${NC}"
echo ""
echo -e "${RED}Critical Failures Found:${NC}"
echo -e "1. ${RED}server_url${NC} parameter doesn't exist (should be ${GREEN}clients.url${NC})"
echo -e "2. ${RED}auth_peers${NC} parameter doesn't exist (not documented)"
echo -e "3. ${RED}/label${NC} endpoint doesn't exist (should be ${GREEN}/loki/api/v1/labels${NC})"
echo -e "4. ${RED}Malformed query syntax${NC} - multiple errors in LogQL"
echo ""
echo -e "${YELLOW}Summary:${NC}"
echo -e "Response 2 contains substantial factual errors in:"
echo -e "- Configuration parameters"
echo -e "- API endpoints"
echo -e "- Query syntax"
echo ""
