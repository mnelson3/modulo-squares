#!/bin/bash

# Android App Distribution Script
# Usage: ./distribute-android.sh <build_type> <release_notes>

set -e

BUILD_TYPE=${1:-debug}
RELEASE_NOTES=${2:-"Automated build"}

echo "🚀 Starting Android app distribution..."
echo "Build Type: $BUILD_TYPE"
echo "Release Notes: $RELEASE_NOTES"

# Check if we're in the right directory
if [[ ! -f "pubspec.yaml" ]]; then
    echo "❌ Error: pubspec.yaml not found. Please run from the mobile package root."
    exit 1
fi

# Build the app
echo "📱 Building Android app..."
if [[ "$BUILD_TYPE" == "release" ]]; then
    flutter build apk --release
    APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
else
    flutter build apk --debug
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
fi

if [[ ! -f "$APK_PATH" ]]; then
    echo "❌ Error: APK not found at $APK_PATH"
    exit 1
fi

echo "✅ APK built successfully: $APK_PATH"

# Distribute to Firebase App Distribution
echo "📤 Distributing to Firebase App Distribution..."
if [[ -n "$FIREBASE_APP_ID_PRODUCTION" ]]; then
    firebase appdistribution:distribute "$APK_PATH" \
        --app "$FIREBASE_APP_ID_PRODUCTION" \
        --groups "testers" \
        --release-notes "$RELEASE_NOTES"
    echo "✅ Successfully distributed to Firebase App Distribution"
else
    echo "⚠️ Warning: FIREBASE_APP_ID_PRODUCTION not set, skipping Firebase distribution"
fi

echo "🎉 Android distribution completed!"