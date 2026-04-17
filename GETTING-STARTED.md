# ☁️ Cloud Home — Setup Guide

> Total time: ~45 minutes. Everything is copy-paste.
> Stuck? Ask Nicara. You can't permanently break anything.

---

## What you'll have when done

| Service | Address | Replaces |
|---|---|---|
| Files & Photos | cloud.YOURDOMAIN.com | Google Drive + Photos |
| Passwords | vault.YOURDOMAIN.com | 1Password |
| AI Chat | ai.YOURDOMAIN.com | ChatGPT (+ Claude) |
| Media | media.YOURDOMAIN.com | Netflix (optional) |

---

## Step 1 — Buy a domain (5 min)

1. Go to **cloudflare.com** → Sign up (free account)
2. Left menu → **Domain Registration** → search a name you like
3. Buy it (~$10/year)

✅ You now own your address on the internet.

---

## Step 2 — Rent a server (10 min)

1. Go to **hetzner.cloud** → Sign up
2. **New Project** → name it "Cloud Home"
3. **Add Server** and pick:

| Setting | Choose |
|---|---|
| Location | Falkenstein |
| Image | Ubuntu 24.04 |
| Type | **CX32** — €8.24/month (8GB RAM) |
| SSH Keys | Click **+ Add SSH key** (see note below) |

> **SSH key note:** On your laptop, open a terminal and run:
> ```
> ssh-keygen -t ed25519 -C "cloud-home"
> ```
> Press Enter three times (accept defaults, no passphrase).
> Then run: `cat ~/.ssh/id_ed25519.pub` and paste the result into Hetzner.

4. Click **Create & Buy Now**
5. **Write down the server IP** (shown on dashboard, looks like: 65.108.123.45)

✅ Your server is running.

---

## Step 3 — Connect domain to server (5 min)

1. Go to **Cloudflare** → click your domain → **DNS** on the left
2. Click **Add Record**:

| Field | Value |
|---|---|
| Type | A |
| Name | * |
| IPv4 address | your server IP |
| Proxy | Grey cloud (DNS only) |

3. Click Save. Then **Add Record** again:

| Field | Value |
|---|---|
| Type | A |
| Name | @ |
| IPv4 address | your server IP |
| Proxy | Grey cloud (DNS only) |

4. Click Save. Wait 5 minutes.

✅ Your domain now points to your server.

---

## Step 4 — Connect to your server (1 min)

On your laptop terminal:
```
ssh root@YOUR_SERVER_IP
```

If it asks "Are you sure?" → type `yes` → Enter.

✅ You're inside your server.

---

## Step 5 — Download and install (10 min)

Copy-paste these commands one at a time:

```bash
apt install -y git
```

```bash
git clone https://github.com/galmizrahi15504-bot/cloud-home.git
cd cloud-home
```

```bash
bash scripts/setup.sh
```

Wait ~3 minutes. When you see "Setup complete!" → continue.

---

## Step 6 — Fill in your settings (5 min)

```bash
cp .env.example .env
bash scripts/generate-secrets.sh
nano .env
```

In the editor, find these 3 lines and change them:

```
DOMAIN=yourdomain.com          ← your actual domain
ACME_EMAIL=you@yourdomain.com  ← your email
TIMEZONE=UTC                   ← e.g. Asia/Jerusalem
```

Save: **Ctrl+X** → **Y** → **Enter**

---

## Step 7 — Launch everything (1 min)

```bash
docker compose up -d
```

Wait 2 minutes for everything to start.

✅ Your cloud is live.

---

## Step 8 — Set up your services (10 min)

### Passwords (Vaultwarden)
1. Go to `https://vault.YOURDOMAIN.com`
2. Click **Create Account** → fill in your name, email, and a strong password
3. **Important:** After creating your account, open `.env` on the server, change `VAULTWARDEN_SIGNUPS=true` to `VAULTWARDEN_SIGNUPS=false`, then run `docker compose up -d` again. This prevents anyone else from registering.
4. On your phone/laptop: install the **Bitwarden** app → Settings → Self-hosted → enter `https://vault.YOURDOMAIN.com`

### Files & Photos (Nextcloud)
1. Go to `https://cloud.YOURDOMAIN.com`
2. Log in with username `admin` and the password from your `.env` file:
   ```bash
   grep NEXTCLOUD_ADMIN_PASSWORD .env
   ```
3. On your laptop: install the **Nextcloud** app → enter your server URL → log in
4. On your phone: install **Nextcloud** app → turn on photo auto-upload

### AI Chat (Open WebUI)
1. Go to `https://ai.YOURDOMAIN.com`
2. Click **Sign up** → create your account (first account becomes admin)
3. See Step 9 for adding Claude

---

## Step 9 — Add Claude AI (5 min)

Get your API key:
1. Go to **console.anthropic.com** → Sign up
2. Click **API Keys** → **Create Key** → copy it

Add it to your server:
```bash
nano .env
```
Find `ANTHROPIC_API_KEY=` and paste your key after the `=`

Save, then restart:
```bash
docker compose up -d
```

Claude now appears automatically in the model picker at `ai.YOURDOMAIN.com`.

> **Cost:** You pay only when you use it. A normal conversation costs ~$0.01–0.05.
> No monthly subscription.

---

## Step 10 — Free local AI model (2 min)

For quick questions that don't need the full power of Claude:
```bash
docker exec ollama ollama pull phi3:mini
```

This is a 2.3GB model that runs entirely on your server, completely free and private.
Pick it from the model dropdown in your AI chat.

---

## Step 11 — Backups (optional but recommended)

Sign up at **backblaze.com** (free for first 10GB).
Create a bucket and App Key, then add to `.env`:

```
B2_ACCOUNT_ID=your_account_id
B2_ACCOUNT_KEY=your_key
B2_BUCKET=your_bucket_name
```

Run a test backup:
```bash
bash scripts/backup.sh
```

Set up automatic nightly backups (runs at 3am):
```bash
echo "0 3 * * * root cd /root/cloud-home && bash scripts/backup.sh" >> /etc/crontab
```

---

## That's it! 🎉

Your monthly cost: **~€9/month total** (server + domain).

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Something won't load | `docker compose ps` to see what's running |
| A service crashed | `docker compose logs SERVICE_NAME` |
| Restart everything | `docker compose restart` |
| Start fresh | `docker compose down && docker compose up -d` |
| Forgot a password | `grep PASSWORD .env` |
| Confused | Ask Nicara 😊 |
