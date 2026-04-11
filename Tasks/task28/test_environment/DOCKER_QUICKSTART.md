# Docker Quick Start Guide - Task 28 Testing

This guide shows how to run all Task 28 tests in a Docker container with systemd.

## Why Docker?

- ✅ **Isolated environment** - doesn't affect your Mac or VM
- ✅ **systemd as PID 1** - proper systemd environment
- ✅ **Complete systemd stack** - journald, systemd-cat, journalctl all work
- ✅ **Easy cleanup** - just stop the container
- ✅ **Outputs saved locally** - mounted volume to `./outputs/`

## Prerequisites

- Docker installed on your Mac
- Docker Compose installed

Check:
```bash
docker --version
docker-compose --version
```

## Quick Start (3 commands)

### Option 1: Automated (Recommended)

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task28/test_environment
chmod +x run_tests_in_docker.sh
./run_tests_in_docker.sh
```

This will:
1. Build Docker image with Ubuntu 22.04 + systemd
2. Start container with systemd as PID 1
3. Run all 18 GPT tests (10 R1 + 8 R2)
4. Save outputs to `./outputs/R1/` and `./outputs/R2/`

### Option 2: Manual Steps

```bash
# 1. Build and start container
docker-compose up -d

# 2. Wait for systemd to initialize
sleep 5

# 3. Verify systemd is running
docker exec task28_systemd_tests ps -p 1 -o comm=

# 4. Run tests
docker exec task28_systemd_tests bash -c "cd /task28_tests && ./run_all_GPT_tests_with_output.sh"

# 5. Check outputs
ls -la outputs/R1/
ls -la outputs/R2/
```

## Output Files

All test outputs are automatically saved to your local Mac:

```
outputs/
├── R1/
│   ├── GPT_test_01_basic_systemd_cat_output.txt
│   ├── GPT_test_02_UID_filtering_output.txt
│   ├── GPT_test_03_unit_vs_user_output.txt
│   ├── GPT_test_04_flock_snippet_output.txt
│   ├── GPT_test_05_systemd_cat_flush_output.txt
│   ├── GPT_test_06_service_unit_verbatim_output.txt
│   ├── GPT_test_07_user_unit_loop_output.txt
│   ├── GPT_test_08_group_logger_script_output.txt
│   ├── GPT_test_09_template_unit_output.txt
│   └── GPT_test_10_chmod_6640_output.txt
└── R2/
    ├── GPT_test_01_basic_systemd_cat_output.txt
    ├── GPT_test_02_current_boot_output.txt
    ├── GPT_test_03_logger_alternative_output.txt
    ├── GPT_test_04_metadata_filtering_output.txt
    ├── GPT_test_05_UID_filter_output.txt
    ├── GPT_test_06_authorized_readers_output.txt
    ├── GPT_test_07_atomic_concurrent_output.txt
    └── GPT_test_08_shared_file_risks_output.txt
```

## Useful Commands

### Enter the container
```bash
docker exec -it task28_systemd_tests bash
```

### Check journal entries
```bash
docker exec task28_systemd_tests journalctl -n 50 --no-pager
```

### Re-run tests manually
```bash
docker exec task28_systemd_tests bash -c "cd /task28_tests && ./run_all_GPT_tests_with_output.sh"
```

### View container logs
```bash
docker logs task28_systemd_tests
```

### Stop and remove container
```bash
docker-compose down
```

### Stop and remove with cleanup
```bash
docker-compose down -v
```

## Troubleshooting

### "systemd is not PID 1"

The container needs `--privileged` mode and cgroup mounts. This is configured in `docker-compose.yml`.

### "Permission denied"

Make sure scripts are executable:
```bash
chmod +x run_tests_in_docker.sh
chmod +x run_all_GPT_tests_with_output.sh
```

### "Container won't start"

Check Docker daemon is running:
```bash
docker ps
```

Rebuild the image:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### "Tests are hanging"

Some tests may take time (concurrent write tests). Wait at least 5 minutes before checking.

Enter container to debug:
```bash
docker exec -it task28_systemd_tests bash
cd /task28_tests
./run_all_GPT_tests_with_output.sh
```

## Architecture

```
┌─────────────────────────────────────┐
│  Your Mac (Host)                    │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Docker Container              │ │
│  │                               │ │
│  │ ┌─────────────────────────┐   │ │
│  │ │ systemd (PID 1)         │   │ │
│  │ │  ├─ systemd-journald    │   │ │
│  │ │  ├─ dbus                │   │ │
│  │ │  └─ other services      │   │ │
│  │ └─────────────────────────┘   │ │
│  │                               │ │
│  │ /task28_tests/                │ │
│  │  ├─ R1/ (10 tests)            │ │
│  │  ├─ R2/ (8 tests)             │ │
│  │  └─ outputs/ ← MOUNTED       │ │
│  └───────────────────────────────┘ │
│         │                           │
│         └─→ ./outputs/ (local)     │
└─────────────────────────────────────┘
```

## Why This Works

1. **Ubuntu 22.04** - Full systemd support
2. **Privileged mode** - Needed for systemd to manage cgroups
3. **systemd as PID 1** - Proper init system
4. **Volume mount** - `./outputs/` is shared between container and host
5. **No VM needed** - Runs locally on your Mac

## Cleanup

When done testing:

```bash
# Stop container
docker-compose down

# Remove image
docker rmi task28_test_environment_task28-systemd

# Keep outputs
ls -la outputs/
```

The output files remain on your Mac even after removing the container.
