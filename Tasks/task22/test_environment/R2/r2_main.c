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
