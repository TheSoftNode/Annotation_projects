# Test Instructions for Task 18

## Setup

First, set up the test data:

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task_18/test_environment

# Set environment variables
export environment="production"
export measurement_name="api_server"
export statistics_result_string="cpu 100 0.5 1.2 2.3 3.4 4.5 5.6 6.7"
```

## Test 1: Original Code (PROMPT)

```bash
chmod +x PROMPT_original_code.sh
./PROMPT_original_code.sh
```

**Expected behavior:** Should fail or produce no output (the bug from the PROMPT)

---

## R1 Fixes (3 options)

### Test 2: R1 Fix Option 1 (Using -v, most portable)

```bash
chmod +x R1_fix_option1_using_-v.sh
./R1_fix_option1_using_-v.sh
```

**Expected output:**
```
resource_usage_production,name=api_server cpu_count=100, cpu_min=0.5, cpu_10p=1.2, cpu_25p=2.3, cpu_50p=3.4, cpu_75p=4.5, cpu_90p=5.6, cpu_max=6.7
```

### Test 3: R1 Fix Option 2 (Using ENVIRON)

```bash
chmod +x R1_fix_option2_using_ENVIRON.sh
./R1_fix_option2_using_ENVIRON.sh
```

**Expected output:**
```
resource_usage_production,name=api_server cpu_count=100, cpu_min=0.5, cpu_10p=1.2, cpu_25p=2.3, cpu_50p=3.4, cpu_75p=4.5, cpu_90p=5.6, cpu_max=6.7
```

### Test 4: R1 Fix Option 3 (Using gawk with --assign)

```bash
chmod +x R1_fix_option3_using_gawk.sh
./R1_fix_option3_using_gawk.sh
```

**Expected output:**
```
resource_usage_production,name=api_server cpu_count=100, cpu_min=0.5, cpu_10p=1.2, cpu_25p=2.3, cpu_50p=3.4, cpu_75p=4.5, cpu_90p=5.6, cpu_max=6.7
```

**Note:** This requires GNU awk (gawk) to be installed. Check with: `gawk --version`

---

## R2 Fixes (2 versions)

### Test 5: R2 Fix Version 1 (Assignment-based approach)

```bash
chmod +x R2_fix_version1.sh
./R2_fix_version1.sh
```

**Expected output:**
```
resource_usage_production,name=api_server cpu_count=100,cpu_min=0.5,cpu_10p=1.2,cpu_25p=2.3,cpu_50p=3.4,cpu_75p=4.5,cpu_90p=5.6,cpu_max=6.7
```

### Test 6: R2 Fix Version 2 (Final - cleaner with fields variable)

```bash
chmod +x R2_fix_version2_final.sh
./R2_fix_version2_final.sh
```

**Expected output:**
```
resource_usage_production,name=api_server cpu_count=100,cpu_min=0.5,cpu_10p=1.2,cpu_25p=2.3,cpu_50p=3.4,cpu_75p=4.5,cpu_90p=5.6,cpu_max=6.7
```

**Note:** Both R2 versions use `awk --assign` which requires GNU awk (gawk). R2 assumes --assign works without checking portability.

---

## Summary

**R1 Fixes:**
- **Option 1**: Uses `-v` (POSIX-compliant, works on all awk implementations) ✅ Most portable
- **Option 2**: Uses `ENVIRON` (works on all awk implementations) ✅ Portable
- **Option 3**: Uses `gawk --assign` (GNU awk specific) ⚠️ Requires gawk

**R2 Fixes:**
- **Version 1**: Fixed spacing issue, uses assignment-based concatenation
- **Version 2**: Cleaner approach using fields variable
- Both use `awk --assign` (assumes GNU awk without verification) ⚠️ Requires gawk

Check which version of AWK you have: `awk --version`
