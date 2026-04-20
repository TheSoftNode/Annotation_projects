# Response 1

Here's a **step-by-step troubleshooting guide** to resolve your Grafana/Loki/Promtail cross-server issue. The problem is almost always in **network connectivity**, **configuration mismatches**, or **incorrect data source setup**. Follow these checks systematically:

---

### **🔍 Phase 1: Verify Promtail → Loki Connection**

*(Is Promtail actually sending logs to Loki?)*

**Check Promtail Logs** (on the Promtail server):
```bash
journalctl -u promtail -f  # If using systemd
# OR
cat /var/log/promtail.log   # Default log location
```

1. **Look for errors** like:
   * `failed to send log entries: Post "http://<LOKI_IP>:3100/...": dial tcp <LOKI_IP>:3100: connect: connection refused`
   * `server returned HTTP status 401 Unauthorized` (auth issue)
   * `context deadline exceeded` (network timeout)

2. **Verify Promtail Config** (`/etc/promtail/promtail-config.yml`):

Ensure `clients.url` points to the **Loki server's PUBLIC IP/FQDN** (not `localhost`!):
```yaml
clients:
  - url: http://<LOKI_SERVER_PUBLIC_IP>:3100/loki/api/v1/push
```

* ⚠️ **Critical**: If Loki uses HTTPS/reverse proxy (e.g., Nginx), the URL **must** match (e.g., `https://logs.example.com/loki/api/v1/push`).

**Test Network Connectivity** (from Promtail server → Loki server):
```bash
telnet <LOKI_SERVER_PUBLIC_IP> 3100
# OR
nc -zv <LOKI_SERVER_PUBLIC_IP> 3100
```

3.
   * ✅ **Success**: `Connected to ...`
   * ❌ **Failure**: `Connection refused` or timeout → **Firewall/Network issue** (see [Phase 4](https://app.superannotate.com/editor/custom-llm/#-phase-4-check-network--firewall)).

**Manually Send a Test Log** (from Promtail server):
```bash
curl -v -H "Content-Type: application/json" -X POST \
  -d '{"streams": [{"stream": {"job": "test"}, "values": [[ "'$(date +%s)000000000'", "test log message" ]]}]}' \
  http://<LOKI_SERVER_PUBLIC_IP>:3100/loki/api/v1/push
```

4.
   * If this **fails**, Loki isn't reachable → Fix network/firewall first.
   * If this **succeeds**, but Promtail logs don't appear → Promtail config is broken.

---

### **🕵️ Phase 2: Verify Loki is Receiving Logs**

*(Is Loki storing the logs?)*

**Check Loki Logs** (on Loki server):
```bash
journalctl -u loki -f  # If using systemd
# OR
cat /var/log/loki.log
```

1.
   * Look for:
     * `POST /loki/api/v1/push` entries (with 204 status = success).
     * Errors like `invalid chunk` or `tenant ID not set`.

**Query Loki Directly** (on Loki server):
```bash
curl -s "http://localhost:3100/loki/api/v1/query?query={job=\"test\"}" | jq .
```

2.
   * Replace `job="test"` with your Promtail `job_name` (from Promtail config).
   * ✅ **Success**: Returns log entries.
   * ❌ **Failure**: `{"status":"error","errorType":"timeout","error":"query timed out"}` → Loki isn't receiving data.

3. **Check Loki Configuration** (`/etc/loki/loki-config.yml`):

Ensure `server.http_listen_address` is **not** `127.0.0.1` (binds to localhost only!). Should be:
```yaml
server:
  http_listen_address: 0.0.0.0  # Listens on all interfaces
```

---

### **🖥️ Phase 3: Verify Grafana → Loki Connection**

*(Is Grafana talking to Loki correctly?)*

1. **Check Grafana Loki Data Source**:
   * In Grafana: **Configuration → Data Sources → Loki**.
   * **URL**: Must be `http://<LOKI_SERVER_PUBLIC_IP>:3100` (or `https://...` if using TLS).
   * ⚠️ **Common Mistakes**:
     * Using `localhost` (Grafana runs on a different server!).
     * Missing `/loki` path if Loki is behind a reverse proxy (e.g., `http://<IP>:3100/loki`).
     * Wrong port (default is `3100`, not `9080`).

2. **Test Connection in Grafana**:
   * Click **"Save & Test"** in the Loki data source config.
   * ✅ **Success**: "Data source is working".
   * ❌ **Failure**: "HTTP Error Bad Gateway" → Network issue or wrong URL.

3. **Query Loki via Grafana's Debug Mode**:
   * Open browser dev tools (F12) → Network tab.
   * Run a Loki query in Grafana (e.g., `{job="your_job"}`).
   * Check the **XHR request** to `/loki/api/v1/query`.
   * Look for:
     * `401 Unauthorized` → Auth issue (add credentials in Grafana data source).
     * `502 Bad Gateway` → Grafana can't reach Loki (network issue).
     * `404 Not Found` → Wrong path (e.g., missing `/loki`).

---

### **🔥 Phase 4: Check Network & Firewall**

*(Critical for cross-server setups)*

**On Loki Server**:
```bash
sudo ufw allow 3100/tcp  # If using UFW
# OR
sudo firewall-cmd --add-port=3100/tcp --permanent && sudo firewall-cmd --reload  # Firewalld
```

1.

2. **On Promtail Server**:
   * Ensure outbound traffic to `<LOKI_IP>:3100` is allowed.

**Test from Grafana Server**:
```bash
curl -v http://<LOKI_SERVER_PUBLIC_IP>:3100/ready
```

3.
   * Should return `ready`. If not → Firewall blocks Grafana→Loki.

---

### **⏱️ Phase 5: Check Time Synchronization**

*(Logs might be "invisible" due to time skew)*

Ensure **all servers (Grafana, Loki, Promtail) use NTP**:
```bash
timedatectl status | grep "NTP service"
```

*
  * If `inactive`, install NTP: `sudo apt install ntp` (Debian) or `sudo yum install ntp` (RHEL).

---

### **✅ Final Checklist**

| Issue Area | What to Verify |
| ----- | ----- |
| **Promtail Config** | `clients.url` = `http://<LOKI_PUBLIC_IP>:3100/loki/api/v1/push` (no `localhost`!) |
| **Loki Config** | `http_listen_address: 0.0.0.0` (not `127.0.0.1`) |
| **Firewall** | Port `3100` open on Loki server for Promtail **and** Grafana servers |
| **Grafana DS URL** | Exactly matches Loki's public endpoint (test with `curl` first!) |
| **Time Sync** | All servers within 1-2 seconds of each other (use `ntpdate -q pool.ntp.org`) |

---

### **💡 Pro Tips**

* **Use `loki-canary`**: Deploy [Loki Canary](https://grafana.com/docs/loki/latest/send-data/loki-canary/) to simulate log traffic and monitor pipeline health.
* **Simplify**: Temporarily disable firewalls (`sudo ufw disable`) for testing (re-enable after!).
* **Logs > Metrics**: If you see metrics in Grafana but not logs, Loki is the culprit (not Prometheus).

If you follow these steps, **95% of cases are resolved by fixing the Promtail `clients.url` or firewall rules**. Start with **Phase 1 (Promtail logs)** – that's where most failures happen! 🚀
