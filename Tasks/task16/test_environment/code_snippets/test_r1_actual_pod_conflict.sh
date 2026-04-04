#!/bin/bash

echo "=========================================="
echo "Response 1 - ACTUAL CocoaPods Conflict Test"
echo "Attempting to install with conflicting versions"
echo "=========================================="
echo ""

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "❌ CocoaPods is not installed."
    echo "This test requires CocoaPods to demonstrate the actual conflict."
    echo "Install with: sudo gem install cocoapods"
    exit 1
fi

echo "✅ CocoaPods is installed: $(pod --version)"
echo ""

# Create a temporary test directory
TEST_DIR="/tmp/r1_firebase_downgrade_test"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Creating test Podfile with Response 1's downgrade code..."
echo ""

cat > Podfile << 'EOF'
platform :ios, '11.0'

target 'TestApp' do
  # Response 1's verbatim downgrade suggestion:
  pod 'Firebase/Auth', '~> 10.25.0'
  pod 'Firebase/Firestore', '~> 10.25.0'
  pod 'Firebase/Storage', '~> 10.25.0'

  # Adding a Firebase module that requires v11+
  # This simulates what happens when other pods need newer Firebase
  pod 'Firebase/Crashlytics', '~> 11.0'
end
EOF

echo "Podfile contents:"
echo "=========================================="
cat Podfile
echo "=========================================="
echo ""

echo "Running: pod install --repo-update"
echo "This WILL fail due to version conflict..."
echo ""

# Run pod install and capture output
pod install --repo-update 2>&1 | tee pod_install_output.log

echo ""
echo "=========================================="
echo "RESULT:"
echo "=========================================="

if grep -q "CocoaPods could not find compatible versions" pod_install_output.log; then
    echo "❌ CONFLICT DETECTED (as expected)"
    echo ""
    echo "CocoaPods cannot resolve:"
    echo "  - Firebase/Auth ~> 10.25.0 (requires Firebase/Core 10.25.0)"
    echo "  - Firebase/Crashlytics ~> 11.0 (requires Firebase/Core 11.x)"
    echo ""
    echo "This proves Response 1's downgrade advice is incomplete."
    echo "Response 1 says '✅ This works' but provides NO warning about:"
    echo "  ❌ Checking compatibility with other Firebase modules"
    echo "  ❌ Verifying all pods support the downgraded version"
    echo "  ❌ Potential conflicts with other dependencies"
fi

echo ""
echo "Test directory: $TEST_DIR"
echo "Full output saved to: $TEST_DIR/pod_install_output.log"
echo ""
echo "Date: $(date)"
echo "=========================================="
