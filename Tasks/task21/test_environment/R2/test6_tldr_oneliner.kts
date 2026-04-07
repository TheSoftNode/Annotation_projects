// R2 TL;DR: The one-liner you can copy-paste
val safeRandomFloat = kotlin.random.Random.nextFloat()

println("Generated value: $safeRandomFloat")
println("Is finite: ${safeRandomFloat.isFinite()}")
println("Is NaN: ${safeRandomFloat.isNaN()}")
println("Is infinite: ${safeRandomFloat.isInfinite()}")
println("Is in range [0f, 1f): ${safeRandomFloat >= 0f && safeRandomFloat < 1f}")
