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
