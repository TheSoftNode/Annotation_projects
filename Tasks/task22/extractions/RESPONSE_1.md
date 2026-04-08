Here's the C program using nested if-else statements:

#include <stdio.h>

int main() {

    int number;



    // Accept number from user

    printf("Enter a positive number: ");

    scanf("%d", &number);



    // Using nested if-else to check

    if (number > 0) {           // Outer if: Check if positive

        if (number % 20 == 0) { // Inner if: Check if multiple of 20

            printf("%d is a multiple of 20.\n", number);

        } else {                // Inner else: Not multiple of 20

            printf("%d is not a multiple of 20.\n", number);

        }

    } else {                    // Outer else: Not positive number

        printf("Error: Please enter a positive number.\n");

    }



    return 0;

}

**Alternative version with more explicit nesting:**

#include <stdio.h>

int main() {

    int number;



    printf("Enter a positive number: ");

    scanf("%d", &number);



    // Nested if-else structure

    if (number > 0) {

        // First level nesting

        if (number % 20 == 0) {

            // Second level (implicit)

            printf("%d is a multiple of 20.\n", number);

        } else {

            printf("%d is not a multiple of 20.\n", number);

        }

    } else {

        printf("Invalid input! Number must be positive.\n");

    }



    return 0;

}

**Another version with multiple else-if branches:**

#include <stdio.h>

int main() {

    int number;



    printf("Enter a positive number: ");

    scanf("%d", &number);



    // Using nested if-else with multiple conditions

    if (number > 0) {

        if (number % 20 == 0) {

            printf("%d is a multiple of 20.\n", number);

        }

        else {

            printf("%d is not a multiple of 20.\n", number);

        }

    }

    else if (number == 0) {

        printf("Zero is not a positive number.\n");

    }

    else {

        printf("Negative numbers are not allowed.\n");

    }



    return 0;

}

**Sample Output:**

Enter a positive number: 40

40 is a multiple of 20.

Enter a positive number: 35

35 is not a multiple of 20.

Enter a positive number: -5

Error: Please enter a positive number.

**How the nested if-else works:**

1. **Outer if-else**: Checks if the number is positive (`number > 0`)
2. **Inner if-else**: If the number is positive, checks if it's a multiple of 20 (`number % 20 == 0`)
3. **Nested structure**: The inner if-else is nested inside the outer if's code block

**Flowchart of logic:**

Start

  ↓

Input number

  ↓

Is number > 0? ──No──→ Print error

  Yes

  ↓

Is number % 20 == 0? ──No──→ Print "not multiple"

  Yes

  ↓

Print "is multiple"

  ↓

End

The program demonstrates proper use of nested if-else statements where:

* The inner condition (multiple check) is only evaluated if the outer condition (positive check) is true
* Each `else` corresponds to the immediately preceding `if`
