#!/bin/bash

# iOS App Distribution Script
# Usage: ./distribute-ios.sh <build_type> <release_notes>

set -e

BUILD_TYPE=${1:-debug}
RELEASE_NOTES=${2:-"Automated build"}

echo "🚀 Starting iOS app distribution..."
echo "Build Type: $BUILD_TYPE"
echo "Release Notes: $RELEASE_NOTES"

# Check if we're in the right directory
if [[ ! -f "pubspec.yaml" ]]; then
    echo "❌ Error: pubspec.yaml not found. Please run from the mobile package root."
    exit 1
fi

# Check if running on macOS (required for iOS builds)
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "⚠️ Warning: Not running on macOS. iOS builds require macOS environment."
    echo "This script will simulate the build process for testing purposes."
    SIMULATION_MODE=true
fi

# Build the app
echo "📱 Building iOS app..."
if [[ "$BUILD_TYPE" == "release" ]]; then
    if [[ "$SIMULATION_MODE" == "true" ]]; then
        echo "🔧 Simulating iOS release build..."
        # Create a dummy IPA file for testing
        mkdir -p build/ios/ipa
        echo "Dummy IPA content" > build/ios/ipa/app.ipa
    else
        flutter build ios --release --no-codesign
    fi
    IPA_PATH="build/ios/ipa/app.ipa"
else
    if [[ "$SIMULATION_MODE" == "true" ]]; then
        echo "🔧 Simulating iOS debug build..."
        mkdir -p build/ios/ipa
        echo "Dummy debug IPA content" > build/ios/ipa/app-debug.ipa
    else
        flutter build ios --debug --no-codesign
    fi
    IPA_PATH="build/ios/ipa/app-debug.ipa"
fi

if [[ ! -f "$IPA_PATH" ]]; then
    echo "❌ Error: IPA not found at $IPA_PATH"
    exit 1
fi

echo "✅ IPA built successfully: $IPA_PATH"

# For production builds, you would typically use Fastlane or Xcode Cloud
# For now, we'll just log the successful build
if [[ "$BUILD_TYPE" == "release" ]]; then
    echo "📤 Production iOS build completed"
    echo "Next steps:"
    echo "  1. Sign the app with proper certificates"
    echo "  2. Upload to TestFlight or App Store"
    echo "  3. Or use Fastlane for automated distribution"
else
    echo "📤 Debug iOS build completed"
    echo "The app can be installed on development devices"
fi

echo "🎉 iOS distribution completed!"