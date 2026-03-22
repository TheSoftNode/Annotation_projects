#include <stdio.h>
int main() {
    int guessedLetters[256] = {0};
    guessedLetters[97] = 1; // Mark 'a' (ASCII 97) as guessed
    const char *guessedChar = (const char*)guessedLetters;
    
    printf("Value in int array at index 97: %d\n", guessedLetters[97]);
    printf("Value accessed via char pointer at index 97: %d\n", guessedChar[97]);
    return 0;
}
