# Documentation Verification Summary

## Purpose
This document verifies all factual claims from both R1 and R2 that require documentation sources, based on web searches and official Docker/jq documentation.

---

## R1 Documentation Claims

### 1. {{.Image}} placeholder in docker ps
**Claim:** "{{.Image}} shows the full image reference (repo:tag or @digest)"

**Verification Result:** ✅ **SUPPORTED**
- Source: Docker official documentation
- `{{.Image}}` returns the image name and tag (e.g., `prom/node-exporter:latest`)
- URL: https://docs.docker.com/reference/cli/docker/container/ls/

### 2. docker ps vs docker ps -a behavior
**Claim:** "`docker ps` shows only running containers, `-a` shows all including stopped"

**Verification Result:** ✅ **SUPPORTED**
- Source: Docker official documentation
- Confirmed: `docker ps` lists running containers by default
- `-a/--all` flag shows all containers including stopped ones
- URL: https://docs.docker.com/reference/cli/docker/container/ls/

### 3. {{.Id}} vs {{.ID}} capitalization
**Claim:** R1 uses `{{.Id}}` in variation 2

**Verification Result:** ⚠️ **INCONSISTENT**
- Docker documentation shows `.ID` (capital)
- R1 uses lowercase `.Id` in one variation
- This is potentially a placeholder error
- Test results will show if this works or fails

---

## R2 Documentation Claims

### 1. "jq is standard on most Linux/macOS systems"
**Claim:** "You need `jq` installed (standard on most Linux/macOS systems)"

**Verification Result:** ❌ **FALSE**
- Source: jq official download page and installation documentation
- **macOS Sequoia (15+)**: NOW pre-installed as of 2024/2025
- **Earlier macOS versions**: NOT pre-installed, requires Homebrew/MacPorts
- **Linux distributions**: NOT pre-installed by default, requires manual installation via package managers
- URL: https://jqlang.org/download/
- **Conclusion:** Misleading claim - jq is only pre-installed on newest macOS, not "most systems"

### 2. "Officially recommended by Docker for complex filtering"
**Claim:** "The JSON+`jq` method is officially recommended by Docker for complex filtering"

**Verification Result:** ❌ **NOT SUPPORTED**
- Source: Docker official formatting documentation
- Docker documents JSON output format (`--format json`)
- Docker does NOT explicitly recommend jq for complex filtering
- Community uses jq extensively, but it's not "officially recommended" by Docker
- URLs checked:
  - https://docs.docker.com/engine/cli/formatting/
  - https://docs.docker.com/reference/cli/docker/container/ls/
- **Conclusion:** False claim - no official Docker recommendation found

### 3. "Docker intentionally doesn't provide substring filtering for performance and security reasons"
**Claim:** "Docker intentionally doesn't provide substring filtering for performance and security reasons (image names/tags aren't indexed)"

**Verification Result:** ❌ **UNSUPPORTED**
- Source: Docker filter documentation
- Docker documents available filters but does NOT explain WHY substring matching is absent
- No official source attributing this to "performance and security reasons"
- No official source saying "image names/tags aren't indexed"
- URL: https://docs.docker.com/reference/cli/docker/container/ls/#filter
- **Conclusion:** Speculation presented as fact - no source provided

### 4. "ancestor filter requires exact image ID or repo:tag reference"
**Claim:** "it requires an exact image ID or `repo:tag` reference"

**Verification Result:** ❌ **MISLEADING/INCOMPLETE**
- Source: Docker official documentation
- Docker docs state: **"ancestor matches containers based on its image or a descendant of it"**
- Supported forms: `image`, `image:tag`, `image:tag@digest`, `short-id`, `full-id`
- The filter ALSO matches descendants, not just exact matches
- URL: https://docs.docker.com/reference/cli/docker/container/ls/
- **Conclusion:** Incomplete claim - omits that descendants are also matched

### 5. "No native Docker CLI filter for substring matching on image tags"
**Claim:** "There is no native Docker CLI filter for substring matching on image tags"

**Verification Result:** ✅ **SUPPORTED**
- Source: Docker filter documentation
- Docker provides filters like `ancestor`, `name`, `id`, `status`, `label`, etc.
- None of these support substring/wildcard matching on image tags
- URL: https://docs.docker.com/reference/cli/docker/container/ls/#filter
- **Conclusion:** Accurate claim

### 6. docker ps --format '{{json .}}' outputs JSON
**Claim:** "`docker ps -a --format '{{json .}}'` outputs all containers as structured JSON per container"

**Verification Result:** ✅ **SUPPORTED WITH CAVEAT**
- Source: Docker formatting documentation
- `--format json` or `--format '{{json .}}'` outputs JSON format
- **CAVEAT:** Output is NOT a valid JSON array - each container is a separate JSON object per line (newline-delimited JSON)
- URL: https://docs.docker.com/reference/cli/docker/container/ls/#format
- GitHub Issue: https://github.com/moby/moby/issues/46906
- **Conclusion:** Works but format is newline-delimited JSON, not JSON array

### 7. split(":") produces ["repo/name", "tag"]
**Claim:** "Split `.Image` at `:` → `[ \"repo/name\", \"tag\" ]`"

**Verification Result:** ❌ **OVERSIMPLIFIED/MISLEADING**
- Source: jq manual for split() function
- `split(":")` splits on ALL colons in the string
- **Problems:**
  - `localhost:5000/repo:tag` → `["localhost", "5000/repo", "tag"]` (3 parts, not 2)
  - `repo@sha256:abc123` → `["repo@sha256", "abc123"]` (digest format)
  - `repo` (no tag) → `["repo"]` (index [1] is null)
- URL: https://jqlang.org/manual/v1.7/
- **Conclusion:** Misleading - only works for simple `repo:tag` format, breaks with registry URLs

### 8. "Handles images with digests correctly" vs "Does not match digest-based images"
**Claim:** First says "✅ Handles images with digests (`@sha256:...`) correctly", later says "Does not match digest-based images"

**Verification Result:** ❌ **SELF-CONTRADICTION**
- R2 makes contradictory claims within the same response
- Test results show the command FAILS on digest images (jq null errors)
- **Conclusion:** Clear contradiction - response contradicts itself

---

## Docker Inspect .Image vs .Config.Image

### Context from GPT_R1_Factual.md
**Claim:** Docker's `.Image` placeholder shows "Image ID" vs `.Config.Image` shows image name

**Verification Result:** ✅ **SUPPORTED**
- Source: Docker inspect documentation
- When inspecting CONTAINERS:
  - `.Image` → Image ID/SHA256 digest (e.g., `sha256:925ff619...`)
  - `.Config.Image` → Image name/tag as specified (e.g., `local/test:buildkit-alpha`)
- Docker example: "Get an instance's image name" uses `.Config.Image`
- URL: https://docs.docker.com/reference/cli/docker/inspect/
- **Test verification:** See outputs/R1/test6_image_vs_config_image.txt
- **Conclusion:** R1's claim about "full image reference" is disputed - {{.Image}} in docker ps context shows image name, but in docker inspect shows image ID

---

## Summary of Documentation Findings

### R1 Claims Status
- ✅ 2 claims fully supported
- ⚠️ 1 claim has inconsistency (capitalization)
- 🔍 1 claim needs context clarification ({{.Image}} behavior differs between docker ps and docker inspect)

### R2 Claims Status
- ✅ 2 claims supported (no substring filter, JSON output)
- ❌ 5 claims false/misleading:
  1. "jq standard on most systems" - FALSE
  2. "Officially recommended by Docker" - FALSE
  3. "Performance and security reasons" - UNSUPPORTED SPECULATION
  4. "Requires exact reference" - INCOMPLETE (omits descendants)
  5. "split(\":\") produces [repo, tag]" - OVERSIMPLIFIED
- ❌ 1 self-contradiction (digest handling)

### Overall Assessment
**R2 has significantly more documentation issues than R1:**
- R2 makes unsupported claims about official recommendations
- R2 presents speculation as fact
- R2 oversimplifies technical behavior
- R2 contradicts itself within the same response
- R1 has minor issues but no false claims

---

## Sources Used

1. **Docker Official Documentation**
   - https://docs.docker.com/reference/cli/docker/container/ls/
   - https://docs.docker.com/reference/cli/docker/inspect/
   - https://docs.docker.com/engine/cli/formatting/

2. **jq Official Documentation**
   - https://jqlang.org/download/
   - https://jqlang.org/manual/v1.7/

3. **Docker GitHub Issues**
   - https://github.com/moby/moby/issues/46906 (JSON format issue)

4. **Community Resources**
   - Multiple blog posts and guides confirming jq usage patterns
   - No official Docker recommendation for jq found
