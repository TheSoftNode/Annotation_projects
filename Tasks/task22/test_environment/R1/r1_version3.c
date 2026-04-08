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
