// R1 Example: Unsafe expression that could produce inf/NaN
val randomFiniteFloat = generateSequence {
    // Example unsafe expression: could produce inf/NaN
    (1.0 / (kotlin.random.Random.nextFloat() - 0.5)).toFloat()
}.first { it.isFinite() }

println("Generated value: $randomFiniteFloat")
println("Is finite: ${randomFiniteFloat.isFinite()}")
println("Is NaN: ${randomFiniteFloat.isNaN()}")
println("Is infinite: ${randomFiniteFloat.isInfinite()}")
