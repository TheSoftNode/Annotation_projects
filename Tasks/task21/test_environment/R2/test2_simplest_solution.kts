// R2 Simplest Solution: Use Kotlin's built-in uniform generator
val safeRandomFloat = kotlin.random.Random.nextFloat()          // → Float in [0.0, 1.0)

println("Generated value: $safeRandomFloat")
println("Is finite: ${safeRandomFloat.isFinite()}")
println("Is NaN: ${safeRandomFloat.isNaN()}")
println("Is infinite: ${safeRandomFloat.isInfinite()}")

// Test multiple times to verify it always returns finite values
println("\nTesting 1000 iterations:")
var allFinite = true
repeat(1000) {
    val value = kotlin.random.Random.nextFloat()
    if (!value.isFinite()) {
        allFinite = false
        println("Non-finite value found: $value")
    }
}
println("All values finite: $allFinite")
