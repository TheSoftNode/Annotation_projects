# Response 2 - Areas of Improvement (AOIs)

## AOI #1 - SUBSTANTIAL

**Response Excerpt:**
```
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
```

**Description:** The response uses scanf with %d without validating its return value. When users enter non-numeric strings, scanf fails and leaves num with a garbage value, causing the program to run with unpredictable results instead of handling the error.

**Severity:** Substantial

**Tool Type:** Code Executor
**Query:** `echo "hello" | ./r2_main`

**URL:**
**Source Excerpt:**
```
Enter a positive number: 206245984 is not a multiple of 20.
```

---

## AOI #2 - MINOR

**Response Excerpt:**
```
printf("Enter a positive number: ");

scanf("%d", &num);
```

**Description:** The response prompts "Enter a positive number" which is misleading since the program reads any integer and then validates positivity, not restricting input to positive numbers only.

**Severity:** Minor

---
