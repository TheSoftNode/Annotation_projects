Use **GitHub Codespaces** for this one. It is the fairest way to test Response 1 because it gives you a clean, disposable environment for Node \+ TypeScript CLI behavior. Your Mac is also fine, but Codespaces is better if you want fewer local-environment variables.

Before testing anything, make sure you have:  
`node`  
`npm`  
`typescript`

For a clean test project in Codespaces:

mkdir ts1343-check

cd ts1343-check

npm init \-y

npm i \-D typescript@latest

npx tsc \-v

Keep the `npx tsc -v` output. It matters because some claims are version-sensitive.

Now the claim-by-claim breakdown.

---

1. Claim: "❌ **`// @ts-ignore`** and **`// @ts-expect-error`** **do NOT work** on **`import.meta`** errors like **`TS1343`**."

Breakdown: this claims both comment directives fail to suppress TS1343.

Primary source check: TypeScript’s official docs say `// @ts-ignore` “suppresses all errors that originate on the following line,” and the 3.9 release notes say `// @ts-expect-error` acts as a suppression comment similar to `// @ts-ignore`. That directly cuts against the claim as written. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html))

How to test manually:

cat \> tsconfig.json \<\<'EOF'

{

  "compilerOptions": {

    "module": "commonjs",

    "target": "es2020"

  }

}

EOF

cat \> test.ts \<\<'EOF'

// @ts-ignore

console.log(import.meta.url)

EOF

npx tsc \--noEmit

Then test the other directive:

cat \> test.ts \<\<'EOF'

// @ts-expect-error

console.log(import.meta.url)

EOF

npx tsc \--noEmit

Expected result if the claim is true: you should still get `TS1343` in both runs.

A result that disputes the claim: no `TS1343` appears.

Status: **disputed by the primary docs**. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html))

---

2. Claim: "`@ts-ignore` and `@ts-expect-error` only suppress type-checking errors"

Breakdown: this is a stronger claim than the docs. It says the directives are limited to type-checking errors only.

Primary source check: the official `@ts-ignore` docs do **not** say “type-checking errors only”; they say it “suppresses all errors that originate on the following line.” The 3.9 notes also describe `@ts-expect-error` as a suppression comment similar to `@ts-ignore`. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html))

How to test manually: reuse the exact tests from Claim 1\.

Expected result if the claim is true: TS1343 should not be suppressible by either directive.

A result that disputes the claim: TS1343 is suppressed.

Status: **disputed by the primary docs**. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html))

---

3. Claim: "`TS1343` is a **compile-time module system validation error**, not a **type-checking** error."

Breakdown: this claims a specific internal classification for TS1343.

Primary source check: I did **not** find an official TypeScript doc that classifies TS1343 with this exact wording. The docs I found describe what `@ts-ignore` suppresses and which `module` settings support `import.meta`, but they do not label TS1343 as “not a type-checking error” in the precise way Response 1 does. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html))

How to test manually:

cat \> tsconfig.json \<\<'EOF'

{

  "compilerOptions": {

    "module": "commonjs",

    "target": "es2020"

  }

}

EOF

cat \> test.ts \<\<'EOF'

console.log(import.meta.url)

EOF

npx tsc \--noEmit

npx tsc \--noEmit \--noCheck

Expected result if the claim is true in the strongest sense: you would expect the error to survive even when type checking is skipped.

A result that weakens the claim: the error disappears under `--noCheck`, or is suppressible with `@ts-ignore`.

Status: **not directly supported by the primary docs I checked**. You should treat this one as needing manual confirmation.

---

4. Claim: "`TS1343` is a **syntactic/module system validation error** — it’s thrown by the TypeScript compiler *before* type-checking even begins."

Breakdown: this is even stronger than Claim 3 because it asserts the phase in which the error occurs.

Primary source check: I did **not** find an official doc saying TS1343 is emitted “before type-checking even begins.” The official docs I checked do not make that parser-vs-checker distinction here. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html))

How to test manually: use the exact same `--noCheck` comparison from Claim 3\.

Expected result if the claim is true: `TS1343` should still appear with `--noCheck`.

A result that weakens the claim: `TS1343` disappears with `--noCheck`.

Status: **unsupported by the primary docs I found**.

---

5. Claim: "It’s essentially a **configuration error**, not a **code error**."

Breakdown: this is partly factual and partly characterization.

Primary source check: the docs do support that `import.meta` depends on the `module` setting, and the `module` docs say `es2020` adds support for `import.meta`, while `system` also has dedicated `import.meta` support. But the docs do not frame it as a strict “configuration error vs code error” binary. ([TypeScript](https://www.typescriptlang.org/docs/handbook/modules/reference.html))

How to test manually:

cat \> tsconfig.json \<\<'EOF'

{

  "compilerOptions": {

    "module": "commonjs",

    "target": "es2020"

  }

}

EOF

cat \> test.ts \<\<'EOF'

console.log(import.meta.url)

EOF

npx tsc \--noEmit

Then change only the `module` value:

cat \> tsconfig.json \<\<'EOF'

{

  "compilerOptions": {

    "module": "es2020",

    "target": "es2020"

  }

}

EOF

npx tsc \--noEmit

Expected result if the characterization is directionally right: changing `module` alone removes TS1343.

Status: **directionally supported**, but the wording is interpretive rather than a precise documented fact. ([TypeScript](https://www.typescriptlang.org/docs/handbook/modules/reference.html))

---

6. Claim: "you must ensure your `tsconfig.json` has one of these module settings: `es2020`, `es2022`, `esnext`, `system`, `node16`, `nodenext`."

Breakdown: this claims that this is the full allowed set.

Primary source check: current official docs say `es2020` adds support for `import.meta`, `es2022` builds on that, `system` has dedicated `import.meta` support, and the current module docs also document `node18` as a valid module mode. In current TypeScript docs, `node16`, `node18`, and `nodenext` are all documented, and `node18` was added in TypeScript 5.8. ([TypeScript](https://www.typescriptlang.org/docs/handbook/modules/reference.html))

How to test manually:

cat \> test.ts \<\<'EOF'

console.log(import.meta.url)

EOF

Try these one by one:

cat \> tsconfig.json \<\<'EOF'

{ "compilerOptions": { "module": "commonjs", "target": "es2020" } }

EOF

npx tsc \--noEmit

cat \> tsconfig.json \<\<'EOF'

{ "compilerOptions": { "module": "es2020", "target": "es2020" } }

EOF

npx tsc \--noEmit

cat \> tsconfig.json \<\<'EOF'

{ "compilerOptions": { "module": "node16", "target": "es2020" } }

EOF

npx tsc \--noEmit

cat \> tsconfig.json \<\<'EOF'

{ "compilerOptions": { "module": "node18", "target": "es2020" } }

EOF

npx tsc \--noEmit

Expected result if Response 1’s list is complete: `node18` would not work or would be irrelevant.

A result that disputes the claim: `node18` also works in your TypeScript version.

Status: **incomplete / disputed as written**, because the list omits `node18` in current TypeScript docs. ([TypeScript](https://www.typescriptlang.org/docs/handbook/modules/reference.html))

---

7. Claim: "If you’re seeing `TS1343`, then your effective `module` setting is NOT one of these — even if you *think* it is."

Breakdown: this says the effective compiler config is the deciding factor.

Primary source check: the docs support the general idea that the effective config matters. `tsc --showConfig` prints the final config, and `extends` means one config can override another. The docs also say `tsc` searches for `tsconfig.json` starting in the current directory and then up the parent chain. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-2.html))

How to test manually:

npx tsc \--showConfig

Expected result if the claim is right: the effective `module` value you see there should match the behavior you get.

Status: **generally supported**, but only after you confirm the actual project and actual invoked config. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-2.html))

---

8. Claim: "Run this command from the directory where `flight.service.ts` lives: `npx tsc --showConfig --verbose | grep -i '"module"'`"

Breakdown: this claims the command itself is a valid way to inspect the merged config.

Primary source check: official CLI docs list `--showConfig` as a general CLI option, while `--verbose` is listed under **Build Options**, not general CLI commands. That does **not** support the command exactly as written for normal `tsc` usage. ([TypeScript](https://www.typescriptlang.org/docs/handbook/compiler-options.html))

How to test manually, exactly as written:

npx tsc \--showConfig \--verbose | grep \-i '"module"'

Expected result if the claim is true: a line like `"module": "es2022"` should print.

A result that disputes the claim: an error about `--verbose` only being usable with `--build`.

Status: **disputed / very likely wrong as written** based on the official CLI docs. ([TypeScript](https://www.typescriptlang.org/docs/handbook/compiler-options.html))

---

9. Claim: "This means **a different `tsconfig.json`** (perhaps in a parent folder, or a `tsconfig.json` inside `libs/common/src/`) is overriding your root config."

Breakdown: this says a conflicting `tsconfig.json` is the cause.

Primary source check: the docs support two relevant facts: `tsc` searches upward for a `tsconfig.json` when invoked without input files, and `extends` allows configs to override inherited values. But the docs do **not** say that any random nearby `tsconfig.json` automatically “merges” with your root config. That only happens through the actual project selection and/or `extends`. ([TypeScript](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html))

How to test manually:

find . \-name "tsconfig.json" \-type f

Then inspect each one for `extends` and `module`:

grep \-R "\\"extends\\"" .

grep \-R "\\"module\\"" .

Then run from the exact directory/tool context that produces the error:

npx tsc \--showConfig

Expected result if the claim is right: the effective config shown by `--showConfig` will come from a different config than you expected, or an `extends` chain will override it.

Status: **partly supported, but overstated as written**. ([TypeScript](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html))

---

10. Claim: "In the conflicting `tsconfig.json`, make it extend your root one: ... This ensures it inherits `"module": "es2022"`."

Breakdown: this says `extends` will inherit the base config’s values unless overridden.

Primary source check: that is supported. The official `extends` docs say the base config is loaded first and then overridden by the inheriting config. ([TypeScript](https://www.typescriptlang.org/tsconfig/extends.html))

How to test manually:

Create a root config:

mkdir \-p child

cat \> tsconfig.json \<\<'EOF'

{

  "compilerOptions": {

    "module": "es2022"

  }

}

EOF

Create a child config that extends it:

cat \> child/tsconfig.json \<\<'EOF'

{

  "extends": "../tsconfig.json"

}

EOF

Check the effective child config:

cd child

npx tsc \--showConfig

Expected result if the claim is true: the printed config includes `"module": "es2022"`.

Status: **supported**. ([TypeScript](https://www.typescriptlang.org/tsconfig/extends.html))

---

11. Claim: "After fixing, re-run: `npx tsc --showConfig --verbose | grep -i '"module"'` ... You must see `"module": "es2022"`."

Breakdown: this contains two claims: the command works, and `es2022` is the one required result.

Primary source check: the command issue is already disputed in Claim 8\. Also, the official docs do **not** say the module value must specifically be `es2022`; `es2020`, `es2022`, `esnext`, `system`, and the Node ESM modes are all documented relevant module settings for `import.meta`. ([TypeScript](https://www.typescriptlang.org/docs/handbook/compiler-options.html))

How to test manually:

Use the supported command instead:

npx tsc \--showConfig

Then look for `"module"` in the output.

Expected result if the “must be es2022” part is true: only `es2022` should be acceptable.

A result that disputes it: `es2020`, `system`, `node16`, `node18`, or `nodenext` also eliminate TS1343.

Status: **disputed as an absolute “must”**. ([TypeScript](https://www.typescriptlang.org/docs/handbook/modules/reference.html))

---

12. Claim: "✅ TypeScript version ≥ 4.7"

Breakdown: this implies 4.7 is the key threshold.

Primary source check: `import.meta` support itself dates back to TypeScript 2.9. TypeScript 4.7 is specifically when `node16` and `nodenext` module modes were added. TypeScript 5.8 added `node18`. So `≥ 4.7` is relevant to some module-mode choices, but it is not the universal threshold for all `import.meta` support. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-9.html))

How to test manually:

npx tsc \-v

Expected result if the claim is meant narrowly for `node16`/`nodenext`: versions older than 4.7 should not recognize those module modes.

Status: **partly supported, but too broad as written**. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-9.html))

---

13. Claim: "❌ Do NOT rely on `@ts-ignore` or `@ts-expect-error` | ✅ Avoid them — they won’t work here"

Breakdown: same factual core as Claim 1, repeated in the checklist.

Primary source check: official docs again cut against this. `@ts-ignore` suppresses all errors on the following line, and `@ts-expect-error` works as a suppression comment in the same general way. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html))

How to test manually: reuse the exact tests from Claim 1\.

Status: **disputed**. ([TypeScript](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html))

---

14. Claim: "✅ Your root `tsconfig.json` has `"module": "es2022"`"

Breakdown: this is not something I need the web for; it is directly supported by the config you pasted in the conversation.

How to verify manually in your repo:

grep \-n '"module"' tsconfig.json

Expected result: it should show `"module": "es2022"` in the root config you pasted.

Status: **supported by the text you provided**.

---

What I would test first, in order:

1. `npx tsc -v`  
2. the exact `@ts-ignore` test from Claim 1  
3. the exact `@ts-expect-error` test from Claim 1  
4. the exact `npx tsc --showConfig --verbose | grep -i '"module"'` command from Claim 8  
5. `npx tsc --showConfig`  
6. `find . -name "tsconfig.json" -type f`

When you send me the outputs, include:  
the output of `npx tsc -v`  
whether Claim 1’s two tests produced TS1343 or not  
the exact output of the `--showConfig --verbose` command  
the exact output of plain `npx tsc --showConfig`

