fun generateRandomFiniteFloat(seedGenerator: () -> Float): Float =
    seedGenerator().let { f ->
        if (f.isNaN() || f.isInfinite()) generateRandomFiniteFloat(seedGenerator)
        else f
    }

fun main() {
    println(generateRandomFiniteFloat { Float.POSITIVE_INFINITY })
}
