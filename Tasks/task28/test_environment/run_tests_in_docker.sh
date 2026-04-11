#!/bin/bash
# Run all Task 28 tests inside Docker container with systemd

echo "==========================================================================="
echo "Task 28 - Running Tests in Docker Container (with systemd)"
echo "==========================================================================="
echo ""

# Step 1: Build and start container
echo "Step 1: Building Docker image with systemd..."
docker-compose build

if [ $? -ne 0 ]; then
    echo "✗ Docker build failed"
    exit 1
fi

echo ""
echo "✓ Docker image built successfully"
echo ""

echo "Step 2: Starting container with systemd as PID 1..."
docker-compose up -d

if [ $? -ne 0 ]; then
    echo "✗ Failed to start container"
    exit 1
fi

echo ""
echo "✓ Container started"
echo ""

# Step 3: Wait for systemd to initialize
echo "Step 3: Waiting for systemd to initialize..."
sleep 5

# Verify systemd is running
echo "Verifying systemd is PID 1..."
docker exec task28_systemd_tests ps -p 1 -o comm=

echo ""

# Step 4: Run the tests
echo "Step 4: Running all GPT tests inside container..."
echo ""

docker exec task28_systemd_tests bash -c "cd /task28_tests && ./run_all_GPT_tests_with_output.sh"

TEST_EXIT=$?

echo ""
echo "==========================================================================="
echo ""

if [ $TEST_EXIT -eq 0 ]; then
    echo "✓ All tests completed"
else
    echo "⚠ Tests completed with exit code $TEST_EXIT"
fi

echo ""
echo "Step 5: Output files are in ./outputs/ (mounted from container)"
echo ""

echo "Listing output files:"
find outputs/ -name "*.txt" 2>/dev/null | sort

echo ""
echo "==========================================================================="
echo ""
echo "Container is still running. To:"
echo "  • View logs: docker logs task28_systemd_tests"
echo "  • Enter container: docker exec -it task28_systemd_tests bash"
echo "  • Stop container: docker-compose down"
echo ""
