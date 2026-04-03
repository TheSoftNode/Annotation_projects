# AOI #1 Verification Test Guide

## Claim to Verify
**Response 1 AOI #1:** The professional menu example has 5 options but only implements case handlers for options 1, 2, and 5. Options 3 (Network Tools) and 4 (Disk Utilities) have no corresponding case statements, which causes the menu to silently loop back without any action or feedback.

---

## Test Script
**Location:** `r1_aoi1_professional_menu_with_logs.sh`

**What it does:**
- Runs the exact code from Response 1 (Professional Menu example)
- Adds detailed logging to track what happens when each option is selected
- Logs to `/tmp/dialog_menu_test.log`

---

## How to Run the Test

### Step 1: Run the script
```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/task_15/test_environment
./r1_aoi1_professional_menu_with_logs.sh
```

### Step 2: Test Each Option
The menu will appear with arrow key navigation. Test in this order:

1. **Test Option 1 (View System Info):**
   - Use arrow keys to select option 1
   - Press Enter
   - **Expected:** Should show system info dialog, then return to menu
   - **Log should show:** Handler executed for option 1

2. **Test Option 2 (Manage Users):**
   - Select option 2
   - Press Enter
   - **Expected:** Should show username input dialog, then return to menu
   - **Log should show:** Handler executed for option 2

3. **Test Option 3 (Network Tools) - THE BUG:**
   - Select option 3
   - Press Enter
   - **Expected:** Menu should reappear immediately with NO action
   - **Log should show:** ⚠️ NO HANDLER FOUND for choice '3'

4. **Test Option 4 (Disk Utilities) - THE BUG:**
   - Select option 4
   - Press Enter
   - **Expected:** Menu should reappear immediately with NO action
   - **Log should show:** ⚠️ NO HANDLER FOUND for choice '4'

5. **Test Option 5 (Exit):**
   - Select option 5
   - Press Enter
   - **Expected:** Should show "Goodbye!" and exit
   - **Log should show:** Handler executed for option 5, Exiting program

### Step 3: Examine the log file
```bash
cat /tmp/dialog_menu_test.log
```

---

## What the Log Will Show

### For Options 1, 2, 5 (Working):
```
[Iteration X] User selected: '1' (exit status: 0)
[Iteration X] Executing handler for option 1 (View System Info)
[Iteration X] Completed handler for option 1
[Iteration X] End of case statement, looping back...
```

### For Options 3, 4 (BROKEN - No Handlers):
```
[Iteration X] User selected: '3' (exit status: 0)
[Iteration X] ⚠️  NO HANDLER FOUND for choice '3' - falling through to loop restart
[Iteration X] End of case statement, looping back...
```

---

## Code Analysis

### The Case Statement (from Response 1):
```bash
case $choice in
    1)
        dialog --title "System Info" --msgbox "$(uname -a)" 10 50
        ;;
    2)
        dialog --title "User Management" --inputbox "Enter username:" 8 40 2>&1 >/dev/tty
        ;;
    5)
        clear
        echo "Goodbye!"
        exit 0
        ;;
esac
```

### The Problem:
- Menu declares 5 options: 1, 2, 3, 4, 5
- Case statement only handles: 1, 2, 5
- **Missing:** Cases for 3 and 4
- **Result:** When user selects 3 or 4, case statement has no matching handler, falls through, loops back to menu

---

## Expected Test Results

### Verification Checklist:
- [ ] Option 1 executes handler (shows system info)
- [ ] Option 2 executes handler (shows input dialog)
- [ ] Option 3 does NOTHING (silent loop back) ⚠️
- [ ] Option 4 does NOTHING (silent loop back) ⚠️
- [ ] Option 5 executes handler (exits program)
- [ ] Log file shows "NO HANDLER FOUND" for options 3 and 4
- [ ] No error messages displayed to user for options 3 and 4

---

## Why This is an AOI

**User Experience Impact:**
1. User sees 5 options in the menu
2. User expects all 5 options to work
3. Selecting options 3 or 4 produces NO feedback
4. No error message, no action, no indication of why nothing happened
5. Creates confusion: "Is this broken? Did I do something wrong?"

**Severity: Minor** because:
- This is example code in the response
- Other examples work correctly
- Doesn't prevent user from understanding the main answer
- But it IS broken code that shouldn't be presented as working

---

## After Testing

Once you've confirmed the behavior, save the log output as evidence:
```bash
cp /tmp/dialog_menu_test.log /Users/apple/Desktop/Applyloop-project3/Tasks/task_15/test_environment/AOI1_VERIFICATION_LOG.txt
```

This log file will serve as **Source Excerpt** for AOI #1 verification.
