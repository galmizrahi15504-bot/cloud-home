#!/bin/bash
# ============================================================
# 🔑 Generate all secrets for .env
# Run once after: cp .env.example .env
# ============================================================

set -euo pipefail

ENV_FILE="${1:-.env}"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ $ENV_FILE not found. Run: cp .env.example .env"
  exit 1
fi

gen()     { openssl rand -hex 32; }
gen_b64() { openssl rand -base64 48 | tr -d '\n'; }

echo "🔑 Generating secrets..."

declare -A secrets=(
  ["POSTGRES_PASSWORD"]="$(gen)"
  ["NEXTCLOUD_ADMIN_PASSWORD"]="$(gen | head -c 20)"
  ["VAULTWARDEN_ADMIN_TOKEN"]="$(gen_b64)"
  ["OPENWEBUI_SECRET"]="$(gen)"
  ["RESTIC_PASSWORD"]="$(gen)"
)

for key in "${!secrets[@]}"; do
  value="${secrets[$key]}"
  if grep -q "^${key}=$" "$ENV_FILE"; then
    sed -i "s|^${key}=$|${key}=${value}|" "$ENV_FILE"
    echo "  ✅ ${key}"
  else
    echo "  ⏭️  ${key} already set"
  fi
done

echo ""
echo "Done! Now edit .env and set:"
echo "  DOMAIN, ACME_EMAIL, TIMEZONE"
echo ""
echo "  nano $ENV_FILE"
