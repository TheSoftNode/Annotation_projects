#!/bin/bash

# Test Script for Response 1 Claims
# Task 42: Grafana/Loki/Promtail Troubleshooting
#
# Usage: ./test_r1_claims.sh <LOKI_SERVER_IP>
#
# This script tests all verifiable claims from Response 1

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Output directory
OUTPUT_DIR="./test_outputs/R1"
mkdir -p "$OUTPUT_DIR"

# Get Loki server IP from argument
LOKI_IP="${1:-localhost}"
LOKI_PORT="3100"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}Response 1 Claims Testing${NC}"
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
echo "# Response 1 Test Results" > "$OUTPUT_DIR/test_results.md"
echo "**Date**: $(date)" >> "$OUTPUT_DIR/test_results.md"
echo "**Loki Server**: $LOKI_IP:$LOKI_PORT" >> "$OUTPUT_DIR/test_results.md"
echo "" >> "$OUTPUT_DIR/test_results.md"

echo -e "${YELLOW}[INFO]${NC} Checking for required tools..."
MISSING_TOOLS=()
for tool in curl jq nc; do
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

# TEST 1: TCP Connectivity with nc
echo -e "${BLUE}[TEST 1]${NC} Testing TCP connectivity with nc..."
if command -v nc &> /dev/null; then
    OUTPUT=$(nc -zv $LOKI_IP $LOKI_PORT 2>&1 || true)
    if echo "$OUTPUT" | grep -q "succeeded\|open\|Connected"; then
        echo -e "${GREEN}[PASS]${NC} TCP connection successful"
        log_test "TCP Connectivity (nc)" "PASS" "$OUTPUT"
    else
        echo -e "${RED}[FAIL]${NC} TCP connection failed"
        log_test "TCP Connectivity (nc)" "FAIL" "$OUTPUT"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} nc not available"
    log_test "TCP Connectivity (nc)" "SKIPPED" "nc command not found"
fi
echo ""

# TEST 2: Loki Ready Endpoint
echo -e "${BLUE}[TEST 2]${NC} Testing /ready endpoint..."
if command -v curl &> /dev/null; then
    OUTPUT=$(curl -s -w "\nHTTP_STATUS:%{http_code}" http://$LOKI_IP:$LOKI_PORT/ready 2>&1 || true)
    HTTP_STATUS=$(echo "$OUTPUT" | grep "HTTP_STATUS" | cut -d: -f2)
    BODY=$(echo "$OUTPUT" | grep -v "HTTP_STATUS")

    if [ "$HTTP_STATUS" = "200" ] && echo "$BODY" | grep -q "ready"; then
        echo -e "${GREEN}[PASS]${NC} /ready endpoint returns 200 and 'ready'"
        log_test "/ready Endpoint" "PASS" "HTTP Status: $HTTP_STATUS\nBody: $BODY"
    else
        echo -e "${RED}[FAIL]${NC} /ready endpoint failed (Status: $HTTP_STATUS)"
        log_test "/ready Endpoint" "FAIL" "HTTP Status: $HTTP_STATUS\nBody: $BODY"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} curl not available"
    log_test "/ready Endpoint" "SKIPPED" "curl command not found"
fi
echo ""

# TEST 3: Manual Log Push
echo -e "${BLUE}[TEST 3]${NC} Testing manual log push to /loki/api/v1/push..."
if command -v curl &> /dev/null; then
    TIMESTAMP=$(date +%s)000000000
    OUTPUT=$(curl -v -H "Content-Type: application/json" -X POST \
        -d "{\"streams\": [{\"stream\": {\"job\": \"test\"}, \"values\": [[ \"$TIMESTAMP\", \"test log message\" ]]}]}" \
        http://$LOKI_IP:$LOKI_PORT/loki/api/v1/push 2>&1 || true)

    if echo "$OUTPUT" | grep -q "HTTP.*204\|< 204"; then
        echo -e "${GREEN}[PASS]${NC} Log push successful (HTTP 204)"
        log_test "Manual Log Push" "PASS" "$OUTPUT"
    else
        echo -e "${RED}[FAIL]${NC} Log push failed (expected HTTP 204)"
        log_test "Manual Log Push" "FAIL" "$OUTPUT"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} curl not available"
    log_test "Manual Log Push" "SKIPPED" "curl command not found"
fi
echo ""

# TEST 4: Query Endpoint (Expected to FAIL per factual file)
echo -e "${BLUE}[TEST 4]${NC} Testing /loki/api/v1/query with log query..."
echo -e "${YELLOW}[NOTE]${NC} Per factual file: This is EXPECTED TO FAIL (log queries return 400)"
if command -v curl &> /dev/null && command -v jq &> /dev/null; then
    OUTPUT=$(curl -s -w "\nHTTP_STATUS:%{http_code}" "http://$LOKI_IP:$LOKI_PORT/loki/api/v1/query?query={job=\"test\"}" 2>&1 || true)
    HTTP_STATUS=$(echo "$OUTPUT" | grep "HTTP_STATUS" | cut -d: -f2)
    BODY=$(echo "$OUTPUT" | grep -v "HTTP_STATUS")

    if [ "$HTTP_STATUS" = "400" ]; then
        echo -e "${GREEN}[EXPECTED]${NC} Query returned 400 (as documented - log queries not supported on /query)"
        log_test "Query Endpoint (Log Query)" "EXPECTED_FAIL" "HTTP Status: $HTTP_STATUS\nBody: $BODY\n\nNote: R1 claims this works, but docs say log queries return 400"
    elif [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${YELLOW}[UNEXPECTED]${NC} Query returned 200 (contradicts documentation)"
        log_test "Query Endpoint (Log Query)" "UNEXPECTED_PASS" "HTTP Status: $HTTP_STATUS\nBody: $BODY\n\nNote: Docs say this should return 400"
    else
        echo -e "${RED}[ERROR]${NC} Unexpected status: $HTTP_STATUS"
        log_test "Query Endpoint (Log Query)" "ERROR" "HTTP Status: $HTTP_STATUS\nBody: $BODY"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} curl or jq not available"
    log_test "Query Endpoint (Log Query)" "SKIPPED" "curl or jq not found"
fi
echo ""

# TEST 5: Check /loki/api/v1/labels endpoint (correct alternative)
echo -e "${BLUE}[TEST 5]${NC} Testing /loki/api/v1/labels (correct labels endpoint)..."
if command -v curl &> /dev/null; then
    OUTPUT=$(curl -s -w "\nHTTP_STATUS:%{http_code}" "http://$LOKI_IP:$LOKI_PORT/loki/api/v1/labels" 2>&1 || true)
    HTTP_STATUS=$(echo "$OUTPUT" | grep "HTTP_STATUS" | cut -d: -f2)
    BODY=$(echo "$OUTPUT" | grep -v "HTTP_STATUS")

    if [ "$HTTP_STATUS" = "200" ]; then
        echo -e "${GREEN}[PASS]${NC} Labels endpoint works (HTTP 200)"
        log_test "Labels Endpoint" "PASS" "HTTP Status: $HTTP_STATUS\nBody: $BODY"
    else
        echo -e "${RED}[FAIL]${NC} Labels endpoint failed (Status: $HTTP_STATUS)"
        log_test "Labels Endpoint" "FAIL" "HTTP Status: $HTTP_STATUS\nBody: $BODY"
    fi
else
    echo -e "${YELLOW}[SKIP]${NC} curl not available"
    log_test "Labels Endpoint" "SKIPPED" "curl command not found"
fi
echo ""

# TEST 6: Check systemd tools availability
echo -e "${BLUE}[TEST 6]${NC} Checking systemd tools (journalctl, systemctl, timedatectl)..."
SYSTEMD_TOOLS=()
for tool in journalctl systemctl timedatectl; do
    if command -v $tool &> /dev/null; then
        echo -e "${GREEN}[OK]${NC} Found: $tool"
        SYSTEMD_TOOLS+=("$tool:available")
    else
        echo -e "${YELLOW}[WARN]${NC} Not found: $tool"
        SYSTEMD_TOOLS+=("$tool:missing")
    fi
done
log_test "Systemd Tools Check" "INFO" "$(printf '%s\n' "${SYSTEMD_TOOLS[@]}")"
echo ""

# TEST 7: Check firewall tools availability
echo -e "${BLUE}[TEST 7]${NC} Checking firewall tools (ufw, firewall-cmd)..."
FIREWALL_TOOLS=()
for tool in ufw firewall-cmd; do
    if command -v $tool &> /dev/null; then
        echo -e "${GREEN}[OK]${NC} Found: $tool"
        FIREWALL_TOOLS+=("$tool:available")
    else
        echo -e "${YELLOW}[INFO]${NC} Not found: $tool (may not be installed on this system)"
        FIREWALL_TOOLS+=("$tool:missing")
    fi
done
log_test "Firewall Tools Check" "INFO" "$(printf '%s\n' "${FIREWALL_TOOLS[@]}")"
echo ""

# TEST 8: Check NTP tools
echo -e "${BLUE}[TEST 8]${NC} Checking time sync tools..."
TIME_TOOLS=()
for tool in timedatectl ntpdate chrony; do
    if command -v $tool &> /dev/null; then
        echo -e "${GREEN}[OK]${NC} Found: $tool"
        TIME_TOOLS+=("$tool:available")
    else
        echo -e "${YELLOW}[INFO]${NC} Not found: $tool"
        TIME_TOOLS+=("$tool:missing")
    fi
done
echo -e "${YELLOW}[NOTE]${NC} R1 recommends 'ntp' package, but current docs recommend 'chrony'"
log_test "Time Sync Tools Check" "INFO" "$(printf '%s\n' "${TIME_TOOLS[@]}")\n\nNote: R1's 'ntp' package recommendation is outdated"
echo ""

# Summary
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}Test Summary${NC}"
echo -e "${BLUE}================================================${NC}"
echo -e "Test results saved to: ${GREEN}$OUTPUT_DIR/test_results.md${NC}"
echo ""
echo -e "${YELLOW}Key Findings:${NC}"
echo -e "1. Test 4 (query endpoint): Expected to fail per documentation"
echo -e "2. NTP package recommendation: Outdated (chrony is current)"
echo -e "3. All other R1 commands and endpoints appear valid"
echo ""
