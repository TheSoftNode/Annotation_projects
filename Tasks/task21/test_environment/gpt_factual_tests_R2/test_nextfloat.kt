fun main() {
    repeat(1000000) {
        val safeRandomFloat = kotlin.random.Random.nextFloat()
        if (!safeRandomFloat.isFinite()) {
            println("NON_FINITE at iteration $it: $safeRandomFloat")
            return
        }
        if (safeRandomFloat < 0.0f || safeRandomFloat >= 1.0f) {
            println("OUT_OF_RANGE at iteration $it: $safeRandomFloat")
            return
        }
    }
    println("All sampled values were finite and in [0.0f, 1.0f)")
}
