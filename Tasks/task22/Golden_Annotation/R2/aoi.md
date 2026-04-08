# Response 2 - Areas of Improvement (AOIs)

## AOI #1 - SUBSTANTIAL

**Response Excerpt:**
```c
scanf("%d", &num);
```

**Description:** The response uses scanf with %d without validating its return value, causing undefined behavior when users enter non-numeric strings (scanf fails and leaves num uninitialized) or decimal inputs like 20.1 (scanf reads only 20 and leaves .1 in the buffer).

**Severity:** Substantial

---

## AOI #2 - MINOR

**Response Excerpt:**
```c
printf("Enter a positive number: ");
scanf("%d", &num);
```

**Description:** The response prompts "Enter a positive number" which is misleading since the program reads any integer and then validates positivity, not restricting input to positive numbers only.

**Severity:** Minor

---
