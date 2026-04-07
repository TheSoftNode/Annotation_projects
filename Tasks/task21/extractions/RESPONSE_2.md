### **The problem**

You already have something that *looks* like a "random Float", e.g.

val raw = (Math.random() * Float.MAX_VALUE).toFloat()   // can become Infinity

`Math.random()` returns a `Double` in `[0.0, 1.0)`. When you multiply that by `Float.MAX_VALUE` the intermediate `Double` can exceed the range that a `Float` can represent, and the conversion can produce `Infinity` (or even `NaN` in edge cases).
So the expression you have may occasionally give you a **non‑finite** value.

### **Goal**

Create an expression that produces a random `Float` **but guarantees that the result is finite** (i.e. it is neither `NaN` nor `Infinity`).

### **The simplest solution – use Kotlin's built‑in uniform generator**

Kotlin's standard‑library random utilities (`kotlin.random.Random`) already generate *finite* `Float`s only. The easiest way to get a random `Float` that is guaranteed to be valid is:

val safeRandomFloat = kotlin.random.Random.nextFloat()          // → Float in [0.0, 1.0)

* `Random.nextFloat()` always returns a **finite** value in the half‑open interval `[0.0f, 1.0f)`.
* No extra filtering, no loops – it's a single, safe expression.

If you need a `Float` in a different range, just scale and shift it:

// Example: random Float in [min, max) where min < max

val min = 2.5f

val max = 7.3f

val safeRandomFloatInRange = min + (max - min) * kotlin.random.Random.nextFloat()

Because the base `nextFloat()` is already finite, the derived value will be finite as long as `min` and `max` are finite (which they usually are).

---

### **If you *must* keep the original generator**

Suppose you are stuck with a generator that might produce non‑finite values (e.g. the `Math.random() * Float.MAX_VALUE` approach). You can **filter** the results until you get a finite one:

val safeRandomFloat = generateRandomFloat()

    .filter { !it.isNaN() && !it.isInfinite() }

    .firstOrNull() ?: 0f        // fallback (or throw, depending on your needs)

private fun generateRandomFloat(): Flow<Float> = flow {

    while (true) {

        // Re‑use the original (potentially unsafe) generator here

        val candidate = (Math.random() * Float.MAX_VALUE).toFloat()

        emit(candidate)            // could be NaN/Infinity

    }

}

But **you really don't want to do this**. It's wasteful (you may loop forever if the underlying generator is pathological) and obscures intent. Using `kotlin.random.Random.nextFloat()` sidesteps the whole issue.

---

### **One‑liner "filter‑and‑retry" expression (if you really need it)**

If you *already have* a `Float` value (e.g. coming from some function) and you want to replace any non‑finite value with a fresh random float, you can write a concise expression using standard library helpers:

val safeFloat = generateRandomFiniteFloat {

    (Math.random() * Float.MAX_VALUE).toFloat()   // ← your original expression

}

// Helper that keeps generating until a finite Float appears

fun generateRandomFiniteFloat(seedGenerator: () -> Float): Float =

    seedGenerator().let { f ->

        if (f.isNaN() || f.isInfinite()) generateRandomFiniteFloat(seedGenerator)

        else f

    }

This is essentially a recursive tail‑recursive loop that guarantees finiteness, but again – **prefer the built‑in `Random.nextFloat()`** unless you have an external source you can't replace.

---

### **TL;DR – the one‑liner you can copy‑paste**

val safeRandomFloat = kotlin.random.Random.nextFloat()

That's it. It produces a random `Float` uniformly distributed over `[0f, 1f)` **and never yields `NaN` or `Infinity`**. If you need a different range, just add linear scaling as shown above.
