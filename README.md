# ☁️ Cloud Home

> This repo is your complete guide to setting up your own private cloud.
> Everything is here. Read top to bottom. Nothing to install from this repo — just follow the steps.

---

## What you're building

Right now your stuff lives on other people's computers:
- Files → Google Drive
- Passwords → 1Password / LastPass
- AI → ChatGPT

After this setup, it lives on **your** computer (a small rented server in Germany). You control it. Nobody else has access to it. Costs ~€8/month.

You'll have:

| What | Your address | Replaces |
|---|---|---|
| Files & Photos | cloud.YOURDOMAIN.com | Google Drive + Photos |
| Passwords | vault.YOURDOMAIN.com | 1Password |
| AI Chat (Claude) | ai.YOURDOMAIN.com | ChatGPT |
| Movies & Shows | media.YOURDOMAIN.com | Netflix (optional) |

---

## Why there are no code files in this repo

Normally a setup like this requires lots of config files, scripts, and technical knowledge. We're using a tool called **Coolify** that handles all of that automatically through a web UI. You click to deploy apps, it handles the rest. This repo is just the instructions — no files to edit, no commands to understand.

---

## Before you start — create these 4 accounts

All free. Do this before anything else so you have everything ready.

**1. Cloudflare** — [cloudflare.com](https://cloudflare.com)
Where you buy your domain name (your address on the internet).
Sign up for a free account.

**2. Hetzner** — [hetzner.cloud](https://hetzner.cloud)
Where you rent your server (the computer that runs your apps 24/7).
Sign up for a free account. They may ask for ID — normal, they're a German company.

**3. Anthropic** — [console.anthropic.com](https://console.anthropic.com)
Claude AI. Sign up → **API Keys** → **Create Key** → save the key somewhere safe.
Go to **Billing** → add a payment method. You pay only when you use it (~$0.02 per conversation).

**4. Backblaze** — [backblaze.com](https://backblaze.com)
Where your automatic backups go. Free up to 10GB.
Sign up → **Buckets** → **Create Bucket** → name it `cloud-home-backup`.
Then → **App Keys** → **Create App Key** → save the Key ID and App Key.
On the bucket page, also note your **Endpoint URL** (looks like `https://s3.us-west-004.backblazeb2.com`) — you'll need it later.

---

## Step 1 — Buy a domain name (5 min)

A domain is your address on the internet. Something like `galcloud.com` or `myprivatecloud.net`.

1. Log into **Cloudflare** → left menu → **Domain Registration** → **Register Domains**
2. Search for a name you like
3. Buy it (~$10/year)

✅ You now have your address on the internet.

---

## Step 2 — Rent your server (5 min)

1. Log into **Hetzner** → **New Project** → name it "Cloud Home"
2. Click **Add Server** and pick exactly these settings:

| Setting | Choose |
|---|---|
| Location | Falkenstein |
| Image | Ubuntu 24.04 |
| Type | **CX22 (€3.29/mo)** — if you mainly want Claude AI |
| | **CX32 (€8.24/mo)** — if you also want free local AI models |
| SSH Keys | See note below ↓ |

### Setting up your SSH key (one time only)

An SSH key is how your laptop proves to the server that it's you — like a physical key to a door.

Open a terminal on your laptop:
- **Mac:** press Cmd+Space → type "Terminal" → open it
- **Windows:** press Windows key → type "PowerShell" → open it

Run this:
```
ssh-keygen -t ed25519
```
Press Enter three times (no passphrase needed).

Then run:
```
cat ~/.ssh/id_ed25519.pub
```
This prints a long line of text. Copy the whole thing.

Back on Hetzner → click **Add SSH Key** → paste that line → name it "my laptop" → save.

3. Click **Create & Buy Now**
4. **Write down the IP address** shown on the dashboard — looks like: `65.108.123.45`

✅ Your server is running 24/7 from this moment.

---

## Step 3 — Connect your domain to your server (5 min)

This tells the internet: "when someone types anything.yourdomain.com, send them to my server."

1. Log into **Cloudflare** → click your domain → **DNS** in the left menu
2. Click **Add Record**:

| Field | Value |
|---|---|
| Type | A |
| Name | `*` |
| IPv4 address | your server IP |
| Proxy status | **Grey cloud** (DNS only — NOT orange) |

Click Save.

3. Click **Add Record** again:

| Field | Value |
|---|---|
| Type | A |
| Name | `@` |
| IPv4 address | your server IP |
| Proxy status | **Grey cloud** |

Click Save. Wait 5 minutes.

✅ Your domain now points to your server.

---

## Step 4 — Connect to your server (1 min)

Open your terminal and type (swap in your actual IP):
```
ssh root@YOUR_SERVER_IP
```

If it asks "Are you sure you want to continue?" → type `yes` → Enter.

You're now inside your server. Any command you type runs on that computer in Germany.

✅ You're in.

---

## Step 5 — Install Coolify — your control panel (3 min)

Coolify manages all your apps. After this step you never need the terminal again — everything runs through a website.

Paste this one line into the terminal:
```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Wait about 3 minutes. When it finishes, open your browser and go to:
```
http://YOUR_SERVER_IP:8000
```

Create your Coolify admin account (pick a username and password — this is your control panel login).

✅ Your control panel is live.

---

## Step 6 — Configure your domain in Coolify (2 min)

1. In Coolify → **Settings** (left sidebar)
2. Find **Instance Domain** → set it to: `coolify.YOURDOMAIN.com`
3. Turn on **Auto SSL**

Every app you deploy from now on gets a secure HTTPS connection automatically.

✅ SSL is handled.

---

## Step 7 — Deploy your apps (10 min)

In Coolify → click **+ New Resource** → **Service** → browse the app catalog.

---

### 🔑 Passwords — Vaultwarden

**What it is:** Your own private password manager. Works with the Bitwarden app on your phone/laptop.

**Deploy:**
1. Search "Vaultwarden" → click it → click **Deploy**
2. Set domain: `vault.YOURDOMAIN.com`
3. Click **Deploy** → wait ~30 seconds

**Set up:**
- Go to `https://vault.YOURDOMAIN.com`
- Click **Create Account** → fill in your details
- After your account is created: go back to Coolify → Vaultwarden → **Environment Variables** → change `SIGNUPS_ALLOWED` from `true` to `false` → **Save + Restart**
  *(This stops anyone else from registering on your server)*

**On your devices:**
- Install the **Bitwarden** app (phone + laptop)
- Go to Settings → Self-hosted → Server URL → enter `https://vault.YOURDOMAIN.com`
- Log in with your account

✅ Your passwords now live on your own server.

---

### ☁️ Files & Photos — Nextcloud

**What it is:** Your own Google Drive + Google Photos in one.

**Deploy:**
1. Search "Nextcloud" → pick **Nextcloud with PostgreSQL** → click **Deploy**
2. Set domain: `cloud.YOURDOMAIN.com`
3. Set an admin username and password (write these down)
4. Click **Deploy** → wait ~1–2 minutes

**Set up:**
- Go to `https://cloud.YOURDOMAIN.com`
- Log in with the username and password you just set
- Install the **Nextcloud** app on your phone and laptop → enter your server address → log in
- On your phone: enable **Auto Upload** for photos in the Nextcloud app

✅ Your files and photos now sync to your own server.

---

### 🤖 AI Chat — Open WebUI (Claude)

**What it is:** A chat interface like ChatGPT, but connected to Claude and running on your server.

**Deploy:**
1. Search "Open WebUI" → click it → click **Deploy**
2. Set domain: `ai.YOURDOMAIN.com`
3. Add an environment variable:
   - Name: `ANTHROPIC_API_KEY`
   - Value: your Anthropic key (from the "Before you start" section)
4. Click **Deploy** → wait ~30 seconds

**Set up:**
- Go to `https://ai.YOURDOMAIN.com`
- Click **Sign up** → create your account *(first account = admin)*
- Select **Claude** from the model dropdown → start chatting

> **If Claude doesn't appear in the dropdown:**
> Go to Admin Panel (top-right menu) → Settings → Connections → Anthropic → confirm your API key is there → Save.

✅ Claude is ready. You pay per message, not per month (~$0.02 per conversation).

---

### 🎥 Movies & Shows — Jellyfin (optional)

**What it is:** Your own Netflix. Only set this up if you have movie or show files to watch.

**Deploy:**
1. Search "Jellyfin" → click it → click **Deploy**
2. Set domain: `media.YOURDOMAIN.com`
3. Click **Deploy** → wait ~30 seconds
4. Go to `https://media.YOURDOMAIN.com` → follow the setup wizard

To add your media files to the server, ask Nicara — it's one simple command.

✅ Your media server is running.

---

## Step 8 — Set up backups (5 min)

Protects everything if the server ever has a problem.

In Coolify → **Settings** → **Backup** → **Add S3 Storage**:

| Field | Value |
|---|---|
| Name | Backblaze |
| Endpoint | Your Backblaze bucket endpoint (from "Before you start") |
| Bucket | `cloud-home-backup` |
| Access Key | your Backblaze Key ID |
| Secret Key | your Backblaze App Key |
| Region | `us-west-004` (or whatever matches your endpoint) |

Click **Save** → then **Backup Now** to test it → if it says success, enable **Scheduled Backups** (daily).

✅ Your data backs up automatically every night.

---

## 🎉 Done!

**What you now have:**
- Files & photos syncing to your server
- Passwords on your server
- Claude AI at your own private URL
- Media server (if you set it up)
- Nightly backups to Backblaze

**Monthly cost:** €3–8 server + ~$10/year domain + a few dollars of Claude usage.

---

## Day-to-day management

Go to `https://coolify.YOURDOMAIN.com` anytime.

| What | How |
|---|---|
| Restart an app | Click the service → Restart |
| See why something broke | Click the service → Logs |
| Update an app to latest version | Click the service → Update |
| Add a new app | New Resource → Service |
| Change a setting | Click the service → Environment Variables |

You never need to touch the terminal again.

---

## In 6 months — moving to your own hardware

When you get your own PC or mini server at home:

1. Install Coolify on it (same one command as Step 5)
2. In Coolify → Settings → Backup → Restore → pick the latest backup
3. In Cloudflare → DNS → update the IP to your home server's IP
4. Delete the Hetzner server

Everything comes with you — files, passwords, AI history, settings. Your cost drops to basically €0/month (just the domain).

Full details: [MIGRATION.md](MIGRATION.md)

---

## Can I swap any app for something else?

Yes. Every app here is replaceable and your data is always exportable.
Full details: [SWAP-GUIDE.md](SWAP-GUIDE.md)

---

## Troubleshooting

| Problem | Fix |
|---|---|
| App won't load | Coolify → service → Logs |
| Forgot a password | Coolify → service → Environment Variables |
| Something crashed | Coolify → service → Restart |
| Completely broken | Coolify → service → Redeploy |
| Confused | Ask Nicara 😊 |
