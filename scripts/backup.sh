#!/bin/bash
# ============================================================
# 💾 CLOUD HOME — Automated Backup Script
# ============================================================
# Backs up all data to Backblaze B2 using Restic
# Schedule with cron: 0 3 * * * /root/cloud/scripts/backup.sh
# ============================================================

set -euo pipefail

# Load environment
CLOUD_DIR="${HOME}/cloud"
source "$CLOUD_DIR/.env"

# Restic config
export RESTIC_REPOSITORY="s3:https://s3.us-west-000.backblazeb2.com/${B2_BUCKET}"
export AWS_ACCESS_KEY_ID="${B2_ACCOUNT_ID}"
export AWS_SECRET_ACCESS_KEY="${B2_ACCOUNT_KEY}"
export RESTIC_PASSWORD="${RESTIC_PASSWORD}"

BACKUP_DIR="$CLOUD_DIR/backups/temp"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$CLOUD_DIR/backups/backup_${TIMESTAMP}.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

mkdir -p "$BACKUP_DIR" "$CLOUD_DIR/backups"

log "🚀 Starting Cloud Home backup..."

# ----------------------------------------------------------
# Step 1: Dump PostgreSQL databases
# ----------------------------------------------------------
log "📦 Dumping PostgreSQL databases..."
docker exec postgres pg_dumpall -U "${POSTGRES_USER:-cloudadmin}" > "$BACKUP_DIR/postgres_all.sql" 2>> "$LOG_FILE"
log "✅ PostgreSQL dump complete"

# Dump Immich's separate database
docker exec immich-postgres pg_dumpall -U "${IMMICH_DB_USER:-immich}" > "$BACKUP_DIR/immich_postgres.sql" 2>> "$LOG_FILE"
log "✅ Immich PostgreSQL dump complete"

# ----------------------------------------------------------
# Step 2: Initialize Restic repo (first run only)
# ----------------------------------------------------------
restic snapshots > /dev/null 2>&1 || {
    log "📁 Initializing Restic repository..."
    restic init
    log "✅ Repository initialized"
}

# ----------------------------------------------------------
# Step 3: Backup everything
# ----------------------------------------------------------
log "☁️ Starting Restic backup..."

restic backup \
    --verbose \
    --tag "cloud-home" \
    --exclude="*.log" \
    --exclude="*.tmp" \
    --exclude="cache/*" \
    "$CLOUD_DIR/docker-compose.core.yml" \
    "$CLOUD_DIR/docker-compose.data.yml" \
    "$CLOUD_DIR/docker-compose.ai-media.yml" \
    "$CLOUD_DIR/.env" \
    "$CLOUD_DIR/caddy/" \
    "$CLOUD_DIR/authelia/" \
    "$CLOUD_DIR/postgres/" \
    "$CLOUD_DIR/scripts/" \
    "$BACKUP_DIR/postgres_all.sql" \
    "$BACKUP_DIR/immich_postgres.sql" \
    /var/lib/docker/volumes/ \
    2>> "$LOG_FILE"

log "✅ Restic backup complete"

# ----------------------------------------------------------
# Step 4: Apply retention policy
# ----------------------------------------------------------
log "🧹 Applying retention policy..."
restic forget \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 6 \
    --prune \
    2>> "$LOG_FILE"

log "✅ Retention policy applied"

# ----------------------------------------------------------
# Step 5: Cleanup
# ----------------------------------------------------------
rm -rf "$BACKUP_DIR"
log "🧹 Temp files cleaned"

# ----------------------------------------------------------
# Step 6: Verify
# ----------------------------------------------------------
log "🔍 Verifying backup integrity..."
restic check --read-data-subset=5% 2>> "$LOG_FILE"
log "✅ Backup verified"

# Summary
SNAPSHOT_SIZE=$(restic stats latest --mode raw-data 2>/dev/null | grep "Total Size" | awk '{print $3, $4}')
log "📊 Latest snapshot size: ${SNAPSHOT_SIZE:-unknown}"
log "🎉 Backup completed successfully!"

# Keep only last 7 log files
ls -t "$CLOUD_DIR/backups/backup_"*.log 2>/dev/null | tail -n +8 | xargs rm -f 2>/dev/null || true
