# Source Excerpt Corrections Needed for Task 14

## Problem
Source Excerpts are showing text FROM response files when they should show VERIFICATION RESULTS (test outputs, grep outputs, verbatim documentation).

## Fixes Needed

### R1 AOI #3 - Inverted Export Logic
**Current:** Shows escaped code from RESPONSE_1.md (lines 161-172)
**Should be:** Result of code review analysis showing the logic flow

### R1 AOI #4 - Combobox Read-Only Claim
**Current:** Paraphrased summary (lines 198-203)
**Should be:** Verbatim quote from Python docs about Combobox state

### R1 AOI #5 - Separator Validation
**Current:** Shows escaped code from RESPONSE_1.md (lines 234-249)
**Should be:** Result showing separator string passes empty validation

### R1 AOI #7 - Monolithic Architecture
**Current:** Shows description FROM PROMPT (lines 346-352)
**Should be:** Result of code structure analysis (e.g., "grep -n 'class\|def' shows all in one class")

### R1 AOI #8 - Separator Comment
**Current:** Paraphrased (line 378)
**Should be:** Verbatim quote from Python/ttk docs about Combobox item states

### R2 AOI #1 - Dead Code
**Current:** Shows escaped code from RESPONSE_2.md (lines 499-534)
**Should be:** Result like "grep 'protocol' shows only safe_on_close used"

### R2 AOI #2 - Misleading Comment
**Current:** Shows escaped code from RESPONSE_2.md (lines 563-582)
**Should be:** Just reference same test output as R1 AOI#2 (already has it at line 561)

### R2 AOI #3 - Categorization
**Current:** Shows escaped text from RESPONSE_2.md (lines 608-613)
**Should be:** Verbatim quote (no escapes) from line 1

### R2 AOI #4 - Details Clearing
**Current:** Shows escaped code from both files (lines 639-649)
**Should be:** Grep results showing both have same line

### R2 AOI #5 - Hard-coded Filename
**Current:** Shows escaped code from RESPONSE_2.md (lines 675-680)
**Should be:** grep result showing the hard-coded string

### R2 AOI #6 - Date Not Updated
**Current:** Shows escaped code from RESPONSE_2.md (lines 713-723)
**Should be:** grep result or code analysis showing no date update in stop_activity

### R2 AOI #7 - Opening Pleasantry
**Current:** Shows escaped text from RESPONSE_2.md (lines 750-752)
**Should be:** Verbatim quote (no escapes) from line 1

### R2 AOI #8 - tk.Button Colors
**Current:** Shows escaped code from RESPONSE_2.md (lines 780-797)
**Should be:** grep result showing tk.Button with bg= parameters

## General Rules

**Response Excerpt** = Verbatim from RESPONSE file (can have escapes if needed for display)
**Source Excerpt** = OUTPUT from running the Query command:
- Test output (verbatim terminal output)
- Grep output (verbatim grep results)
- Web docs (verbatim quoted text from URL)
- Code analysis results (NOT the code itself)