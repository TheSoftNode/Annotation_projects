# Response 2 Hangman - Test Summary

## Overview
Extracted and tested C code from Response 2 of the Hangman task (lines 333-498 from RLHF-TASK 3.md).

## Files Created
- `response2_hangman.c` - Cleaned C code with markdown escapes removed
- `response2_hangman` - Compiled executable
- `test_response2.sh` - Automated test script
- `test1_output.txt`, `test2_output.txt`, `test3_output.txt` - Test outputs
- `debug_test.c` - Isolated bug demonstration
- `response2_test_results.txt` - Comprehensive test results and analysis

## Compilation Results

**Status:** ✅ SUCCESS (with warnings)

**Warning:**
```
response2_hangman.c:19:23: warning: comparison of integers of different signs:
'int' and 'unsigned long' [-Wsign-compare]
    for (int i = 0; i < strlen(secret); i++)
```

This is a minor type mismatch warning that doesn't affect functionality.

## Critical Bug Found

### Bug: Word Display Never Shows Guessed Letters

**Severity:** CRITICAL - Game is completely unplayable

**Location:** `printWord()` function (lines 15-35)

**Root Cause:**
The function incorrectly uses the `guessedLetters[256]` array. This array is indexed by ASCII values (e.g., guessedLetters[97] = 1 means 'a' was guessed), but the function treats it as a position-based array.

**Code with Bug:**
```c
void printWord(const char *secret, const char *guessed) {
    printf("Current word: ");
    for (int i = 0; i < strlen(secret); i++) {
        if (guessed[i] == 1) {  // BUG: checks positions 0,1,2,3,4
            printf("%c ", secret[i]);
        } else {
            printf("_ ");
        }
    }
    printf("\n");
}
```

**What Happens:**
- For word "array", the loop checks `guessed[0]`, `guessed[1]`, `guessed[2]`, `guessed[3]`, `guessed[4]`
- But actual guess data is at `guessed[97]` (for 'a') and `guessed[114]` (for 'r')
- Result: Display always shows "_ _ _ _ _" even when letters are correctly guessed

**Evidence:**
```
Test output shows:
- Player guesses 'r': "Good job! 'r' is in the word."
- Display: "_ _ _ _ _" (no change)
- Player guesses 'a': "Good job! 'a' is in the word."
- Display: "_ _ _ _ _" (still no change)
```

## Test Results

### Test 1: Word "array" with selected guesses
- Correctly guessed: 'r', 'a'
- Display remained: "_ _ _ _ _" throughout
- Result: GAME OVER (ran out of lives)
- **BUG CONFIRMED**

### Test 2: Alphabet sequence guessing
- Word: "array"
- Multiple correct letters found
- Display never changed from "_ _ _ _ _"
- **BUG CONFIRMED**

### Test 3: Repeated letter detection
- Tested guessing 'a' multiple times
- Correctly shows: "You already guessed 'a'. Try again."
- This feature WORKS correctly ✅
- But display bug persists ❌

## Debug Demonstration

Created `debug_test.c` to isolate and demonstrate the bug:

```
Word to guess: array
Player has guessed: 'a' and 'r'

BUGGY VERSION OUTPUT:
Current word: _ _ _ _ _

CORRECT VERSION OUTPUT:
Current word: a r r a _
```

The debug test clearly shows:
- Buggy version checks indices 0-4 (all zeros)
- Correct data is at indices 97 and 114
- This proves the conceptual error in array indexing

## Playability Assessment

**Can the game be played?** ❌ NO

**Reasons:**
1. Word display never shows guessed letters
2. No visual feedback of progress
3. Player is essentially guessing blind
4. Game logic works but provides zero useful information

This is like playing Hangman with your eyes closed - technically functional but completely unusable.

## Comparison with Similar Bugs

This bug is similar to the "moving_to_r1" bug mentioned in Task 2:
- Compiles successfully ✅
- Runs without crashing ✅
- Logic error causes incorrect behavior ❌
- Conceptual misunderstanding of data structures ❌

## Correct Implementation

The fix requires checking if the CHARACTER at each position has been guessed:

```c
void printWord(const char *secret, const int *guessedLetters) {
    printf("Current word: ");
    for (int i = 0; i < strlen(secret); i++) {
        // Check if THIS CHARACTER has been guessed (not position i)
        if (guessedLetters[(unsigned char)secret[i]] == 1) {
            printf("%c ", secret[i]);
        } else {
            printf("_ ");
        }
    }
    printf("\n");
}
```

## Recommendation

**Response 2 should be REJECTED** due to the critical bug that makes the game completely unplayable. The bug demonstrates a fundamental misunderstanding of array indexing and data structure design.

## All Test Files

1. ✅ `response2_hangman.c` - Extracted clean code
2. ✅ `response2_hangman` - Compiled executable
3. ✅ Compilation documented with warnings
4. ✅ Automated tests created and run
5. ✅ Runtime behavior documented
6. ✅ Logic bugs identified and explained
7. ✅ Comprehensive test results file created
8. ✅ Debug demonstration program created

**Task completed successfully.**
