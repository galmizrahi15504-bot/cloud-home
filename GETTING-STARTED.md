# 🚀 Getting Started — Day One With Your New Computer

> You just unboxed your laptop. Follow this guide top to bottom.
> No coding. No terminal experience needed. Just follow the steps.
> Estimated time: ~2 hours for everything.

---

## Part 1: Set Up Your Laptop (30 min)

### Step 1: First boot
- [ ] Power on, go through the basic Windows/Linux setup
- [ ] Connect to WiFi
- [ ] Install browser updates

### Step 2: Install your 4 essential apps
- [ ] **Bitwarden** — download from bitwarden.com (browser extension + app)
- [ ] **Nextcloud** — download desktop client from nextcloud.com/install
- [ ] **Tailscale** — download from tailscale.com (creates your private tunnel)
- [ ] **Immich** — on your phone only (from App Store / Play Store)

Don't configure them yet — we'll connect them to your cloud after it's built.

---

## Part 2: Buy Your Cloud (15 min)

### Step 3: Buy a domain name
- [ ] Go to **cloudflare.com** → create a free account
- [ ] Go to "Domain Registration" → search for a name you like
- [ ] Buy it (~$10-12/year) — pick something personal (e.g., galcloud.com, galsworld.net)
- [ ] You now own your permanent digital address

### Step 4: Rent your server
- [ ] Go to **hetzner.cloud** → create an account
- [ ] Verify your identity (they may ask for an ID — normal for EU companies)
- [ ] Click "New Project" → name it "Cloud Home"
- [ ] Click "Add Server"
  - **Location:** Falkenstein or Helsinki (cheapest)
  - **Image:** Ubuntu 24.04
  - **Type:** CAX21 (ARM, 4 vCPU, 8GB RAM) — €4.50/month
  - **Networking:** Enable IPv4
  - **SSH Key:** Click "Add SSH Key"
    - On your laptop, open terminal and type: `ssh-keygen -t ed25519`
    - Press Enter for all questions (defaults are fine)
    - Copy the key: `cat ~/.ssh/id_ed25519.pub`
    - Paste it into Hetzner
  - Click **Create & Buy Now**
- [ ] Write down your server's IP address (shown on the dashboard)

### Step 5: Point your domain to your server
- [ ] Back on Cloudflare → go to your domain → DNS settings
- [ ] Add a record:
  - Type: **A**
  - Name: **\***  (asterisk — this means ALL subdomains)
  - Content: **your server IP address**
  - Proxy: **DNS only** (grey cloud, NOT orange)
  - Click Save
- [ ] Add another record:
  - Type: **A**
  - Name: **@** (this is the root domain)
  - Content: **your server IP address**
  - Proxy: **DNS only**
  - Click Save

**Your domain now points to your server. Give it 5 minutes to take effect.**

---

## Part 3: Build Your Cloud Home (45 min)

### Step 6: Connect to your server
- [ ] Open terminal on your laptop
- [ ] Type: `ssh root@YOUR_SERVER_IP` (replace with your actual IP)
- [ ] Type "yes" when it asks about fingerprint
- [ ] You're now inside your server!

### Step 7: Upload Cloud Home files
- [ ] On your server, run:
```
apt install -y git
git clone https://github.com/galmizrahi15504-bot/cloud-home.git
cd cloud-home
```

### Step 8: Run the setup script
- [ ] Run: `bash scripts/setup.sh`
- [ ] Wait for it to finish (~5 minutes)
- [ ] It installs Docker, sets up firewall, hardens SSH — all automatic

### Step 9: Generate your secrets
- [ ] Run: `cp .env.example .env`
- [ ] Run: `bash scripts/generate-secrets.sh`
- [ ] Now edit your domain and email:
  - Run: `nano .env`
  - Change `DOMAIN=yourdomain.com` to your actual domain
  - Change `ACME_EMAIL=you@yourdomain.com` to your email
  - Change `TIMEZONE=UTC` to your timezone (e.g., `Asia/Jerusalem`, `America/New_York`)
  - Press **Ctrl+X**, then **Y**, then **Enter** to save

### Step 10: Set up your login
- [ ] Generate your password hash:
```
docker run --rm authelia/authelia:latest \
  authelia crypto hash generate argon2 --password 'PICK_A_STRONG_PASSWORD'
```
- [ ] Copy the hash it gives you (starts with `$argon2id$...`)
- [ ] Edit the user file: `nano authelia/users_database.yml`
  - Replace the placeholder hash with your real hash
  - Change the email to yours
  - Press **Ctrl+X**, then **Y**, then **Enter**

### Step 11: Launch! 🚀
- [ ] Run: `bash scripts/start.sh`
- [ ] Wait ~2 minutes for everything to come online
- [ ] Open your browser and go to: `https://dash.yourdomain.com`
- [ ] You should see the login page!
- [ ] Log in with username `gal` and the password you chose
- [ ] Set up 2FA (it will show you a QR code — scan with your phone's authenticator app)

**🎉 YOUR CLOUD HOME IS LIVE!**

---

## Part 4: Connect Your Apps (20 min)

### Step 12: Passwords (Vaultwarden)
- [ ] Go to `https://vault.yourdomain.com`
- [ ] Create your account
- [ ] Open Bitwarden app/extension on your laptop
- [ ] Settings → Self-hosted → enter `https://vault.yourdomain.com`
- [ ] Log in
- [ ] Start saving all your passwords here

### Step 13: Files (Nextcloud)
- [ ] Go to `https://cloud.yourdomain.com`
- [ ] Log in with the admin credentials from your .env file
- [ ] Open Nextcloud desktop app → enter `https://cloud.yourdomain.com`
- [ ] Choose which folders to sync
- [ ] On phone: install Nextcloud app → same server URL

### Step 14: Photos (Immich)
- [ ] Go to `https://photos.yourdomain.com`
- [ ] Create your account
- [ ] On phone: open Immich app → enter `https://photos.yourdomain.com`
- [ ] Turn on automatic backup
- [ ] Your photos now upload to YOUR server

### Step 15: Security (lock it down)
- [ ] Run: `bash scripts/harden.sh`
- [ ] Set up Cloudflare Tunnel (optional but recommended):
  - Go to Cloudflare dashboard → Zero Trust → Tunnels
  - Create a tunnel → copy the token
  - Edit .env: add `CLOUDFLARE_TUNNEL_TOKEN=your_token`
  - Run: `docker compose -f docker-compose.security.yml up -d cloudflared`
  - Now your server has ZERO open ports
- [ ] Install Tailscale on your laptop + phone
  - Go to tailscale.com → create account → install app
  - On server: edit .env, add TAILSCALE_AUTH_KEY
  - Run: `docker compose -f docker-compose.security.yml up -d tailscale`

---

## Part 5: Add the Fun Stuff (Week 2+)

### AI (Open WebUI + Ollama)
- [ ] Everything's already running from start.sh
- [ ] Go to `https://ai.yourdomain.com`
- [ ] Create account
- [ ] Pull a small AI model: `ssh root@YOUR_IP "docker exec ollama ollama pull phi3:mini"`
- [ ] To add Claude/GPT: Open WebUI settings → Connections → add your API keys

### Media (when you have content)
- [ ] Go to `https://media.yourdomain.com` (Jellyfin)
- [ ] Set up libraries pointing to /data/movies, /data/shows, /data/music
- [ ] Upload content to your server's media folders
- [ ] Install Jellyfin app on your TV/phone

### Music
- [ ] Go to `https://music.yourdomain.com` (Navidrome)
- [ ] Upload music to the music folder on your server
- [ ] Install Symfonium (Android) or play.substreamer.com (web)

---

## Part 6: Verify Everything Works (10 min)

### The Checklist
- [ ] `https://dash.yourdomain.com` — Dashboard loads ✅
- [ ] `https://vault.yourdomain.com` — Bitwarden app connects ✅
- [ ] `https://cloud.yourdomain.com` — Files syncing ✅
- [ ] `https://photos.yourdomain.com` — Photos uploading from phone ✅
- [ ] `https://ai.yourdomain.com` — AI chat works ✅
- [ ] `https://status.yourdomain.com` — All services green ✅
- [ ] `https://search.yourdomain.com` — Private search works ✅

### Test Your Backup
- [ ] Run: `bash scripts/backup.sh`
- [ ] Check it completes without errors
- [ ] This now runs automatically every night at 3 AM

---

## 🎉 You're Done!

Your virtual world is live. Everything is:
- ✅ Running on your own server
- ✅ Protected by 2FA + firewall + encrypted tunnel
- ✅ Backing up automatically every night
- ✅ Accessible from any device, anywhere
- ✅ Costing you ~€10/month

**At month 6:** buy a mini PC, run `restore.sh`, cancel Hetzner, drop to €4.50/month forever.

---

## 🆘 If Something Goes Wrong

| Problem | Fix |
|---|---|
| A service won't load | `docker compose -f docker-compose.LAYER.yml restart SERVICE_NAME` |
| Everything is down | `bash scripts/start.sh` (restarts all services) |
| Forgot your password | Edit `authelia/users_database.yml`, generate new hash |
| Server is full | Check with `df -h`, clean Docker: `docker system prune` |
| Need to rebuild from scratch | New server → `setup.sh` → `restore.sh` → done |
| Confused about anything | Ask Nicara — I built this, I know every piece 😊 |

---

*Welcome to your digital home, Gal. It's all yours now.* 🏠☁️
