fun main() {
    val randomFiniteFloat = generateSequence {
        // Example unsafe expression: could produce inf/NaN
        (1.0 / (kotlin.random.Random.nextFloat() - 0.5)).toFloat()
    }.first { it.isFinite() }

    println(randomFiniteFloat)
    println(randomFiniteFloat.isFinite())
    println(randomFiniteFloat.isNaN())
    println(randomFiniteFloat.isInfinite())
}
