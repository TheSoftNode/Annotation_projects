// R2 Flow Filter Approach: Filter results until getting a finite one
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.runBlocking

fun generateRandomFloat(): Flow<Float> = flow {
    while (true) {
        // Re-use the original (potentially unsafe) generator here
        val candidate = (Math.random() * Float.MAX_VALUE).toFloat()
        emit(candidate)            // could be NaN/Infinity
    }
}

val safeRandomFloat = runBlocking {
    generateRandomFloat()
        .filter { !it.isNaN() && !it.isInfinite() }
        .firstOrNull() ?: 0f        // fallback (or throw, depending on your needs)
}

println("Generated value: $safeRandomFloat")
println("Is finite: ${safeRandomFloat.isFinite()}")
