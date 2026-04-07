# Commands Extraction - All Code/Commands Verbatim

## From CONVERSATION HISTORY

### Assistant's Main Command
```bash
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
```

### Assistant's Variation 1 - Include stopped containers
```bash
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
```

### Assistant's Variation 2 - Show only container IDs
```bash
docker ps -aq --filter "status=running" | xargs docker inspect --format '{{.Id}} {{.Image}}' | grep -i buildkit | cut -d' ' -f1
```

### Assistant's Variation 3 - Exact-match on tag only
```bash
docker ps --format "{{.ID}} {{.Image}} {{.Names}}" |
  awk -F':' '{if ($2 ~ /buildkit/) print $0}'
```

### Assistant's Test Command
```bash
select version();
```

---

## From RESPONSE 1

### Main One-liner (running containers only)
```bash
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
```

### Variation 1 - Include stopped containers
```bash
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
```

### Variation 2 - Show only the container IDs
```bash
docker ps -aq | xargs docker inspect --format '{{.Id}} {{.Image}}' | grep -i buildkit | cut -d' ' -f1
```

### Variation 3 - Exact-match on the tag only
```bash
docker ps --format "{{.ID}} {{.Image}} {{.Names}}" |
  awk -F':' '{if ($2 ~ /buildkit/) print $0}'
```

---

## From RESPONSE 2

### Main Single-Line Command (Exact Tag Substring Match)
```bash
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"'
```

### Variation 1 - Running containers only (remove `-a`)
```bash
docker ps --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"'
```

### Variation 2 - Case-insensitive match (add `ascii_downcase`)
```bash
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | ascii_downcase | contains("buildkit")) | "\(.ID)\t\(.Image)\t\(.Names)"'
```

### Variation 3 - Only container IDs (for scripting)
```bash
docker ps -a --format '{{json .}}' | jq -r 'select(.Image | split(":")[1] | contains("buildkit")) | .ID'
```

### Example of what will NEVER work
```bash
# This will NEVER work (wildcards unsupported):
docker ps --filter "ancestor=*buildkit*"

# This only matches EXACT image references:
docker ps --filter "ancestor=buildkit:latest"  # Must be exact
```

### Enhanced Version for Digest Support
```bash
docker ps -a --format '{{json .}}' | jq -r 'select( (.Image | contains("buildkit")) and (.Image | contains(":") or .Image | contains("@")) ) | "\(.ID)\t\(.Image)\t\(.Names)"'
```

### Fallback grep Method
```bash
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i ':[^:]*buildkit'
```

---

## Summary

**Total Commands in Conversation History:** 4 commands + 1 SQL test
**Total Commands in Response 1:** 4 commands (3 variations of main approach)
**Total Commands in Response 2:** 7 commands (3 variations + 2 examples of what won't work + 1 enhanced version + 1 fallback)

**Key Differences:**
- Response 1 uses `grep -i` for filtering (case-insensitive)
- Response 2 uses `jq` with JSON output for filtering
- Response 1's variation 2 uses `{{.Id}}` (capitalization inconsistency)
- Response 2 provides more variations and edge case handling
