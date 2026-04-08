**USER:**

wap to accept a positive number from user and test accepted number is multiple of 20 or not in c

---

**ASSISTANT:**

Here's a C program that accepts a positive number from the user and checks if it is a multiple of 20:

#include <stdio.h>

int main() {

    int number;

    // Prompt user to enter a positive number

    printf("Enter a positive number: ");

    scanf("%d", &number);

    // Check if the number is positive

    if (number <= 0) {

        printf("Please enter a positive number only.\n");

    }

    else {

        // Check if the number is multiple of 20

        if (number % 20 == 0) {

            printf("%d is a multiple of 20.\n", number);

        }

        else {

            printf("%d is not a multiple of 20.\n", number);

        }

    }

    return 0;

}

**How the program works:**

1. **Input**: Uses `scanf()` to read an integer from the user.
2. **Validation**: Checks if the entered number is positive (greater than 0).
3. **Multiple Check**: Uses the modulo operator (`%`) to check if the remainder when dividing by 20 is zero.
4. **Output**: Displays appropriate message based on the result.

**Sample Output:**

Enter a positive number: 60

60 is a multiple of 20.

Enter a positive number: 25

25 is not a multiple of 20.

Enter a positive number: -10

Please enter a positive number only.

**Key Points:**

* `%` operator returns the remainder of division
* If `number % 20 == 0`, then the number is perfectly divisible by 20
* The program includes input validation to ensure the number is positive.
