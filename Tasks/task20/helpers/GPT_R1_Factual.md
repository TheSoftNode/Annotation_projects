Use your **Mac Terminal**, not GitHub Codespaces, for this test. Docker’s official macOS path is Docker Desktop, and GitHub says a codespace puts you inside a dev container with limited access to the outer VM, so it is not the cleanest place to verify host-level `docker ps` behavior. ([Docker Documentation](https://docs.docker.com/desktop/setup/install/mac-install/?utm_source=chatgpt.com))

Before testing the response, make sure:

* Docker Desktop is installed and running on your Mac. ([Docker Documentation](https://docs.docker.com/desktop/setup/install/mac-install/?utm_source=chatgpt.com))  
* `docker` works: run `docker version`  
* the helper tools exist: run `which grep awk cut xargs`

You do **not** need extra packages if those commands are already present.

Run this setup first so you have a fair, controlled test case:

docker rm \-f c\_tag\_running c\_repo\_running c\_plain\_running buildkit\_named c\_tag\_stopped 2\>/dev/null || true  
docker image rm local/test:buildkit-alpha local/buildkit-repo:latest local/plain:latest local/test:foo-buildkit 2\>/dev/null || true

docker pull busybox:latest

docker image tag busybox:latest local/test:buildkit-alpha  
docker image tag busybox:latest local/buildkit-repo:latest  
docker image tag busybox:latest local/plain:latest  
docker image tag busybox:latest local/test:foo-buildkit

docker run \-d \--name c\_tag\_running local/test:buildkit-alpha sh \-c 'sleep 600'  
docker run \-d \--name c\_repo\_running local/buildkit-repo:latest sh \-c 'sleep 600'  
docker run \-d \--name c\_plain\_running local/plain:latest sh \-c 'sleep 600'  
docker run \-d \--name buildkit\_named local/plain:latest sh \-c 'sleep 600'  
docker create \--name c\_tag\_stopped local/test:foo-buildkit sh \-c 'echo done'

Then confirm the ground truth with this baseline:

docker ps \-a \--format "table {{.ID}}\\t{{.Image}}\\t{{.Names}}"

You should now have:

* `c_tag_running` → image tag contains `buildkit`  
* `c_repo_running` → **repo** contains `buildkit`, tag is `latest`  
* `c_plain_running` → no `buildkit` anywhere  
* `buildkit_named` → container **name** contains `buildkit`, image does not  
* `c_tag_stopped` → stopped/created container whose tag contains `buildkit`

Now the claim breakdown.

1. Claim: **"One-liner (running containers only)"**

How to verify:

* Look at the first command in the response. It is physically one line.  
* Then run the exact command from the response:

docker ps \--format "table {{.ID}}\\t{{.Image}}\\t{{.Names}}" | grep \-i buildkit

What to check:

* `docker ps` should only consider running containers by default. Docker’s docs say `docker ps` only shows running containers unless you add `-a`. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/?utm_source=chatgpt.com))  
* With the fixture above, `c_tag_stopped` should **not** appear.  
2. Claim: **"Lists the containers that are currently running (add \-a if you also want stopped ones)."**

How to verify:

* Run:

docker ps  
docker ps \-a

Expected:

* `docker ps` should omit `c_tag_stopped`  
* `docker ps -a` should include it

This claim is supported by Docker’s `docker container ls` docs, which state that `docker ps` shows only running containers by default and `-a/--all` shows all containers. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/?utm_source=chatgpt.com))

3. Claim: **"Prints a tidy table with the container ID, the full image reference (repo:tag or @digest), and the container Name. The table keyword adds a header row."**

How to verify:

* Run the exact first command again:

docker ps \--format "table {{.ID}}\\t{{.Image}}\\t{{.Names}}"

What to check:

* There should be a header row because Docker’s formatting docs say `table` includes headers. ([Docker Documentation](https://docs.docker.com/engine/cli/formatting/))  
* Docker’s `docker container ls` docs list `.ID`, `.Image`, and `.Names` as valid placeholders. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/))

What is disputed:

* The specific wording **"the full image reference (repo:tag or @digest)"** is **not cleanly supported** by the official docs. Docker’s `docker container ls` page describes the `.Image` placeholder as **"Image ID"**, while Docker’s general `docker inspect` examples say `.Config.Image` is the field to use when you want the image name. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/container/ls/))

Manual cross-check for that disputed part:

docker inspect c\_tag\_running \--format '{{.Image}}'  
docker inspect c\_tag\_running \--format '{{.Config.Image}}'

What to look for:

* If `{{.Image}}` prints a SHA-like value and `{{.Config.Image}}` prints `local/test:buildkit-alpha`, that disputes the response’s wording about “full image reference.” Docker’s own example for “Get an instance’s image name” uses `.Config.Image`. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/inspect/))  
4. Claim: **"Variations (still a single line)"**

How to verify:

* Check the response visually.  
* The second variation is shown on one line.  
* The AWK variation is shown across **two physical lines** in the pasted response.

So this is at least visually disputable from the response as written.

5. Claim: **"Show only the container IDs (useful for feeding into other commands)"**

Run the exact command from the response:

docker ps \-aq | xargs docker inspect \--format '{{.Id}} {{.Image}}' | grep \-i buildkit | cut \-d' ' \-f1

What to check:

* If this claim is accurate, the output should be only container IDs, one per line.  
* With the fixture above, there are definitely containers whose image tags include `buildkit`, so non-empty output would be expected if the matching logic is correct.

What is disputed:

* Docker’s docs say `.Config.Image` is the way to get the image name from `docker inspect`; the response’s command uses `.Image` instead. That means the explanatory idea behind this variation is not supported by the official docs. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/inspect/))

Best diagnostic check:

docker inspect c\_tag\_running \--format '{{.Image}}'  
docker inspect c\_tag\_running \--format '{{.Config.Image}}'

If the first one is not the name/tag string, that is strong evidence against the response’s description. ([Docker Documentation](https://docs.docker.com/reference/cli/docker/inspect/))

6. Claim: **"Exact-match on the tag only (ensure the word appears in the tag, not the repo name)"**

Run the exact AWK snippet exactly as shown:

docker ps \--format "{{.ID}} {{.Image}} {{.Names}}" |  
  awk \-F':' '{if ($2 \~ /buildkit/) print $0}'

What to check against the fixture:

* `c_tag_running` should likely appear  
* `c_repo_running` should likely **not** appear, because its repo contains `buildkit` but its tag is `latest`  
* `buildkit_named` is the important test: if it appears, then the command is not truly isolating “tag only”

Also check whether `c_tag_running` appears even though its tag is `buildkit-alpha`, not exactly `buildkit`. If it does, that disputes the phrase **"Exact-match"**.

7. Claim: **"All of these fit on a single command line and achieve the goal of listing only containers whose image tag contains the word buildkit."**

How to verify:

* Compare each command’s output against the baseline truth you created.

What to look for:

* First command:  
  * if `c_repo_running` appears, it matched repo name, not tag only  
  * if `buildkit_named` appears, it matched container name, not image tag  
* Second command:  
  * if it returns nothing despite `c_tag_running` existing, it did not achieve the stated goal  
* Third command:  
  * if `buildkit_named` appears, it is not tag-only  
  * if `c_tag_running` appears even though the tag is `buildkit-alpha`, it is not exact-match

That gives you a direct manual way to decide whether the global summary claim is accurate.

For convenience, here is the exact test sequence I recommend running in order:

docker version  
which grep awk cut xargs  
docker ps \-a \--format "table {{.ID}}\\t{{.Image}}\\t{{.Names}}"  
docker ps \--format "table {{.ID}}\\t{{.Image}}\\t{{.Names}}" | grep \-i buildkit  
docker ps \-a \--format "table {{.ID}}\\t{{.Image}}\\t{{.Names}}" | grep \-i buildkit  
docker ps \-aq | xargs docker inspect \--format '{{.Id}} {{.Image}}' | grep \-i buildkit | cut \-d' ' \-f1  
docker inspect c\_tag\_running \--format '{{.Image}}'  
docker inspect c\_tag\_running \--format '{{.Config.Image}}'  
docker ps \--format "{{.ID}} {{.Image}} {{.Names}}" |  
  awk \-F':' '{if ($2 \~ /buildkit/) print $0}'

When you finish, send me the exact outputs and I’ll help you classify each claim as supported, disputed, or false.

