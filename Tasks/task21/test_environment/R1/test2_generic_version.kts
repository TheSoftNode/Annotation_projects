// R1 Generic Version: Wrapping any expression
fun yourRandomExpression(): Float {
    // Simulating an expression that might produce NaN or infinite
    return (1.0 / (kotlin.random.Random.nextFloat() - 0.5)).toFloat()
}

val randomFiniteFloat = generateSequence { yourRandomExpression() }
    .first { it.isFinite() }

println("Generated value: $randomFiniteFloat")
println("Is finite: ${randomFiniteFloat.isFinite()}")
