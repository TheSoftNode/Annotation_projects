/* r1_completable.c — Response 1 code with necessary includes added
 * so it can compile. Only the missing headers are added; no other
 * changes to the logic. */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <locale.h>

int main()
{
    setlocale(LC_TIME, "");
    struct tm *localTime;
    time_t rawtime;
    char formattedTime[100];

    time(&rawtime);
    localTime = localtime(&rawtime);

    if (localTime == NULL)
    {
        fprintf(stderr, "Error: localtime failed\n");
        return 1;
    }

    // Get the time offset
    time_t gmtimeOffset = mktime(gmtime(&rawtime));
    time_t localTimeOffset = mktime(localTime);
    int timeOffset = (int)(localTimeOffset - gmtimeOffset);

    // Format the time using strftime
    if (strftime(formattedTime, sizeof(formattedTime), "%Y-%m-%d %H:%M:%S", localTime) == 0)
    {
        fprintf(stderr, "Error: strftime failed\n");
        return 1;
    }

    printf("Local time: %s\n", formattedTime);
    printf("Time offset to GMT: %d seconds\n", timeOffset);

    return 0;
}
