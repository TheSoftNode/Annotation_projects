#include <stdio.h>
#include <string.h>
#include <ctype.h>

// AOI #1 verification
void printWord_buggy(const char *secret, const int *guessed) {
    printf("BUGGY:   ");
    for (int i = 0; i < strlen(secret); i++) {
        if (guessed[i] == 1) {
            printf("%c ", secret[i]);
        } else {
            printf("_ ");
        }
    }
    printf("\n");
}

void printWord_correct(const char *secret, const int *guessed) {
    printf("CORRECT: ");
    for (int i = 0; i < strlen(secret); i++) {
        if (guessed[(unsigned char)secret[i]] == 1) {
            printf("%c ", secret[i]);
        } else {
            printf("_ ");
        }
    }
    printf("\n");
}

int main(void) {
    const char *word = "array";
    int guessedLetters[256] = {0};

    guessedLetters['a'] = 1;
    guessedLetters['r'] = 1;

    printf("=== AOI #1 Verification ===\n");
    printWord_buggy(word, guessedLetters);
    printWord_correct(word, guessedLetters);
    
    return 0;
}
