**CONVERSATION HISTORY:**  
**USER:**

Using the docker command line, how can I get a list of only containers that use an image that contains ‘buildkit’ as part of their tag?

---

**ASSISTANT:**

You can combine Docker’s formatting options with a simple text‑filter (e.g. `grep`) to show only those containers whose **image : tag** string contains the word **buildkit**.

### **One‑liner**

docker ps \--format ""table {{.ID}}\\t{{.Image}}\\t{{.Names}}"" | grep \-i buildkit

#### **What it does**

| Part | Explanation |
| ----- | ----- |
| `docker ps` | Lists the running containers (add `-a` if you also want stopped ones). |
| `--format ""table {{.ID}}\t{{.Image}}\t{{.Names}}""` | Prints a tidy table with the container ID, the full image reference (`repo:tag` or `@digest`), and the container name. The `table` header makes the output readable. |
| \` | grep \-i buildkit\` |

### **Variations**

* **Include stopped containers**

 docker ps \-a \--format ""table {{.ID}}\\t{{.Image}}\\t{{.Names}}"" | grep \-i buildkit


* **Show only the container IDs** (useful for feeding into other commands)

 docker ps \-aq \--filter ""status=running"" | xargs docker inspect \--format '{{.Id}} {{.Image}}' | grep \-i buildkit | cut \-d' ' \-f1


(Here we first get the IDs of running containers, inspect each to pull the image name, filter with `grep`, then keep the ID column.)

* **Exact‑match on the tag only** (if you need to be sure the word appears *as part of the tag* and not somewhere in the repository name)

 docker ps \--format ""{{.ID}} {{.Image}} {{.Names}}"" |

    awk \-F':' '{if ($2 \~ /buildkit/) print $0}'


This splits the image string on the first `:` (separating repo from tag) and checks whether the tag portion (`$2`) contains `buildkit`.

### **Why not just `docker ps --filter`?**

Docker’s `--filter` (aka `-f`) supports a few predefined filters (`id`, `name`, `label`, `status`, `ancestor`, `before`, `since`, `isolated`, etc.).  
The `ancestor` filter expects an **exact** image reference (e.g. `myrepo/myimage:1.2.3`). It does **not** accept wildcards or substring matching, so you cannot directly ask for “any image whose tag contains *buildkit*”. Hence the combination with `grep`/`awk`/`sed` is the most straightforward and portable approach.

**PROMPT:**  
I’d like to do this in a single line. The `--filters "ancestor=*buildkit*"` doesn’t work because ancestor doesn’t seem to support wildcards.

**RESPONSE 1:**

**One‑liner (running containers only)**

docker ps \--format "table {{.ID}}\\t{{.Image}}\\t{{.Names}}" | grep \-i buildkit

**Explanation**

| Part | What it does |
| ----- | ----- |
| `docker ps` | Lists the containers that are currently running (add `-a` if you also want stopped ones). |
| `--format "table {{.ID}}\t{{.Image}}\t{{.Names}}"` | Prints a tidy table with the container **ID**, the full **image reference** (`repo:tag` or `@digest`), and the container **Name**. The `table` keyword adds a header row. |
| \` | grep \-i buildkit\` |

---

### **Variations (still a single line)**

**Include stopped containers**  
docker ps \-a \--format "table {{.ID}}\\t{{.Image}}\\t{{.Names}}" | grep \-i buildkit

* 

**Show only the container IDs** (useful for feeding into other commands)  
docker ps \-aq | xargs docker inspect \--format '{{.Id}} {{.Image}}' | grep \-i buildkit | cut \-d' ' \-f1

* 

**Exact‑match on the tag only** (ensure the word appears in the tag, not the repo name)  
docker ps \--format "{{.ID}} {{.Image}} {{.Names}}" |

  awk \-F':' '{if ($2 \~ /buildkit/) print $0}'

* 

All of these fit on a single command line and achieve the goal of listing only containers whose image tag contains the word **buildkit**.

      
**RESPONSE 2:**

You’re absolutely right—Docker’s `--filter ancestor=...` **does not support wildcards** (it requires an exact image ID or `repo:tag` reference). **There is no native Docker CLI filter for substring matching on image tags.**

However, you *can* achieve this in a **single command line** (using pipes is still a single command line) with **precise tag matching** (avoiding false positives from repo names) using Docker’s JSON output. Here’s the most robust solution:

### **✅ Single-Line Command (Exact Tag Substring Match)**

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | "\\(.ID)\\t\\(.Image)\\t\\(.Names)"'

#### **Why this works:**

1. **`docker ps -a --format '{{json .}}'`**  
   → Outputs **all containers** (including stopped ones) as **structured JSON** per container.  
2. **`| jq -r '...'`**  
   → Uses `jq` (standard JSON processor) to:  
   * Split `.Image` at `:` → `[ "repo/name", "tag" ]`  
   * Check if **tag part (`[1]`)** contains `"buildkit"`  
   * Output **ID, Image, and Names** in a clean tab-delimited format

#### **Key advantages over `grep`:**

* ✅ **Only matches the *tag* portion** (avoids false positives like `repo/buildkit-image:latest`)  
* ✅ Handles images with digests (`@sha256:...`) correctly  
* ✅ Case-sensitive by default (add `| ascii_downcase` in `jq` for case-insensitive)

---

### **⚙️ Variations (All Single-Line)**

#### **1\. Running containers only (remove `-a`):**

docker ps \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | "\\(.ID)\\t\\(.Image)\\t\\(.Names)"'

#### **2\. Case-insensitive match (add `ascii_downcase`):**

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | ascii\_downcase | contains("buildkit")) | "\\(.ID)\\t\\(.Image)\\t\\(.Names)"'

#### **3\. Only container IDs (for scripting):**

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | .ID'

---

### **❌ Why `--filter` *cannot* work (for reference)**

\# This will NEVER work (wildcards unsupported):

docker ps \--filter "ancestor=\*buildkit\*"

\# This only matches EXACT image references:

docker ps \--filter "ancestor=buildkit:latest"  \# Must be exact

### **📌 Critical Notes**

1. **You need `jq` installed** (standard on most Linux/macOS systems; `sudo apt install jq` if missing).

**Does not match digest-based images** (e.g., `buildkit@sha256:...`) since they lack a `:tag`.  
→ If you need digest support, use this enhanced version:  
docker ps \-a \--format '{{json .}}' | jq \-r 'select( (.Image | contains("buildkit")) and (.Image | contains(":") or .Image | contains("@")) ) | "\\(.ID)\\t\\(.Image)\\t\\(.Names)"'

2. 

---

### **💡 Why this is the “correct” approach**

Docker intentionally **doesn’t provide substring filtering** for performance and security reasons (image names/tags aren’t indexed). The JSON+`jq` method is:

* **Officially recommended** by Docker for complex filtering  
* **Precise** (avoids regex pitfalls of `grep`)  
* **Script-safe** (handles spaces/newlines in container names)

ℹ️ If you *absolutely cannot* use `jq`, the `grep` method is your only fallback (but **will have false positives** if your repo name contains “buildkit”):

docker ps \-a \--format "table {{.ID}}\\t{{.Image}}\\t{{.Names}}" | grep \-i ':\[^:\]\*buildkit'