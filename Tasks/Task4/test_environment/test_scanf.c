#include <stdio.h>

int main() {
    char guess;
    
    printf("Type 'ate' and press enter:\n");
    
    for (int i = 0; i < 3; i++) {
        printf("Guess %d: ", i+1);
        scanf(" %c", &guess);
        printf("Read '%c'\n", guess);
    }
    
    return 0;
}
