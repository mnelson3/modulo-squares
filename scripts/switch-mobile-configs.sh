#!/bin/bash

# Mobile Config Switcher for Modulo Squares
# Switches Android and iOS Firebase config files based on environment

set -e

ENVIRONMENT=${1:-dev}

echo "🔄 Switching mobile configs to $ENVIRONMENT environment..."

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo "❌ Error: Environment must be 'dev', 'staging', or 'prod'"
    exit 1
fi

# Android config switching
ANDROID_SRC="packages/app/android/app/google-services.$ENVIRONMENT.json"
ANDROID_DEST="packages/app/android/app/google-services.json"

if [ -f "$ANDROID_SRC" ]; then
    cp "$ANDROID_SRC" "$ANDROID_DEST"
    echo "✅ Android config switched to $ENVIRONMENT"
else
    echo "❌ Error: Android config file not found: $ANDROID_SRC"
    exit 1
fi

# iOS config switching
IOS_SRC="packages/app/ios/Runner/GoogleService-Info.$ENVIRONMENT.plist"
IOS_DEST="packages/app/ios/Runner/GoogleService-Info.plist"

if [ -f "$IOS_SRC" ]; then
    cp "$IOS_SRC" "$IOS_DEST"
    echo "✅ iOS config switched to $ENVIRONMENT"
else
    echo "❌ Error: iOS config file not found: $IOS_SRC"
    exit 1
fi

echo "🎉 Mobile configs successfully switched to $ENVIRONMENT environment!"