# 🗺️ The 6-Month Plan — Gal's Virtual World

> Simple. Phased. Ready for upgrade at month 6.
> Created: April 2026

---

## 🖥️ Your New Computer = The Remote Control

Your computer is just the door to your virtual world. Everything important lives in the cloud. Computer breaks? Buy a new one, log in, everything's there.

---

## Month 1 — The Foundation (~€25 one-time + ~€13/month)

**Goal: Your cloud exists and the essentials are running.**

### Buy These:
- [ ] **Domain name** — Cloudflare Registrar (~$12/year). Pick something personal.
- [ ] **Hetzner VPS** — CAX21 (4 ARM cores, 8GB RAM, 80GB) = **€4.50/month** to start
- [ ] **Hetzner Storage Box** — BX11 (1TB) = **€3.80/month** for backups + media

### Set Up:
- [ ] Run `setup.sh` on fresh server (10 min)
- [ ] Run `generate-secrets.sh` (1 min)
- [ ] Edit `.env` with your domain (5 min)
- [ ] Set up Authelia user (5 min)
- [ ] Run `start.sh` — core + data services only (2 min)
- [ ] Run `harden.sh` for security (5 min)

### You Now Have:
- ✅ **Vaultwarden** — password manager (move ALL your passwords here first!)
- ✅ **Nextcloud** — your files, calendar, contacts (install phone app, start syncing)
- ✅ **Authelia** — single login with 2FA for everything
- ✅ **AdGuard** — ad blocking
- ✅ **Uptime Kuma** — monitoring
- ✅ Automated daily backups running

### First Week Habits:
1. Install Bitwarden app → connect to your Vaultwarden → migrate all passwords
2. Install Nextcloud app on phone → move important files from Google Drive
3. Set up 2FA on everything using Authelia

---

## Month 2 — Your Photos & Security (~€0 extra)

**Goal: Free yourself from Google Photos. Lock down the fortress.**

### Set Up:
- [ ] Start Immich (add to data compose, or it's already there)
- [ ] Install Immich app on phone → start uploading photos
- [ ] Set up Cloudflare Tunnel (free) → close all public ports
- [ ] Set up Tailscale (free) → private access to admin tools

### You Now Have:
- ✅ **Immich** — all your photos backed up, face recognition, memories
- ✅ **Zero open ports** — your server is invisible
- ✅ **Private VPN** — admin access only through your tunnel

---

## Month 3 — Your AI & Automation (~€0 extra)

**Goal: Your own private AI assistant and automation engine.**

### Set Up:
- [ ] Start AI & media compose layer
- [ ] Pull a small AI model: `docker exec ollama ollama pull phi3:mini`
- [ ] Open WebUI → connect your OpenAI/Anthropic API keys for heavy tasks
- [ ] Set up 2-3 automations in n8n (start simple):
  - Daily weather/news digest
  - New file notification
  - Anything repetitive you do

### You Now Have:
- ✅ **Open WebUI** — private ChatGPT (small stuff runs local, big stuff via API)
- ✅ **n8n** — automations running in the background
- ✅ **SearXNG** — private search engine

---

## Month 4 — Media & Entertainment (~€0 extra)

**Goal: Your own streaming services.**

### Set Up:
- [ ] Upload movies/music to your Hetzner Storage Box
- [ ] Mount storage box in Jellyfin and Navidrome
- [ ] Install Jellyfin app on your TV/phone
- [ ] Install Subsonic-compatible music app (Symfonium, Substreamer)
- [ ] Set up Audiobookshelf if you listen to audiobooks/podcasts

### You Now Have:
- ✅ **Jellyfin** — your own Netflix
- ✅ **Navidrome** — your own Spotify
- ✅ **Audiobookshelf** — your own Audible

---

## Month 5 — Code & Projects (~€0 extra)

**Goal: Your development world lives in the cloud too.**

### Set Up:
- [ ] Push Golden Route to your own Gitea (mirror from GitHub)
- [ ] Set up Code-Server (VS Code in browser) — add to compose if desired
- [ ] Create n8n automations for Golden Route monitoring
- [ ] Connect Nicara/OpenClaw to your cloud services

### You Now Have:
- ✅ **Gitea** — your own GitHub (private repos, no limits)
- ✅ **Code-Server** — code from any device, anywhere
- ✅ Golden Route monitored and integrated

---

## Month 6 — Upgrade Decision 🚀

**Goal: Evaluate what you actually use, then scale smart.**

### Review:
- [ ] Check Uptime Kuma — which services do you use most?
- [ ] Check resource usage — is the server struggling?
- [ ] Check storage — how much space are you using?

### Upgrade Paths (pick what you need):

| If You Need... | Upgrade To | Cost Change |
|---|---|---|
| **More AI power** | Hetzner CAX31 (16GB RAM) → run Llama 3.1 8B locally | €4.50 → €12/mo |
| **Serious AI** | Add a GPU VPS (Vast.ai/RunPod) on-demand | ~€0.20/hr when needed |
| **More storage** | Hetzner BX21 (5TB) | €3.80 → €10/mo |
| **More everything** | Hetzner CPX31 (8 vCPU, 16GB, 160GB) | €4.50 → €17/mo |
| **Redundancy** | Add Oracle Free Tier as backup server | Free |
| **Management UI** | Add Cosmos Cloud or Coolify on top | Free (open-source) |

### Or The Big Move:
If you're ready, migrate from VPS to **dedicated server** (Hetzner AX42 — 8 cores, 64GB RAM, 2×1TB SSD, ~€52/mo). Run everything including heavy AI models locally. This becomes your serious permanent infrastructure.

---

## 📊 Cost Over 6 Months

| Month | What's Running | Monthly Cost |
|---|---|---|
| 1 | Foundation (VPS + storage + domain) | ~€9.30 |
| 2 | + Photos + Security tunnels | ~€9.30 |
| 3 | + AI + Automation | ~€9.30 |
| 4 | + Media streaming | ~€9.30 |
| 5 | + Code + Projects | ~€9.30 |
| 6 | Upgrade decision | €9-52 depending on path |

**6-month total before upgrade: ~€56 (~$60)**

Compare: Google One + 1Password + Netflix + Spotify alone = ~$400 over 6 months.

---

## 🔑 The Simple Rules

1. **Vaultwarden first** — move your passwords before anything else
2. **One service per week** — don't rush, learn each one
3. **Phone apps immediately** — install Nextcloud, Immich, Bitwarden apps on day one
4. **Backups are automatic** — just verify they work once a month
5. **If something breaks** — `docker compose restart <service>`. That's usually it.
6. **When in doubt** — ask Nicara. I know this whole setup inside out.

---

## 🛒 Shopping List When You Buy Your Computer

For your actual computer (the remote control), all you need:
- Any modern laptop/desktop — it's just accessing web pages
- A browser (that's it, seriously)
- Bitwarden browser extension → connected to your Vaultwarden
- Nextcloud desktop sync client
- Tailscale app (for private admin access)

Your computer is thin. Your cloud is thick. That's the future.

---

*6 months from now, you'll look back and wonder how you ever lived without this.* 🚀
