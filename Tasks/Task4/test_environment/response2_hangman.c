#include <stdio.h>

#include <stdlib.h>

#include <string.h>

#include <ctype.h>

#include <time.h>

#define MAX_LIVES 6

// Function to print the current state of the word (with underscores)

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

    // 1. Setup the word list and seed random number generator

    const char *wordList[] = {

        "programming", "computer", "language", "variable",

        "structure", "pointer", "syntax", "array"

    };



    srand(time(NULL)); // Seed the random generator

    int wordIndex = rand() % 8; // Pick a random index (0 to 7)



    const char *secretWord = wordList[wordIndex];

    int wordLength = strlen(secretWord);

    int guessedLetters[256] = {0}; // ASCII array to track guessed status

    int lives = MAX_LIVES;

    int correctCount = 0;

    char guess;

    printf("Welcome to Hangman!\n");

    // 2. Game Loop

    while (lives > 0 && correctCount < wordLength) {

        printf("\n----------------------------\n");

        printf("Lives remaining: %d\n", lives);



        printWord(secretWord, (const char*)guessedLetters); // Cast for array logic



        printf("Guess a letter: ");

        scanf(" %c", &guess); // Space before %c skips any leftover newline characters



        guess = tolower(guess); // Convert to lowercase to handle inputs like 'A'

        // 3. Check if input is a letter

        if (!isalpha(guess)) {

            printf("Please enter a valid letter.\n");

            continue;

        }

        // 4. Check if letter was already guessed

        if (guessedLetters[(unsigned char)guess] == 1) {

            printf("You already guessed '%c'. Try again.\n", guess);

            continue;

        }

        // Mark this specific character as guessed in our tracking array

        guessedLetters[(unsigned char)guess] = 1;

        // 5. Check if the guess is in the secret word

        int found = 0;

        for (int i = 0; i < wordLength; i++) {

            if (secretWord[i] == guess) {

                found = 1;

                correctCount++;

            }

        }

        if (found) {

            printf("Good job! '%c' is in the word.\n", guess);

        } else {

            printf("Sorry, '%c' is not there.\n", guess);

            lives--;

        }

    }

    // 6. Game Over Logic

    printf("\n----------------------------\n");

    if (correctCount == wordLength) {

        printf("CONGRATULATIONS! You won!\n");

        printf("The word was: %s\n", secretWord);

    } else {

        printf("GAME OVER! You ran out of lives.\n");

        printf("The word was: %s\n", secretWord);

    }

    return 0;

}
