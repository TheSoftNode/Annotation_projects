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
