#!/bin/bash
# ============================================================
# 🚀 CLOUD HOME — Server Setup
# Run once on a fresh Ubuntu 24.04 server.
# Usage: bash setup.sh
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✅${NC} $1"; }
info() { echo -e "${BLUE}→${NC} $1"; }

echo ""
echo "☁️  Cloud Home — Server Setup"
echo "=============================="
echo ""

# System update
info "Updating system..."
apt update && apt upgrade -y
apt install -y curl wget git nano ufw fail2ban ca-certificates gnupg restic
ok "System ready"

# Docker
if ! command -v docker &>/dev/null; then
  info "Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  systemctl enable docker && systemctl start docker
fi
ok "Docker: $(docker --version)"

# Docker Compose plugin
if ! docker compose version &>/dev/null; then
  apt install -y docker-compose-plugin
fi
ok "Docker Compose: $(docker compose version)"

# Fix Ubuntu 24.04: disable systemd-resolved so AdGuard/port 53 works
# (Not needed in this simplified stack, but harmless to leave out)

# Firewall
info "Setting up firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 443/udp
ufw --force enable
ok "Firewall active (SSH, HTTP, HTTPS allowed)"

# Fail2ban — blocks IPs that try to brute-force your server
info "Setting up Fail2ban..."
cat > /etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
bantime  = 3600
findtime = 600
maxretry = 5

[sshd]
enabled  = true
maxretry = 3
EOF
systemctl enable fail2ban && systemctl restart fail2ban
ok "Fail2ban active (3 SSH attempts = 1 hour ban)"

# Harden SSH — disable password login, require SSH key
info "Hardening SSH..."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
if ! grep -q "# CloudHome" /etc/ssh/sshd_config; then
  cat >> /etc/ssh/sshd_config <<'EOF'

# CloudHome
PasswordAuthentication no
PermitRootLogin prohibit-password
MaxAuthTries 3
EOF
  systemctl restart sshd
fi
ok "SSH hardened (key-only login)"

echo ""
echo "=============================="
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. cp .env.example .env"
echo "  2. bash scripts/generate-secrets.sh"
echo "  3. nano .env  (set DOMAIN, ACME_EMAIL, TIMEZONE)"
echo "  4. docker compose up -d"
echo "=============================="
