In Kotlin, if you have an expression that produces random `Float` values and you want to exclude infinities (`Float.POSITIVE_INFINITY`, `Float.NEGATIVE_INFINITY`) and `NaN`, you can use a loop or a sequence to keep generating values until a valid one (a finite number) is produced.

Here's a concise expression using `generateSequence` to achieve this:

val randomFiniteFloat = generateSequence { kotlin.random.Random.nextFloat() }

    .first { it.isFinite() }

### **Explanation:**

* `kotlin.random.Random.nextFloat()` generates a random `Float` in the range `[0.0, 1.0)`, but note that in theory, floating-point operations could produce `NaN` or infinity under certain conditions (though `nextFloat()` itself won't — it's guaranteed to return finite values).
* However, if your **original expression** might produce `NaN` or infinities (e.g., due to arithmetic), then wrapping it like this ensures safety.

### **Generic version for any expression:**

If your expression is something like `someComputation().toFloat()`, you can adapt it:

val randomFiniteFloat = generateSequence { yourRandomExpression() }

    .first { it.isFinite() }

Where `yourRandomExpression()` returns a `Float` that might be `NaN` or infinite.

### **Example:**

val randomFiniteFloat = generateSequence {

    // Example unsafe expression: could produce inf/NaN

    (1.0 / (kotlin.random.Random.nextFloat() - 0.5)).toFloat()

}.first { it.isFinite() }

This will keep trying until a finite value is generated.

✅ Note: `Float.isFinite()` returns `true` only for non-infinite and non-NaN values.
