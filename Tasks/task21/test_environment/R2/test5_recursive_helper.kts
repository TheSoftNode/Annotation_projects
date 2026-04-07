// R2 Recursive Helper: One-liner "filter-and-retry" expression
fun generateRandomFiniteFloat(seedGenerator: () -> Float): Float =
    seedGenerator().let { f ->
        if (f.isNaN() || f.isInfinite()) generateRandomFiniteFloat(seedGenerator)
        else f
    }

val safeFloat = generateRandomFiniteFloat {
    (Math.random() * Float.MAX_VALUE).toFloat()   // ← your original expression
}

println("Generated value: $safeFloat")
println("Is finite: ${safeFloat.isFinite()}")
println("Is NaN: ${safeFloat.isNaN()}")
println("Is infinite: ${safeFloat.isInfinite()}")
