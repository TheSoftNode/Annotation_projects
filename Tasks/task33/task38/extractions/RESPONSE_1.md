## **📦 Package Proposal – tiny‑indexeddb‑orm**

## **Short tagline** – *A tiny, zero‑dependency, type‑safe ORM for the browser's IndexedDB that ships migrations, reactive queries and full TypeScript support out of the box.*

## Below is a complete "expert‑programmer" blueprint that turns the idea from the pool (\#31) into a publish‑ready npm package that works for both JavaScript and TypeScript consumers.

## ---

### **1️⃣ Why this package?**

| Problem | Existing solutions | Gap we fill |
| ----- | ----- | ----- |
| Heavy‑weight libraries (Dexie, lovefield) ship dozens of kilobytes, many APIs you never use. | Dexie, lovefield, idb | A **tiny** (\< 5 KB gzipped) wrapper that feels like an ORM, **typed** and **migration‑aware**, with **zero run‑time dependencies**. |
| No first‑class TypeScript schema → migration pipeline. | Dexie's `Table` typings, but migrations are manual. | **Declarative schema**, automatic version bump, and safe migration scripts written in plain TS. |
| Hard to react to data changes. | Dexie Observable plugin (extra bundle), custom events. | Built‑in **reactive `watch` API** that emits `EventTarget` events (or RxJS‑compatible Observable if the user opts in). |
| Testing IndexedDB in Node is a pain. | `fake-indexeddb` works but is not part of the library. | **Bundled test harness** and **type‑only** test utilities so consumers can write fast Jest tests without pulling the whole library. |

## Result: a **tiny, opinionated, production‑ready** ORM that lives comfortably in a modern SPA or an Electron app.

## ---

### **2️⃣ High‑level Architecture**

## src/

##  ├─ core/                     \# Core IndexedDB wrapper (open DB, transactions)

##  ├─ schema/                   \# Schema definition \+ migration compiler

##  ├─ model/                    \# Model class (CRUD, query builder)

##  ├─ reactive/                 \# Watch/subscribe utilities (EventTarget \+ optional RxJS)

##  ├─ utils/                    \# Helpers (deep‑clone, type checks)

##  └─ index.ts                  \# Public re‑exports

##

## types/

##  └─ generated/                \# .d.ts files produced by tsc (re‑exported)

##

## test/

##  ├─ unit/                     \# Jest unit tests (uses fake-indexeddb)

##  └─ integration/              \# Real browser tests (via Playwright, optional)

##

## rollup.config.mjs            \# Bundle to ESM & CJS (with terser)

## tsconfig.json                \# TS → ES2020, declaration generation

## package.json                 \# npm metadata \+ scripts

##

## *All source files are **written in TypeScript** (`.ts`). The published package contains compiled JavaScript plus the generated declaration files, so both JS and TS consumers get full IntelliSense.*

## **Optional WASM optimisation** – a small Rust crate (`crate/fast-index`) can compile to WebAssembly and provide a high‑speed binary search for large primary‑key ranges. It is **lazy‑loaded** only when the user opts‑in via `enableWasm: true` in the config. This satisfies the "you may use a third language for part of the codebase" clause while keeping the vanilla path pure TS.

## ---

### **3️⃣ Public API (What the consumer sees)**

## // 1\. Define a schema \-------------------------------------------------

## import { defineSchema, Field, PrimaryKey, Index } from 'tiny-indexeddb-orm';

##

## export const MySchema \= defineSchema({

##   version: 2,

##   stores: {

##     users: {

##       key: PrimaryKey('id', 'number'),           // auto‑increment not needed

##       fields: {

##         name: Field('string'),

##         email: Field('string', { unique: true }),

##         createdAt: Field('date')

##       },

##       indexes: \[Index('email'), Index('createdAt')\]

##     },

##     posts: {

##       key: PrimaryKey('id', 'number'),

##       fields: {

##         authorId: Field('number'),

##         title: Field('string'),

##         body: Field('string'),

##         tags: Field('string\[\]')

##       },

##       indexes: \[Index('authorId'), Index('tags', { multiEntry: true })\]

##     }

##   },

##   // 2\. Migration scripts \---------------------------------------------

##   migrations: {

##     // version \=\> function(prevDb, newDb)

##     2: async ({ oldVersion, db }) \=\> {

##       // Add a new index to users

##       await db.createIndex('users', 'createdAt');

##     }

##   }

## });

##

## // 2\. Initialise the DB \-------------------------------------------------

## import { DB } from 'tiny-indexeddb-orm';

##

## const db \= new DB('my‑app', MySchema);

## await db.open();                     // runs migrations automatically

##

## // 3\. Use a model \-------------------------------------------------------

## const Users \= db.model('users');     // typed Model\<User\>

##

## await Users.insert({ id: 1, name: 'Ada', email: 'ada@a.io', createdAt: new Date() });

##

## const user \= await Users.findById(1);

## const all \= await Users.where('email').like('%@a.io').orderBy('createdAt').toArray();

##

## // 4\. Reactive watching \-------------------------------------------------

## const stop \= Users.watch((event) \=\> {

##   console.log('users changed', event);

## });

## // … later

## stop(); // unsubscribe

##

## // 5\. Optional WASM fast lookups \-----------------------------------------

## await db.enableWasm({ path: '/wasm/fast-index.wasm' });

##

## All methods return **native Promises**; the type system infers the record shape from the schema.

## ---

### **4️⃣ Core Implementation Details**

#### **4.1 Schema & Migration Compiler**

## *File: `src/schema/index.ts`*

1. ## **Schema DSL** – The `defineSchema` function receives a plain object; Typescript generic magic extracts field types.

2. ## **Version handling** – The `DB` class stores the current version (`indexedDB.open(name, version)`) and sequentially runs each migration function stored under `schema.migrations`.

3. ## **Migration runner** – Executes user code inside a temporary upgrade transaction, exposing a simplified API (`createStore`, `deleteStore`, `createIndex`, `deleteIndex`). Errors abort the upgrade, preserving atomicity.

#### **4.2 Core IndexedDB Wrapper**

## *File: `src/core/database.ts`*

* ## **`open()`** – Returns a promise that resolves with an `IDBDatabase`. Handles `onupgradeneeded` by delegating to the migration compiler.

* ## **Transaction manager** – `run<T>(storeName, mode, fn)` opens a transaction and auto‑commits/rolls back. Handles `onabort`/`onerror` and maps them to rejected promises.

* ## **Error mapping** – Converts `DOMException` codes to a typed `DBError` enum.

#### **4.3 Model & Query Builder**

## *File: `src/model/model.ts`*

* ## **CRUD** – `insert`, `update`, `delete`, `findById`. All use the transaction manager.

* ## **Query** – A lightweight builder that stores an array of filter objects (`{field, op, value}`) and executes them via a cursor request. Supports:

  * ## Equality, `<`, `>`, `<=`, `>=`, `IN`, `LIKE` (simple `%` wildcard)

  * ## Compound `AND`/`OR` (via chaining)

  * ## `orderBy`, `limit`, `offset`

* ## **Result mapping** – Deserialises `Date` fields automatically (detects schema type).

#### **4.4 Reactive Layer**

## *File: `src/reactive/watch.ts`*

* ## **EventTarget** – Each `Model` instance owns a hidden `EventTarget`. Whenever a CRUD operation runs, it dispatches an event `{type, payload}`.

* ## **`watch(callback)`** – Returns an `unsubscribe` function.

* ## **Optional RxJS** – If the consumer `import { asObservable } from 'tiny-indexeddb-orm/reactive'`, we expose `asObservable(model)` that returns an RxJS `Observable` built on top of the internal `EventTarget`. This dependency is *peer‑only*; the core bundle stays at 0 KB extra.

#### **4.5 WASM Fast Index (optional)**

## *Folder: `crate/fast-index`* – Rust code compiled with `wasm-pack`. Exposes a `binarySearch(sortedKeys: Uint32Array, target: number) -> i32`.

## *In JS* – `src/wasm/loader.ts` lazily fetches the `.wasm` file, instantiates it, and replaces the internal primary‑key lookup implementation. All of this is behind the `db.enableWasm()` public method.

## ---

### **5️⃣ Build & Publish Pipeline**

| Step | Tool | Reason |
| ----- | ----- | ----- |
| **Compile TS → JS (ES2020)** | `tsc` (no‑emit on errors) | Generates clean, readable JS and `.d.ts`. |
| **Bundle for ESM & CJS** | `rollup` with `@rollup/plugin-node-resolve`, `commonjs`, `typescript`, `terser` | Gives both `module` and `main` fields for npm consumers, tree‑shakable ESM, minified production bundle (\~ 3 KB gz). |
| **Generate `.d.ts`** | `tsc --emitDeclarationOnly` | Types are shipped alongside the bundle. |
| **Create source‑map** | `rollup --sourcemap` | Debuggable in browsers. |
| **Run tests** | `jest` (with `fake-indexeddb`) \+ `playwright` (optional real‑browser integration) | 100 % coverage on core logic, 80 % on browser APIs. |
| **Lint & format** | `eslint` \+ `prettier` | Enforce code quality. |
| **CI** | **GitHub Actions** – `node-version: [18, 20]` – run lint → test → build → npm publish (on tag) | Fully automated release process. |
| **Release** | `npm version` → `git push --tags` → **semantic-release** (optional) | Automated changelog and version bump. |
| **Docs** | `typedoc` \+ a small **VitePress** site (hosted on GitHub Pages) | API reference \+ quick‑start guides. |

## **`package.json` key fields**

## {

##   "name": "tiny-indexeddb-orm",

##   "version": "1.0.0",

##   "description": "A tiny, type‑safe, migration‑aware ORM for IndexedDB",

##   "main": "dist/cjs/index.js",

##   "module": "dist/esm/index.js",

##   "types": "dist/index.d.ts",

##   "files": \["dist", "README.md", "LICENSE"\],

##   "scripts": {

##     "clean": "rimraf dist",

##     "build": "npm run clean && tsc && rollup \-c",

##     "test": "jest \--coverage",

##     "lint": "eslint src/\*\*/\*.ts",

##     "prepare": "npm run build",

##     "release": "semantic-release"

##   },

##   "peerDependencies": {

##     "rxjs": "^7.0.0"

##   },

##   "devDependencies": {

##     "@rollup/plugin-commonjs": "^25.0.0",

##     "@rollup/plugin-node-resolve": "^15.0.0",

##     "@rollup/plugin-typescript": "^11.0.0",

##     "typescript": "^5.2.0",

##     "rollup": "^4.0.0",

##     "rollup-plugin-terser": "^7.0.0",

##     "jest": "^29.0.0",

##     "fake-indexeddb": "^4.0.0",

##     "eslint": "^8.0.0",

##     "prettier": "^3.0.0",

##     "semantic-release": "^22.0.0",

##     "typedoc": "^0.25.0",

##     "vitepress": "^1.0.0",

##     "playwright": "^1.38.0"

##   }

## }

##

## ---

### **6️⃣ Testing Strategy**

## **Unit tests (Jest \+ fake-indexeddb)**

## import { DB, defineSchema, PrimaryKey, Field } from '../src';

## import 'fake-indexeddb/auto';

##

## const TestSchema \= defineSchema({

##   version: 1,

##   stores: {

##     notes: {

##       key: PrimaryKey('id', 'number'),

##       fields: { title: Field('string'), body: Field('string'), created: Field('date') },

##       indexes: \[\]

##     }

##   }

## });

##

## test('insert → findById works', async () \=\> {

##   const db \= new DB('test-db', TestSchema);

##   await db.open();

##   const Notes \= db.model('notes');

##   await Notes.insert({ id: 1, title: 'Hello', body: 'World', created: new Date() });

##   const note \= await Notes.findById(1);

##   expect(note?.title).toBe('Hello');

## });

##

## **Integration tests (Playwright)** – Run a headless Chromium instance, open a page that loads the packaged bundle, then verify that `indexedDB` actually persists across page reloads.

## **Coverage** – Target **≥ 95 %** on the core folder (`core`, `model`, `schema`), lower on the optional WASM glue (which is exercised indirectly).

## ---

### **7️⃣ Publishing Checklist**

1. ## **Run `npm pack` locally** – inspect the tarball (`dist/`, `README.md`, `LICENSE`).

2. ## **Validate bundle size** – `gzip-size dist/esm/index.js` \< 5 KB.

3. ## **Check types** – `tsc --noEmit` on a fresh consumer project that imports the package.

4. ## **Run `npm audit`** – make sure no vulnerabilities.

5. ## **Tag a release** – `npm version minor -m "chore(release): %s"` → push tag → CI triggers `semantic-release` → publishes to npm.

## ---

### **8️⃣ Future Roadmap (optional, not required for first release)**

| v1.1 | v2.0 |
| ----- | ----- |
| **Batch operations** (`bulkInsert`, `bulkDelete`) | **Full‑text search** via WebAssembly‑based Lunr |
| **Relation helpers** (`hasMany`, `belongsTo`) | **Server‑sync adapters** (e.g., sync with a remote GraphQL endpoint) |
| **Typed `watch` options** (filter by mutation type) | **Plug‑in system** for custom serializers (e.g., `crypto-js` encrypt fields) |
| **Better multi‑tab coordination** (BroadcastChannel) | **CLI scaffolding** (`npx tiny-indexeddb-orm init`) |

## ---

## **🎉 TL;DR – What you get**

* ## **Package name:** `tiny-indexeddb-orm`

* ## **Language:** 100 % TypeScript (core) \+ optional Rust → WASM for fast index lookups.

* ## **Publishable on npm:** Yes – already structured with `package.json`, `dist/`, and generated `.d.ts`.

* ## **Ready for both JavaScript & TypeScript:** Consumers import the compiled JS; TS users benefit from the generated typings automatically.

* ## **Zero runtime dependencies** (except an optional peer dependency on RxJS).

## You now have a concrete, production‑grade plan that satisfies every constraint:

* ## **Idea comes from the given pool** (tiny‑indexeddb‑orm).

* ## **Targets JS & TS** – the public API works in plain JS, typings give full type safety.

* ## **Implemented with JavaScript/TypeScript** (and optional Rust → WASM).

* ## **Fully publishable on npm** – complete build, test, CI, and packaging workflow.

## Happy coding, and may your `npm publish` be swift and your bundle tiny\! 🚀
