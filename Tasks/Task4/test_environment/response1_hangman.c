/* Hangman.c - a very simple Hangman game
 * --------------------------------------------------------------
 * Compile:   gcc -Wall -Wextra -std=c11 Hangman.c -o hangman
 * Run:       ./hangman
 * --------------------------------------------------------------
 *  This program demonstrates the basic logic you need for Hangman.
 *  Feel free to copy, modify, or extend it!
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <ctype.h>

/* ---------- Configuration ---------- */
#define MAX_WORD_LEN 50   /* maximum length of a word (including '\0')   */
#define MAX_GUESSES  6    /* allowed wrong guesses before game over       */

/* ---------- Word list ---------- */
static const char *wordList[] = {
    "apple", "banana", "orange", "grape", "melon",
    "coconut", "strawberry", "blueberry", "raspberry", "mango",
    "elephant", "giraffe", "tiger", "lion", "zebra",
    "mountain", "river", "ocean", "forest", "desert",
    "computer", "keyboard", "monitor", "printer", "mouse",
    "science", "math", "history", "geography", "biology"
};
#define WORD_COUNT (sizeof(wordList) / sizeof(wordList[0]))

/* ---------- Helper prototypes ---------- */
static const char *chooseWord(void);
static void displayWord(const char *target, const char *guessed);
static int  processGuess(char guess, const char *target,
                         char *guessed, int *misses, char *used);
static void drawHangman(int misses);
static int  isWordComplete(const char *target, const char *guessed);
static int  yesNoPrompt(const char *msg);

/* ---------- Main entry point ---------- */
int main(void)
{
    srand((unsigned)time(NULL));

    int playAgain = 1;
    while (playAgain) {
        const char *target = chooseWord();
        char guessed[MAX_WORD_LEN];   /* what the player has discovered */
        char used[MAX_WORD_LEN];      /* letters already tried          */
        int  misses = 0;              /* wrong guesses count            */
        int  len = (int)strlen(target);

        /* initialise the display strings */
        for (int i = 0; i < len; ++i) guessed[i] = '_';
        guessed[len] = '\0';
        used[0] = '\0';

        printf("\n=== Hangman ===\n");
        printf("Word length: %d letters\n", len);
        printf("You have %d wrong guesses allowed.\n", MAX_GUESSES);
        printf("Let's play!\n\n");

        /* ----- main guessing loop ----- */
        while (misses < MAX_GUESSES && !isWordComplete(target, guessed)) {
            drawHangman(misses);
            printf("\nWord: ");
            displayWord(target, guessed);
            printf("\nGuessed letters: %s\n", used[0] ? used : "(none)");
            printf("Enter a letter: ");

            char guess;
            /* Read a single character, ignore whitespace */
            int ch;
            while ((ch = getchar()) != EOF && isspace(ch))
                ; /* skip spaces / newlines */
            if (ch == EOF) {
                printf("\nGood-bye!\n");
                return 0;
            }
            guess = (char)tolower(ch);

            /* Throw away the rest of the line */
            while ((ch = getchar()) != '\n' && ch != EOF)
                ;

            if (processGuess(guess, target, guessed, &misses, used)) {
                printf("Good guess!\n");
            } else {
                printf("Sorry, wrong guess.\n");
                ++misses;
            }
        }

        /* ----- Game over ----- */
        drawHangman(misses);
        printf("\nWord: ");
        displayWord(target, guessed);
        printf("\n\n");

        if (isWordComplete(target, guessed)) {
            printf("Congratulations! You guessed the word \"%s\".\n", target);
        } else {
            printf("Game over! The word was \"%s\". Better luck next time.\n", target);
        }

        playAgain = yesNoPrompt("Play again? (y/n) ");
    }

    printf("Thanks for playing!\n");
    return 0;
}

/* ---------- Function definitions ---------- */

/* Pick a random word from the static list */
static const char *chooseWord(void)
{
    int idx = rand() % WORD_COUNT;
    return wordList[idx];
}

/* Show the word with underscores for hidden letters */
static void displayWord(const char *target, const char *guessed)
{
    for (int i = 0; target[i] != '\0'; ++i)
        printf("%c ", guessed[i]);
}

/* Process a single guessed letter.
 * Returns 1 if the guess was correct, 0 otherwise.
 * Updates `guessed`, `used`, and `misses` (by reference). */
static int processGuess(char guess, const char *target,
                        char *guessed, int *misses, char *used)
{
    int correct = 0;

    /* If the player already used this letter, tell them and don't penalize */
    if (strchr(used, guess) != NULL) {
        printf("You already guessed '%c'. Try another letter.\n", guess);
        return 1;           /* treat as "no change" - not a miss */
    }

    /* Record the used letter */
    int usedIdx = (int)strlen(used);
    used[usedIdx] = guess;
    used[usedIdx + 1] = '\0';

    /* Check each position in the word */
    for (int i = 0; target[i] != '\0'; ++i) {
        if (tolower(target[i]) == guess && guessed[i] == '_') {
            guessed[i] = target[i];   /* reveal the letter */
            correct = 1;
        }
    }

    return correct;
}

/* Draw a very simple ASCII hangman */
static void drawHangman(int misses)
{
    const char *stages[] = {
        "  +---+\n  |   |\n      |\n      |\n      |\n      |\n=========",
        "  +---+\n  |   |\n  O   |\n      |\n      |\n      |\n=========",
        "  +---+\n  |   |\n  O   |\n  |   |\n      |\n      |\n=========",
        "  +---+\n  |   |\n  O   |\n /|   |\n      |\n      |\n=========",
        "  +---+\n  |   |\n  O   |\n /|\\  |\n      |\n      |\n=========",
        "  +---+\n  |   |\n  O   |\n /|\\  |\n /    |\n      |\n=========",
        "  +---+\n  |   |\n  O   |\n /|\\  |\n / \\  |\n      |\n========="
    };
    /* Misses can be 0-MAX_GUESSES inclusive; we have MAX_GUESSES+1 stages */
    printf("%s\n", stages[misses]);
}

/* Returns true if every non-space character in `target` has been guessed */
static int isWordComplete(const char *target, const char *guessed)
{
    for (int i = 0; target[i] != '\0'; ++i) {
        if (target[i] != ' ' && guessed[i] == '_')
            return 0;
    }
    return 1;
}

/* Prompt the user for a yes/no answer.
 * Returns 1 for yes, 0 for no. */
static int yesNoPrompt(const char *msg)
{
    char answer[16];
    while (1) {
        printf("%s ", msg);
        if (!fgets(answer, sizeof answer, stdin))
            return 0;   /* EOF -> treat as no */

        /* Accept only the first non-space character */
        char c = answer[0];
        while (c != '\0' && isspace((unsigned char)c))
            ++c;
        c = tolower((unsigned char)c);

        if (c == 'y' || c == 'c' || c == 's')   /* yes, continue, si */
            return 1;
        if (c == 'n' || c == 'o')               /* no */
            return 0;

        printf("Please answer with 'y' (yes) or 'n' (no).\n");
    }
}
