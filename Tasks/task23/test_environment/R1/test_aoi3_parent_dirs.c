#include <stdio.h>
#include <sys/stat.h>
#include <errno.h>
#include <stdlib.h>

int main() {
    const char *directory = "/tmp/test_parent/child/grandchild";
    
    // Make sure parent doesn't exist
    system("rm -rf /tmp/test_parent");
    
    if (mkdir(directory, 0777) == -1) {
        if (errno != EEXIST) {
            perror("Failed to create directory");
            printf("Error code: %d (ENOENT=%d)\n", errno, ENOENT);
            return 1;
        }
    } else {
        printf("Directory created successfully\n");
    }
    
    return 0;
}
