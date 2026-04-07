fun main() {
    repeat(1000000) {
        val raw = (Math.random() * Float.MAX_VALUE).toFloat()
        if (raw.isNaN() || raw.isInfinite()) {
            println("NON_FINITE at iteration $it: $raw")
            return
        }
    }
    println("No non-finite values seen in 1,000,000 samples")
}
