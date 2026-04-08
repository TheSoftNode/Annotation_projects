#include <stdio.h>

#include <stdlib.h>

#include <string.h>

#include <sys/stat.h>  // For mkdir on POSIX systems

int main() {

    const char *directory = "/path/to/your/directory";  // Replace with your directory

    const char *filename = "newfile.txt";               // Name of the file to create

    char fullPath[1024];                                // Buffer for the full path

    // Step 1: Combine directory and filename

    snprintf(fullPath, sizeof(fullPath), "%s/%s", directory, filename);

    // Step 2: Create the directory if it doesn't exist (POSIX only)

    if (mkdir(directory, 0777) == -1) {

        // Check if the error is because the directory already exists

        if (errno != EEXIST) {

            perror("Failed to create directory");

            return 1;

        }

    }

    // Step 3: Open the file to create it

    FILE *file = fopen(fullPath, "w");

    if (file == NULL) {

        perror("Failed to create file");

        return 1;

    }

    // Optional: Write content to the file

    fprintf(file, "This is the content of the new file.");

    // Close the file

    fclose(file);

    printf("File created successfully at: %s\n", fullPath);

    return 0;

}
