# ☁️ Cloud Home — Your Digital Fortress

> Your AI, your data, your tools — all yours, forever.  
> 24 services. 16 files. ~€13/month. Zero subscriptions.

---

## What You Get

| # | Service | URL | Replaces |
|---|---------|-----|----------|
| 1 | **Caddy** | (reverse proxy) | Nginx, Apache |
| 2 | **Authelia** | auth.domain.com | Okta, Auth0 |
| 3 | **Redis** | (internal cache) | — |
| 4 | **Portainer** | manage.domain.com | — |
| 5 | **Uptime Kuma** | status.domain.com | Pingdom, UptimeRobot |
| 6 | **AdGuard Home** | dns.domain.com | Pi-hole |
| 7 | **Watchtower** | (auto-updates) | — |
| 8 | **PostgreSQL** | (database) | — |
| 9 | **Nextcloud** | cloud.domain.com | Google Drive, Calendar, Contacts |
| 10 | **Immich** | photos.domain.com | Google Photos |
| 11 | **Vaultwarden** | vault.domain.com | LastPass, 1Password |
| 12 | **Gitea** | git.domain.com | GitHub |
| 13 | **Ollama** | (AI runtime) | — |
| 14 | **Open WebUI** | ai.domain.com | ChatGPT |
| 15 | **n8n** | auto.domain.com | Zapier, Make |
| 16 | **SearXNG** | search.domain.com | Google Search |
| 17 | **Jellyfin** | media.domain.com | Netflix |
| 18 | **Navidrome** | music.domain.com | Spotify |
| 19 | **Audiobookshelf** | books.domain.com | Audible |
| 20 | **FreshRSS** | rss.domain.com | Feedly |
| 21 | **Homepage** | dash.domain.com | — |
| 22-24 | Immich DB/Redis/ML | (internal) | — |

## Quick Start (5 Steps)

### 1. Get a server + domain
- Server: [Hetzner](https://hetzner.cloud) CX32 (~€8/mo)
- Domain: [Cloudflare](https://dash.cloudflare.com) (~$12/year)
- Point DNS A record `*.yourdomain.com` → your server IP

### 2. Upload & setup
```bash
ssh root@YOUR_SERVER_IP
# Upload cloud-home folder, then:
cd cloud-home
bash scripts/setup.sh
```

### 3. Configure
```bash
cp .env.example .env
bash scripts/generate-secrets.sh    # Auto-fills all random secrets
nano .env                            # Set DOMAIN, ACME_EMAIL, TIMEZONE
```

### 4. Set up Authelia user
```bash
# Generate your password hash
docker run --rm authelia/authelia:latest \
  authelia crypto hash generate argon2 --password 'YourSecurePassword'

# Paste hash into users file
nano authelia/users_database.yml
```

### 5. Launch!
```bash
bash scripts/start.sh
# Wait 1-2 minutes, then visit: https://dash.yourdomain.com
```

## File Structure
```
cloud-home/
├── docker-compose.core.yml       7 services  (proxy, auth, monitoring)
├── docker-compose.data.yml       8 services  (files, photos, passwords, git)
├── docker-compose.ai-media.yml   9 services  (AI, media, automation)
├── .env.example                  All config variables
├── caddy/Caddyfile               16 subdomain routes
├── authelia/
│   ├── configuration.yml         SSO config (auto-templated from .env)
│   └── users_database.yml        Your user account
├── postgres/init-databases.sh    Auto-creates all databases
├── scripts/
│   ├── setup.sh                  Fresh server provisioning
│   ├── generate-secrets.sh       One-command secret generation
│   ├── start.sh                  Start all services (ordered)
│   ├── stop.sh                   Stop all services (ordered)
│   ├── backup.sh                 Encrypted backup to B2
│   └── restore.sh               Disaster recovery
├── .gitignore                    Protects secrets
└── README.md
```

## Verified ✅

- All 24 services validated (YAML structure, networking, dependencies)
- All 16 Caddy routes verified against container names
- Healthchecks on all critical services (Caddy, Authelia, Redis, PostgreSQL, Nextcloud, Vaultwarden, Ollama, Jellyfin)
- Memory limits on resource-heavy services (prevents OOM crashes)
- All `depends_on` use condition format (services wait for healthy dependencies)
- Authelia config auto-templates domain from .env (no manual find-replace)
- Caddy has upload limits for Nextcloud (10GB) and Immich (5GB)
- WebSocket support for n8n, Jellyfin, and Uptime Kuma
- Security headers on all routes (HSTS, XSS protection, etc.)
- Watchtower uses rolling restart (no all-at-once downtime)

## Disaster Recovery

```bash
# Server dies? Get a new one and:
ssh root@NEW_SERVER_IP
bash scripts/setup.sh
bash scripts/restore.sh
# Everything is back. ✅
```

## Cost

| Item | Monthly |
|------|---------|
| Hetzner CX32 (4 vCPU, 8GB, 80GB) | ~€8 |
| Storage volume (100GB) | ~€4 |
| Domain | ~€1 |
| Backblaze B2 backup | ~€0.50 |
| **Total** | **~€13.50** |

---

*Built and verified by Nicara. 16 files, 24 services, zero subscriptions.* ☁️
