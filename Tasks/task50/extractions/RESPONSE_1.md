## You're right — if you tried:

## ps aux | grep 'Z' | grep \-v grep

##

## and it **still showed the `grep` line**, it might be because the process name or command line includes something like `grep 'Z'`, but the `'Z'` part doesn't appear in the same line as `grep`, so `grep 'Z'` matches the process, but `grep -v grep` doesn't remove it — because the `grep` command may not be clearly visible in the output depending on the system.

## But more likely, you're seeing a **zombie process**, which is actually what `grep 'Z'` is often used for — to find processes with status `Z` (zombie). In that case, the command **is working correctly**, and you're not seeing the `grep` command itself — you're seeing real zombie processes.

## Let's clarify:

### **✅ Goal: Find zombie processes (status `Z`), without including the `grep` command in results.**

## Zombie processes have a `STAT` (status) field of `Z` (or `Z+`). The best way to find them reliably is:

## ps aux | awk '$8 \~ /Z/ { print }'

##

### **Why this is better:**

* ## `ps aux` outputs columns.

* ## The **8th column** is the **process state (STAT)**.

* ## `awk '$8 ~ /Z/'` checks if the 8th field **contains 'Z'**, meaning it's a zombie.

* ## It **won't match** the `grep` command because `grep` isn't a zombie and its state isn't `Z`.

### **Example output:**

## USER  PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND

## user 1234  0.0  0.0      0     0 ?        Z    10:00   0:00 \[defunct\]

##

## This method is **accurate** and avoids self-inclusion issues entirely.

## ---

### **✅ So, to answer your question:**

## How to modify `ps aux | grep 'Z'` so it doesn't include itself?

## 👉 Use:

## ps aux | awk '$8 \~ /Z/'

##

## This shows **only zombie processes**, and **excludes `grep`** naturally — no workaround needed.

## Let me know if you were actually looking for something else (e.g. processes with 'Z' in the name, not zombies).