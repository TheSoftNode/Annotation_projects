
## **TL;DR**

**Use `systemd‑cat` (or any other program that talks to `journald`) and pipe the output to a dedicated service file.**  
That gives you:

* reliable, per‑user rate‑limited storage (no accidental disk‑fill)  
* built‑in log rotation, compression, and retention policies managed by `journald`  
* no race conditions between users – each writer gets its own “journal entry” that is safely appended by the daemon  
* optional forwarding to a remote system, easy viewing with `journalctl`, and the ability to aggregate logs from many users into a single, searchable stream.

Only fall back to a plain text file **if** you deliberately need a human‑editable, “append‑only” file that lives in a location you control and you accept the associated risks and maintenance overhead.

Below is a deeper dive into why `systemd‑cat` (or the journal API) is the safer, more maintainable choice for a multi‑user Linux group, followed by a practical step‑by‑step implementation.

---

## **1\. What the two options actually do**

| Feature | Plain text file (e.g., `/var/log/group‑script.log`) | `systemd‑cat` (writes to the journal) |
| ----- | ----- | ----- |
| **Atomicity of each write** | *Not guaranteed* – two processes can truncate or interleave their text, causing missing or garbled lines. | Each `systemd‑cat` invocation is a *single* write to the journal socket; the daemon queues and serialises entries for you. |
| **File‑level locking** | You must add your own `flock`/`lockfile` logic or rely on shell redirection quirks. Easy to forget or mis‑use. | The journald daemon owns the socket and does the locking for you. |
| **Log rotation & size limits** | You must write your own rotation script (`logrotate`, size check, `mv`/`>file`) or risk unbounded growth. | `journald` automatically rotates, compresses, and discards old entries based on configurable limits (`SystemMaxUse=`, `SystemMaxFileSize=`, etc.). |
| **Per‑user rate limiting** | No built‑in limit – one misbehaving script can fill the disk instantly. | `journald` applies per‑UID rate limits & size caps (see `RateLimitIntervalSec=`/`RateLimitBurst=`). |
| **Querying / filtering** | You need custom `grep`/`awk` pipelines or external tools. | `journalctl -u <unit>` or `journalctl _UID=$UID` gives instant, structured view, regex, time‑range filtering, etc. |
| **Structured metadata** | Only raw text; you must embed your own key=value tags manually. | You can attach fields (`PRIORITY=`, `SYSLOG_IDENTIFIER=`, `COMM=`) directly from `systemd‑cat` for richer queries. |
| **Privileged access** | Needs write permission on the target file (often requires `root` or a specific group). | Any user can write to the journal *if* the system is configured to allow it (default is usually open to all users with `SystemMaxUse=` set). |
| **Remote/central collection** | Must implement a network transport yourself (e.g., rsync, syslog, TCP). | `journald` can forward to remote collectors (via `ForwardToSyslog=`, `ForwardToConsole=`, `ForwardToRemote=`). |
| **Auditability** | File permissions must be manually audited. | Journal entries are immutable once written; `journalctl --verify` can detect tampering. |
| **Dependencies** | Only a file system and permissions. | Requires `systemd` (present on virtually every modern Linux distro). |

### **Bottom line**

If your environment already runs `systemd` (which is the default on most modern distros), leveraging its journal is the **safer, more robust** approach. The only reason to store a traditional log file is when you *explicitly* need a simple, human‑readable flat file that cannot be expressed easily in journald (e.g., a CSV that must be parsed by an external non‑systemd tool).

---

## **2\. How to use `systemd-cat` for per‑user logging**

### **2.1. Basic one‑liner usage**

\#\!/usr/bin/env bash

\# Example script that all group members run

echo "Starting work at $(date)" | systemd-cat \-p info \-t group-script

\# ... your work ...

echo "Finished work at $(date)" | systemd-cat \-p info \-t group-script

* `-p <priority>` maps to syslog priorities: `debug`, `info`, `notice`, `warning`, `error`, `crit`, `alert`, `emerg`.  
* `-t <field>` sets the *SYSTEMD\_IDENTIFIER* field, which makes it easy to filter (`journalctl -t group-script`).

### **2.2. Create a dedicated systemd service for the group**

Create a drop‑in unit that runs under each user’s UID but is started by the system manager. This lets you centralise configuration without giving every user direct access to `journald` sockets.

#### **/etc/systemd/system/group‑log.service**

\[Unit\]

Description=Collect logs from members of the "loggroup" group

\# Optional: only run after network or other services are up

After=network.target

\[Service\]

\# Run as the invoking user (systemd will substitute %i with the user name)

User=%i

Group=loggroup                \# optional – may be omitted if you want only UID

\# This is the command that actually streams output to journald

ExecStart=/usr/bin/systemd-cat \-t group-log

\# When the service stops, flush any pending buffers

ExecStopPost=/usr/bin/systemd-cat \--flush

\# Do NOT keep a persistent journal for this unit; let journald manage it

StandardOutput=journal

StandardError=journal

#### **How to start it per‑user automatically**

For each user `alice`, `bob`, … you can create a *user* unit that spawns `group-log.service` under that UID:

\# As root, enable for every member of the group "loggroup"

for u in $(getent group loggroup | cut \-d: \-f4); do

    mkdir \-p /etc/systemd/user/alice.service

    cat \> /etc/systemd/user/alice.service \<\<'EOF'

\[Unit\]

Description=Group‑log collector for alice

\[Service\]

ExecStart=/usr/bin/systemd-cat \-t group-log

StandardOutput=journal

StandardError=journal

EOF

    systemctl \--user enable alice.service

    systemctl \--user start alice.service

done

**What this gives you:**

* Each user runs a *systemd* service under their own UID, but the service routes all its stdout/stderr into the *system* journal.  
* The service can be stopped/restarted independently (`systemctl --user stop alice.service`).  
* No root‑owned files are created; the only privileged artifact is the system‑wide service that launches per‑user daemons.

---

## **3\. Sample `journalctl` usage for the group**

\# Show all entries from the group log identifier, newest first

journalctl \-t group-log \-n 20

\# Show only entries from a specific UID (e.g., alice)

journalctl \_UID=1001 \-t group-log

\# Show everything from a particular priority range

journalctl \-p warning \-t group-log

\# Export to a plain text file for archiving

journalctl \-t group-log \--output=short-iso \> /var/log/group-log-$(date \+%F).txt

Because journald already stores timestamps, priorities, and the identifier, **no extra parsing** is needed to extract meaningful data.

---

## **4\. When a plain text file might still be justified**

| Situation | Why a plain file could be preferable |
| ----- | ----- |
| **Legacy tools** that only understand raw log files (e.g., an old monitoring agent). | You must write to a known pathname they read. |
| **Human editing** – a sysadmin wants to `tail -f` the file directly. | Simpler to open with `cat`/`less` without needing `journalctl`. |
| **External log forwarding** to a collector that expects plain text over syslog or a TCP socket. | You can still forward the journal entries, but some collectors require a specific file format. |
| **Compliance requirement** for a signed, append‑only log stored on a non‑journald FS (e.g., a read‑only root partition). | Write to a mounted read‑only area and rotate manually. |

If any of these apply, you can still create a **shared file** *and* keep the `systemd-cat` approach as a fallback:

\# Append to a shared file safely (uses flock to avoid race conditions)

logfile="/var/log/group-log.txt"

(

    flock \-n 200 || exit 1               \# acquire exclusive lock

    printf '%s \[%s\] %s\\n' "$(date \+%F\_%T)" "$USER" "$(cat)" \>\> "$logfile"

) 200\>\>"$logfile"

But remember: you must **manage lock acquisition**, handle occasional failures, and rotate the file yourself.

---

## **5\. Security & Permissions Checklist**

If you decide to go the **plain‑file** route, consider these hardening steps:

**Create a dedicated group** (e.g., `logwriters`) and give it write access only to the log file.  
groupadd logwriters

chown root:logwriters /var/log/group-log.txt

chmod 6640 /var/log/group-log.txt   \# group can write, others read

1.   
2. **Set `setgid` on the directory** (`chmod 2775 /var/log/group-log`) so new files inherit the group automatically.  
3. **Apply `auditd` rules** to detect modification or deletion of the file.  
4. **Enable `systemd` file‑system attributes** (`chmod 1730` \+ `sticky`) to prevent one user from deleting another’s files.  
5. **Consider AppArmor/SELinux policies** that restrict which processes can open/write that file.

---

## **6\. Example: Full Minimal Setup (shared service that writes to journal)**

Below is a complete example that you can copy/paste onto a test machine and adapt to your group.

### **6.1. Create a group**

sudo groupadd developers   \# name can be anything

sudo usermod \-aG developers alice

sudo usermod \-aG developers bob

### **6.2. Install a simple logger script**

sudo tee /usr/local/bin/group-logger \<\<'EOS'

\#\!/usr/bin/env bash

\# This script will be executed by each user; it just logs a line.

PRIO=${LOG\_PRIORITY:-info}

ID=${LOG\_ID:-group-logger}

while read \-r line; do

    systemd-cat \-p "$PRIO" \-t "$ID" \<\<\<"$line"

done

EOS

sudo chmod \+x /usr/local/bin/group-logger

### **6.3. Create a systemd unit that runs the logger for each user**

sudo tee /etc/systemd/system/group-logger@.service \<\<'EOS'

\[Unit\]

Description=%i – logger for developers group

After=network.target

\[Service\]

ExecStart=/usr/local/bin/group-logger

\# Inherit the environment variables from the user (optional)

EnvironmentFile=-/etc/default/group-logger   \# optional static config

StandardOutput=journal

StandardError=journal

\# Allow the service to be started per‑user without needing root each time

User=%i

\[Install\]

WantedBy=default.target

EOS

### **6.4. Enable it for each member (optional automation)**

for u in alice bob carol; do

    sudo systemctl enable group-logger@"$u".service

    sudo systemctl start  group-logger@"$u".service

done

Now, any line printed to the script’s `stdout` (e.g., via `echo "something"` or `printf`) will appear in the journal with the identifier `group-logger` and you can retrieve it via:

journalctl \-t group-logger \-f   \# live view

journalctl \-t group-logger \-u alice   \# view alice’s entries

---

## **7\. TL;DR Recommendation Checklist**

1. **Prefer `systemd-cat` → journald** for shared logging in a multi‑user environment.  
2. Deploy a **systemd service unit** (or per‑user unit) that runs `systemd-cat -t <tag>` on each script’s output.  
3. Configure **journal retention** (`/etc/systemd/journald.conf`) to keep the logs you care about (`SystemMaxUse=`, `SystemMaxFileSize=`, `MaxRetentionSec=`).  
4. **Test** by running two users concurrently and verify that entries are not interleaved or truncated.  
5. If you must keep a flat file, **lock it** (`flock`), **rotate** it, and **protect it** with proper permissions/GID.

---

### **Quick “copy‑paste” starter script**

\#\!/usr/bin/env bash

\# file: \~/bin/group-logger.sh   (make it executable)

\# Example: print a timestamp and a message each time the script runs

{

    echo "=== START $(date \+%F\_%T) by $USER \==="

    \# put whatever your real task does here

    sleep 1

    echo "=== END $(date \+%F\_%T) by $USER \==="

} | systemd-cat \-p info \-t group-logger

Run it with:

\~$ ./bin/group-logger.sh

And later view the collected entries:

$ journalctl \-t group-logger \-u $USER \-e   \# latest entries for this user

---

## **8\. Final Thought**

The “best” solution in a modern Linux group is **not about the storage location** per se, but about **how you integrate the logging mechanism with the system’s native log manager**. Leveraging `systemd-cat` (or the `journald` API) gives you:

* automatic, per‑user isolation  
* centralised, searchable logs  
* built‑in size/compression management  
* minimal admin overhead

Using a naïve shared text file works for tiny prototypes, but it scales poorly and can introduce hard‑to‑debug race conditions or denial‑of‑service scenarios when multiple group members start writing logs simultaneously.

*Happy logging, and enjoy the richer visibility that journald brings\!* 🚀

      
