fun main() {
    val randomFiniteFloat = generateSequence { kotlin.random.Random.nextFloat() }
        .first { it.isFinite() }

    println(randomFiniteFloat)
    println(randomFiniteFloat.isFinite())
    println(randomFiniteFloat >= 0.0f)
    println(randomFiniteFloat < 1.0f)
}
