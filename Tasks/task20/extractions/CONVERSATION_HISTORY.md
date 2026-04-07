# CONVERSATION HISTORY

**USER:**

Using the docker command line, how can I get a list of only containers that use an image that contains 'buildkit' as part of their tag?

---

**ASSISTANT:**

You can combine Docker's formatting options with a simple text‑filter (e.g. `grep`) to show only those containers whose **image : tag** string contains the word **buildkit**.

### **One‑liner**

```
docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
```

#### **What it does**

| Part | Explanation |
| ----- | ----- |
| `docker ps` | Lists the running containers (add `-a` if you also want stopped ones). |
| `--format "table {{.ID}}\t{{.Image}}\t{{.Names}}"` | Prints a tidy table with the container ID, the full image reference (`repo:tag` or `@digest`), and the container name. The `table` header makes the output readable. |
| ` | grep -i buildkit` |

### **Variations**

* **Include stopped containers**

  ```
  docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}" | grep -i buildkit
  ```

* **Show only the container IDs** (useful for feeding into other commands)

  ```
  docker ps -aq --filter "status=running" | xargs docker inspect --format '{{.Id}} {{.Image}}' | grep -i buildkit | cut -d' ' -f1
  ```

  (Here we first get the IDs of running containers, inspect each to pull the image name, filter with `grep`, then keep the ID column.)

* **Exact‑match on the tag only** (if you need to be sure the word appears *as part of the tag* and not somewhere in the repository name)

  ```
  docker ps --format "{{.ID}} {{.Image}} {{.Names}}" |
    awk -F':' '{if ($2 ~ /buildkit/) print $0}'
  ```

  This splits the image string on the first `:` (separating repo from tag) and checks whether the tag portion (`$2`) contains `buildkit`.

### **Why not just `docker ps --filter`?**

Docker's `--filter` (aka `-f`) supports a few predefined filters (`id`, `name`, `label`, `status`, `ancestor`, `before`, `since`, `isolated`, etc.).
The `ancestor` filter expects an **exact** image reference (e.g. `myrepo/myimage:1.2.3`). It does **not** accept wildcards or substring matching, so you cannot directly ask for "any image whose tag contains *buildkit*". Hence the combination with `grep`/`awk`/`sed` is the most straightforward and portable approach.
