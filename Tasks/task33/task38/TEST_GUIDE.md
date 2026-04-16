# Task 38 Testing Guide

## Overview
Both responses are **blueprints/proposals**, not complete packages. Testing focuses on:
1. Verifying factual claims about existing tools/packages
2. Attempting to build with the code provided
3. Checking documentation claims

---

## R1: tiny-indexeddb-orm Testing

### What I Can Do Automatically:
- ✅ Check npm package sizes for Dexie
- ✅ Verify TypeScript documentation claims
- ✅ Check tool availability (rollup, jest, etc.)
- ✅ Verify deprecated package warnings

### What You Should Do:

#### Test 1: Create and test package.json
```bash
mkdir -p ~/Desktop/task38_r1_test
cd ~/Desktop/task38_r1_test
```

Create `package.json` with this exact content from Response 1:
```json
{
  "name": "tiny-indexeddb-orm",
  "version": "1.0.0",
  "description": "A tiny, type‑safe, migration‑aware ORM for IndexedDB",
  "main": "dist/cjs/index.js",
  "module": "dist/esm/index.js",
  "types": "dist/index.d.ts",
  "files": ["dist", "README.md", "LICENSE"],
  "scripts": {
    "clean": "rimraf dist",
    "build": "npm run clean && tsc && rollup -c",
    "test": "jest --coverage",
    "lint": "eslint src/**/*.ts",
    "prepare": "npm run build",
    "release": "semantic-release"
  },
  "peerDependencies": {
    "rxjs": "^7.0.0"
  },
  "devDependencies": {
    "@rollup/plugin-commonjs": "^25.0.0",
    "@rollup/plugin-node-resolve": "^15.0.0",
    "@rollup/plugin-typescript": "^11.0.0",
    "typescript": "^5.2.0",
    "rollup": "^4.0.0",
    "rollup-plugin-terser": "^7.0.0",
    "jest": "^29.0.0",
    "fake-indexeddb": "^4.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "semantic-release": "^22.0.0",
    "typedoc": "^0.25.0",
    "vitepress": "^1.0.0",
    "playwright": "^1.38.0"
  }
}
```

Then run:
```bash
npm install
```

**Expected:** Install will succeed but may show deprecation warning for `rollup-plugin-terser`

**Report back:**
- Did install succeed?
- Any deprecation warnings?
- Did `prepare` script try to run automatically?

---

## R2: debounce-promise Testing

### What I Can Do Automatically:
- ✅ Check if `debounce-promise` name is available on npm
- ✅ Verify lodash.debounce documentation
- ✅ Check p-debounce package claims
- ✅ Verify TypeScript/Jest compatibility claims

### What You Should Do:

#### Test 1: Check npm package availability
```bash
npm view debounce-promise name version
```

**Expected:** Package already exists (Response 2 claims it's available - this is FALSE)

**Report back:** What does npm return?

#### Test 2: Create and test the package
```bash
mkdir -p ~/Desktop/task38_r2_test
cd ~/Desktop/task38_r2_test
mkdir src
```

Create `src/index.ts` with the exact TypeScript code from Response 2 (lines 710-937 from RESPONSE_2.md)

Create `package.json`:
```json
{
  "name": "debounce-promise",
  "version": "1.0.0",
  "description": "Debounce async functions with proper Promise merging and ordering",
  "main": "dist/index.js",
  "module": "dist/index.mjs",
  "types": "dist/index.d.ts",
  "files": ["dist"],
  "scripts": {
    "build": "tsc",
    "test": "jest",
    "prepublishOnly": "npm run build && npm run test"
  },
  "keywords": ["debounce", "promise", "async", "throttle", "utility"],
  "author": "Your Name",
  "license": "MIT",
  "devDependencies": {
    "typescript": "^5",
    "jest": "^29",
    "@types/jest": "^29",
    "ts-jest": "^29"
  },
  "engines": {
    "node": ">=14"
  }
}
```

Then:
```bash
npm install
npm run build
```

**Expected:** Build will fail because no tsconfig.json provided

**Report back:**
- Did install succeed?
- What error did `npm run build` give?

---

## Summary of Key Claims to Verify

### R1 Claims:
1. ❌ RxJS is "optional peer dependency" - but package.json doesn't mark it optional
2. ❌ "rollup-plugin-terser" - this package is deprecated
3. ❓ "< 5 KB gzipped" - unverified bundle size claim
4. ❓ Package is "already structured" and "publishable" - FALSE, missing files

### R2 Claims:
1. ❌ "debounce-promise" name is "available on npm as of 2024" - FALSE, already taken
2. ❌ "Lodash doesn't handle async correctly" - overstated, Lodash doesn't claim to
3. ❌ "p-debounce doesn't handle ordering or merging well" - FALSE, it does handle merging
4. ❓ "Publishable now" - FALSE, incomplete build setup

---

## What to Test

Run the tests above and report back:
1. R1: npm install output and any warnings
2. R2: npm view output showing package exists
3. R2: npm run build error message

I'll handle the automated checks in parallel.
