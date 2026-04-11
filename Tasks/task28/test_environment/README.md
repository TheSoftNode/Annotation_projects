# Task 28 Test Environment

## Structure

```
test_environment/
├── R1/                           # Response 1 specific tests
│   ├── test_R1_service_file_claims.sh
│   ├── test_R1_flock_example.sh
│   └── test_R1_permissions_commands.sh
├── R2/                           # Response 2 specific tests
│   ├── test_R2_logger_command.sh
│   └── test_R2_example_script.sh
├── test_shared_atomicity.sh      # Tests claims both make
├── run_all_tests.sh              # Master test runner
└── outputs/                      # Test results
    ├── R1/
    ├── R2/
    └── *.txt
```

## Quick Start (GitHub Codespaces)

```bash
cd /workspaces/*/Tasks/task28/test_environment
chmod +x *.sh R1/*.sh R2/*.sh
./run_all_tests.sh
```

## Individual Test Execution

### R1 Tests
```bash
bash R1/test_R1_service_file_claims.sh
bash R1/test_R1_flock_example.sh
bash R1/test_R1_permissions_commands.sh
```

### R2 Tests
```bash
bash R2/test_R2_logger_command.sh
bash R2/test_R2_example_script.sh
```

### Shared Tests
```bash
bash test_shared_atomicity.sh  # CRITICAL: Race condition test
```

## Key Tests

### Most Important: Atomicity Test
`test_shared_atomicity.sh` - Tests the core claim that journald is atomic while plain files have race conditions.

**Claims tested:**
- R1-001: Plain files can interleave/truncate
- R2-020: Concurrent writes interleave
- R1-002/R1-003: systemd-cat writes are atomic
- R2-011/R2-012: journald avoids garbled output

### R1 Specific Tests

**Service Files** - Tests R1's systemd service configuration claims
**flock** - Tests R1's file locking example for shared log safety
**Permissions** - Tests R1's chmod/chown security commands

### R2 Specific Tests

**logger** - Tests R2's claim about logger as alternative to systemd-cat
**Example Script** - Tests R2's simple example code

## Viewing Results

```bash
# All outputs
ls -lh outputs/**/*.txt outputs/*.txt

# R1 results
cat outputs/R1/test_R1_*

# R2 results
cat outputs/R2/test_R2_*

# Shared results
cat outputs/test_shared_*
```

## Understanding Test Output

- **✓** = Claim verified / Test passed
- **✗** = Claim disputed / Test failed
- **⚠** = Inconclusive / Needs manual check

## Full Claim Reference

See `../helpers/Factual_Test_Plan_Task28.md` for complete list of 80+ claims tested.

## Requirements

- Linux with systemd (Ubuntu/Debian Codespaces)
- systemd-cat, journalctl commands
- Bash 4.0+
- sudo access (for some tests)
