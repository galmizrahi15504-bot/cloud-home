# ☁️ Cloud Home

Your self-hosted cloud. Files, passwords, AI, media. ~€5/month.

## Quick Start

→ Read [GETTING-STARTED.md](GETTING-STARTED.md)

## Stack

| App | Purpose |
|---|---|
| [Coolify](https://coolify.io) | Control panel — deploys and manages everything |
| [Nextcloud](https://nextcloud.com) | Files + Photos |
| [Vaultwarden](https://github.com/dani-garcia/vaultwarden) | Passwords (Bitwarden-compatible) |
| [Open WebUI](https://openwebui.com) | AI chat (Claude + local models) |
| [Ollama](https://ollama.com) | Local AI model runner (optional) |
| [Jellyfin](https://jellyfin.org) | Media server (optional) |

## Server

Hetzner VPS:
- **CX22 (€3.29/mo)** — Claude API only, no local AI
- **CX32 (€8.24/mo)** — Full stack including local AI models

## The approach

Coolify handles all the infrastructure: reverse proxy, SSL certificates, Docker, updates. You manage everything through a web UI — no terminal needed after initial setup.

## Month 6

Move to your own hardware (mini PC ~$150). Coolify makes migration trivial — export your services, import on the new machine.
