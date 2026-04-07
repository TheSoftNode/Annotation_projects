I’m analyzing **RESPONSE 2** above, since that is the one you most recently pasted.

For this one, use **your Mac Terminal**, not GitHub Codespaces. Docker’s official Mac path is Docker Desktop, and GitHub says a codespace runs inside a Linux dev container where you have limited access to the outer VM host. For a fair Docker CLI test, your Mac is the cleaner environment. ([Docker Documentation](https://docs.docker.com/desktop/setup/install/mac-install/?utm_source=chatgpt.com))

Before you test anything, check dependencies first:

docker version

jq \--version

`docker` is required because every command in the response uses Docker, and `jq` is required because the main solution pipes into `jq`. jq’s own site says it is a separate tool with downloads for macOS/Linux/Windows. ([jqlang.org](https://jqlang.org/download/?utm_source=chatgpt.com))

Use this setup so the response can be tested against known cases:

docker rm \-f c\_tag\_running c\_repo\_running c\_plain\_running buildkit\_named c\_tag\_stopped c\_regport c\_upper\_tag c\_digest\_running c\_child 2\>/dev/null || true

docker image rm local/test:buildkit-alpha local/buildkit-repo:latest local/plain:latest localhost:5000/example/plain:buildkit-alpha local/test:BuildKitBeta local/child-of-buildkit:latest 2\>/dev/null || true

docker pull busybox:latest

docker image tag busybox:latest local/test:buildkit-alpha

docker image tag busybox:latest local/buildkit-repo:latest

docker image tag busybox:latest local/plain:latest

docker image tag busybox:latest localhost:5000/example/plain:buildkit-alpha

docker image tag busybox:latest local/test:BuildKitBeta

docker run \-d \--name c\_tag\_running local/test:buildkit-alpha sh \-c 'sleep 600'

docker run \-d \--name c\_repo\_running local/buildkit-repo:latest sh \-c 'sleep 600'

docker run \-d \--name c\_plain\_running local/plain:latest sh \-c 'sleep 600'

docker run \-d \--name buildkit\_named local/plain:latest sh \-c 'sleep 600'

docker create \--name c\_tag\_stopped local/test:buildkit-alpha sh \-c 'echo done'

docker run \-d \--name c\_regport localhost:5000/example/plain:buildkit-alpha sh \-c 'sleep 600'

docker run \-d \--name c\_upper\_tag local/test:BuildKitBeta sh \-c 'sleep 600'

DIGEST\_REF=$(docker image inspect busybox:latest \--format '{{index .RepoDigests 0}}')

docker run \-d \--name c\_digest\_running "$DIGEST\_REF" sh \-c 'sleep 600'

mkdir \-p /tmp/docker-ancestor-test

cat \>/tmp/docker-ancestor-test/Dockerfile \<\<'EOF'

FROM local/test:buildkit-alpha

CMD \["sh","-c","sleep 600"\]

EOF

docker build \-t local/child-of-buildkit:latest /tmp/docker-ancestor-test

docker run \-d \--name c\_child local/child-of-buildkit:latest

Now record the ground truth:

docker inspect \--format '{{.Name}} \-\> {{.Config.Image}}' c\_tag\_running c\_repo\_running c\_plain\_running buildkit\_named c\_tag\_stopped c\_regport c\_upper\_tag c\_digest\_running c\_child

docker ps \-a \--format json

Docker’s inspect docs use `.Config.Image` for “Get an instance’s image name,” and Docker’s `docker ps` docs show `--format json` for JSON output. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/inspect/))

Now the claims, in the exact format you asked for.

1. Claim: **"Docker’s \--filter ancestor=... does not support wildcards (it requires an exact image ID or repo:tag reference)."**

How to verify:  
Run these exact commands:

docker ps \--filter "ancestor=\*buildkit\*"

docker ps \--filter "ancestor=local/test:buildkit-alpha"

What to compare:

* If wildcards are unsupported, the first command should **not** act like substring matching for your `buildkit` tag case.  
* The second command should match `c_tag_running`, and because `ancestor` also matches descendants, it may also match `c_child`.

What the primary source says:  
Docker’s `ancestor` filter supports these forms: `image`, `image:tag`, `image:tag@digest`, `short-id`, and `full-id`. Docker’s docs do **not** describe wildcard substring matching for `ancestor`. The same docs also say `ancestor` matches containers based on the image **or a descendant of it**, which disputes the narrower wording “requires an exact image ID or repo:tag reference.” ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/))

2. Claim: **"There is no native Docker CLI filter for substring matching on image tags."**

How to verify:  
Check the supported `docker ps --filter` behavior by trying:

docker ps \--filter "ancestor=local/test:buildkit-alpha"

docker ps \--filter "ancestor=\*buildkit\*"

docker ps \--filter "ancestor=buildkit"

Expected result:  
Docker documents exact ancestor representations, not a built-in “tag contains substring” filter.

What the primary source says:  
Docker documents the available `docker ps` filters and the supported `ancestor` forms, but not a substring tag filter. This claim is supported by the documented filter surface. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/))

3. Claim: **"However, you can achieve this in a single command line (using pipes is still a single command line) with precise tag matching (avoiding false positives from repo names) using Docker’s JSON output."**

How to verify:  
Run the exact command from the response:

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | "\\(.ID)\\t\\(.Image)\\t\\(.Names)"'

Expected result if the claim were fully accurate:

* It should include `c_tag_running` and `c_tag_stopped`  
* It should exclude `c_repo_running`  
* It should exclude `buildkit_named`  
* It should also behave correctly for `c_regport`

What the primary source says:  
Docker supports Go-template formatting and a `json` function, and `docker ps --format json` is documented for JSON output. But the “precise tag matching” part is **not** guaranteed by Docker docs, and the jq logic depends on `split(":")[1]`, which jq defines as splitting on the separator string, not as “parse Docker image ref into repo and tag.” That makes this claim a **local-test claim**, not a doc-supported fact. ([Docker Documentation](https://docs.docker.com/engine/cli/formatting/))

4. Claim: **"docker ps \-a \--format '{{json .}}' → Outputs all containers (including stopped ones) as structured JSON per container."**

How to verify:  
Run exactly:

docker ps \-a \--format '{{json .}}'

Expected result:  
You should see one JSON object per container, including `c_tag_stopped`.

What the primary source says:  
Docker explicitly documents `docker ps --format json` for JSON output, and Docker’s formatting docs say the `json` function encodes an element as a JSON string. That makes this claim plausible and testable, though Docker’s container-ls page explicitly shows `--format json`, not this exact `{{json .}}` form. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/))

5. Claim: **"Uses jq (standard JSON processor)"**

How to verify:  
This is mostly descriptive. Run:

jq \--version

What the primary source says:  
jq’s official site describes jq as “a lightweight and flexible command-line JSON processor.” The word “standard” is not something the jq primary docs establish, but “JSON processor” is supported. ([jqlang.org](https://jqlang.org/?utm_source=chatgpt.com))

6. Claim: **"Split .Image at : → \[ "repo/name", "tag" \]"**

How to verify:  
Run these exact checks:

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Names=="c\_tag\_running") | .Image, (.Image | split(":"))'

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Names=="c\_regport") | .Image, (.Image | split(":"))'

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Names=="c\_digest\_running") | .Image, (.Image | split(":"))'

Expected result:

* For a plain `repo:tag` image, `split(":")` may look like `[repo, tag]`  
* For `localhost:5000/example/plain:buildkit-alpha`, it will not be just `[repo/name, tag]`  
* For a digest reference, it also will not be just `[repo/name, tag]`

What the primary source says:  
jq says `split(str)` splits an input string on the separator argument. Docker’s image reference syntax is `IMAGE[:TAG][@DIGEST]`, and registry references can contain `:port`. So the claim that `split(":")` produces exactly `[repo/name, tag]` is **not generally factual**. ([jqlang.org](https://jqlang.org/manual/v1.7/))

7. Claim: **"Check if tag part (\[1\]) contains "buildkit""**

How to verify:  
Run:

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | .Names'

Expected result:  
This command really does check whether the second split segment contains `buildkit`.

What the primary source says:  
jq documents both `split` and `contains`, so this claim about what the code is doing is supported. Whether `[1]` is truly “the tag part” for every Docker image reference is a separate claim, and that part is disputed. ([jqlang.org](https://jqlang.org/manual/v1.7/))

8. Claim: **"Output ID, Image, and Names in a clean tab-delimited format"**

How to verify:  
Run the main command and inspect one output line.

Expected result:  
Each matching line should have three fields separated by tabs: ID, Image, Names.

What the primary source says:  
That follows directly from the jq string `"\(.ID)\t\(.Image)\t\(.Names)"`. This is a code-behavior claim and is straightforward to test locally. jq’s docs also note jq operates on JSON values and emits output per filter. ([jqlang.org](https://jqlang.org/manual/?utm_source=chatgpt.com))

9. Claim: **"Only matches the tag portion (avoids false positives like repo/buildkit-image:latest)"**

How to verify:  
Run the main command exactly:

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | "\\(.ID)\\t\\(.Image)\\t\\(.Names)"'

Then compare against your setup:

* `c_repo_running` has `buildkit` in the **repo**, not the tag  
* `c_tag_running` has `buildkit` in the **tag**  
* `c_regport` tests a registry host with `:port`

Expected result if the claim were true:

* `c_repo_running` should be excluded  
* `c_tag_running` should be included  
* `c_regport` should still be handled correctly

What the primary source says:  
Docker’s image references can include `:port`, `:tag`, and `@digest`, while jq’s `split(":")` is just raw string splitting. So this claim is **not reliably supported** by the docs and needs local testing. ([Docker Documentation](https://docs.docker.com/engine/containers/run/?utm_source=chatgpt.com))

10. Claim: **"Handles images with digests (@sha256:...) correctly"**

How to verify:  
Run:

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Names=="c\_digest\_running") | .Image'

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | "\\(.ID)\\t\\(.Image)\\t\\(.Names)"'

Expected result:  
This lets you see exactly what `.Image` looks like for a digest-based container and whether the selection logic behaves sensibly.

What the primary source says:  
Docker documents digest image references as `IMAGE@sha256:...`. jq documents `split(":")` as plain string splitting. That does **not** by itself establish “handles digests correctly.” Also, this response later says digest-based images do **not** match because they lack a `:tag`, so the response contradicts itself internally. ([Docker Documentation](https://docs.docker.com/engine/containers/run/?utm_source=chatgpt.com))

11. Claim: **"Case-sensitive by default (add | ascii\_downcase in jq for case-insensitive)"**

How to verify:  
Run both exact commands from the response:

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | "\\(.ID)\\t\\(.Image)\\t\\(.Names)"'

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | ascii\_downcase | contains("buildkit")) | "\\(.ID)\\t\\(.Image)\\t\\(.Names)"'

Expected result with the setup above:

* `c_upper_tag` may fail the first command  
* `c_upper_tag` should match the second command if Docker preserved the uppercase tag

What the primary source says:  
jq documents `contains` as substring containment and `ascii_downcase` as converting ASCII letters to lowercase, which supports this claim. ([jqlang.org](https://jqlang.org/manual/v1.7/))

12. Claim: **"1. Running containers only (remove \-a):"**

How to verify:  
Run the exact variation:

docker ps \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | "\\(.ID)\\t\\(.Image)\\t\\(.Names)"'

Expected result:  
`c_tag_stopped` should not appear, because Docker docs say `docker ps` shows running containers only unless you add `-a`. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/))

13. Claim: **"3. Only container IDs (for scripting):"**

How to verify:  
Run the exact variation:

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | .ID'

Expected result:  
Only IDs should print, one per line.

What the primary source says:  
This is directly testable from the jq expression because it outputs `.ID` only. jq’s filter model supports that reading. ([jqlang.org](https://jqlang.org/manual/?utm_source=chatgpt.com))

14. Claim: **"This will NEVER work (wildcards unsupported): docker ps \--filter "ancestor=*buildkit*""**

How to verify:  
Run it exactly:

docker ps \--filter "ancestor=\*buildkit\*"

Expected result:  
It should not behave as a native substring-tag filter.

What the primary source says:  
Docker documents supported `ancestor` representations, not wildcard matching. The absolute wording “NEVER” is stronger than the docs themselves, so treat this as **supported in spirit, but best verified locally**. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/))

15. Claim: **"This only matches EXACT image references: docker ps \--filter "ancestor=buildkit:latest" \# Must be exact"**

How to verify:  
Use your child-image setup and run:

docker ps \--filter "ancestor=local/test:buildkit-alpha"

Expected result:  
If Docker behaves as documented, this can match containers using that image **and descendants**, so it is not limited to “only exact image references.”

What the primary source says:  
Docker’s docs explicitly say `ancestor` matches containers based on an image **or a descendant of it**. That disputes this claim. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/))

16. Claim: **"You need jq installed (standard on most Linux/macOS systems; sudo apt install jq if missing)."**

How to verify:  
Run:

jq \--version

What the primary source says:  
The first part, “You need jq installed,” is supported because the response’s commands call `jq`. jq’s download page also supports `sudo apt-get install jq` for Debian/Ubuntu. But I did **not** find a primary source supporting the phrase “standard on most Linux/macOS systems.” ([jqlang.org](https://jqlang.org/download/?utm_source=chatgpt.com))

17. Claim: **"Does not match digest-based images (e.g., buildkit@sha256:...) since they lack a :tag."**

How to verify:  
Run:

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Names=="c\_digest\_running") | .Image'

docker ps \-a \--format '{{json .}}' | jq \-r 'select(.Image | split(":")\[1\] | contains("buildkit")) | .Names'

Expected result:  
This shows whether the digest-based image appears and how the split logic treats it.

What the primary source says:  
Docker’s image reference syntax does distinguish `:tag` from `@digest`, but jq `split(":")` still splits anywhere a colon occurs in the string. So the reasoning in this claim is **not securely supported by the docs**, and it also conflicts with the earlier “handles digests correctly” statement. ([Docker Documentation](https://docs.docker.com/engine/containers/run/?utm_source=chatgpt.com))

18. Claim: **"Docker intentionally doesn’t provide substring filtering for performance and security reasons (image names/tags aren’t indexed)."**

How to verify:  
You cannot fairly verify that causal explanation just by running code.

What the primary source says:  
I did **not** find a Docker primary source in the filter docs or `docker container ls` docs that attributes the limitation to “performance and security reasons” or to image names/tags not being indexed. Treat this claim as **unsupported by the primary docs I checked**. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/))

19. Claim: **"Officially recommended by Docker for complex filtering"**

How to verify:  
This is a documentation claim, not a runtime claim.

What the primary source says:  
Docker documents formatting, JSON output, and filters, but I did **not** find a primary Docker doc saying that the JSON+`jq` pattern is “officially recommended by Docker for complex filtering.” Treat this as **unsupported by the primary docs I checked**. ([Docker Documentation](https://docs.docker.com/engine/cli/formatting/))

20. Claim: **"If you absolutely cannot use jq, the grep method is your only fallback (but will have false positives if your repo name contains “buildkit”):"**

How to verify:  
Run the exact fallback:

docker ps \-a \--format "table {{.ID}}\\t{{.Image}}\\t{{.Names}}" | grep \-i ':\[^:\]\*buildkit'

Expected result:

* `c_tag_running` should likely match  
* `c_repo_running` is the important case to check  
* `c_regport` is also important because `:[^:]*buildkit` can interact badly with extra colons in the image reference

What the primary source says:  
Docker documents the formatting pieces used here, but the “only fallback” part is not something Docker’s docs establish. The false-positive warning is reasonable to test locally, but not something I found as an official Docker statement. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/))

When you run these, send me:

* the output of the **ground truth** commands  
* the output of the **main jq command**  
* the output of the **ancestor wildcard** test  
* the output of the **ancestor exactness** test  
* the output of the **grep fallback**

After that, I’ll help you classify each claim as supported, disputed, or false.

