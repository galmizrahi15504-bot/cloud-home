# 🗺️ The Master Plan — Gal's Virtual World

> Start cloud. Learn it. Go hardware. Pay almost nothing forever.
> Created: April 2026

---

## 🎯 The Strategy

```
  NOW          Month 1-6              Month 6+              Forever
   │               │                     │                    │
   ▼               ▼                     ▼                    ▼
Buy laptop → Cloud on Hetzner → Buy mini PC for home → ~€4.50/month
 (~$900)      (~€10/month)        (~$150 one-time)      (electricity
              Learn everything     Move everything         + domain
              Risk-free             from cloud → home       + backup)
```

**Why this order:**
1. Don't stack two hardware purchases at once (laptop + mini PC)
2. Learn the system risk-free in the cloud first (mess up? rebuild in 5 min)
3. By month 6 you'll know exactly what you need
4. Then go hardware and drop to ~€4.50/month for the next decade

---

## 💰 The Full Money Picture

### Phase 1: Cloud (Months 1-6)

| Item | Cost |
|---|---|
| Framework 13 laptop | ~$900 (one-time) |
| Hetzner VPS (6 months) | €27 |
| Hetzner Storage Box (6 months) | €23 |
| Domain name (1 year) | €12 |
| Backblaze B2 backup (6 months) | €3 |
| **Phase 1 total** | **~$900 laptop + ~€65 cloud** |

### Phase 2: Move Home (Month 6)

| Item | Cost |
|---|---|
| Intel N100 Mini PC (16GB, 500GB) | ~$150 (one-time) |
| External HDD 2TB (media/photos) | ~$60 (one-time) |
| Cancel Hetzner VPS | -€4.50/mo saved |
| Cancel Storage Box | -€3.80/mo saved |
| **Phase 2 total** | **~$210 one-time** |

### Phase 3: Forever (Month 7+)

| Item | Monthly Cost |
|---|---|
| Electricity (mini PC, 15W 24/7) | ~€3-4 |
| Domain name | ~€1 |
| Offsite backup (Backblaze) | ~€0.50 |
| **Monthly forever** | **~€4.50** |

### Total Cost Summary

| Period | Total Spent |
|---|---|
| **Year 1** | $900 (laptop) + $210 (mini PC) + ~€120 (cloud+home running) = **~$1,240** |
| **Year 2** | ~€54 (~$60) — just electricity, domain, backup |
| **Year 3** | ~€54 (~$60) |
| **Year 10** | Still ~€54/year. Mini PC still running. |

### What You'd Pay Big Tech Instead

| Period | Subscriptions (Google+Netflix+Spotify+1Password+ChatGPT+etc) |
|---|---|
| Year 1 | ~$1,128 |
| Year 2 | ~$1,128 |
| Year 10 | ~$11,280 total |

**Your 10-year cost: ~$1,750.** Their 10-year cost: **~$11,280.** You save ~$9,500 and own everything.

---

## 📅 Month-by-Month Walkthrough

### Month 1 — The Foundation

**Goal: Your cloud exists. Essentials running.**

Buy:
- [ ] Domain name — Cloudflare Registrar (~$12/year)
- [ ] Hetzner VPS — CAX21 (4 ARM cores, 8GB RAM) = €4.50/month
- [ ] Hetzner Storage Box — BX11 (1TB) = €3.80/month

Set up:
- [ ] Run `setup.sh` on fresh server (10 min)
- [ ] Run `generate-secrets.sh` (1 min)
- [ ] Edit `.env` with your domain (5 min)
- [ ] Set up Authelia user (5 min)
- [ ] Run `start.sh` — core + data services (2 min)
- [ ] Run `harden.sh` for security (5 min)

You now have:
- ✅ **Vaultwarden** — password manager (migrate ALL passwords here first!)
- ✅ **Nextcloud** — files, calendar, contacts
- ✅ **Authelia** — single login with 2FA
- ✅ **AdGuard** — ad blocking
- ✅ **Uptime Kuma** — monitoring
- ✅ Automated daily backups

First week habits:
1. Install Bitwarden app → connect to Vaultwarden → migrate passwords
2. Install Nextcloud app on phone → move files from Google Drive
3. Set up 2FA on everything

---

### Month 2 — Photos & Security

**Goal: Free from Google Photos. Fortress locked down.**

- [ ] Start Immich → install app on phone → upload photos
- [ ] Set up Cloudflare Tunnel (free) → close all public ports
- [ ] Set up Tailscale (free) → private admin access

You now have:
- ✅ **Immich** — photo backup with face recognition
- ✅ **Zero open ports** — server invisible to attackers
- ✅ **Private VPN** — admin tools behind encrypted tunnel

---

### Month 3 — AI & Automation

**Goal: Your own private AI + automation engine.**

- [ ] Start AI & media compose layer
- [ ] Pull AI model: `docker exec ollama ollama pull phi3:mini`
- [ ] Connect OpenAI/Anthropic API keys in Open WebUI
- [ ] Set up 2-3 automations in n8n

You now have:
- ✅ **Open WebUI** — private ChatGPT
- ✅ **n8n** — background automations
- ✅ **SearXNG** — private search

---

### Month 4 — Media & Entertainment

**Goal: Your own streaming services.**

- [ ] Upload movies/music to Storage Box
- [ ] Mount in Jellyfin and Navidrome
- [ ] Install Jellyfin app on TV/phone
- [ ] Install music app (Symfonium/Substreamer)

You now have:
- ✅ **Jellyfin** — your Netflix
- ✅ **Navidrome** — your Spotify
- ✅ **Audiobookshelf** — your Audible

---

### Month 5 — Code & Projects

**Goal: Development world in the cloud.**

- [ ] Mirror Golden Route to Gitea
- [ ] Set up Code-Server (VS Code in browser)
- [ ] Create n8n automations for Golden Route
- [ ] Connect Nicara/OpenClaw to cloud services

You now have:
- ✅ **Gitea** — your own GitHub
- ✅ **Code-Server** — code from any device
- ✅ Golden Route integrated

---

### Month 6 — The Move Home 🏠

**Goal: Buy mini PC, move everything from cloud to home.**

Buy:
- [ ] Intel N100 Mini PC (16GB RAM, 500GB SSD) — ~$150
- [ ] External HDD 2TB — ~$60
- [ ] UPS battery backup (optional) — ~$40

Move:
- [ ] Install Ubuntu on mini PC
- [ ] Run `setup.sh`
- [ ] Run `restore.sh` (pulls everything from cloud backup)
- [ ] Set up Cloudflare Tunnel to point to home
- [ ] Update DNS
- [ ] Test everything works
- [ ] Cancel Hetzner VPS ← stop paying €8.30/month

**From now on: ~€4.50/month. Forever.**

---

## 🔮 Future Upgrades (When You Want Them)

| Want More... | Do This | Cost |
|---|---|---|
| **Storage** | Plug in a bigger hard drive | $50-100 one-time |
| **AI power** | Upgrade mini PC to 32GB RAM | ~$30 (RAM stick) |
| **Serious AI** | Rent GPU time on Vast.ai | ~$0.20/hr, only when needed |
| **Redundancy** | Add Oracle Free Tier as cloud backup | Free |
| **Max power** | Swap mini PC for a used workstation | ~$200-400 |

All upgrades are optional. The base setup handles everything.

---

## 🛒 Complete Shopping List

### When You Buy Your Laptop (Now):
- [ ] Framework 13 DIY Edition — ~$900
- [ ] RAM 32GB (buy separately, cheaper) — ~$60
- [ ] SSD 1TB (buy separately) — ~$70

### When You Start Cloud Home (Month 1):
- [ ] Hetzner account (hetzner.cloud)
- [ ] Domain (Cloudflare Registrar)
- [ ] Backblaze B2 account (free signup, pay per use)

### When You Move Home (Month 6):
- [ ] Intel N100 Mini PC 16GB/500GB — ~$150
- [ ] External HDD 2TB — ~$60
- [ ] UPS battery backup (optional) — ~$40

---

## 🔑 The Simple Rules

1. **Passwords first** — Vaultwarden before anything else
2. **One service per week** — don't rush
3. **Phone apps on day one** — Bitwarden, Nextcloud, Immich
4. **Backups are automatic** — verify monthly
5. **If it breaks** — restart the service. Usually fixes it.
6. **When in doubt** — ask Nicara 😊

---

## ☕ The Bottom Line

For the price of **one coffee per month**, you get:
- Your own AI assistant
- Your own file storage
- Your own photo backup
- Your own password manager
- Your own Netflix, Spotify, Audible
- Your own search engine
- Your own automation engine
- Your own code platform
- Complete privacy
- Zero subscriptions
- Data you own forever

*This is your plan, Gal. Simple, phased, no rush. The code is ready. The blueprint is done. When you get that laptop — we go.* 🚀
