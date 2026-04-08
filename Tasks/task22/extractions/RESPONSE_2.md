Here's the C program that accepts a positive number from the user and checks if it's a multiple of 20 using **nested if-else** as requested:

#include <stdio.h>

int main() {

    int num;



    printf("Enter a positive number: ");

    scanf("%d", &num);



    if (num > 0) {  // First if: Check if number is positive

        if (num % 20 == 0) {  // Nested if: Check multiple of 20

            printf("%d is a multiple of 20.\n", num);

        } else {  // Nested else

            printf("%d is not a multiple of 20.\n", num);

        }

    } else {  // Else for first if (non-positive number)

        printf("Error: Please enter a positive number only.\n");

    }



    return 0;

}

**Explanation of nested if-else structure:**

1. **Outer if-else** (first level):
   * Checks if the number is positive (`num > 0`)
   * If true → enters the nested block
   * If false → executes the outer `else` (error message for non-positive)
2. **Nested if-else** (second level, inside the outer if block):
   * Checks if the number is divisible by 20 (`num % 20 == 0`)
   * If true → prints "multiple of 20"
   * If false → prints "not a multiple of 20"

**Sample Outputs:**

Enter a positive number: 40

40 is a multiple of 20.

Enter a positive number: 35

35 is not a multiple of 20.

Enter a positive number: -5

Error: Please enter a positive number only.

Enter a positive number: 0

Error: Please enter a positive number only.

**Why this uses nested if-else:**

* The inner `if-else` (checking multiple of 20) is **nested inside** the true branch of the outer `if` (checking positivity)
* This satisfies the requirement to use nested conditionals specifically
* The structure clearly separates the two validation steps (positivity check first, then multiple check) using conditional nesting
