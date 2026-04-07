# R1 - All Non-Command/Code Factual Claims

## Complete List of Factual Claims from Response 1

### 1. "One-liner (running containers only)"
**Type:** Description claim
**What it claims:** The command is a one-liner that shows only running containers

---

### 2. "Lists the containers that are currently running"
**Type:** Docker behavior claim
**What it claims:** `docker ps` lists currently running containers

---

### 3. "add `-a` if you also want stopped ones"
**Type:** Docker flag behavior claim
**What it claims:** The `-a` flag includes stopped containers in the output

---

### 4. "Prints a tidy table with the container **ID**, the full **image reference** (`repo:tag` or `@digest`), and the container **Name**."
**Type:** Format output claim
**What it claims:**
- The format string produces a table
- Shows container ID
- Shows full image reference in `repo:tag` or `@digest` format
- Shows container Name

---

### 5. "The `table` keyword adds a header row"
**Type:** Docker formatting claim
**What it claims:** Using `table` in the format string adds a header row to the output

---

### 6. "Variations (still a single line)"
**Type:** Multi-variation claim
**What it claims:** All the variations shown are still single-line commands

---

### 7. "Include stopped containers"
**Type:** Variation description claim
**What it claims:** The first variation includes stopped containers

---

### 8. "Show only the container IDs"
**Type:** Variation description claim
**What it claims:** The second variation outputs only container IDs

---

### 9. "useful for feeding into other commands"
**Type:** Use case claim
**What it claims:** The container ID-only output is useful for piping to other commands

---

### 10. "Exact-match on the tag only"
**Type:** Filtering precision claim
**What it claims:** The awk variation matches only the tag portion, not other parts

---

### 11. "ensure the word appears in the tag, not the repo name"
**Type:** Filtering precision claim
**What it claims:** The awk variation ensures "buildkit" is in the tag, not the repository name

---

### 12. "All of these fit on a single command line"
**Type:** Global summary claim
**What it claims:** All variations are single-line commands

---

### 13. "achieve the goal of listing only containers whose image tag contains the word **buildkit**"
**Type:** Effectiveness claim
**What it claims:** All variations successfully list containers whose image TAG contains "buildkit"

---

## Claims in Table (Explanation Column)

### 14. Table Row 3: "| ` | grep -i buildkit` |"
**Type:** Incomplete explanation
**What it claims:** Nothing - the explanation for the grep portion is missing from the table

---

## Summary by Category

### Docker Behavior Claims (2 claims)
1. `docker ps` lists currently running containers
2. `-a` flag includes stopped containers

### Format/Output Claims (3 claims)
3. Format produces "tidy table" with ID, image reference, Name
4. `table` keyword adds header row
5. Outputs "full image reference" as `repo:tag` or `@digest`

### Variation Description Claims (4 claims)
6. All variations are single-line commands
7. Variation 1 includes stopped containers
8. Variation 2 shows only container IDs
9. Container IDs are useful for feeding into other commands

### Filtering Precision Claims (2 claims)
10. AWK variation does "exact-match on the tag only"
11. AWK variation ensures match is in tag, not repo name

### Effectiveness Claims (2 claims)
12. All variations fit on single command line
13. All variations list containers whose image TAG contains "buildkit"

### Issues/Errors (1 claim)
14. Incomplete table explanation for grep command

---

## Total Count: 14 factual claims (13 complete + 1 incomplete)
