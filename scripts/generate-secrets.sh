#!/bin/bash
# ============================================================
# 🔑 Generate all secrets for .env
# ============================================================
# Run this ONCE after copying .env.example to .env
# It fills in all the random secrets automatically
# You still need to set: DOMAIN, ACME_EMAIL, passwords
# ============================================================

set -euo pipefail

ENV_FILE="${1:-.env}"

if [ ! -f "$ENV_FILE" ]; then
    echo "❌ $ENV_FILE not found. Run: cp .env.example .env"
    exit 1
fi

gen() { openssl rand -hex 32; }
gen_b64() { openssl rand -base64 48 | tr -d '\n'; }

echo "🔑 Generating secrets..."

# Replace empty secret fields with generated values
declare -A secrets=(
    ["POSTGRES_PASSWORD"]="$(gen)"
    ["IMMICH_DB_PASSWORD"]="$(gen)"
    ["AUTHELIA_JWT_SECRET"]="$(gen)"
    ["AUTHELIA_SESSION_SECRET"]="$(gen)"
    ["AUTHELIA_STORAGE_ENCRYPTION_KEY"]="$(gen)"
    ["NEXTCLOUD_ADMIN_PASSWORD"]="$(gen | head -c 24)"
    ["VAULTWARDEN_ADMIN_TOKEN"]="$(gen_b64)"
    ["OPENWEBUI_SECRET"]="$(gen)"
    ["N8N_ENCRYPTION_KEY"]="$(gen)"
    ["SEARXNG_SECRET"]="$(gen)"
    ["RESTIC_PASSWORD"]="$(gen)"
)

for key in "${!secrets[@]}"; do
    value="${secrets[$key]}"
    # Only fill in if currently empty (KEY= with nothing after)
    if grep -q "^${key}=$" "$ENV_FILE"; then
        sed -i "s|^${key}=$|${key}=${value}|" "$ENV_FILE"
        echo "  ✅ ${key} generated"
    else
        echo "  ⏭️  ${key} already set, skipping"
    fi
done

echo ""
echo "🎉 Secrets generated! Now edit $ENV_FILE to set:"
echo "   - DOMAIN (your domain name)"
echo "   - ACME_EMAIL (for SSL certificates)"
echo "   - TIMEZONE (your timezone)"
echo "   - B2_ACCOUNT_ID, B2_ACCOUNT_KEY, B2_BUCKET (for backups)"
echo ""
echo "Run: nano $ENV_FILE"
