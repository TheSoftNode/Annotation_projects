#include <stdio.h>
#include <string.h>

void printWord(const char *secret, const char *guessed) {
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

int main() {
    const char *word = "array";
    int guessedLetters[256] = {0};
    
    // Simulate guessing 'a' and 'r'
    guessedLetters[97] = 1;  // 'a' ASCII 97
    guessedLetters[114] = 1; // 'r' ASCII 114
    
    printf("Testing cast from int* to char*:\n");
    printf("sizeof(int) = %zu, sizeof(char) = %zu\n", sizeof(int), sizeof(char));
    
    // Check what happens at byte positions 0-4 when we cast
    printf("\nByte values at positions 0-4 after casting int[256] to char*:\n");
    char *asChar = (char*)guessedLetters;
    for (int i = 0; i < 5; i++) {
        printf("asChar[%d] = %d\n", i, asChar[i]);
    }
    
    printf("\nChecking int array values at indices 97 and 114:\n");
    printf("guessedLetters[97] = %d (at byte offset %zu)\n", guessedLetters[97], 97 * sizeof(int));
    printf("guessedLetters[114] = %d (at byte offset %zu)\n", guessedLetters[114], 114 * sizeof(int));
    
    printf("\nCalling printWord with the cast:\n");
    printWord(word, (const char*)guessedLetters);
    
    return 0;
}
