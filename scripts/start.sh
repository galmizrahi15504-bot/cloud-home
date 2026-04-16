#!/bin/bash
# ============================================================
# 🚀 Start all Cloud Home services in correct order
# ============================================================

set -euo pipefail

CLOUD_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$CLOUD_DIR"

echo "☁️  Starting Cloud Home..."
echo ""

# Phase 1: Core infrastructure
echo "[1/3] Starting core infrastructure..."
docker compose -f docker-compose.core.yml up -d
echo "  Waiting for core services to be healthy..."
sleep 10

# Phase 2: Data services
echo "[2/3] Starting data services..."
docker compose -f docker-compose.data.yml up -d
echo "  Waiting for databases to initialize..."
sleep 15

# Phase 3: AI & Media
echo "[3/3] Starting AI & media services..."
docker compose -f docker-compose.ai-media.yml up -d

echo ""
echo "=================================================="
echo "  ✅ All services starting!"
echo "=================================================="
echo ""
echo "  Check status:     docker ps"
echo "  View logs:        docker compose -f docker-compose.core.yml logs -f"
echo "  Dashboard:        https://dash.${DOMAIN:-yourdomain.com}"
echo ""
echo "  Services may take 1-2 minutes to fully initialize."
echo "=================================================="
