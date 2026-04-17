# ☁️ Cloud Home

Your own private cloud. Files, passwords, AI, media. ~€8/month.  
No technical knowledge needed. Everything is copy-paste.

---

## What you'll have when done

| App | Your URL | Replaces |
|---|---|---|
| Files & Photos | cloud.YOURDOMAIN.com | Google Drive + Google Photos |
| Passwords | vault.YOURDOMAIN.com | 1Password |
| AI Chat (Claude) | ai.YOURDOMAIN.com | ChatGPT |
| Movies & Shows | media.YOURDOMAIN.com | Netflix (optional) |

---

# PART 1 — Do this before buying your computer

These are all free and take ~30 minutes. Having them ready means zero waiting when you sit down with your new machine.

## ✅ Create these 4 accounts

### 1. Cloudflare — [cloudflare.com](https://cloudflare.com)
- Sign up for a free account
- Left menu → **Domain Registration** → search a name you like → buy it (~$10/year)
- This is your address on the internet (e.g. `galcloud.com`)
- 💾 **Save:** your domain name

### 2. Hetzner — [hetzner.cloud](https://hetzner.cloud)
- Sign up for a free account
- They may ask for ID verification — do it now, can take a day
- Don't buy a server yet — just the account
- 💾 **Save:** your login

### 3. Anthropic — [console.anthropic.com](https://console.anthropic.com)
- Sign up → **API Keys** → **Create Key** → copy the key
- Go to **Billing** → add a payment method (you won't be charged until you use it)
- 💾 **Save:** your API key

### 4. Backblaze — [backblaze.com](https://backblaze.com)
- Sign up for a free account
- Go to **Buckets** → **Create Bucket** → name it `cloud-home-backup` → create it
- On the bucket page, note the **Endpoint URL** (looks like `https://s3.us-west-004.backblazeb2.com`)
- Go to **App Keys** → **Create App Key** → copy both the Key ID and the App Key
- 💾 **Save:** Endpoint URL, Key ID, App Key

## ✅ Generate your SSH key

An SSH key is how your laptop securely connects to your server — like a key to a door. Do this on your current laptop.

Open a terminal:
- **Mac:** Cmd+Space → type Terminal → open it
- **Windows:** Windows key → type PowerShell → open it

Run:
```
ssh-keygen -t ed25519
```
Press Enter three times.

Then run:
```
cat ~/.ssh/id_ed25519.pub
```
This prints one long line of text.

💾 **Save:** copy and paste that line somewhere safe — you'll need it when setting up the server.

---

> ✅ **You're done with Part 1.** Save everything in one place (a notes app, doc, etc). When your new computer arrives, go to Part 2.

---

# PART 2 — Setting up your cloud (on your new computer)

Total time: ~45 minutes.

---

## Step 1 — Set up your server (10 min)

1. Log into **Hetzner** → **New Project** → name it "Cloud Home"
2. Click **Add Server** → pick these settings:

| Setting | Choose |
|---|---|
| Location | Falkenstein |
| Image | Ubuntu 24.04 |
| Type | **CX22 — €3.29/mo** (Claude AI only) or **CX32 — €8.24/mo** (Claude + free local AI) |
| SSH Keys | Click **Add SSH Key** → paste the line you saved in Part 1 → name it "my laptop" |

3. Click **Create & Buy Now**
4. 💾 **Save:** the server IP address shown on the dashboard (looks like `65.108.123.45`)

---

## Step 2 — Point your domain to your server (5 min)

1. Log into **Cloudflare** → click your domain → **DNS** in the left menu
2. Click **Add Record**:

| Field | Value |
|---|---|
| Type | A |
| Name | `*` |
| IPv4 address | your server IP |
| Proxy status | Grey cloud — DNS only (NOT orange) |

Click Save.

3. Click **Add Record** again:

| Field | Value |
|---|---|
| Type | A |
| Name | `@` |
| IPv4 address | your server IP |
| Proxy status | Grey cloud |

Click Save → wait 5 minutes.

---

## Step 3 — Connect to your server (1 min)

Open a terminal on your new computer and run (replace with your IP):
```
ssh root@YOUR_SERVER_IP
```
If asked "Are you sure?" → type `yes` → Enter.

You're now inside your server.

---

## Step 4 — Install Coolify (3 min)

Coolify is your control panel. It manages all your apps through a website — no more terminal after this.

Paste this into the terminal:
```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Wait ~3 minutes. When done, open your browser and go to:
```
http://YOUR_SERVER_IP:8000
```
Create your admin account (username + password).

---

## Step 5 — Configure your domain in Coolify (2 min)

1. Coolify → **Settings** (left sidebar)
2. **Instance Domain** → set it to `coolify.YOURDOMAIN.com`
3. Enable **Auto SSL**

Every app you deploy now gets HTTPS automatically.

---

## Step 6 — Deploy your apps (10 min)

In Coolify → **+ New Resource** → **Service** → search for each app below.

---

### 🔑 Vaultwarden — Passwords

1. Search "Vaultwarden" → Deploy
2. Domain: `vault.YOURDOMAIN.com` → Deploy → wait 30 seconds
3. Go to `https://vault.YOURDOMAIN.com` → **Create Account** → register
4. Back in Coolify → Vaultwarden → **Environment Variables** → set `SIGNUPS_ALLOWED` to `false` → Save + Restart

**On your phone/laptop:** Install the **Bitwarden** app → Settings → Self-hosted → enter `https://vault.YOURDOMAIN.com` → log in.

---

### ☁️ Nextcloud — Files & Photos

1. Search "Nextcloud" → pick **Nextcloud with PostgreSQL** → Deploy
2. Domain: `cloud.YOURDOMAIN.com` → set an admin username + password → Deploy → wait ~2 minutes
3. Go to `https://cloud.YOURDOMAIN.com` → log in

**On your phone/laptop:** Install the **Nextcloud** app → enter your server address → log in → enable auto photo backup.

---

### 🤖 Open WebUI — AI Chat

1. Search "Open WebUI" → Deploy
2. Domain: `ai.YOURDOMAIN.com`
3. Add environment variable: `ANTHROPIC_API_KEY` = your Anthropic key → Deploy → wait 30 seconds
4. Go to `https://ai.YOURDOMAIN.com` → Sign up → pick **Claude** from the model dropdown → chat

> If Claude doesn't appear: Admin Panel → Settings → Connections → Anthropic → confirm key is there → Save.

---

### 🎥 Jellyfin — Movies & Shows (optional)

1. Search "Jellyfin" → Deploy
2. Domain: `media.YOURDOMAIN.com` → Deploy → wait 30 seconds
3. Go to `https://media.YOURDOMAIN.com` → follow the setup wizard

To add your media files to the server, ask Nicara.

---

## Step 7 — Set up backups (5 min)

Coolify → **Settings** → **Backup** → **Add S3 Storage**:

| Field | Value |
|---|---|
| Name | Backblaze |
| Endpoint | your Backblaze endpoint URL (saved in Part 1) |
| Bucket | `cloud-home-backup` |
| Access Key | your Backblaze Key ID |
| Secret Key | your Backblaze App Key |

Click Save → **Backup Now** to test → enable **Scheduled Backups** (daily).

---

## 🎉 You're done

**Monthly cost:** €3–8 server + ~$10/year domain + a few dollars of Claude usage.

---

# Managing everything

Go to `https://coolify.YOURDOMAIN.com` anytime.

| Task | How |
|---|---|
| Restart an app | Click the service → Restart |
| See why something broke | Click the service → Logs |
| Update an app | Click the service → Update |
| Add a new app | New Resource → Service |
| Change a setting | Click the service → Environment Variables |

---

# In 6 months — moving to your own hardware

1. Get a mini PC (~$150 one-time cost) — after that your monthly cost drops to ~€0
2. Install Coolify on it (same command as Step 4)
3. Coolify → Settings → Backup → Restore → pick latest backup
4. Cloudflare → DNS → update IP to your home server's IP
5. Delete the Hetzner server

Everything — files, passwords, AI history — comes with you. See [MIGRATION.md](MIGRATION.md) for details.

---

# Troubleshooting

| Problem | Fix |
|---|---|
| App won't load | Coolify → service → Logs |
| Forgot a password | Coolify → service → Environment Variables |
| Something crashed | Coolify → service → Restart |
| Confused | Ask Nicara 😊 |
