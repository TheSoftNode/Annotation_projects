fun main() {
    val min = -Float.MAX_VALUE
    val max = Float.MAX_VALUE
    println("max - min = ${max - min}")
    repeat(20) {
        val safeRandomFloatInRange = min + (max - min) * kotlin.random.Random.nextFloat()
        println("$safeRandomFloatInRange | finite=${safeRandomFloatInRange.isFinite()}")
    }
}
