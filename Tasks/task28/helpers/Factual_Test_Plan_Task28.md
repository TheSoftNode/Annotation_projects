# Task 28 - Factual Test Plan

## User Request
"I am writing a shell script to be used by members of a Linux group. What is better to save the logs efficiently and safely: a log file where all users can write to it or writing the logs to journald using 'systemd-cat'?"

---

## RESPONSE 1 - Testable Claims

### Table Claims (Section 1)

#### Atomicity
- **Claim R1-001**: Two processes writing to plain text file can truncate or interleave text
- **Claim R1-002**: Each systemd-cat invocation is a single write to journal socket
- **Claim R1-003**: journald daemon queues and serializes entries

#### File Locking
- **Claim R1-004**: Plain text requires flock/lockfile logic
- **Claim R1-005**: journald daemon owns socket and does locking

#### Log Rotation & Size Limits
- **Claim R1-006**: journald automatically rotates based on SystemMaxUse configuration
- **Claim R1-007**: journald automatically compresses logs
- **Claim R1-008**: journald discards old entries based on SystemMaxFileSize configuration

#### Per-user Rate Limiting
- **Claim R1-009**: journald applies per-UID rate limits (RateLimitIntervalSec)
- **Claim R1-010**: journald applies per-UID rate limits (RateLimitBurst)

#### Querying/Filtering
- **Claim R1-011**: `journalctl -u <unit>` works for filtering by unit
- **Claim R1-012**: `journalctl _UID=$UID` works for filtering by user ID
- **Claim R1-013**: journalctl provides regex filtering
- **Claim R1-014**: journalctl provides time-range filtering

#### Structured Metadata
- **Claim R1-015**: systemd-cat can attach PRIORITY field
- **Claim R1-016**: systemd-cat can attach SYSLOG_IDENTIFIER field
- **Claim R1-017**: systemd-cat can attach COMM field

#### Privileged Access
- **Claim R1-018**: "Any user can write to the journal if the system is configured to allow it"
- **Claim R1-019**: "default is usually open to all users with SystemMaxUse= set"

#### Remote/Central Collection
- **Claim R1-020**: journald can forward via ForwardToSyslog=
- **Claim R1-021**: journald can forward via ForwardToConsole=
- **Claim R1-022**: journald can forward via ForwardToRemote=

#### Auditability
- **Claim R1-023**: Journal entries are immutable once written
- **Claim R1-024**: `journalctl --verify` can detect tampering

### Code/Command Claims (Section 2)

#### Basic systemd-cat usage (2.1)
- **Claim R1-025**: `echo "text" | systemd-cat -p info -t group-script` works
- **Claim R1-026**: `-p` flag accepts: debug, info, notice, warning, error, crit, alert, emerg
- **Claim R1-027**: `-t` sets SYSLOG_IDENTIFIER field
- **Claim R1-028**: `journalctl -t group-script` filters by identifier

#### Service file claims (2.2)
- **Claim R1-029**: User=%i substitutes with user name
- **Claim R1-030**: `systemd-cat --flush` flushes pending buffers
- **Claim R1-031**: StandardOutput=journal directs output to journal
- **Claim R1-032**: StandardError=journal directs errors to journal

#### User unit automation (2.2)
- **Claim R1-033**: `getent group loggroup | cut -d: -f4` lists group members
- **Claim R1-034**: `systemctl --user enable alice.service` enables user service
- **Claim R1-035**: `systemctl --user start alice.service` starts user service

#### journalctl usage (Section 3)
- **Claim R1-036**: `journalctl -t group-log -n 20` shows 20 newest entries
- **Claim R1-037**: `journalctl _UID=1001 -t group-log` filters by UID
- **Claim R1-038**: `journalctl -p warning -t group-log` filters by priority
- **Claim R1-039**: `journalctl -t group-log --output=short-iso` exports with ISO timestamps

#### flock usage (Section 4)
- **Claim R1-040**: `flock -n 200 || exit 1` acquires exclusive lock on FD 200
- **Claim R1-041**: `200>>"$logfile"` opens file for append on FD 200

#### Security/Permissions (Section 5)
- **Claim R1-042**: `groupadd logwriters` creates group
- **Claim R1-043**: `chown root:logwriters file` sets ownership
- **Claim R1-044**: `chmod 6640 file` sets setuid+setgid with rw-r-----
- **Claim R1-045**: `chmod 2775 dir` sets setgid on directory
- **Claim R1-046**: `chmod 1730` with sticky bit prevents deletion

#### Full example (Section 6)
- **Claim R1-047**: `sudo groupadd developers` creates group
- **Claim R1-048**: `sudo usermod -aG developers alice` adds user to group
- **Claim R1-049**: `sudo tee /path/file <<'EOS'` creates file with heredoc
- **Claim R1-050**: `sudo chmod +x /path/file` makes file executable
- **Claim R1-051**: Service file with User=%i runs as that user
- **Claim R1-052**: `systemctl enable group-logger@"$u".service` enables templated service
- **Claim R1-053**: `systemctl start group-logger@"$u".service` starts templated service
- **Claim R1-054**: `journalctl -t group-logger -f` shows live view
- **Claim R1-055**: `journalctl -t group-logger -u alice` filters by unit name

#### Configuration claims (Section 7)
- **Claim R1-056**: SystemMaxUse= in /etc/systemd/journald.conf controls max disk usage
- **Claim R1-057**: SystemMaxFileSize= controls individual journal file size
- **Claim R1-058**: MaxRetentionSec= controls retention period

#### Quick starter script (Section 7)
- **Claim R1-059**: `echo "text" | systemd-cat -p info -t group-logger` logs to journal
- **Claim R1-060**: `journalctl -t group-logger -u $USER -e` shows latest user entries

---

## RESPONSE 2 - Testable Claims

### Advantages of systemd-cat

#### Centralized and Secure Logging
- **Claim R2-001**: "Only authorized users (typically root or members of systemd-journal group) can read logs"

#### No Shared Write Permissions Required
- **Claim R2-002**: "systemd-cat allows users to send logs securely without needing direct write access to log files"

#### Structured Logging
- **Claim R2-003**: journald supports metadata: timestamp, user, PID, command
- **Claim R2-004**: Can filter by service using journalctl
- **Claim R2-005**: Can filter by user using journalctl
- **Claim R2-006**: Can filter by time using journalctl
- **Claim R2-007**: Can filter by custom fields using journalctl

#### Automatic Log Rotation
- **Claim R2-008**: journald handles log rotation automatically
- **Claim R2-009**: journald handles retention automatically
- **Claim R2-010**: journald handles disk usage limits automatically

#### Atomic and Thread-Safe
- **Claim R2-011**: "journald ensures log entries are written atomically"
- **Claim R2-012**: journald avoids garbled output from concurrent writes

### Code/Command Claims

- **Claim R2-013**: `echo "text" | systemd-cat -t myscript -p info` works
- **Claim R2-014**: `journalctl -t myscript` filters by identifier
- **Claim R2-015**: `journalctl -t myscript -b` limits to current boot
- **Claim R2-016**: `journalctl -u myscript.service` filters by service unit
- **Claim R2-017**: `journalctl SYSLOG_IDENTIFIER=myscript` filters by identifier field
- **Claim R2-018**: `journalctl _UID=1001` filters by user ID
- **Claim R2-019**: `logger -t myscript "text"` sends to system logger

### Risks of Shared Log File

- **Claim R2-020**: Concurrent writes can interleave log lines
- **Claim R2-021**: Users in group can overwrite or corrupt shared log
- **Claim R2-022**: No built-in limit on log size per user

---

## Test Categories

### Category A: systemd-cat Basic Functionality
Tests: R1-025, R1-026, R1-027, R1-028, R1-059, R2-013, R2-014, R2-015

### Category B: journalctl Filtering and Querying
Tests: R1-011, R1-012, R1-013, R1-014, R1-036, R1-037, R1-038, R1-039, R1-055, R1-060, R2-004, R2-005, R2-006, R2-007, R2-016, R2-017, R2-018

### Category C: journald Configuration and Behavior
Tests: R1-006, R1-007, R1-008, R1-009, R1-010, R1-020, R1-021, R1-022, R1-056, R1-057, R1-058, R2-008, R2-009, R2-010

### Category D: Atomicity and Concurrency
Tests: R1-001, R1-002, R1-003, R2-011, R2-012, R2-020

### Category E: Permissions and Security
Tests: R1-018, R1-019, R1-042, R1-043, R1-044, R1-045, R1-046, R2-001, R2-002, R2-021, R2-022

### Category F: systemd Service Units
Tests: R1-029, R1-030, R1-031, R1-032, R1-033, R1-034, R1-035, R1-051, R1-052, R1-053

### Category G: File Locking
Tests: R1-004, R1-005, R1-040, R1-041

### Category H: Auditability and Immutability
Tests: R1-023, R1-024

### Category I: Alternative Tools
Tests: R2-019

### Category J: Metadata and Structured Fields
Tests: R1-015, R1-016, R1-017, R2-003

---

## Test Environment Requirements

- Linux system with systemd (Ubuntu/Debian Codespaces recommended)
- Multiple user accounts (alice, bob, carol) for concurrency testing
- Root/sudo access for system configuration
- Group creation capabilities
- journald running and accessible
