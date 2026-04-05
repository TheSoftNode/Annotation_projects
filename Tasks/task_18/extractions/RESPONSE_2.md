**RESPONSE 2:**

The issue with your `awk` script is likely due to **whitespace and formatting problems** in the generated string, especially around the comma and space after the first field (`$1 "_count=" $2`).

Let’s look at this line:

output\_influxdb\_string+=" " $1 "\_count=" $2

This appends a **space**, then the value of `$1`, then `_count=`, then `$2`.

Then the next line:

output\_influxdb\_string+=", " $1 "\_min=" $3

This appends a **comma and space**, then again `$1`, then `_min=`, then `$3`.

### **Problem:**

You’re **repeating `$1`** in every field key. That’s probably not what you want.

In InfluxDB line protocol, the format is:

measurement,tag1=value1,tag2=value2 field1=value1,field2=value2 timestamp

* The part before the space is the **series key** (measurement and tags).  
* The part after the space is the **fields**.

So if `$1` is something like `"cpu"`, then you’re generating:

resource\_usage\_prod,name=server1 cpu\_count=10, cpu\_min=1, cpu\_10p=2,...

But this is **invalid** because:

* `cpu_count`, `cpu_min`, etc., should just be field keys like `count`, `min`, `10p`, etc.  
* You should **not prefix every field with `$1`** unless you’re trying to dynamically namespace them (which is fine), but then the space after `"` in `+= " " $1 ...` introduces a leading space in the field list, which breaks the InfluxDB format.

### **✅ The Real Issue: Leading Space in Field List**

This line:

output\_influxdb\_string+=" " $1 "\_count=" $2

adds a **space at the beginning of the field section**, which makes the InfluxDB line protocol invalid.

Instead, the field section should start immediately after the space following the tags — **no leading space**.

---

### **✅ Corrected Version**

echo "${statistics\_result\_string}" | awk \--assign environment="${environment}" \--assign measurement\_name="${measurement\_name}" '{

    output\_influxdb\_string \= "resource\_usage\_" environment ",name=" measurement\_name " " $1 "\_count=" $2

    output\_influxdb\_string \= output\_influxdb\_string "," $1 "\_min=" $3

    output\_influxdb\_string \= output\_influxdb\_string "," $1 "\_10p=" $4

    output\_influxdb\_string \= output\_influxdb\_string "," $1 "\_25p=" $5

    output\_influxdb\_string \= output\_influxdb\_string "," $1 "\_50p=" $6

    output\_influxdb\_string \= output\_influxdb\_string "," $1 "\_75p=" $7

    output\_influxdb\_string \= output\_influxdb\_string "," $1 "\_90p=" $8

    output\_influxdb\_string \= output\_influxdb\_string "," $1 "\_max=" $9

    print output\_influxdb\_string

}'

### **🔍 Key Fix:**

* Start the field section **without a leading space**:  
  ❌ `+= " " $1 "_count=" $2`  
  ✅ `" " $1 "_count=" $2` as part of the initial assignment.

Alternatively, build it cleanly:

{

    fields \= $1 "\_count=" $2 "," $1 "\_min=" $3 "," $1 "\_10p=" $4 "," \\

             $1 "\_25p=" $5 "," $1 "\_50p=" $6 "," $1 "\_75p=" $7 "," \\

             $1 "\_90p=" $8 "," $1 "\_max=" $9

    print "resource\_usage\_" environment ",name=" measurement\_name " " fields

}

This avoids mutation and is easier to read.

---

### **Bonus Tips:**

**Use `--` to separate options from script** (some `awk` versions require it):  
awk \--assign environment=... \--assign measurement\_name=... \-- '{ ... }'

1. 

**Quote shell variables** when passing:  
\--assign environment="${environment}"

2.   
3. **Check input format**: Make sure `${statistics_result_string}` contains exactly 9 fields per line.

**Test with sample input**:  
statistics\_result\_string="cpu 100 1 2 3 4 5 6 10"

environment="prod"

measurement\_name="server1"

Expected output:  
resource\_usage\_prod,name=server1 cpu\_count=100,cpu\_min=1,cpu\_10p=2,cpu\_25p=3,cpu\_50p=4,cpu\_75p=5,cpu\_90p=6,cpu\_max=10

4. 

---

### **✅ Final Corrected Script**

echo "${statistics\_result\_string}" | awk \--assign environment="${environment}" \--assign measurement\_name="${measurement\_name}" '{

    fields \= $1 "\_count=" $2 "," $1 "\_min=" $3 "," $1 "\_10p=" $4 "," \\

             $1 "\_25p=" $5 "," $1 "\_50p=" $6 "," $1 "\_75p=" $7 "," \\

             $1 "\_90p=" $8 "," $1 "\_max=" $9

    print "resource\_usage\_" environment ",name=" measurement\_name " " fields

}'

This will output valid InfluxDB line protocol without leading spaces or syntax errors.
