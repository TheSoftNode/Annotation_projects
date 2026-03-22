#include <stdio.h>
#include <string.h>
int main() {
    const char *secret = "array";
    int guessed[256] = {0};
    guessed['a'] = 1;
    guessed['r'] = 1;
    printf("Expected: a r r a _\nOutput: ");
    for (int i = 0; i < strlen(secret); i++) {
        if (guessed[i] == 1) printf("%c ", secret[i]);
        else printf("_ ");
    }
    printf("\n");
    return 0;
}
