#!/bin/bash
# Firestore Backup Script
# Usage: ./scripts/backup-firestore.sh [environment]

ENVIRONMENT=${1:-prod}
PROJECT_ID="modulo-squares-${ENVIRONMENT}"

echo "Backing up Firestore data for ${PROJECT_ID}..."

# Create backup directory
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Export Firestore data
firebase firestore:export "$BACKUP_DIR/firestore_backup" --project "$PROJECT_ID"

echo "Backup completed: $BACKUP_DIR"
echo "To restore: firebase firestore:import $BACKUP_DIR/firestore_backup --project $PROJECT_ID"
