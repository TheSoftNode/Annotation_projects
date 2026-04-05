**RESPONSE 1:**

**Short answer:**  
The variables `environment` and `measurement_name` are never being set inside the `awk` program, so the string you build ends up empty (or only contains the literal parts you hard‑coded). The reason is that `--assign var=value` is **not** a standard (or even widely‑supported) `awk` option – most `awk` implementations (including the one you are probably running) ignore it and treat it as a filename, leaving the variables undefined.

---

## **What’s actually happening**

echo "${statistics\_result\_string}" |

awk \--assign environment=${environment} \\

    \--assign measurement\_name=${measurement\_name} '{

        …

    }'

1. The shell expands `${environment}` and `${measurement_name}` **before** `awk` is started, inserting their values into the command line.  
2. `awk` sees the arguments `--assign environment=prod` and `--assign measurement_name=latency` (or whatever the values are).  
   GNU `awk` (`gawk`) *does* recognise `--assign` as a synonym for `-v`, but many other `awk`s (e.g. `mawk`, `busybox awk`, the `awk` that comes with macOS/BridgeBSD) **do not**.  
   When an unknown option is encountered, `awk` treats it as a filename to read from. Since no such file exists, `awk` silently skips it and proceeds with an empty script body – the variables are never defined, so they evaluate to the empty string (`""`).

Inside the script you then do things like  
output\_influxdb\_string="resource\_usage\_" environment

3. If `environment` is empty, this becomes just the literal `"resource_usage_"`. The same happens for `measurement_name` and all the later fields, so the final `print` outputs only the static parts (or nothing at all if the input line is empty).

That’s why you don’t see the values you expect.

---

## **How to fix it**

### **1\. Use the portable `-v` option (or export the variables and let `awk` read them from the environment)**

echo "${statistics\_result\_string}" |

awk \-v environment="${environment}" \\

    \-v measurement\_name="${measurement\_name}" '

        {

            output\_influxdb\_string \= "resource\_usage\_" environment

            output\_influxdb\_string \= output\_influxdb\_string ",name=" measurement\_name

            output\_influxdb\_string \= output\_influxdb\_string " " $1 "\_count=" $2

            output\_influxdb\_string \= output\_influxdb\_string ", " $1 "\_min=" $3

            output\_influxdb\_string \= output\_influxdb\_string ", " $1 "\_10p=" $4

            output\_influxdb\_string \= output\_influxdb\_string ", " $1 "\_25p=" $5

            output\_influxdb\_string \= output\_influxdb\_string ", " $1 "\_50p=" $6

            output\_influxdb\_string \= output\_influxdb\_string ", " $1 "\_75p=" $7

            output\_influxdb\_string \= output\_influxdb\_string ", " $1 "\_90p=" $8

            output\_influxdb\_string \= output\_influxdb\_string ", " $1 "\_max=" $9

            print output\_influxdb\_string

        }

    '

* `-v var=value` is defined by POSIX and works in **all** `awk` implementations.  
* Quoting the shell variables (`"${environment}"`) protects you from word‑splitting if they contain spaces.

### **2\. (Alternative) Export the variables and let `awk` read them from `ENVIRON`**

export environment measurement\_name

echo "${statistics\_result\_string}" |

awk '

        {

            output\_influxdb\_string \= "resource\_usage\_" ENVIRON\["environment"\]

            output\_influxdb\_string \= output\_influxdb\_string ",name=" ENVIRON\["measurement\_name"\]

            …

            print output\_influxdb\_string

        }

    '

This avoids passing the values on the command line altogether and works even with very old `awk`s.

### **3\. If you really want to keep the `--assign` syntax, make sure you’re using GNU awk**

\# Verify you are using gawk

awk \--version   \# should show "GNU Awk"

If you are on a system where `/usr/bin/awk` is not `gawk`, invoke it explicitly:

gawk \--assign environment="${environment}" \\

     \--assign measurement\_name="${measurement\_name}" '…'

---

## **A few extra polishing tips (optional but helpful)**

| Issue | Why it matters | Fix |
| ----- | ----- | ----- |
| **Trailing spaces** | You add a space before each `,` (`", "`). This yields strings like `resource_usage_prod,name=latency, cpu_count=42`. The extra space after the comma is harmless for InfluxDB line‑protocol but looks odd. | Use `","` instead of `", "` if you don’t want the extra space. |
| **Missing newline** | `echo` adds a newline, which `awk` treats as a record separator. If `statistics_result_string` already ends with a newline you’ll get an empty first record. | Either `echo -n` (if you know the string has no internal newlines) or let `awk` handle it – it’s usually fine. |
| **Undefined fields** | If the input line has fewer than 9 fields, `$9` (etc.) will be empty, producing trailing `=`. | Guard against it: `($9 == "" ? "" : ", " $1 "_max=" $9)` or simply rely on InfluxDB tolerating missing fields. |
| **Readability** | Repeating `output_influxdb_string =` is verbose. | Use the `+=` operator for strings (available in most awks): `output_influxdb_string += ", " $1 "_min=" $3` etc., or build an array and `join` it. |

---

### **TL;DR**

* `--assign` is not a portable `awk` option; most `awk`s ignore it, leaving your variables undefined.  
* Use `-v var=value` (or export the variables and read them from `ENVIRON`) to pass shell values into `awk`.  
* With the variables correctly set, the script will print the InfluxDB line you expect.

Give the corrected command a try and you should see output like:

resource\_usage\_prod,name=latency cpu\_count=42, cpu\_min=5, cpu\_10p=10, cpu\_25p=20, cpu\_50p=30, cpu\_75p=40, cpu\_90p=45, cpu\_max=50

(assuming your input line contains those nine numbers). Happy scripting\!

