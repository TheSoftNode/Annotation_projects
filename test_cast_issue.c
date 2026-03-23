#include <stdio.h>
#include <string.h>

// What the code actually does (BUGGY)
void printWord_ACTUAL(const char *secret, const char *guessed) {
    printf("ACTUAL CODE: ");
    for (int i = 0; i < strlen(secret); i++) {
        if (guessed[i] == 1) {  // Checks positions 0,1,2,3,4...
            printf("%c ", secret[i]);
        } else {
            printf("_ ");
        }
    }
    printf("\n");
}

// If we just fix the cast but keep wrong logic
void printWord_FIXED_CAST_ONLY(const char *secret, const int *guessed) {
    printf("FIXED CAST ONLY: ");
    for (int i = 0; i < strlen(secret); i++) {
        if (guessed[i] == 1) {  // STILL checks positions 0,1,2,3,4...
            printf("%c ", secret[i]);
        } else {
            printf("_ ");
        }
    }
    printf("\n");
}

// Correct implementation
void printWord_CORRECT(const char *secret, const int *guessed) {
    printf("CORRECT: ");
    for (int i = 0; i < strlen(secret); i++) {
        if (guessed[(unsigned char)secret[i]] == 1) {  // Checks ASCII values
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
    
    // Mark 'a' and 'r' as guessed
    guessedLetters['a'] = 1;  // ASCII 97
    guessedLetters['r'] = 1;  // ASCII 114
    
    printf("Word: %s\n", word);
    printf("Guessed: 'a' and 'r'\n\n");
    
    printWord_ACTUAL(word, (const char*)guessedLetters);
    printWord_FIXED_CAST_ONLY(word, guessedLetters);
    printWord_CORRECT(word, guessedLetters);
    
    return 0;
}
