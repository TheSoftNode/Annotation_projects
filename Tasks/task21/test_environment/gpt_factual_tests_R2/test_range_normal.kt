fun main() {
    val min = 2.5f
    val max = 7.3f
    repeat(100000) {
        val safeRandomFloatInRange = min + (max - min) * kotlin.random.Random.nextFloat()
        if (!safeRandomFloatInRange.isFinite()) {
            println("NON_FINITE at iteration $it: $safeRandomFloatInRange")
            return
        }
        if (safeRandomFloatInRange < min || safeRandomFloatInRange >= max) {
            println("OUT_OF_RANGE at iteration $it: $safeRandomFloatInRange")
            return
        }
    }
    println("All sampled values were finite and in [min, max)")
}
