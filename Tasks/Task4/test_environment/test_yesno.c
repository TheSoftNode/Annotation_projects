#include <stdio.h>
#include <ctype.h>

int main(void) {
    char answer[] = "  yes";
    char c = answer[0];
    printf("Initial c = '%c' (ASCII %d)\n", c, c);
    
    // Bug: increments character value instead of index
    while (c != '\0' && isspace((unsigned char)c))
        ++c;
    
    printf("After ++c loop: c = '%c' (ASCII %d)\n", c, c);
    printf("Expected: c = 'y', but got '%c'\n", c);
    
    return 0;
}
