# Response 2

**Solution – get the current GMT‑offset (the amount you have to add to UTC to obtain local time) in pure C99 on Linux, without asking the user for a particular timestamp.**

The only thing we need from the system is the current wall‑clock time; we obtain that with the standard `time()` function (which returns the _current_ epoch seconds). After that we convert it to a broken‑down time with `localtime()` (or the thread‑safe `localtime_r()`) and read the `tm_gmtoff` field that glibc (and most other Linux libc implementations) fills in. `tm_gmtoff` is **seconds east of UTC** – i.e. the offset you must **add** to a UTC (`GMT`) time to get the local civil time. If you need the offset in the opposite sense (how much to subtract from local time to get UTC) just change the sign.

If `tm_gmtoff` is not available on a very old or non‑glibc system we fall back to the classic `timezone`/`daylight`/global variables that `tzset()` populates. This fallback works for the _standard‑time_ offset; to know whether DST is currently active we still need a `localtime()` call, so the fallback is only used when the platform lacks `tm_gmtoff`.

```c
/*  gmt_offset.c  –  C99, Linux
 *  Returns the current offset (in seconds) that must be added to UTC
 *  to obtain local civil time.
 *  Positive value → local time is ahead of UTC (e.g. +02:00 for CEST)
 *  Negative value → local time is behind UTC (e.g. -05:00 for EST)
 *
 *  Compile:  gcc -std=c99 -Wall -Wextra -o gmt_offset gmt_offset.c
 */

#define _POSIX_C_SOURCE 200809L   /* for localtime_r */
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

/* -------------------------------------------------------------
 *  Returns the current GMT offset in seconds (east of UTC).
 *  If the function cannot determine the offset, it returns 0
 *  and sets *errp to a non‑zero value (optional).
 * ------------------------------------------------------------- */
static long get_gmt_offset(int *errp)
{
    long offset = 0L;
    int   err   = 0;

    if (errp) *errp = 0;

    /* 1️⃣  Initialise the timezone database from the environment
     *     (TZ variable, /etc/localtime, etc.).  This must be done
     *     before any call to localtime*. */
    tzset();

    /* 2️⃣  Obtain the current calendar time. */
    time_t now = time((time_t *)0);
    if (now == (time_t)-1) {
        err = errno;
        if (errp) *errp = err;
        return 0L;
    }

    /* 3️⃣  Convert to broken‑down local time.
     *     Use the re‑entrant variant; fall back to the non‑reentrant
     *     one only if the former is not available (very old systems). */
#if defined(_POSIX_THREAD_SAFE_FUNCTIONS) && _POSIX_THREAD_SAFE_FUNCTIONS >= 0
    struct tm tm;
    if (localtime_r(&now, &tm) == NULL) {
        err = errno;
        if (errp) *errp = err;
        return 0L;
    }
#else
    struct tm *tmp = localtime(&now);
    if (tmp == NULL) {
        err = errno;
        if (errp) *errp = err;
        return 0L;
    }
    /* copy to a local object so we can safely read tm_gmtoff */
    struct tm tm = *tmp;
#endif

    /* 4️⃣  Preferred method: use tm_gmtoff if the libc provides it.
     *     It is defined in <time.h> on glibc, musl, BSD, etc. */
#if defined(__USE_GNU) || defined(__GLIBC__) || defined(__APPLE__) || \
    defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__)
    offset = tm.tm_gmtoff;          /* seconds east of UTC */
#else
    /* 5️⃣  Fallback for very old libc that lacks tm_gmtoff.
     *     The global variable `timezone' holds the offset (seconds west
     *     of UTC) for *standard* time.  `daylight' tells whether DST
     *     rules exist; we still need to know if DST is currently in
     *     effect – we can deduce it from tm.tm_isdst. */
    long std_offset = -timezone;    /* convert west‑of‑UTC to east‑of‑UTC */
    if (tm.tm_isdst > 0) {          /* DST is active */
        std_offset += 3600L;        /* most zones shift by +1 hour */
    }
    offset = std_offset;
#endif

    return offset;
}

/* -------------------------------------------------------------
 *  Example usage – prints the offset in ±HH:MM format.
 * ------------------------------------------------------------- */
int main(void)
{
    int err;
    long off_sec = get_gmt_offset(&err);
    if (err) {
        perror("get_gmt_offset");
        return EXIT_FAILURE;
    }

    long hours = off_sec / 3600L;
    long mins  = (labs(off_sec) % 3600L) / 60L;
    char sign  = (off_sec < 0) ? '-' : '+';

    printf("Current GMT offset: %c%02ld:%02ld\n",
           sign, labs(hours), mins);
    return EXIT_SUCCESS;
}
```

### **How it works**

| Step                                   | What we do                                                                                                                                        | Why it satisfies the requirements                                                                                            |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **1. `tzset()`**                       | Reads the TZ environment variable, `/etc/localtime` (or `/etc/timezone`) and initialises the global variables `timezone`, `daylight`, `tzname[]`. | No user‑supplied timestamp is needed; we merely let the libc set up its internal timezone tables.                            |
| **2. `time(NULL)`**                    | Obtains the current epoch seconds (the "wall‑clock").                                                                                             | This is the _only_ timestamp we use, and it is the current time – the program does not ask the caller for a specific moment. |
| **3. `localtime_r()` / `localtime()`** | Breaks the epoch into a `struct tm` representing local civil time.                                                                                | The conversion yields the `tm_gmtoff` field (or lets us compute the offset from `timezone`/`daylight`/`tm_isdst`).           |
| **4. Read `tm_gmtoff`**                | If available, this field is _seconds east of UTC_ – exactly the offset we need to add to a GMT time to get local time.                            | Direct, locale‑aware, DST‑correct, and works for any zone the system knows.                                                  |
| **5. Fallback**                        | On very old libc that lacks `tm_gmtoff`, we use `-timezone` (standard‑time offset) and add an hour when `tm.tm_isdst>0`.                          | Guarantees the function still works on legacy systems while still being pure C99.                                            |

### **What you get**

- `get_gmt_offset()` returns a **signed** number of seconds:
  - **positive** → local time is _ahead_ of UTC (e.g. `+02:00` for Central European Summer Time).

  - **negative** → local time is _behind_ UTC (e.g. `-05:00` for Eastern Standard Time).

If you have a `struct tm` that already represents a GMT (UTC) instant and you want the corresponding local time, simply do:

```c
struct tm gm = {0};
gm.tm_year = 2025 - 1900;   /* example: 2025‑11‑02 12:00:00 UTC */
gm.tm_mon  = 10 - 1;        /* November */
gm.tm_mday = 2;
gm.tm_hour = 12;
gm.tm_min  = 0;
gm.tm_sec  = 0;
gm.tm_isdst = -1;           /* let mktime decide DST */

time_t utc = mktime(&gm);   /* converts the broken‑down time to epoch,
                               interpreting the fields as *local* time.
                               To treat them as UTC we temporarily set
                               timezone = 0, but the simplest portable
                               way is: */
time_t utc_epoch = timegm(&gm);   /* GNU extension; if not available,
                                   use mktime with TZ=UTC */

/* Apply the offset */
time_t local_epoch = utc_epoch + off_sec;   /* off_sec from get_gmt_offset() */
struct tm *local = localtime(&local_epoch);
```

If you only need the offset value (e.g. to display "GMT±HH:MM"), the function above is sufficient.

---

**Key points**

- Pure C99 – only standard headers (`<time.h>`, `<stdio.h>`, `<stdlib.h>`) and POSIX‑2008 (`localtime_r`) are used.

- No reliance on a user‑provided timestamp; we ask the system for the _current_ time.

- Correctly handles daylight‑saving time because the conversion (`localtime`) already knows whether the instant falls in DST.

- Works on any modern Linux glibc/musl system; the fallback makes it usable on older implementations as well.

Feel free to drop the `get_gmt_offset()` function into your project and use the returned value whenever you need to adjust a GMT timestamp to the local civil time dictated by the system's locale/timezone settings. Happy coding!
