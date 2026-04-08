#include <stdio.h>

#include <errno.h>

#include <string.h>

int main() {

    // Specify the FULL path (or relative path) to the file

    const char *filepath = "/home/user/documents/newfile.txt"; // Linux/macOS

    // const char *filepath = "C:\\Users\\user\\documents\\newfile.txt"; // Windows (use double backslashes or single forward slashes)

    // const char *filepath = "subdir/newfile.txt"; // Relative to current working directory

    FILE *file = fopen(filepath, "wx"); // "w" = write, "x" = exclusive creation (fail if exists)

    if (file == NULL) {

        perror("Error opening file");

        // Optional: Check specific error (e.g., EEXIST if file exists, ENOENT if path invalid)

        if (errno == EEXIST) {

            fprintf(stderr, "File already exists: %s\n", filepath);

        } else if (errno == ENOENT) {

            fprintf(stderr, "Directory does not exist: %s\n", filepath);

        }

        return 1;

    }

    // Write something to the file (optional)

    fprintf(file, "Hello, this is a new file!\n");

    // Always close the file when done

    fclose(file);

    printf("File created successfully at: %s\n", filepath);

    return 0;

}
