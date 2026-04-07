// R2 Problem Example: Unsafe expression that can become Infinity
val raw = (Math.random() * Float.MAX_VALUE).toFloat()   // can become Infinity

println("Generated value: $raw")
println("Is finite: ${raw.isFinite()}")
println("Is NaN: ${raw.isNaN()}")
println("Is infinite: ${raw.isInfinite()}")

// Test multiple times to see if we can get Infinity
println("\nTesting 100 iterations:")
var infinityCount = 0
var nanCount = 0
var finiteCount = 0

repeat(100) {
    val value = (Math.random() * Float.MAX_VALUE).toFloat()
    when {
        value.isInfinite() -> infinityCount++
        value.isNaN() -> nanCount++
        value.isFinite() -> finiteCount++
    }
}

println("Finite: $finiteCount, Infinity: $infinityCount, NaN: $nanCount")
