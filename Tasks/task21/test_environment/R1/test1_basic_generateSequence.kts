// R1 Main Solution: Basic generateSequence with Random.nextFloat()
val randomFiniteFloat = generateSequence { kotlin.random.Random.nextFloat() }
    .first { it.isFinite() }

println("Generated value: $randomFiniteFloat")
println("Is finite: ${randomFiniteFloat.isFinite()}")
println("Is NaN: ${randomFiniteFloat.isNaN()}")
println("Is infinite: ${randomFiniteFloat.isInfinite()}")
