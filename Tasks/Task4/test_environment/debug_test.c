#include <stdio.h>
#include <string.h>

// Reproduce the bug in isolation to demonstrate the issue

void printWord_BUGGY(const char *secret, const char *guessed) {
    printf("Current word: ");
    for (int i = 0; i < strlen(secret); i++) {
        if (guessed[i] == 1) {
            printf("%c ", secret[i]);
        } else {
            printf("_ ");
        }
    }
    printf("\n");
}

void printWord_CORRECT(const char *secret, const int *guessedLetters) {
    printf("Current word: ");
    for (int i = 0; i < strlen(secret); i++) {
        if (guessedLetters[(unsigned char)secret[i]] == 1) {
            printf("%c ", secret[i]);
        } else {
            printf("_ ");
        }
    }
    printf("\n");
}

int main() {
    const char *word = "array";
    int guessedLetters[256] = {0};

    printf("=== DEMONSTRATION OF THE BUG ===\n\n");
    printf("Word to guess: %s\n\n", word);

    // Simulate guessing 'a' and 'r'
    guessedLetters[97] = 1;  // 'a' guessed
    guessedLetters[114] = 1; // 'r' guessed

    printf("Player has guessed: 'a' and 'r'\n");
    printf("guessedLetters[97] (a) = %d\n", guessedLetters[97]);
    printf("guessedLetters[114] (r) = %d\n", guessedLetters[114]);
    printf("\n");

    printf("Checking what indices the BUGGY version looks at:\n");
    for (int i = 0; i < strlen(word); i++) {
        printf("Position %d (char '%c'): checking guessedLetters[%d] = %d\n",
               i, word[i], i, guessedLetters[i]);
    }
    printf("\n");

    printf("BUGGY VERSION OUTPUT:\n");
    printWord_BUGGY(word, (const char*)guessedLetters);
    printf("\n");

    printf("CORRECT VERSION OUTPUT:\n");
    printWord_CORRECT(word, guessedLetters);
    printf("\n");

    printf("=== EXPLANATION ===\n");
    printf("The buggy version checks guessedLetters[0], [1], [2], [3], [4]\n");
    printf("But the actual guessed characters are stored at indices 97 and 114!\n");
    printf("So it never finds any guessed letters and displays all underscores.\n");

    return 0;
}
