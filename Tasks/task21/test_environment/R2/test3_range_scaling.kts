// R2 Range Scaling: random Float in [min, max) where min < max
val min = 2.5f
val max = 7.3f
val safeRandomFloatInRange = min + (max - min) * kotlin.random.Random.nextFloat()

println("Generated value in range [$min, $max): $safeRandomFloatInRange")
println("Is finite: ${safeRandomFloatInRange.isFinite()}")
println("Is in range: ${safeRandomFloatInRange >= min && safeRandomFloatInRange < max}")

// Test multiple times
println("\nTesting 100 iterations:")
var allInRange = true
var allFinite = true
repeat(100) {
    val value = min + (max - min) * kotlin.random.Random.nextFloat()
    if (!value.isFinite()) {
        allFinite = false
    }
    if (value < min || value >= max) {
        allInRange = false
        println("Out of range value: $value")
    }
}
println("All values finite: $allFinite")
println("All values in range: $allInRange")
