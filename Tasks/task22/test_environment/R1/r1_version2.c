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
