# Task 42 Testing Environment Setup Guide

## Overview

This guide provides comprehensive instructions for setting up a test environment to verify all claims in Response 1 and Response 2 for the Grafana/Loki/Promtail troubleshooting task.

---

## Testing Strategy

### Primary Testing Environment: **Mac Terminal + SSH to Linux Servers**

The responses contain Linux-specific systemd commands (`journalctl`, `systemctl`, `timedatectl`, `ufw`, `firewall-cmd`) that must be tested on actual Linux hosts where Loki, Promtail, and Grafana are running.

### Secondary Testing Environment: **GitHub Codespace** (Limited)

Only suitable for generic `curl` and `nc` tests if the Loki server is publicly reachable. NOT suitable for systemd commands.

---

## Prerequisites

### Required Tools Check

Before testing, SSH into each Linux server and verify tools exist:

```bash
which curl jq nc telnet journalctl systemctl timedatectl ufw firewall-cmd ntpdate
```

**Important**: If a tool is missing, record it as an **environment dependency issue**, NOT a response logic failure.

### Three-Server Setup Required

1. **Promtail Server** - Where Promtail runs
2. **Loki Server** - Where Loki runs
3. **Grafana Server** - Where Grafana runs

---

## Testing Architecture

```
┌─────────────────┐
│   Mac Terminal  │
│                 │
└────────┬────────┘
         │ SSH
    ┌────┴────┬────────┐
    │         │        │
┌───▼────┐ ┌──▼────┐ ┌▼───────┐
│Promtail│ │ Loki  │ │Grafana │
│ Server │ │Server │ │ Server │
└────────┘ └───────┘ └────────┘
```

---

## Test Execution Plan

### Phase 1: Configuration File Verification

#### Test 1.1: Promtail Configuration Path (R1)

**SSH to**: Promtail Server

```bash
# Check if R1's claimed path exists
ls -la /etc/promtail/promtail-config.yml

# If exists, verify contents
cat /etc/promtail/promtail-config.yml | grep -A 2 "clients:"
```

**What to verify**:
- Does `/etc/promtail/promtail-config.yml` exist?
- Does it contain `clients:` section with `url:` parameter?

**R1 Claim**: Uses this exact path
**Expected**: Path may vary by installation (Docker, Helm, systemd)

#### Test 1.2: Promtail `server_url` vs `clients.url` (R2 vs R1)

**SSH to**: Promtail Server

```bash
# Check R2's claimed parameter
grep -r "server_url" /etc/promtail/

# Check R1's claimed parameter
grep -A 5 "clients:" /etc/promtail/promtail-config.yml
```

**What to verify**:
- R2 claims: `server_url` exists
- R1 claims: `clients.url` exists

**Expected**: R1 is correct (verified from docs)

#### Test 1.3: Loki `auth_enabled` and `auth_peers` (R2)

**SSH to**: Loki Server

```bash
# Find Loki config file (path may vary)
find /etc -name "*loki*.yml" -o -name "*loki*.yaml" 2>/dev/null

# Check R2's claimed parameters
grep "auth_enabled" /etc/loki/loki-config.yml
grep "auth_peers" /etc/loki/loki-config.yml
```

**What to verify**:
- Does `auth_enabled` exist? (YES - documented)
- Does `auth_peers` exist? (NO - not documented)

**Expected**: `auth_enabled` exists, `auth_peers` does NOT exist

#### Test 1.4: Loki `http_listen_address` (R1)

**SSH to**: Loki Server

```bash
# Check Loki config
grep "http_listen_address" /etc/loki/loki-config.yml
```

**What to verify**:
- What is the actual value? (`127.0.0.1`, `0.0.0.0`, or empty `""`)

**R1 Claim**: Should be `0.0.0.0` for cross-server setup
**Expected**: Depends on deployment; default is `""` (empty)

---

### Phase 2: Service Status Commands

#### Test 2.1: Check Promtail Logs (Both Responses)

**SSH to**: Promtail Server

```bash
# R1 and R2 both suggest this
journalctl -u promtail -f
```

**What to verify**:
- Does the `promtail` systemd unit exist?
- Do logs appear?
- Look for connection errors to Loki

**Expected**: Works if Promtail is systemd-managed with unit name `promtail`

#### Test 2.2: Check Promtail Log File (R1)

**SSH to**: Promtail Server

```bash
# R1 claims this is default log location
cat /var/log/promtail.log
```

**What to verify**:
- Does `/var/log/promtail.log` exist?

**R1 Claim**: "Default log location"
**Expected**: Not verified in official docs; may vary by install

#### Test 2.3: Check Loki Logs (Both Responses)

**SSH to**: Loki Server

```bash
# Both responses suggest this
journalctl -u loki -f
```

**What to verify**:
- Does the `loki` systemd unit exist?
- Do logs appear?
- Look for `POST /loki/api/v1/push` entries with 204 status

**Expected**: Works if Loki is systemd-managed

#### Test 2.4: Check Loki Service Status (R2)

**SSH to**: Loki Server

```bash
# R2 specific command
systemctl status loki
```

**What to verify**:
- Service status (active/inactive/failed)

**Expected**: Works on systemd systems

---

### Phase 3: Network Connectivity Tests

#### Test 3.1: TCP Port Connectivity (R1)

**SSH to**: Promtail Server

```bash
# Test 1: telnet
telnet <LOKI_SERVER_IP> 3100

# Test 2: netcat
nc -zv <LOKI_SERVER_IP> 3100
```

**What to verify**:
- Can Promtail server reach Loki server on port 3100?
- Success: "Connected to..."
- Failure: "Connection refused" or timeout

**Expected**: Both commands are valid network tests

#### Test 3.2: Manual Log Push Test (R1)

**SSH to**: Promtail Server

```bash
curl -v -H "Content-Type: application/json" -X POST \
  -d '{"streams": [{"stream": {"job": "test"}, "values": [[ "'$(date +%s)000000000'", "test log message" ]]}]}' \
  http://<LOKI_SERVER_IP>:3100/loki/api/v1/push
```

**What to verify**:
- HTTP status code returned
- Expected: `204 No Content` (documented success response)
- Body should be empty

**R1 Claim**: This tests if Loki is reachable
**Expected**: Valid test; 204 = success

#### Test 3.3: Loki Readiness Check (R1)

**SSH to**: Grafana Server (or any server)

```bash
curl -v http://<LOKI_SERVER_IP>:3100/ready
```

**What to verify**:
- HTTP status: Should be 200
- Response body: Should say "ready"

**R1 Claim**: Tests if Loki is ready to accept traffic
**Expected**: Valid endpoint; returns "ready" with HTTP 200

---

### Phase 4: API Endpoint Tests (Critical)

#### Test 4.1: Query Loki Logs - R1's Method

**SSH to**: Loki Server

```bash
curl -s "http://localhost:3100/loki/api/v1/query?query={job=\"test\"}" | jq .
```

**What to verify**:
- HTTP status code
- Response body content
- Any error messages

**R1 Claim**: This queries Loki for logs
**FACTUAL FILE FINDING**: **DISPUTED** - Current Loki docs say `/loki/api/v1/query` is for instant queries, and log queries (like `{job="test"}`) return `400 Bad Request`

**Expected**: This command may FAIL with 400 error

#### Test 4.2: Check `/label` Endpoint - R2's Method

**SSH to**: Promtail Server (or any server)

```bash
curl -v http://<LOKI_SERVER_IP>:<PORT>/label
```

**What to verify**:
- HTTP status (404, 200, or other)
- Response body

**R2 Claim**: Tests connection to Loki
**FACTUAL FILE FINDING**: **DISPUTED** - Documented endpoints are `/loki/api/v1/labels` (plural) and `/loki/api/v1/label/<name>/values`, NOT bare `/label`

**Expected**: Likely returns 404 Not Found

#### Test 4.3: R2's Query Command (Malformed)

**SSH to**: Loki Server (or any server)

```bash
curl -X GET "http://<LOKI_SERVER_IP>:<PORT>/label/__name__!='' status=0" | jq .
```

**What to verify**:
- Whether curl accepts the URL
- HTTP status
- Error messages

**R2 Claim**: Queries for recent logs
**FACTUAL FILE FINDING**: **DISPUTED** - Multiple syntax errors:
1. Path `/label/__name__!=''` mixes API path with query
2. Missing LogQL braces `{}`
3. Missing comma between filters
4. `status=0` should be `status="0"` (quoted)

**Expected**: This command WILL FAIL

---

### Phase 5: Firewall Commands (Conditional)

#### Test 5.1: UFW Rule (R1) - Ubuntu/Debian Only

**SSH to**: Loki Server

```bash
# Only run if UFW is installed and active
which ufw
sudo ufw status

# If active, test R1's command
sudo ufw allow 3100/tcp
```

**What to verify**:
- Does UFW accept the rule syntax?

**Expected**: Valid UFW syntax

#### Test 5.2: Firewalld Rule (R1) - RHEL/CentOS Only

**SSH to**: Loki Server

```bash
# Only run if firewalld is installed
which firewall-cmd
sudo firewall-cmd --state

# If running, test R1's command
sudo firewall-cmd --add-port=3100/tcp --permanent && sudo firewall-cmd --reload
```

**What to verify**:
- Does firewalld accept the rule syntax?

**Expected**: Valid firewalld syntax

---

### Phase 6: Time Synchronization

#### Test 6.1: Check NTP Status (R1)

**SSH to**: All servers

```bash
timedatectl status | grep "NTP service"
```

**What to verify**:
- Is NTP active or inactive?

**Expected**: Valid systemd command

#### Test 6.2: NTP Installation Commands (R1)

**SSH to**: Any Linux server

```bash
# Check if ntpdate exists
which ntpdate

# R1's install commands
# Debian/Ubuntu:
# sudo apt install ntp

# RHEL/CentOS:
# sudo yum install ntp
```

**What to verify**:
- Is `ntp` package the current recommended package?

**FACTUAL FILE FINDING**: **OUTDATED** - Current docs recommend `chrony` or `systemd-timesyncd`, not `ntp`

**Expected**: Commands work but are outdated

---

### Phase 7: Grafana UI Verification

#### Test 7.1: Grafana Data Source Configuration

**Access**: Grafana Web UI

Steps:
1. Navigate to Configuration → Data Sources → Loki
2. Check the URL field
3. Verify it points to `http://<LOKI_SERVER_IP>:3100`
4. Check that it's NOT set to `localhost` (if Grafana is on different server)
5. Click "Save & Test"

**What to verify**:
- R1 Claim: URL must be Loki server's IP, not localhost
- R2 Claim: "Status" is "OK" in "Data source" tab

**Expected**:
- R1's guidance is correct
- R2's exact UI wording may not match current Grafana UI

#### Test 7.2: Grafana Query Debug (R1)

**Access**: Grafana Web UI

Steps:
1. Open browser dev tools (F12)
2. Go to Network tab
3. Run a Loki query: `{job="your_job"}`
4. Check XHR requests to `/loki/api/v1/query`
5. Look for error status codes (401, 502, 404)

**What to verify**:
- R1 provides this debugging method

**Expected**: Valid troubleshooting approach

---

## Test Results Template

Use this template to record results:

```markdown
### Test [Number]: [Test Name]

**Date**: YYYY-MM-DD
**Tester**: [Name]
**Server**: [Promtail/Loki/Grafana]

**Command Executed**:
```bash
[exact command]
```

**Output**:
```
[paste full output]
```

**HTTP Status** (if applicable): [200/204/400/404/etc]

**Result**: PASS / FAIL / PARTIAL

**Notes**: [any observations]

**Response Accuracy**:
- R1 claim: [accurate / inaccurate / partially accurate]
- R2 claim: [accurate / inaccurate / partially accurate / N/A]
```

---

## Critical Tests Summary

### Must-Run Tests to Verify Key Disputes:

| Test | Response | Claim | Expected Outcome |
|------|----------|-------|------------------|
| 1.2 | R2 | Promtail uses `server_url` | **FAIL** - Parameter doesn't exist |
| 1.3 | R2 | Loki has `auth_peers` | **FAIL** - Parameter doesn't exist |
| 4.1 | R1 | Query logs with `/loki/api/v1/query?query={job="test"}` | **FAIL** - Returns 400 for log queries |
| 4.2 | R2 | Test connection with `/label` | **FAIL** - Endpoint doesn't exist |
| 4.3 | R2 | Query with `/label/__name__!='' status=0` | **FAIL** - Invalid syntax |
| 3.2 | R1 | Push test returns 204 | **PASS** - Correct status code |
| 3.3 | R1 | `/ready` returns "ready" | **PASS** - Valid endpoint |

---

## Environment Dependency vs Response Error

**Environment Dependency** (Not response's fault):
- Missing tools (`jq`, `telnet`, `ntpdate`)
- Different systemd unit names
- Different file paths
- Docker vs bare-metal installation differences

**Response Error** (Counts against accuracy):
- Incorrect parameter names (`server_url`, `auth_peers`)
- Invalid API endpoints (`/label`)
- Malformed query syntax
- Wrong HTTP status codes
- Non-existent configuration options

---

## Test Execution Order

1. **Configuration Verification** (Tests 1.1-1.4) - 15 minutes
2. **Service Status** (Tests 2.1-2.4) - 10 minutes
3. **Network Connectivity** (Tests 3.1-3.3) - 10 minutes
4. **API Endpoints** (Tests 4.1-4.3) - **Most Critical** - 15 minutes
5. **Firewall** (Tests 5.1-5.2) - Optional - 10 minutes
6. **Time Sync** (Tests 6.1-6.2) - 5 minutes
7. **Grafana UI** (Tests 7.1-7.2) - 15 minutes

**Total Time**: ~1.5 hours for comprehensive testing

---

## Quick Start Guide

### Minimal Test Set (30 minutes)

If time is limited, run these critical tests:

```bash
# 1. Check Promtail config parameter (R2 error)
grep -r "server_url\|clients:" /etc/promtail/

# 2. Check Loki auth_peers (R2 error)
grep "auth_peers" /etc/loki/*.yml

# 3. Test R1's log push
curl -v -H "Content-Type: application/json" -X POST \
  -d '{"streams": [{"stream": {"job": "test"}, "values": [[ "'$(date +%s)000000000'", "test" ]]}]}' \
  http://<LOKI_IP>:3100/loki/api/v1/push

# 4. Test R1's query endpoint (expected to fail)
curl -s "http://localhost:3100/loki/api/v1/query?query={job=\"test\"}" | jq .

# 5. Test R2's /label endpoint (expected 404)
curl -v http://<LOKI_IP>:3100/label

# 6. Test R2's malformed query (expected to fail)
curl -X GET "http://<LOKI_IP>:3100/label/__name__!='' status=0"
```

---

## Safety Notes

⚠️ **WARNING**: Some tests involve:
- Opening firewall ports (Tests 5.1, 5.2)
- Sending test data to Loki (Test 3.2)
- Following live logs (may spam terminal)

Always:
- Get permission before modifying firewall rules
- Test on non-production systems first
- Use Ctrl+C to exit `journalctl -f` or log-following commands
- Record original firewall state before changes

---

## Expected Final Outcomes

Based on factual file analysis and documentation verification:

### Response 1 Accuracy: ~90%
**Major Issues**:
- Query endpoint usage is disputed (Test 4.1)
- NTP package recommendation is outdated (Test 6.2)
- Minor: unsubstantiated 95% statistic, broken link

**Strengths**:
- All configuration parameters correct
- Valid commands and syntax
- Correct HTTP status codes (204, 200)
- Systematic troubleshooting approach

### Response 2 Accuracy: ~60%
**Major Issues**:
- `server_url` doesn't exist (Test 1.2)
- `auth_peers` doesn't exist (Test 1.3)
- `/label` endpoint wrong (Test 4.2)
- Malformed query syntax (Test 4.3)

**Strengths**:
- Basic systemctl/journalctl commands correct
- General troubleshooting flow logical
- `auth_enabled` parameter exists

---

## Next Steps

After completing tests:

1. Record all outputs in test results template
2. Compare actual results with expected outcomes
3. Update VERIFICATION_REPORT.md with test evidence
4. Document any environment-specific findings
5. Create AOI (Areas of Improvement) based on verified failures
