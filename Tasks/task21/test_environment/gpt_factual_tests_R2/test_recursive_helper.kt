fun generateRandomFiniteFloat(seedGenerator: () -> Float): Float =
    seedGenerator().let { f ->
        if (f.isNaN() || f.isInfinite()) generateRandomFiniteFloat(seedGenerator)
        else f
    }

fun main() {
    repeat(10) {
        val safeFloat = generateRandomFiniteFloat {
            (Math.random() * Float.MAX_VALUE).toFloat()
        }
        println("$safeFloat | finite=${safeFloat.isFinite()}")
    }
}
