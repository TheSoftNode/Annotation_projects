Use your **Mac Terminal** with Docker for this test. Docker provides the official Kotlin image which includes the Kotlin compiler and runtime.

Before testing the responses, make sure:

* Docker Desktop is installed and running on your Mac
* `docker` works: run `docker version`

You do **not** need to install Kotlin locally - we'll use Docker to run Kotlin code.

### Test Environment Setup

We'll use the official Kotlin Docker image to compile and run test programs that verify the claims in both responses.

Pull the Kotlin Docker image (Zenika's community-maintained image):

```bash
docker pull zenika/kotlin:latest
```

Verify Kotlin works in Docker:

```bash
docker run --rm zenika/kotlin:latest kotlinc -version
```

### Running Kotlin Code

To test Kotlin expressions, we'll create `.kt` files and run them using Docker:

```bash
# Compile and run a Kotlin script file
docker run --rm -v $(pwd):/app -w /app zenika/kotlin:latest kotlinc -script test.kts
```

Or for direct Kotlin REPL testing:

```bash
docker run -it --rm zenika/kotlin:latest kotlinc
```

### Test Files Location

All test Kotlin files should be placed in:
`/Users/apple/Desktop/Applyloop-project3/Tasks/task21/test_environment/`

We will create test scripts that verify:
1. Whether `Random.nextFloat()` produces finite values only
2. Whether `generateSequence` with `isFinite()` filters correctly
3. Behavior with expressions that can produce NaN/Infinity
4. Performance and complexity comparisons
