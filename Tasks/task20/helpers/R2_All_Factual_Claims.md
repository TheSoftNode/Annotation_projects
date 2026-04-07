# R2 - All Non-Command/Code Factual Claims

## Complete List of Factual Claims from Response 2

### Opening Statement Claims

#### 1. "Docker's `--filter ancestor=...` **does not support wildcards**"
**Type:** Docker filter capability claim
**What it claims:** The ancestor filter does not accept wildcard patterns

#### 2. "it requires an exact image ID or `repo:tag` reference"
**Type:** Docker filter requirement claim
**What it claims:** The ancestor filter only accepts exact image IDs or repo:tag references

#### 3. "**There is no native Docker CLI filter for substring matching on image tags.**"
**Type:** Docker CLI limitation claim
**What it claims:** Docker CLI has no built-in filter for substring matching on tags

---

### Solution Description Claims

#### 4. "you *can* achieve this in a **single command line** (using pipes is still a single command line)"
**Type:** Command line interpretation claim
**What it claims:** Commands with pipes count as "single command line"

#### 5. "**precise tag matching** (avoiding false positives from repo names)"
**Type:** Precision/accuracy claim
**What it claims:** The jq solution provides precise tag matching and avoids false positives from repo names

#### 6. "using Docker's JSON output"
**Type:** Docker feature claim
**What it claims:** Docker provides JSON output format

#### 7. "Here's the most robust solution:"
**Type:** Quality/superiority claim
**What it claims:** The jq solution is the most robust approach

---

### "Why this works" Section Claims

#### 8. "Outputs **all containers** (including stopped ones) as **structured JSON** per container"
**Type:** Docker output format claim
**What it claims:** `docker ps -a --format '{{json .}}'` outputs all containers as structured JSON, one per container

#### 9. "Uses `jq` (standard JSON processor)"
**Type:** Tool characterization claim
**What it claims:** jq is a standard JSON processor

#### 10. "Split `.Image` at `:` → `[ \"repo/name\", \"tag\" ]`"
**Type:** String parsing behavior claim
**What it claims:** Splitting the image string on `:` produces a two-element array with repo and tag

#### 11. "Check if **tag part (`[1]`)** contains `\"buildkit\"`"
**Type:** Array indexing claim
**What it claims:** Index [1] of the split result is the tag portion

#### 12. "Output **ID, Image, and Names** in a clean tab-delimited format"
**Type:** Output format claim
**What it claims:** The output is tab-delimited with ID, Image, and Names fields

---

### "Key advantages over grep" Section Claims

#### 13. "✅ **Only matches the *tag* portion** (avoids false positives like `repo/buildkit-image:latest`)"
**Type:** Precision claim with example
**What it claims:**
- The jq solution only matches the tag portion, not other parts
- Avoids false positives where repo name contains "buildkit"
- Specifically: `repo/buildkit-image:latest` would NOT match

#### 14. "✅ Handles images with digests (`@sha256:...`) correctly"
**Type:** Digest handling claim
**What it claims:** The jq solution correctly handles digest-based images

#### 15. "✅ Case-sensitive by default (add `| ascii_downcase` in `jq` for case-insensitive)"
**Type:** Case sensitivity claim
**What it claims:**
- jq's contains() is case-sensitive by default
- ascii_downcase can be added for case-insensitive matching

---

### Variations Section Claims

#### 16. "**1. Running containers only (remove `-a`):**"
**Type:** Variation description claim
**What it claims:** Removing `-a` shows only running containers

#### 17. "**2. Case-insensitive match (add `ascii_downcase`):**"
**Type:** Variation description claim
**What it claims:** Adding ascii_downcase makes the match case-insensitive

#### 18. "**3. Only container IDs (for scripting):**"
**Type:** Variation description claim
**What it claims:** This variation outputs only container IDs, useful for scripting

---

### "Why --filter cannot work" Section Claims

#### 19. "This will NEVER work (wildcards unsupported):"
**Type:** Absolute impossibility claim
**What it claims:** The wildcard ancestor filter will never work

#### 20. "This only matches EXACT image references:"
**Type:** Exact matching claim
**What it claims:** The ancestor filter only matches exact image references

#### 21. "# Must be exact"
**Type:** Requirement emphasis claim
**What it claims:** The image reference must be exact for ancestor filter to work

---

### "Critical Notes" Section Claims

#### 22. "**You need `jq` installed** (standard on most Linux/macOS systems; `sudo apt install jq` if missing)"
**Type:** Dependency and availability claim
**What it claims:**
- jq needs to be installed
- jq is standard on most Linux/macOS systems
- Can be installed via `sudo apt install jq`

#### 23. "**Does not match digest-based images** (e.g., `buildkit@sha256:...`) since they lack a `:tag`"
**Type:** Limitation claim
**What it claims:**
- The main jq command does not match digest-based images
- Digest images lack a `:tag` separator

#### 24. "If you need digest support, use this enhanced version:"
**Type:** Alternative solution claim
**What it claims:** The enhanced version provides digest support

---

### "Why this is the correct approach" Section Claims

#### 25. "Docker intentionally **doesn't provide substring filtering** for performance and security reasons"
**Type:** Docker design rationale claim
**What it claims:** Docker deliberately omits substring filtering for performance and security reasons

#### 26. "(image names/tags aren't indexed)"
**Type:** Docker implementation detail claim
**What it claims:** Image names and tags are not indexed in Docker

#### 27. "The JSON+`jq` method is: **Officially recommended** by Docker for complex filtering"
**Type:** Official endorsement claim
**What it claims:** Docker officially recommends the JSON+jq method for complex filtering

#### 28. "**Precise** (avoids regex pitfalls of `grep`)"
**Type:** Precision superiority claim
**What it claims:**
- The jq method is precise
- grep has "regex pitfalls" that jq avoids

#### 29. "**Script-safe** (handles spaces/newlines in container names)"
**Type:** Robustness claim
**What it claims:** The jq method handles spaces and newlines in container names safely

---

### Fallback Section Claims

#### 30. "If you *absolutely cannot* use `jq`, the `grep` method is your only fallback"
**Type:** Alternative limitation claim
**What it claims:** grep is the only fallback if jq is not available

#### 31. "**will have false positives** if your repo name contains \"buildkit\""
**Type:** Weakness claim about grep fallback
**What it claims:** The grep fallback will produce false positives if the repo name contains "buildkit"

---

## Summary by Category

### Docker Capability/Limitation Claims (7 claims)
1. ancestor filter doesn't support wildcards
2. ancestor requires exact image ID or repo:tag
3. No native Docker CLI substring filter for image tags
6. Docker provides JSON output format
25. Docker intentionally omits substring filtering for performance/security
26. Image names/tags aren't indexed
27. Docker officially recommends JSON+jq for complex filtering

### Precision/Accuracy Claims (5 claims)
5. Precise tag matching avoiding false positives
7. Most robust solution
13. Only matches tag portion, avoids false positives
28. Precise, avoids regex pitfalls
29. Script-safe, handles spaces/newlines

### Tool/Format Claims (5 claims)
8. Outputs all containers as structured JSON
9. jq is standard JSON processor
12. Tab-delimited output format
15. Case-sensitive by default
22. jq standard on most Linux/macOS systems

### String Parsing Claims (2 claims)
10. split(":") produces ["repo/name", "tag"]
11. Index [1] is the tag part

### Digest Handling Claims (3 claims)
14. Handles digests correctly (in advantages section)
23. Does NOT match digest-based images (in critical notes)
24. Enhanced version provides digest support

### Variation Description Claims (3 claims)
16. Remove -a for running only
17. Add ascii_downcase for case-insensitive
18. ID-only output for scripting

### Impossibility/Limitation Claims (4 claims)
19. Wildcard ancestor will NEVER work
20. Ancestor only matches exact references
30. grep is only fallback if jq unavailable
31. grep fallback has false positives

### Interpretation/Miscellaneous (2 claims)
4. Pipes still count as single command line
21. Must be exact (emphasis)

---

## Total Count: 31 factual claims

## Claims Needing Verification

### From Documentation:
- ✅ Claim 1: ancestor doesn't support wildcards
- ❌ Claim 2: ancestor requires "exact" reference (DISPUTED - also matches descendants)
- ✅ Claim 3: No native substring filter
- ❌ Claim 9: jq is "standard" processor (DISPUTED - widely used but not standard/pre-installed)
- ❌ Claim 22: jq "standard on most Linux/macOS systems" (FALSE - not pre-installed)
- ❌ Claim 25: Docker's design rationale (UNSUPPORTED - no source)
- ❌ Claim 26: Image names/tags not indexed (UNSUPPORTED - no source)
- ❌ Claim 27: Officially recommended by Docker (FALSE - no official recommendation)

### From Test Results:
- ❌ Claim 10: split(":") produces ["repo/name", "tag"] (OVERSIMPLIFIED - fails with registry URLs)
- ❌ Claim 13: Only matches tag portion (DISPUTED - fails with registry:port/repo:tag)
- ❌ Claim 14 vs 23: SELF-CONTRADICTION about digest handling
- ✅ Claim 15: Case-sensitive by default (VERIFIED by test8)
- ✅ Claim 31: grep has false positives (VERIFIED by test results)

### Observable from Code:
- ✅ Claim 8: JSON output format (VERIFIED)
- ✅ Claim 12: Tab-delimited format (VERIFIED)
- ✅ Claim 4: Pipes count as single line (REASONABLE interpretation)

## Self-Contradictions Found

1. **Digest Handling:**
   - Claim 14: "✅ Handles images with digests correctly"
   - Claim 23: "**Does not match digest-based images**"
   - **CONTRADICTION**: Cannot both handle correctly AND not match

## False/Misleading Claims Summary

**High Priority (Provably False):**
1. Claim 22: "jq standard on most Linux/macOS systems" - FALSE
2. Claim 27: "Officially recommended by Docker" - FALSE
3. Claim 14 vs 23: Self-contradiction about digest handling
4. Claim 10: split(":") explanation oversimplified/misleading

**Medium Priority (Unsupported Speculation):**
5. Claim 25: Docker's "performance and security" rationale - NO SOURCE
6. Claim 26: "image names/tags aren't indexed" - NO SOURCE

**Low Priority (Incomplete/Imprecise):**
7. Claim 2: "exact" reference (omits descendant matching)
8. Claim 13: "only matches tag portion" (breaks with edge cases)
