**CONVERSATION HISTORY:**

**USER:**

wap to accept a positive number from user and test accepted number is multiple of 20 or not in c

---

**ASSISTANT:**

Here’s a C program that accepts a positive number from the user and checks if it is a multiple of 20:

\#include \<stdio.h\>

int main() {

    int number;

    // Prompt user to enter a positive number

    printf(""Enter a positive number: "");

    scanf(""%d"", \&number);

    // Check if the number is positive

    if (number \<= 0\) {

        printf(""Please enter a positive number only.\\n"");

    }

    else {

        // Check if the number is multiple of 20

        if (number % 20 \== 0\) {

            printf(""%d is a multiple of 20.\\n"", number);

        }

        else {

            printf(""%d is not a multiple of 20.\\n"", number);

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

60 is a multiple of 20\.

Enter a positive number: 25

25 is not a multiple of 20\.

Enter a positive number: \-10

Please enter a positive number only.

**Key Points:**

* `%` operator returns the remainder of division  
* If `number % 20 == 0`, then the number is perfectly divisible by 20  
* The program includes input validation to ensure the number is positive.

**PROMPT:**  
wap to accept a positive number from user and test accepted number is multiple of 20 or not in c using nested if else

**RESPONSE 1:**

Here’s the C program using nested if-else statements:

\#include \<stdio.h\>

int main() {

    int number;

    

    // Accept number from user

    printf("Enter a positive number: ");

    scanf("%d", \&number);

    

    // Using nested if-else to check

    if (number \> 0\) {           // Outer if: Check if positive

        if (number % 20 \== 0\) { // Inner if: Check if multiple of 20

            printf("%d is a multiple of 20.\\n", number);

        } else {                // Inner else: Not multiple of 20

            printf("%d is not a multiple of 20.\\n", number);

        }

    } else {                    // Outer else: Not positive number

        printf("Error: Please enter a positive number.\\n");

    }

    

    return 0;

}

**Alternative version with more explicit nesting:**

\#include \<stdio.h\>

int main() {

    int number;

    

    printf("Enter a positive number: ");

    scanf("%d", \&number);

    

    // Nested if-else structure

    if (number \> 0\) {

        // First level nesting

        if (number % 20 \== 0\) {

            // Second level (implicit)

            printf("%d is a multiple of 20.\\n", number);

        } else {

            printf("%d is not a multiple of 20.\\n", number);

        }

    } else {

        printf("Invalid input\! Number must be positive.\\n");

    }

    

    return 0;

}

**Another version with multiple else-if branches:**

\#include \<stdio.h\>

int main() {

    int number;

    

    printf("Enter a positive number: ");

    scanf("%d", \&number);

    

    // Using nested if-else with multiple conditions

    if (number \> 0\) {

        if (number % 20 \== 0\) {

            printf("%d is a multiple of 20.\\n", number);

        } 

        else {

            printf("%d is not a multiple of 20.\\n", number);

        }

    } 

    else if (number \== 0\) {

        printf("Zero is not a positive number.\\n");

    }

    else {

        printf("Negative numbers are not allowed.\\n");

    }

    

    return 0;

}

**Sample Output:**

Enter a positive number: 40

40 is a multiple of 20\.

Enter a positive number: 35

35 is not a multiple of 20\.

Enter a positive number: \-5

Error: Please enter a positive number.

**How the nested if-else works:**

1. **Outer if-else**: Checks if the number is positive (`number > 0`)  
2. **Inner if-else**: If the number is positive, checks if it’s a multiple of 20 (`number % 20 == 0`)  
3. **Nested structure**: The inner if-else is nested inside the outer if’s code block

**Flowchart of logic:**

Start

  ↓

Input number

  ↓

Is number \> 0? ──No──→ Print error

  Yes

  ↓

Is number % 20 \== 0? ──No──→ Print "not multiple"

  Yes

  ↓

Print "is multiple"

  ↓

End

The program demonstrates proper use of nested if-else statements where:

* The inner condition (multiple check) is only evaluated if the outer condition (positive check) is true  
* Each `else` corresponds to the immediately preceding `if`

      
**RESPONSE 2:**

Here’s the C program that accepts a positive number from the user and checks if it’s a multiple of 20 using **nested if-else** as requested:

\#include \<stdio.h\>

int main() {

    int num;

    

    printf("Enter a positive number: ");

    scanf("%d", \&num);

    

    if (num \> 0\) {  // First if: Check if number is positive

        if (num % 20 \== 0\) {  // Nested if: Check multiple of 20

            printf("%d is a multiple of 20.\\n", num);

        } else {  // Nested else

            printf("%d is not a multiple of 20.\\n", num);

        }

    } else {  // Else for first if (non-positive number)

        printf("Error: Please enter a positive number only.\\n");

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
   * If true → prints “multiple of 20”  
   * If false → prints “not a multiple of 20”

**Sample Outputs:**

Enter a positive number: 40

40 is a multiple of 20\.

Enter a positive number: 35

35 is not a multiple of 20\.

Enter a positive number: \-5

Error: Please enter a positive number only.

Enter a positive number: 0

Error: Please enter a positive number only.

**Why this uses nested if-else:**

* The inner `if-else` (checking multiple of 20\) is **nested inside** the true branch of the outer `if` (checking positivity)  
* This satisfies the requirement to use nested conditionals specifically  
* The structure clearly separates the two validation steps (positivity check first, then multiple check) using conditional nesting

