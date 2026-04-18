/*  r2_original.c  –  Response 2 code AS-WRITTEN, verbatim.
 *  Note: uses errno without #include <errno.h>.
 */

#define _POSIX_C_SOURCE 200809L /* for localtime_r */
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

/* -------------------------------------------------------------
 *  Returns the current GMT offset in seconds (east of UTC).
 *  If the function cannot determine the offset, it returns 0
 *  and sets *errp to a non-zero value (optional).
 * ------------------------------------------------------------- */
static long get_gmt_offset(int *errp)
{
    long offset = 0L;
    int err = 0;

    if (errp)
        *errp = 0;

    /* 1  Initialise the timezone database from the environment
     *     (TZ variable, /etc/localtime, etc.).  This must be done
     *     before any call to localtime*. */
    tzset();

    /* 2  Obtain the current calendar time. */
    time_t now = time((time_t *)0);
    if (now == (time_t)-1)
    {
        err = errno;
        if (errp)
            *errp = err;
        return 0L;
    }

    /* 3  Convert to broken-down local time.
     *     Use the re-entrant variant; fall back to the non-reentrant
     *     one only if the former is not available (very old systems). */
#if defined(_POSIX_THREAD_SAFE_FUNCTIONS) && _POSIX_THREAD_SAFE_FUNCTIONS >= 0
    struct tm tm;
    if (localtime_r(&now, &tm) == NULL)
    {
        err = errno;
        if (errp)
            *errp = err;
        return 0L;
    }
#else
    struct tm *tmp = localtime(&now);
    if (tmp == NULL)
    {
        err = errno;
        if (errp)
            *errp = err;
        return 0L;
    }
    /* copy to a local object so we can safely read tm_gmtoff */
    struct tm tm = *tmp;
#endif

    /* 4  Preferred method: use tm_gmtoff if the libc provides it.
     *     It is defined in <time.h> on glibc, musl, BSD, etc. */
#if defined(__USE_GNU) || defined(__GLIBC__) || defined(__APPLE__) || \
    defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__)
    offset = tm.tm_gmtoff; /* seconds east of UTC */
#else
    /* 5  Fallback for very old libc that lacks tm_gmtoff.
     *     The global variable `timezone' holds the offset (seconds west
     *     of UTC) for *standard* time.  `daylight' tells whether DST
     *     rules exist; we still need to know if DST is currently in
     *     effect - we can deduce it from tm.tm_isdst. */
    long std_offset = -timezone; /* convert west-of-UTC to east-of-UTC */
    if (tm.tm_isdst > 0)
    {                        /* DST is active */
        std_offset += 3600L; /* most zones shift by +1 hour */
    }
    offset = std_offset;
#endif

    return offset;
}

/* -------------------------------------------------------------
 *  Example usage - prints the offset in +/-HH:MM format.
 * ------------------------------------------------------------- */
int main(void)
{
    int err;
    long off_sec = get_gmt_offset(&err);
    if (err)
    {
        perror("get_gmt_offset");
        return EXIT_FAILURE;
    }

    long hours = off_sec / 3600L;
    long mins = (labs(off_sec) % 3600L) / 60L;
    char sign = (off_sec < 0) ? '-' : '+';

    printf("Current GMT offset: %c%02ld:%02ld\n",
           sign, labs(hours), mins);
    return EXIT_SUCCESS;
}
