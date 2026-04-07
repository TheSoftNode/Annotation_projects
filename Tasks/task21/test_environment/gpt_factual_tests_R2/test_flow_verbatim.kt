val safeRandomFloat = generateRandomFloat()
    .filter { !it.isNaN() && !it.isInfinite() }
    .firstOrNull() ?: 0f        // fallback (or throw, depending on your needs)

private fun generateRandomFloat(): Flow<Float> = flow {
    while (true) {
        // Re-use the original (potentially unsafe) generator here
        val candidate = (Math.random() * Float.MAX_VALUE).toFloat()
        emit(candidate)            // could be NaN/Infinity
    }
}
