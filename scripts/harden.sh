#!/bin/bash
# ============================================================
# 🛡️ CLOUD HOME — Security Hardening Script
# ============================================================
# Run AFTER setup.sh to add maximum security layers
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'
NC='\033[0m'
log() { echo -e "${GREEN}[✅]${NC} $1"; }

echo ""
echo "=================================================="
echo "  🛡️ CLOUD HOME — Security Hardening"
echo "=================================================="
echo ""

# ----------------------------------------------------------
# 1. Automatic Security Updates
# ----------------------------------------------------------
echo "[1/6] Enabling automatic security patches..."
apt install -y unattended-upgrades apt-listchanges
cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF

cat > /etc/apt/apt.conf.d/50unattended-upgrades <<'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
    "${distro_id}ESMApps:${distro_codename}-apps-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
EOF
log "Automatic security updates enabled"

# ----------------------------------------------------------
# 2. Kernel Hardening (sysctl)
# ----------------------------------------------------------
echo "[2/6] Hardening kernel network settings..."
cat > /etc/sysctl.d/99-cloud-home-hardening.conf <<'EOF'
# Prevent IP spoofing
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Disable source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0

# Disable ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0

# Enable SYN flood protection
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2

# Log suspicious packets
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# Ignore ICMP broadcasts
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Disable IPv6 if not needed (reduces attack surface)
# net.ipv6.conf.all.disable_ipv6 = 1
# net.ipv6.conf.default.disable_ipv6 = 1
EOF
sysctl -p /etc/sysctl.d/99-cloud-home-hardening.conf
log "Kernel hardened"

# ----------------------------------------------------------
# 3. SSH Extra Hardening
# ----------------------------------------------------------
echo "[3/6] Extra SSH hardening..."
if ! grep -q "# CloudHome Extra Hardening" /etc/ssh/sshd_config; then
    cat >> /etc/ssh/sshd_config <<'EOF'

# CloudHome Extra Hardening
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
PermitEmptyPasswords no
LoginGraceTime 30
Banner /etc/ssh/banner
EOF
    
    echo "⚠️  Authorized access only. All activity is logged." > /etc/ssh/banner
    systemctl restart sshd
fi
log "SSH extra hardening applied"

# ----------------------------------------------------------
# 4. Rate Limiting with UFW
# ----------------------------------------------------------
echo "[4/6] Adding rate limits..."
ufw limit ssh/tcp comment 'Rate limit SSH'
log "SSH rate limiting enabled"

# ----------------------------------------------------------
# 5. Docker Hardening
# ----------------------------------------------------------
echo "[5/6] Hardening Docker daemon..."
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<'EOF'
{
  "icc": false,
  "no-new-privileges": true,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "userland-proxy": false,
  "live-restore": true
}
EOF
systemctl restart docker
log "Docker hardened (inter-container communication restricted, no privilege escalation)"

# ----------------------------------------------------------
# 6. Close ALL Public Ports (if using Cloudflare Tunnel)
# ----------------------------------------------------------
echo "[6/6] Checking if Cloudflare Tunnel is configured..."
source "${HOME}/cloud/.env" 2>/dev/null || true
if [ -n "${CLOUDFLARE_TUNNEL_TOKEN:-}" ]; then
    echo "  Cloudflare Tunnel detected! Closing public HTTP/HTTPS ports..."
    ufw delete allow 80/tcp 2>/dev/null || true
    ufw delete allow 443/tcp 2>/dev/null || true
    ufw delete allow 443/udp 2>/dev/null || true
    # Keep SSH open (or restrict to Tailscale only)
    log "Public ports closed — all traffic routes through Cloudflare Tunnel"
    echo ""
    echo "  🔒 Your server is now INVISIBLE to port scanners."
    echo "  All traffic goes through Cloudflare's protected network."
else
    echo "  ℹ️  No Cloudflare Tunnel token found. Ports 80/443 remain open."
    echo "  To go fully invisible, set CLOUDFLARE_TUNNEL_TOKEN in .env"
    echo "  and run: docker compose -f docker-compose.security.yml up -d"
fi

echo ""
echo "=================================================="
echo "  🛡️ HARDENING COMPLETE"
echo "=================================================="
echo ""
echo "  Security layers active:"
echo "    ✅ Automatic OS security patches"
echo "    ✅ Kernel network hardening"
echo "    ✅ SSH hardened (keys only, rate limited, no forwarding)"
echo "    ✅ Docker hardened (no privilege escalation, isolated containers)"
echo "    ✅ UFW firewall with rate limiting"
echo ""
echo "  Optional (add to .env and start security compose):"
echo "    🔒 Cloudflare Tunnel — zero public ports"
echo "    🛡️ CrowdSec — collaborative threat intelligence"
echo "    🔐 Tailscale — private VPN for admin access"
echo ""
echo "  Run: docker compose -f docker-compose.security.yml up -d"
echo "=================================================="
