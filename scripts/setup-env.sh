#!/bin/bash
# Environment Setup Script for Modulo
# This script helps populate .env files with Firebase configuration

set -e

ENVIRONMENT=${1:-dev}

echo "Setting up environment variables for: $ENVIRONMENT"

# Check if firebase CLI is available
if ! command -v firebase &> /dev/null; then
    echo "Firebase CLI is not installed. Please install it first:"
    echo "npm install -g firebase-tools"
    exit 1
fi

# Determine project ID based on environment
case $ENVIRONMENT in
    dev)
        PROJECT_ID="modulo-squares-dev"
        ;;
    staging)
        PROJECT_ID="modulo-squares-staging"
        ;;
    prod)
        PROJECT_ID="modulo-squares-prod"
        ;;
    *)
        echo "Invalid environment. Use: dev, staging, or prod"
        exit 1
        ;;
esac

echo "Fetching Firebase config for project: $PROJECT_ID"

# Get Firebase config (this requires authentication)
if ! firebase projects:list | grep -q "$PROJECT_ID"; then
    echo "Project $PROJECT_ID not found or you don't have access."
    echo "Please make sure you're logged in: firebase login"
    exit 1
fi

# Note: In a real implementation, you would use Firebase Admin SDK or CLI
# to fetch the actual config values. For now, this is a template.

echo "Please manually update your .env.$ENVIRONMENT file with the actual values from:"
echo "Firebase Console > Project Settings > General > Your apps > Web app"
echo ""
echo "Required values:"
echo "- API Key"
echo "- Auth Domain" 
echo "- Project ID"
echo "- Storage Bucket"
echo "- Messaging Sender ID"
echo "- App ID"
