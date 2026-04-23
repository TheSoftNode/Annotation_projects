# Task 48 - Code Testing Results

## Response 1 Testing

### Code Sample 1: Full Version (calc_full.sh)

**Test 1: Addition (5 + 3)**
```
Input: 5, 3, +
Output: 8
Result: ✅ PASS
```

**Test 2: Division by Zero (10 / 0)**
```
Input: 10, 0, /
Output: Error: Cannot divide by zero.
Exit Code: 1
Result: ✅ PASS
```

**Test 3: Invalid Input (abc + 5)**
```
Input: abc, 5, +
Output: Loops asking for valid integer
Result: ✅ PASS (input validation works)
```

**Test 4: Multiplication (8 * 2)**
```
Input: 8, 2, *
Output: Error: Invalid operation: *
Result: ❌ FAIL - CRITICAL BUG
```

**🚨 CRITICAL BUG in R1 Full Version:**
- The `*` operator in the final case statement (line 154-156) conflicts with the wildcard pattern `*)`
- When user enters `*` for multiplication, it reaches the final case after division check
- The case wildcard `*)` matches ANY input, including the literal `*` operator
- This causes multiplication to trigger "Invalid operation" error
- **Root cause**: The final case statement handles `+`, `-`, and has `*)` as catchall, but `*` for multiplication was already handled in `read_operator()` so it reaches the main case where `*)` is the wildcard

### Code Sample 2: Minimal Version (calc_minimal.sh)

**Test 1: Addition (5 + 3)**
```
Input: 5, 3, +
Output: 8
Result: ✅ PASS
```

**Test 2: Division by Zero (10 / 0)**
```
Input: 10, 0, /
Output: Error: Cannot divide by zero.
Exit Code: 1
Result: ✅ PASS
```

**Test 3: Invalid Input (abc + 5)**
```
Input: abc, 5, +
Output: First value must be an integer.
Exit Code: 1
Result: ✅ PASS
```

**Test 4: Multiplication (8 * 2)**
```
Input: 8, 2, *
Output: 16
Result: ✅ PASS
```

**Test 5: Integer Division (10 / 3)**
```
Input: 10, 3, /
Output: 3
Result: ✅ PASS (correct integer division)
```

---

## Response 2 Testing

### Code Sample: Improved Version (calc_improved.sh)

**Test 1: Addition (5 + 3)**
```
Input: 5, 3, +
Output: Result: 8
Result: ✅ PASS
```

**Test 2: Division by Zero (10 / 0)**
```
Input: 10, 0, /
Output: Error: Cannot divide by zero.
Exit Code: 0 (script continues, doesn't exit)
Result: ❌ FAIL - BUG
```

**🚨 BUG in R2:**
- Division by zero prints error message but does NOT exit
- Script continues execution and returns exit code 0 (success)
- This violates the claim in the summary table that says "Exit with error message"
- **Root cause**: Missing `exit 1` after the error message on line 30

**Test 3: Invalid Input (abc + 5)**
```
Input: abc, 5, +
Output: Error: Both numbers must be integers.
Exit Code: 1
Result: ✅ PASS
```

**Test 4: Multiplication (8 * 2)**
```
Input: 8, 2, *
Output: Result: 16
Result: ✅ PASS
```

---

## Summary of Issues Found

### Response 1 Issues:
1. ✅ **Minimal version**: Works correctly for all test cases
2. ❌ **Full version**: CRITICAL BUG - multiplication operator fails due to case wildcard conflict

### Response 2 Issues:
1. ❌ **Division by zero**: Does not exit with error code, continues execution
2. ❌ **Contradiction with summary table**: Table claims "Exit with error message" but code doesn't do this for division by zero

---

## Potential AOIs

### Response 1:
- **SUBSTANTIAL**: The full version's multiplication fails due to case statement wildcard conflict (line 154 `*)` matches the `*` operator)

### Response 2:
- **SUBSTANTIAL**: Division by zero does not exit with error code (missing `exit 1` on line 30)
- **MINOR**: Summary table incorrectly states the fix is to "Exit with error message" but the code doesn't implement this for division by zero
