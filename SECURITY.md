# 🛡️ Security Architecture — How Your Cloud Home Is Protected

## Defense Layers (Inside → Outside)

```
Layer 1: Your Data
  ↓ encrypted at rest (LUKS / provider encryption)
Layer 2: Containers
  ↓ isolated, no privilege escalation, restricted communication
Layer 3: Authentication
  ↓ Authelia SSO + TOTP 2FA on all admin services
Layer 4: Firewall
  ↓ UFW allows only needed ports, Fail2ban blocks brute force
Layer 5: CrowdSec
  ↓ Community threat intelligence, blocks known attackers
Layer 6: Cloudflare Tunnel
  ↓ ZERO open ports — server is invisible to scanners
Layer 7: Tailscale VPN
  ↓ Admin tools only accessible via encrypted private tunnel
```

## Is It Separate From Golden Route?

**Completely.** Cloud Home runs on its own server with:
- Different server (different IP, different provider account if you want)
- Different credentials (separate .env, separate SSH keys)
- Different backups (separate Restic repository)
- No shared code, no shared database, no shared network

If Golden Route's server gets compromised, Cloud Home is untouched. They don't know about each other.

## What Attackers See

### Without Cloudflare Tunnel:
```
Port scan result:
  22/tcp   - SSH (rate-limited, key-only, Fail2ban)
  80/tcp   - HTTP → redirects to HTTPS
  443/tcp  - HTTPS → Caddy → Authelia 2FA
  53/tcp   - DNS (AdGuard)
```

### With Cloudflare Tunnel:
```
Port scan result:
  22/tcp   - SSH (or blocked, using Tailscale instead)
  
  That's it. Everything else is invisible.
  All web traffic flows through Cloudflare's network.
  DDoS? Cloudflare absorbs it. Port scan? Nothing to find.
```

## What Happens If...

| Scenario | Result |
|----------|--------|
| **Someone finds your server IP** | Cloudflare Tunnel = no open ports to exploit |
| **Brute force SSH** | Fail2ban + CrowdSec ban after 3 attempts |
| **DDoS attack** | Cloudflare absorbs it (free tier handles this) |
| **Someone guesses a service URL** | Authelia demands 2FA before showing anything |
| **A container gets compromised** | Docker isolation prevents lateral movement |
| **Server physically dies** | Restore from encrypted backup in <1 hour |
| **Hetzner goes bankrupt** | Restore backup on any other VPS provider |
| **Golden Route explodes** | Cloud Home is a completely separate server. Zero impact. |
| **You lose all your devices** | New device → Tailscale login → access everything |

## Honest Limitations

Nothing is truly "invincible." Here's what could still go wrong:

1. **Your Hetzner account gets compromised** — use a unique strong password + 2FA on Hetzner itself
2. **You lose your backup password** — store it in Vaultwarden AND write it on paper in a safe
3. **Zero-day in Docker/Linux** — automatic security updates minimize this window
4. **You reuse passwords** — use Vaultwarden to generate unique passwords everywhere
5. **Social engineering** — no software protects against someone tricking YOU

## How to Activate Full Security

```bash
# 1. Run base setup
bash scripts/setup.sh

# 2. Run hardening
bash scripts/harden.sh

# 3. Add to .env:
CLOUDFLARE_TUNNEL_TOKEN=your_tunnel_token
CROWDSEC_BOUNCER_KEY=your_bouncer_key
TAILSCALE_AUTH_KEY=your_tailscale_key

# 4. Start security layer
docker compose -f docker-compose.security.yml up -d

# Your server is now nearly invisible. 🔒
```

## Security Checklist

- [ ] SSH key-only authentication
- [ ] Fail2ban active
- [ ] UFW firewall enabled
- [ ] Automatic security updates
- [ ] Kernel hardening (sysctl)
- [ ] Docker hardened (no-new-privileges)
- [ ] Authelia 2FA on admin services
- [ ] Cloudflare Tunnel (zero open ports)
- [ ] CrowdSec (threat intelligence)
- [ ] Tailscale (private admin access)
- [ ] Encrypted backups to 2+ locations
- [ ] Unique passwords for everything (Vaultwarden)
- [ ] 2FA on Hetzner account
- [ ] Backup password stored safely offline
