#!/bin/bash
# ============================================================
# 💾 CLOUD HOME — Backup to Backblaze B2
# Runs automatically every night via cron.
# Manual run: bash scripts/backup.sh
# ============================================================

set -euo pipefail

CLOUD_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$CLOUD_DIR/.env"

export RESTIC_REPOSITORY="s3:https://s3.us-west-000.backblazeb2.com/${B2_BUCKET}"
export AWS_ACCESS_KEY_ID="${B2_ACCOUNT_ID}"
export AWS_SECRET_ACCESS_KEY="${B2_ACCOUNT_KEY}"
export RESTIC_PASSWORD="${RESTIC_PASSWORD}"

LOG="$CLOUD_DIR/backups/last-backup.log"
mkdir -p "$CLOUD_DIR/backups"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"; }

> "$LOG"  # clear old log
log "🚀 Starting backup..."

# Initialize repo if first time
restic snapshots &>/dev/null || restic init
log "✅ Repository ready"

# Dump Nextcloud database
log "📦 Dumping database..."
mkdir -p "$CLOUD_DIR/backups/temp"
docker exec postgres pg_dump -U "${POSTGRES_USER:-cloudadmin}" nextcloud \
  > "$CLOUD_DIR/backups/temp/nextcloud.sql"
log "✅ Database dumped"

# Back up everything
log "📤 Uploading to Backblaze..."
restic backup \
  "$CLOUD_DIR/backups/temp" \
  --tag database

# Volumes: back up the named Docker volumes
for volume in nextcloud_data vaultwarden_data openwebui_data; do
  log "📦 Backing up volume: $volume"
  docker run --rm \
    -v "${volume}:/data:ro" \
    -v "$CLOUD_DIR/backups/temp:/backup" \
    alpine tar czf "/backup/${volume}.tar.gz" -C /data .
done

restic backup \
  "$CLOUD_DIR/backups/temp" \
  --tag volumes

# Keep 7 daily, 4 weekly, 3 monthly
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 3 --prune

# Cleanup temp
rm -rf "$CLOUD_DIR/backups/temp"

log "🎉 Backup complete!"
