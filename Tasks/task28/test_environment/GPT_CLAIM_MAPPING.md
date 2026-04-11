# GPT Factual Claim Mapping - Task 28

This document maps each GPT Factual claim to the test script(s) that verify it.

## R1 Claims (21 claims from GPT_FACTUAL_R1_TASK28.md)

| Claim # | Description | Test Script | Status |
|---------|-------------|-------------|--------|
| 1 | Per-user rate limiting | GPT_test_01 | DISPUTED - docs say per-service |
| 2 | systemd-cat sends to journal | GPT_test_01 | CONFIRMED |
| 3 | -p sets priority level | GPT_test_01 | CONFIRMED |
| 4 | Each systemd-cat invocation is single write | GPT_test_01 | UNSUPPORTED - no docs |
| 5 | -t sets identifier | GPT_test_01 | CONFIRMED |
| 6 | Per-UID rate limits | GPT_test_02 | DISPUTED - per-service not per-UID |
| 7 | journalctl retrieves by identifier | GPT_test_01 | CONFIRMED |
| 8 | _UID= field filtering works | GPT_test_02 | CONFIRMED |
| 9 | Journal entries immutable | N/A | OVERSTATED - not fully immutable |
| 10 | ForwardToRemote= exists | N/A | DISPUTED - not documented |
| 11 | Storage= backend exists | N/A | CONFIRMED (in docs) |
| 12 | -t sets SYSTEMD_IDENTIFIER | GPT_test_01 | WRONG - sets SYSLOG_IDENTIFIER |
| 13 | systemctl enable/start syntax | GPT_test_07 | CONFIRMED |
| 14 | _UID= field match | GPT_test_02 | CONFIRMED |
| 15 | journalctl -u alice (user filter) | GPT_test_03 | WRONG - -u is unit not user |
| 16 | journalctl -u $USER (user filter) | GPT_test_03 | WRONG - -u is unit not user |
| 17 | systemd-cat --flush exists | GPT_test_05 | WRONG - --flush is journalctl only |
| 18 | flock -n is nonblocking | GPT_test_04 | CONFIRMED |
| 19 | flock exclusive locking | GPT_test_04 | CONFIRMED |
| 20 | StandardInput=socket directive | GPT_test_09 | CONFIRMED but INCOMPLETE |
| 21 | chmod 6640 comment mismatch | GPT_test_10 | MISMATCH - comment incomplete |

### R1 Test Coverage Summary

- **GPT_test_01_basic_systemd_cat.sh** - Claims 1, 2, 3, 4, 5, 7, 12
- **GPT_test_02_UID_filtering.sh** - Claims 6, 8, 14
- **GPT_test_03_unit_vs_user.sh** - Claims 15, 16 (DISPROVES)
- **GPT_test_04_flock_snippet.sh** - Claims 18, 19
- **GPT_test_05_systemd_cat_flush.sh** - Claim 17 (DISPROVES)
- **GPT_test_06_service_unit_verbatim.sh** - Tests R1's service file
- **GPT_test_07_user_unit_loop.sh** - Claim 13, ordering issues
- **GPT_test_08_group_logger_script.sh** - Tests wrapper script
- **GPT_test_09_template_unit.sh** - Claim 20, template syntax
- **GPT_test_10_chmod_6640.sh** - Claim 21

---

## R2 Claims (24 claims from GPT_FACTUAL_R2_TASK28.md)

| Claim # | Description | Test Script | Status |
|---------|-------------|-------------|--------|
| 1 | systemd-cat better than shared file | N/A | RECOMMENDATION (not pure fact) |
| 2 | journald securely collects logs | GPT_test_06 | SUPPORTED in substance |
| 3 | Only root/systemd-journal can read | GPT_test_06 | MOSTLY CORRECT (incomplete) |
| 4 | Shared file security risks | GPT_test_08 | CONFIRMED (general Unix behavior) |
| 5 | systemd-cat no write access needed | GPT_test_01 | SUPPORTED |
| 6 | journald structured logs metadata | GPT_test_04 | CONFIRMED |
| 7 | journalctl filtering capabilities | GPT_test_01-05 | CONFIRMED |
| 8 | journald log rotation automatic | N/A | CONFIRMED (in docs) |
| 9 | No need to implement log rotation | N/A | SUPPORTED |
| 10 | Atomic writes, no garbled output | GPT_test_07 | STRONGER than docs state |
| 11 | journalctl -u myscript.service | GPT_test_01 | CONFIRMED |
| 12 | journalctl SYSLOG_IDENTIFIER= | GPT_test_04 | CONFIRMED |
| 13 | journalctl _UID=1001 | GPT_test_05 | CONFIRMED |
| 14 | Shared file overwrite/corrupt risk | GPT_test_08 | CONFIRMED |
| 15 | Hard to attribute in shared file | GPT_test_08 | SUPPORTED |
| 16 | Concurrent writes can interleave | GPT_test_08 | CONFIRMED empirically |
| 17 | Manual rotation/permissions needed | GPT_test_08 | SUPPORTED |
| 18 | Users can flood/erase logs | GPT_test_08 | CONFIRMED |
| 19 | No per-user limit (shared file) | N/A | CONFIRMED (no built-in) |
| 20 | systemd-cat pipeline example | GPT_test_01 | CONFIRMED |
| 21 | journalctl -t myscript | GPT_test_01 | CONFIRMED |
| 22 | journalctl -t myscript -b | GPT_test_02 | CONFIRMED |
| 23 | logger -t myscript command | GPT_test_03 | CONFIRMED |
| 24 | logger sends to journald | GPT_test_03 | CONFIRMED |

### R2 Test Coverage Summary

- **GPT_test_01_basic_systemd_cat.sh** - Claims 5, 7, 11, 20, 21
- **GPT_test_02_current_boot.sh** - Claim 22
- **GPT_test_03_logger_alternative.sh** - Claims 23, 24
- **GPT_test_04_metadata_filtering.sh** - Claims 6, 12
- **GPT_test_05_UID_filter.sh** - Claim 13
- **GPT_test_06_authorized_readers.sh** - Claims 2, 3
- **GPT_test_07_atomic_concurrent.sh** - Claim 10 (empirical test)
- **GPT_test_08_shared_file_risks.sh** - Claims 4, 14, 15, 16, 17, 18

---

## Key Findings

### R1 Issues Identified

1. **WRONG Claims**:
   - Claim 12: -t sets SYSTEMD_IDENTIFIER (actually SYSLOG_IDENTIFIER)
   - Claim 15/16: journalctl -u for user filtering (-u is unit, not user)
   - Claim 17: systemd-cat --flush (--flush belongs to journalctl)

2. **DISPUTED Claims**:
   - Claim 1/6: Per-user/per-UID rate limiting (actually per-service)
   - Claim 10: ForwardToRemote= (not found in docs)

3. **UNSUPPORTED Claims**:
   - Claim 4: Single write atomicity (no explicit docs)

4. **INCOMPLETE Implementations**:
   - Claim 20: StandardInput=socket without .socket unit
   - Claim 21: chmod 6640 comment doesn't show 'S' bits

### R2 Issues Identified

1. **OVERSTATED Claims**:
   - Claim 10: "Atomic writes" stronger than manual states

2. **INCOMPLETE Claims**:
   - Claim 3: Mentions root and systemd-journal, but omits adm and wheel groups

3. **Otherwise STRONG**: Most R2 claims are well-supported by docs and empirical tests

---

## Testing Environment Requirements

**MUST HAVE**:
- Linux with systemd as PID 1
- Commands: systemd-cat, journalctl, logger, systemctl, flock
- Azure Ubuntu VM or GitHub Codespaces (with systemd)

**WILL NOT WORK**:
- macOS (no systemd)
- GitHub Codespaces without systemd as PID 1
- Docker containers (usually no systemd as init)

**Pre-flight check**:
```bash
command -v bash systemd-cat journalctl logger
ps -p 1 -o comm=  # Must show "systemd"
journalctl --version
```

---

## Running the Tests

### Run all GPT tests:
```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task28/test_environment
chmod +x run_all_GPT_tests.sh
./run_all_GPT_tests.sh
```

### Run individual R1 test:
```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task28/test_environment/R1
chmod +x GPT_test_01_basic_systemd_cat.sh
./GPT_test_01_basic_systemd_cat.sh
```

### Run individual R2 test:
```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task28/test_environment/R2
chmod +x GPT_test_01_basic_systemd_cat.sh
./GPT_test_01_basic_systemd_cat.sh
```
