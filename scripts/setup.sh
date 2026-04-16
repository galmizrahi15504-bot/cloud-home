#!/bin/bash
# ============================================================
# 🚀 CLOUD HOME — Fresh Server Setup Script
# ============================================================
# Run this on a fresh Ubuntu 24.04 VPS
# Usage: bash setup.sh
# ============================================================

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✅]${NC} $1"; }
info() { echo -e "${BLUE}[ℹ️]${NC} $1"; }
warn() { echo -e "${YELLOW}[⚠️]${NC} $1"; }
err()  { echo -e "${RED}[❌]${NC} $1"; }

echo ""
echo "=================================================="
echo "  ☁️  CLOUD HOME — Server Setup"
echo "  Your digital fortress starts here."
echo "=================================================="
echo ""

# ----------------------------------------------------------
# Step 1: System Update
# ----------------------------------------------------------
info "Updating system packages..."
apt update && apt upgrade -y
log "System updated"

# ----------------------------------------------------------
# Step 2: Install Essential Packages
# ----------------------------------------------------------
info "Installing essentials..."
apt install -y \
    curl wget git nano htop \
    ufw fail2ban \
    ca-certificates gnupg lsb-release \
    unzip jq
log "Essentials installed"

# ----------------------------------------------------------
# Step 3: Install Docker
# ----------------------------------------------------------
if command -v docker &> /dev/null; then
    log "Docker already installed: $(docker --version)"
else
    info "Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
    log "Docker installed: $(docker --version)"
fi

# ----------------------------------------------------------
# Step 4: Install Docker Compose (plugin)
# ----------------------------------------------------------
if docker compose version &> /dev/null; then
    log "Docker Compose already available: $(docker compose version)"
else
    info "Installing Docker Compose plugin..."
    apt install -y docker-compose-plugin
    log "Docker Compose installed"
fi

# ----------------------------------------------------------
# Step 5: Create Docker Network
# ----------------------------------------------------------
if docker network ls | grep -q cloud-net; then
    log "Docker network 'cloud-net' already exists"
else
    docker network create cloud-net
    log "Docker network 'cloud-net' created"
fi

# ----------------------------------------------------------
# Step 6: Create Directory Structure
# ----------------------------------------------------------
info "Creating directory structure..."
CLOUD_DIR="${HOME}/cloud"
mkdir -p "$CLOUD_DIR"/{caddy,authelia,postgres,scripts,media/{movies,shows,music,audiobooks,podcasts},backups}

# Copy config files if they exist in the current directory
if [ -f "docker-compose.core.yml" ]; then
    cp docker-compose.*.yml "$CLOUD_DIR/"
    cp -r caddy/ "$CLOUD_DIR/" 2>/dev/null || true
    cp -r authelia/ "$CLOUD_DIR/" 2>/dev/null || true
    cp -r postgres/ "$CLOUD_DIR/" 2>/dev/null || true
    cp -r scripts/ "$CLOUD_DIR/" 2>/dev/null || true
    cp .env.example "$CLOUD_DIR/" 2>/dev/null || true
fi

log "Directory structure created at $CLOUD_DIR"

# ----------------------------------------------------------
# Step 7: Configure Firewall (UFW)
# ----------------------------------------------------------
info "Configuring firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh           # Port 22
ufw allow 80/tcp        # HTTP
ufw allow 443/tcp       # HTTPS
ufw allow 443/udp       # HTTP/3
ufw allow 53/tcp        # DNS (AdGuard)
ufw allow 53/udp        # DNS (AdGuard)
ufw allow 2222/tcp      # Gitea SSH
ufw --force enable
log "Firewall configured and enabled"

# ----------------------------------------------------------
# Step 8: Configure Fail2ban
# ----------------------------------------------------------
info "Configuring Fail2ban..."
cat > /etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
bantime  = 3600
findtime = 600
maxretry = 5
backend  = systemd

[sshd]
enabled = true
port    = ssh
filter  = sshd
maxretry = 3
EOF

systemctl enable fail2ban
systemctl restart fail2ban
log "Fail2ban configured (3 SSH attempts, 1 hour ban)"

# ----------------------------------------------------------
# Step 9: Harden SSH
# ----------------------------------------------------------
info "Hardening SSH..."
# Backup original config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Apply hardening (only if not already done)
if ! grep -q "# CloudHome SSH Hardening" /etc/ssh/sshd_config; then
    cat >> /etc/ssh/sshd_config <<'EOF'

# CloudHome SSH Hardening
PasswordAuthentication no
PermitRootLogin prohibit-password
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
EOF
    systemctl restart sshd
    log "SSH hardened (key-only authentication)"
else
    log "SSH already hardened"
fi

# ----------------------------------------------------------
# Step 10: Setup .env file
# ----------------------------------------------------------
if [ ! -f "$CLOUD_DIR/.env" ]; then
    if [ -f "$CLOUD_DIR/.env.example" ]; then
        cp "$CLOUD_DIR/.env.example" "$CLOUD_DIR/.env"
        warn "Created .env from template — EDIT IT before starting services!"
        warn "Run: nano $CLOUD_DIR/.env"
    fi
fi

# ----------------------------------------------------------
# Step 11: Make scripts executable
# ----------------------------------------------------------
chmod +x "$CLOUD_DIR"/scripts/*.sh 2>/dev/null || true
chmod +x "$CLOUD_DIR"/postgres/*.sh 2>/dev/null || true

# ----------------------------------------------------------
# Done!
# ----------------------------------------------------------
echo ""
echo "=================================================="
echo "  ☁️  SETUP COMPLETE!"
echo "=================================================="
echo ""
echo "  Next steps:"
echo ""
echo "  1. Edit your environment file:"
echo "     nano $CLOUD_DIR/.env"
echo ""
echo "  2. Edit Authelia config (replace YOURDOMAIN.COM):"
echo "     nano $CLOUD_DIR/authelia/configuration.yml"
echo ""
echo "  3. Generate an Authelia password hash:"
echo "     docker run --rm authelia/authelia:latest \\"
echo "       authelia crypto hash generate argon2 --password 'YourPassword'"
echo ""
echo "  4. Update the user database:"
echo "     nano $CLOUD_DIR/authelia/users_database.yml"
echo ""
echo "  5. Start core services:"
echo "     cd $CLOUD_DIR"
echo "     docker compose -f docker-compose.core.yml up -d"
echo ""
echo "  6. Start data services:"
echo "     docker compose -f docker-compose.data.yml up -d"
echo ""
echo "  7. Start AI & media services:"
echo "     docker compose -f docker-compose.ai-media.yml up -d"
echo ""
echo "  8. Pull your first AI model:"
echo "     docker exec -it ollama ollama pull llama3.1:8b"
echo ""
echo "=================================================="
echo "  Your digital fortress awaits! 🏰"
echo "=================================================="
