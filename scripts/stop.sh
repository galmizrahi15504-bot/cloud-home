#!/bin/bash
# ============================================================
# 🛑 Stop all Cloud Home services (reverse order)
# ============================================================

set -euo pipefail

CLOUD_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$CLOUD_DIR"

echo "🛑 Stopping Cloud Home..."
echo ""

echo "[1/3] Stopping AI & media..."
docker compose -f docker-compose.ai-media.yml down

echo "[2/3] Stopping data services..."
docker compose -f docker-compose.data.yml down

echo "[3/3] Stopping core infrastructure..."
docker compose -f docker-compose.core.yml down

echo ""
echo "✅ All services stopped. Data is safe in Docker volumes."
