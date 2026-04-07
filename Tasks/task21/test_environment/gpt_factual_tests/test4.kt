fun main() {
    val randomFiniteFloat = generateSequence { Float.NaN }
        .first { it.isFinite() }

    println(randomFiniteFloat)
}
