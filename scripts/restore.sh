#!/bin/bash
# ============================================================
# 🔄 CLOUD HOME — Disaster Recovery / Restore Script
# ============================================================
# Restores everything from Restic backup
# Usage: bash restore.sh [snapshot-id]
# If no snapshot ID given, restores latest
# ============================================================

set -euo pipefail

CLOUD_DIR="${HOME}/cloud"
SNAPSHOT="${1:-latest}"

echo ""
echo "=================================================="
echo "  🔄 CLOUD HOME — Disaster Recovery"
echo "=================================================="
echo ""
echo "  Restoring from snapshot: $SNAPSHOT"
echo ""
read -p "  This will overwrite existing data. Continue? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "  Aborted."
    exit 1
fi

# Load environment (from backup or existing)
if [ -f "$CLOUD_DIR/.env" ]; then
    source "$CLOUD_DIR/.env"
else
    echo "  ⚠️  No .env found. Please provide backup credentials:"
    read -p "  B2 Account ID: " B2_ACCOUNT_ID
    read -p "  B2 Account Key: " B2_ACCOUNT_KEY
    read -p "  B2 Bucket: " B2_BUCKET
    read -sp "  Restic Password: " RESTIC_PASSWORD
    echo ""
fi

export RESTIC_REPOSITORY="s3:https://s3.us-west-000.backblazeb2.com/${B2_BUCKET}"
export AWS_ACCESS_KEY_ID="${B2_ACCOUNT_ID}"
export AWS_SECRET_ACCESS_KEY="${B2_ACCOUNT_KEY}"
export RESTIC_PASSWORD="${RESTIC_PASSWORD}"

# ----------------------------------------------------------
# Step 1: Stop all services
# ----------------------------------------------------------
echo ""
echo "  [1/5] Stopping all services..."
cd "$CLOUD_DIR"
docker compose -f docker-compose.ai-media.yml down 2>/dev/null || true
docker compose -f docker-compose.data.yml down 2>/dev/null || true
docker compose -f docker-compose.core.yml down 2>/dev/null || true
echo "  ✅ Services stopped"

# ----------------------------------------------------------
# Step 2: List available snapshots
# ----------------------------------------------------------
echo ""
echo "  [2/5] Available snapshots:"
restic snapshots --tag "cloud-home" | tail -20
echo ""

# ----------------------------------------------------------
# Step 3: Restore files
# ----------------------------------------------------------
echo "  [3/5] Restoring files from backup..."
restic restore "$SNAPSHOT" --target / --verbose
echo "  ✅ Files restored"

# ----------------------------------------------------------
# Step 4: Restore databases
# ----------------------------------------------------------
echo "  [4/5] Restoring databases..."

# Start just the databases
docker compose -f docker-compose.core.yml up -d redis
docker compose -f docker-compose.data.yml up -d postgres immich-postgres
echo "  Waiting for databases to be ready..."
sleep 10

# Restore main PostgreSQL
if [ -f "$CLOUD_DIR/backups/temp/postgres_all.sql" ]; then
    docker exec -i postgres psql -U "${POSTGRES_USER:-cloudadmin}" < "$CLOUD_DIR/backups/temp/postgres_all.sql"
    echo "  ✅ Main PostgreSQL restored"
fi

# Restore Immich PostgreSQL
if [ -f "$CLOUD_DIR/backups/temp/immich_postgres.sql" ]; then
    docker exec -i immich-postgres psql -U "${IMMICH_DB_USER:-immich}" < "$CLOUD_DIR/backups/temp/immich_postgres.sql"
    echo "  ✅ Immich PostgreSQL restored"
fi

# ----------------------------------------------------------
# Step 5: Start everything
# ----------------------------------------------------------
echo "  [5/5] Starting all services..."
docker compose -f docker-compose.core.yml up -d
sleep 5
docker compose -f docker-compose.data.yml up -d
sleep 5
docker compose -f docker-compose.ai-media.yml up -d

echo ""
echo "=================================================="
echo "  ✅ RESTORE COMPLETE!"
echo "=================================================="
echo ""
echo "  All services should be coming online now."
echo "  Check status: docker ps"
echo "  Monitor: https://status.${DOMAIN:-yourdomain.com}"
echo ""
echo "  Welcome back to your digital home! 🏠"
echo "=================================================="
