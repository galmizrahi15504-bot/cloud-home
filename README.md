# ☁️ Cloud Home

Your self-hosted cloud. Files, passwords, AI, media. ~€5/month.

## Guides

| Guide | What it covers |
|---|---|
| [GETTING-STARTED.md](GETTING-STARTED.md) | First-time setup, step by step |
| [MIGRATION.md](MIGRATION.md) | Moving to new hardware in 6 months |
| [SWAP-GUIDE.md](SWAP-GUIDE.md) | How to replace any app with an alternative |

---

## The Stack

| App | Purpose | Swap it with |
|---|---|---|
| [Coolify](https://coolify.io) | Control panel — manages everything | Portainer, Dokku |
| [Nextcloud](https://nextcloud.com) | Files + Photos | Seafile, Syncthing |
| [Vaultwarden](https://github.com/dani-garcia/vaultwarden) | Passwords | Bitwarden hosted |
| [Open WebUI](https://openwebui.com) | AI chat (Claude + local) | LibreChat, Lobe Chat |
| [Ollama](https://ollama.com) | Local AI models (optional) | LM Studio (on desktop) |
| [Jellyfin](https://jellyfin.org) | Media server (optional) | Plex, Emby |

---

## Server

Hetzner VPS:
- **CX22 (€3.29/mo)** — Claude API only, no local AI
- **CX32 (€8.24/mo)** — Full stack including local AI models

---

## Architecture

```
Internet → Coolify (manages SSL + routing)
              ├── cloud.DOMAIN     → Nextcloud
              ├── vault.DOMAIN     → Vaultwarden
              ├── ai.DOMAIN        → Open WebUI
              └── media.DOMAIN     → Jellyfin
```

Everything runs in Docker containers managed by Coolify.
Coolify handles SSL certificates, reverse proxy, restarts, and updates automatically.
