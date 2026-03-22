#include <stdio.h>
#include <ctype.h>

int main() {
    // Test with negative char value
    char c = -1;  // On systems where char is signed
    
    printf("Testing AOI #5 claim:\n");
    printf("char value: %d\n", c);
    
    // This is what the response does (potentially UB):
    // tolower(c) without casting
    
    // Correct way:
    int result = tolower((unsigned char)c);
    printf("tolower((unsigned char)c) = %d\n", result);
    
    return 0;
}
