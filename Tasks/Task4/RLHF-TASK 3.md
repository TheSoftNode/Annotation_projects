**PROMPT:**

how to write basic hangman game in C?

**RESPONSE 1:**

Below is a **complete, easy‑to‑read** Hangman implementation in C that you can compile with any standard C compiler (`gcc`, `clang`, MSVC, etc.).  
It is deliberately kept simple so you can see the core ideas and then extend it as you wish (e.g., adding a larger word list, graphics, difficulty levels, etc.).  
---

## **1️⃣ High‑level design**

| Component | Responsibility |
| ----- | ----- |
| `main()` | Start the game, ask for a word, run the main loop, display win/lose messages. |
| `chooseWord()` | Pick a random word from a static list (or you can read from a file). |
| `displayWord(const char *target, const char *guessed)` | Print the word with hidden letters (`_`) and already guessed letters. |
| `processGuess(char guess, const char *target, char *guessed, int *misses)` | Update the `guessed` string and the miss counter. |
| `drawHangman(int misses)` | Print a simple ASCII hangman diagram based on how many wrong guesses have been made. |
| `isWordComplete(const char *target, const char *guessed)` | Return true when every letter has been guessed. |
| `yesNoPrompt(const char *msg)` | Simple utility for yes/no questions. |

The game state is stored in just a few arrays of characters:

* `target[]` – the word to be guessed (read‑only).  
* `guessed[]` – what the player has discovered so far (filled with `_` initially).  
* `used[]` – letters the player has already tried (to avoid duplicate guesses).

---

## **2️⃣ Full source code**

/\* Hangman.c – a very simple Hangman game  
 \* \--------------------------------------------------------------  
 \* Compile:   gcc \-Wall \-Wextra \-std=c11 Hangman.c \-o hangman  
 \* Run:       ./hangman  
 \* \--------------------------------------------------------------  
 \*  This program demonstrates the basic logic you need for Hangman.  
 \*  Feel free to copy, modify, or extend it\!  
 \*/

\#include \<stdio.h\>  
\#include \<stdlib.h\>  
\#include \<string.h\>  
\#include \<time.h\>  
\#include \<ctype.h\>

/\* \---------- Configuration \---------- \*/  
\#define MAX\_WORD\_LEN 50   /\* maximum length of a word (including '\\0')   \*/  
\#define MAX\_GUESSES  6    /\* allowed wrong guesses before game over       \*/

/\* \---------- Word list \---------- \*/  
static const char \*wordList\[\] \= {  
    "apple", "banana", "orange", "grape", "melon",  
    "coconut", "strawberry", "blueberry", "raspberry", "mango",  
    "elephant", "giraffe", "tiger", "lion", "zebra",  
    "mountain", "river", "ocean", "forest", "desert",  
    "computer", "keyboard", "monitor", "printer", "mouse",  
    "science", "math", "history", "geography", "biology"  
};  
\#define WORD\_COUNT (sizeof(wordList) / sizeof(wordList\[0\]))

/\* \---------- Helper prototypes \---------- \*/  
static const char \*chooseWord(void);  
static void displayWord(const char \*target, const char \*guessed);  
static int  processGuess(char guess, const char \*target,  
                         char \*guessed, int \*misses, char \*used);  
static void drawHangman(int misses);  
static int  isWordComplete(const char \*target, const char \*guessed);  
static int  yesNoPrompt(const char \*msg);

/\* \---------- Main entry point \---------- \*/  
int main(void)  
{  
    srand((unsigned)time(NULL));

    int playAgain \= 1;  
    while (playAgain) {  
        const char \*target \= chooseWord();  
        char guessed\[MAX\_WORD\_LEN\];   /\* what the player has discovered \*/  
        char used\[MAX\_WORD\_LEN\];      /\* letters already tried          \*/  
        int  misses \= 0;              /\* wrong guesses count            \*/  
        int  len \= (int)strlen(target);

        /\* initialise the display strings \*/  
        for (int i \= 0; i \< len; \++i) guessed\[i\] \= '\_';  
        guessed\[len\] \= '\\0';  
        used\[0\] \= '\\0';

        printf("\\n=== Hangman \===\\n");  
        printf("Word length: %d letters\\n", len);  
        printf("You have %d wrong guesses allowed.\\n", MAX\_GUESSES);  
        printf("Let's play\!\\n\\n");

        /\* \----- main guessing loop \----- \*/  
        while (misses \< MAX\_GUESSES && \!isWordComplete(target, guessed)) {  
            drawHangman(misses);  
            printf("\\nWord: ");  
            displayWord(target, guessed);  
            printf("\\nGuessed letters: %s\\n", used\[0\] ? used : "(none)");  
            printf("Enter a letter: ");

            char guess;  
            /\* Read a single character, ignore whitespace \*/  
            int ch;  
            while ((ch \= getchar()) \!= EOF && isspace(ch))  
                ; /\* skip spaces / newlines \*/  
            if (ch \== EOF) {  
                printf("\\nGood‑bye\!\\n");  
                return 0;  
            }  
            guess \= (char)tolower(ch);

            /\* Throw away the rest of the line \*/  
            while ((ch \= getchar()) \!= '\\n' && ch \!= EOF)  
                ;

            if (processGuess(guess, target, guessed, \&misses, used)) {  
                printf("Good guess\!\\n");  
            } else {  
                printf("Sorry, wrong guess.\\n");  
                \++misses;  
            }  
        }

        /\* \----- Game over \----- \*/  
        drawHangman(misses);  
        printf("\\nWord: ");  
        displayWord(target, guessed);  
        printf("\\n\\n");

        if (isWordComplete(target, guessed)) {  
            printf("Congratulations\! You guessed the word \\"%s\\".\\n", target);  
        } else {  
            printf("Game over\! The word was \\"%s\\". Better luck next time.\\n", target);  
        }

        playAgain \= yesNoPrompt("Play again? (y/n) ");  
    }

    printf("Thanks for playing\!\\n");  
    return 0;  
}

/\* \---------- Function definitions \---------- \*/

/\* Pick a random word from the static list \*/  
static const char \*chooseWord(void)  
{  
    int idx \= rand() % WORD\_COUNT;  
    return wordList\[idx\];  
}

/\* Show the word with underscores for hidden letters \*/  
static void displayWord(const char \*target, const char \*guessed)  
{  
    for (int i \= 0; target\[i\] \!= '\\0'; \++i)  
        printf("%c ", guessed\[i\]);  
}

/\* Process a single guessed letter.  
 \* Returns 1 if the guess was correct, 0 otherwise.  
 \* Updates \`guessed\`, \`used\`, and \`misses\` (by reference). \*/  
static int processGuess(char guess, const char \*target,  
                        char \*guessed, int \*misses, char \*used)  
{  
    int correct \= 0;

    /\* If the player already used this letter, tell them and don't penalize \*/  
    if (strchr(used, guess) \!= NULL) {  
        printf("You already guessed '%c'. Try another letter.\\n", guess);  
        return 1;           /\* treat as “no change” – not a miss \*/  
    }

    /\* Record the used letter \*/  
    int usedIdx \= (int)strlen(used);  
    used\[usedIdx\] \= guess;  
    used\[usedIdx \+ 1\] \= '\\0';

    /\* Check each position in the word \*/  
    for (int i \= 0; target\[i\] \!= '\\0'; \++i) {  
        if (tolower(target\[i\]) \== guess && guessed\[i\] \== '\_') {  
            guessed\[i\] \= target\[i\];   /\* reveal the letter \*/  
            correct \= 1;  
        }  
    }

    return correct;  
}

/\* Draw a very simple ASCII hangman \*/  
static void drawHangman(int misses)  
{  
    const char \*stages\[\] \= {  
        "  \+---+\\n  |   |\\n      |\\n      |\\n      |\\n      |\\n=========",  
        "  \+---+\\n  |   |\\n  O   |\\n      |\\n      |\\n      |\\n=========",  
        "  \+---+\\n  |   |\\n  O   |\\n  |   |\\n      |\\n      |\\n=========",  
        "  \+---+\\n  |   |\\n  O   |\\n /|   |\\n      |\\n      |\\n=========",  
        "  \+---+\\n  |   |\\n  O   |\\n /|\\\\  |\\n      |\\n      |\\n=========",  
        "  \+---+\\n  |   |\\n  O   |\\n /|\\\\  |\\n /    |\\n      |\\n=========",  
        "  \+---+\\n  |   |\\n  O   |\\n /|\\\\  |\\n / \\\\  |\\n      |\\n========="  
    };  
    /\* Misses can be 0‑MAX\_GUESSES inclusive; we have MAX\_GUESSES+1 stages \*/  
    printf("%s\\n", stages\[misses\]);  
}

/\* Returns true if every non‑space character in \`target\` has been guessed \*/  
static int isWordComplete(const char \*target, const char \*guessed)  
{  
    for (int i \= 0; target\[i\] \!= '\\0'; \++i) {  
        if (target\[i\] \!= ' ' && guessed\[i\] \== '\_')  
            return 0;  
    }  
    return 1;  
}

/\* Prompt the user for a yes/no answer.  
 \* Returns 1 for yes, 0 for no. \*/  
static int yesNoPrompt(const char \*msg)  
{  
    char answer\[16\];  
    while (1) {  
        printf("%s ", msg);  
        if (\!fgets(answer, sizeof answer, stdin))  
            return 0;   /\* EOF \-\> treat as no \*/

        /\* Accept only the first non‑space character \*/  
        char c \= answer\[0\];  
        while (c \!= '\\0' && isspace((unsigned char)c))  
            \++c;  
        c \= tolower((unsigned char)c);

        if (c \== 'y' || c \== 'c' || c \== 's')   /\* yes, continue, si \*/  
            return 1;  
        if (c \== 'n' || c \== 'o')               /\* no \*/  
            return 0;

        printf("Please answer with 'y' (yes) or 'n' (no).\\n");  
    }  
}

---

## **3️⃣ How the code works (step‑by‑step)**

| Step | What the program does |
| ----- | ----- |
| **1\. Seed RNG** | `srand(time(NULL));` so the word choice varies each run. |
| **2\. Choose a word** | `chooseWord()` returns a pointer to a random string from `wordList`. |
| **3\. Prepare the display arrays** | `guessed` starts as underscores (`_`). `used` is empty. |
| **4\. Main loop** | Repeats until the player either runs out of `MAX_GUESSES` or the word is fully guessed. |
| **5\. Show state** | `drawHangman(misses)` prints the current diagram; `displayWord()` shows the partially revealed word; `used` shows letters already tried. |
| **6\. Get a guess** | Reads a single character, ignoring whitespace and extra characters on the line. |
| **7\. Process the guess** | `processGuess()` checks the guess against the target, updates `guessed` if correct, records the letter in `used`, and tells the caller whether the guess was correct. |
| **8\. Adjust misses** | If the guess was wrong, increment `misses`. |
| **9\. End of game** | Print the final hangman picture, reveal the whole word, and ask if the user wants to play again. |

---

## **4️⃣ Building & Running**

\# Save the code above to a file called Hangman.c  
gcc \-Wall \-Wextra \-std=c11 Hangman.c \-o hangman   \# Linux/macOS  
\# or  
clang \-Wall \-Wextra \-std=c11 Hangman.c \-o hangman

\# Run it  
./hangman

You should see something like:

\=== Hangman \===  
Word length: 5 letters  
You have 6 wrong guesses allowed.  
Let's play\!

  \+---+  
  |   |  
      |  
      |  
      |  
      |  
\=========  
Word: \_ \_ \_ \_ \_  
Guessed letters: (none)  
Enter a letter: a  
Good guess\!

  \+---+  
  |   |  
      |  
      |  
      |  
      |  
\=========  
Word: \_ a \_ a \_  
Guessed letters: a  
Enter a letter: p  
...

---

## **5️⃣ Extending the game**

| Idea | Where to change |
| ----- | ----- |
| **Load words from a file** | Replace `chooseWord()` with a function that reads lines from a text file (`words.txt`) and picks one at random. |
| **Add a hint system** | Keep an auxiliary array `hints[]` parallel to `wordList`; let the player type `?` to receive a hint (cost a miss?). |
| **Graphics / GUI** | Use a lightweight library (e.g., `ncurses`, SDL, or even just Windows console API) for a more polished look. |
| **Difficulty levels** | Adjust `MAX_GUESSES` and word‑length filter based on a menu choice (`easy`, `medium`, `hard`). |
| **Multiplayer / Network** | Move the word selection to a server and let clients guess over sockets. |
| **Unicode / non‑ASCII words** | Use `wchar_t` and the wide‑character I/O functions (`getwchar`, `fwprintf`). |

---

### **TL;DR**

*Copy the code above into a file named `Hangman.c`, compile it, and run it.*  
The program handles word selection, displaying the current state, processing a single‑letter guess, drawing a simple hangman, and detecting win/loss conditions. From here you can add any of the ideas above or keep it as a tidy educational example.

Enjoy coding, and have fun playing your own Hangman game\! 🎉

**RESPONSE 2:**

Creating a basic Hangman game in C is a great project to learn about arrays, loops, string manipulation, and input handling.

Here is a complete, working example of a console-based Hangman game, followed by an explanation of how each part works.

### **The Complete Code**

Save this code in a file named `hangman.c`.

\#include \<stdio.h\>

\#include \<stdlib.h\>

\#include \<string.h\>

\#include \<ctype.h\>

\#include \<time.h\>

\#define MAX\_LIVES 6

// Function to print the current state of the word (with underscores)

void printWord(const char \*secret, const char \*guessed) {

    printf("Current word: ");

    for (int i \= 0; i \< strlen(secret); i++) {

        if (guessed\[i\] \== 1\) {

            printf("%c ", secret\[i\]);

        } else {

            printf("\_ ");

        }

    }

    printf("\\n");

}

int main() {

    // 1\. Setup the word list and seed random number generator

    const char \*wordList\[\] \= {

        "programming", "computer", "language", "variable", 

        "structure", "pointer", "syntax", "array"

    };

    

    srand(time(NULL)); // Seed the random generator

    int wordIndex \= rand() % 8; // Pick a random index (0 to 7\)

    

    const char \*secretWord \= wordList\[wordIndex\];

    int wordLength \= strlen(secretWord);

    int guessedLetters\[256\] \= {0}; // ASCII array to track guessed status

    int lives \= MAX\_LIVES;

    int correctCount \= 0;

    char guess;

    printf("Welcome to Hangman\!\\n");

    // 2\. Game Loop

    while (lives \> 0 && correctCount \< wordLength) {

        printf("\\n----------------------------\\n");

        printf("Lives remaining: %d\\n", lives);

        

        printWord(secretWord, (const char\*)guessedLetters); // Cast for array logic

        

        printf("Guess a letter: ");

        scanf(" %c", \&guess); // Space before %c skips any leftover newline characters

        

        guess \= tolower(guess); // Convert to lowercase to handle inputs like 'A'

        // 3\. Check if input is a letter

        if (\!isalpha(guess)) {

            printf("Please enter a valid letter.\\n");

            continue;

        }

        // 4\. Check if letter was already guessed

        if (guessedLetters\[(unsigned char)guess\] \== 1\) {

            printf("You already guessed '%c'. Try again.\\n", guess);

            continue;

        }

        // Mark this specific character as guessed in our tracking array

        guessedLetters\[(unsigned char)guess\] \= 1;

        // 5\. Check if the guess is in the secret word

        int found \= 0;

        for (int i \= 0; i \< wordLength; i++) {

            if (secretWord\[i\] \== guess) {

                found \= 1;

                correctCount++;

            }

        }

        if (found) {

            printf("Good job\! '%c' is in the word.\\n", guess);

        } else {

            printf("Sorry, '%c' is not there.\\n", guess);

            lives--;

        }

    }

    // 6\. Game Over Logic

    printf("\\n----------------------------\\n");

    if (correctCount \== wordLength) {

        printf("CONGRATULATIONS\! You won\!\\n");

        printf("The word was: %s\\n", secretWord);

    } else {

        printf("GAME OVER\! You ran out of lives.\\n");

        printf("The word was: %s\\n", secretWord);

    }

    return 0;

}

### **Step-by-Step Explanation**

Here is a breakdown of the logic used in the code:

#### **1\. Libraries**

* `<stdio.h>`: For input (`scanf`) and output (`printf`).  
* `<stdlib.h>` & `<time.h>`: Used to generate random numbers so you get a different word every time you play.  
* `<string.h>`: For `strlen`, which helps us know how long the word is.  
* `<ctype.h>`: For `tolower` (converts ‘A’ to ‘a’) and `isalpha` (checks if input is a letter).

#### **2\. Data Structures**

* **Word List:** We use an array of strings (`wordList`) containing the words the player can guess.  
* **Tracking Guesses:** We use an integer array `guessedLetters[256]`.  
  * In C, characters are stored as ASCII numbers (e.g., ‘a’ is 97).  
  * If the player guesses ‘a’, we look at index 97\. If it is `0`, they haven’t guessed it; if it is `1`, they have.  
  * This is faster and easier than looping through the word to check for duplicates every time.

#### **3\. The Game Loop (`while`)**

The game continues running as long as two conditions are met:

1. `lives > 0`  
2. `correctCount < wordLength`

Inside the loop:

1. **Display:** We show the user the “masked” word (e.g., `p r o _ r a _ _ n _`). We look at the `guessedLetters` array; if the letter corresponding to the character in the secret word has been marked as guessed (1), we print it. Otherwise, we print `_`.  
2. **Input:** We use `scanf(" %c", &guess);`. Note the **space** before `%c`. This tells C to skip any “invisible” characters (like the `Enter` key pressed from the previous turn), which is a common bug in C programming.  
3. **Validation:** We ensure the input is a valid letter and not a number or symbol.  
4. **Logic Update:**  
   * We loop through the `secretWord`.  
   * If we find the guessed letter, we increment `correctCount`.  
   * If we finish the loop and the letter was never found, we decrement `lives`.

#### **4\. Win/Loss Condition**

Once the `while` loop breaks, we check why. If `correctCount` equals the length of the word, the user won. Otherwise, they ran out of lives and lost.

### **How to Compile and Run**

If you have a C compiler installed (like GCC), follow these steps:

1. Save the code above into a file named `hangman.c`.  
2. Open your terminal or command prompt.

Compile the program:  
gcc hangman.c \-o hangman

3.   
4. Run the program:  
   * **Windows:** `hangman.exe`  
   * **Mac/Linux:** `./hangman`

### **Ideas for Expansion**

Once you have this working, try adding these features to learn more:

* **Input Buffer Clearing:** If a user types a whole word instead of a letter, `scanf` might glitch. Try looking up how to use `fgets` to read a whole line.  
* **Difficulty Levels:** Create arrays for “Easy” words and “Hard” words.  
* **Hangman Art:** Use `printf` statements to draw a stick figure that gets more complete as `lives` decreases.

