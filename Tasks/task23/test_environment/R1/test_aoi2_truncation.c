#include <stdio.h>
#include <string.h>
#include <errno.h>

int main() {
    const char *directory = "/very/long/path/that/will/exceed/buffer/size/if/combined/with/more/text/and/keeps/going/on/and/on";
    const char *filename = "newfile_with_a_very_long_name_that_adds_even_more_characters_to_test_truncation_behavior.txt";
    char fullPath[50];  // Intentionally small buffer
    
    int result = snprintf(fullPath, sizeof(fullPath), "%s/%s", directory, filename);
    
    printf("snprintf return value: %d\n", result);
    printf("Buffer size: %zu\n", sizeof(fullPath));
    printf("Truncated path: %s\n", fullPath);
    
    if (result >= sizeof(fullPath)) {
        printf("WARNING: Path was truncated! Would have needed %d bytes.\n", result + 1);
    }
    
    return 0;
}
