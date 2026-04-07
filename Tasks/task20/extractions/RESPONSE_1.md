# RESPONSE 1

**One‑liner (running containers only)**

```
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
```

**Explanation**

| Part | What it does |
| ----- | ----- |
| `docker ps` | Lists the containers that are currently running (add `-a` if you also want stopped ones). |
| `--format "table {{.ID}}\t{{.Image}}\t{{.Names}}"` | Prints a tidy table with the container **ID**, the full **image reference** (`repo:tag` or `@digest`), and the container **Name**. The `table` keyword adds a header row. |
| ` | grep -i buildkit` |

---

### **Variations (still a single line)**

**Include stopped containers**
```
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
```

*

**Show only the container IDs** (useful for feeding into other commands)
```
docker ps -aq | xargs docker inspect --format '{{.Id}} {{.Image}}' | grep -i buildkit | cut -d' ' -f1
```

*

**Exact‑match on the tag only** (ensure the word appears in the tag, not the repo name)
```
docker ps --format "{{.ID}} {{.Image}} {{.Names}}" |
  awk -F':' '{if ($2 ~ /buildkit/) print $0}'
```

*

All of these fit on a single command line and achieve the goal of listing only containers whose image tag contains the word **buildkit**.
