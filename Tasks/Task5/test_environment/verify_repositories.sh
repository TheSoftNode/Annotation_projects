#!/bin/bash

# Script to verify repository URLs mentioned in responses

echo "======================================"
echo "Repository URL Verification"
echo "======================================"
echo ""

# Function to check if GitHub repository exists
check_repo() {
    local repo_url="$1"
    local response_name="$2"

    echo "Checking: $repo_url ($response_name)"

    # Extract repo path from URL
    repo_path=$(echo "$repo_url" | sed 's|https://github.com/||' | sed 's|\.git||')
    api_url="https://api.github.com/repos/$repo_path"

    # Check using GitHub API
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "$api_url")

    if [ "$status_code" -eq 200 ]; then
        echo "✅ EXISTS - HTTP $status_code"
    elif [ "$status_code" -eq 404 ]; then
        echo "❌ DOES NOT EXIST - HTTP $status_code"
    else
        echo "⚠️  UNKNOWN - HTTP $status_code"
    fi
    echo ""
}

echo "=== Response 1 Repositories ==="
echo ""
check_repo "https://github.com/mossmann/hackrf.git" "Response 1 - HackRF Driver"
check_repo "https://github.com/mossmann/pyhackrf.git" "Response 1 - PyHackRF"

echo "=== Response 2 Repositories ==="
echo ""
check_repo "https://github.com/atech/pyhackrf.git" "Response 2 - PyHackRF"

echo "=== Correct Repositories (for reference) ==="
echo ""
check_repo "https://github.com/greatscottgadgets/hackrf.git" "HackRF Driver (official)"
check_repo "https://github.com/dressel/pyhackrf.git" "PyHackRF (PyPI official)"
check_repo "https://github.com/GvozdevLeonid/python_hackrf.git" "python-hackrf (alternative)"

echo "======================================"
echo "Verification Complete"
echo "======================================"
