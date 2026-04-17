# ☁️ Cloud Home — Setup Guide

> Everything here is copy-paste. You don't need to understand how it works to follow it.
> If something goes wrong, ask Nicara — you can't permanently break anything.

---

## What you're building

Right now your stuff lives on other people's computers:
- Files → Google Drive
- Passwords → 1Password / LastPass
- AI → ChatGPT

After this setup, it lives on **your** computer (a small rented server). You control it. Nobody else has access. Costs ~€8/month total.

You'll have:

| What | Address | Replaces |
|---|---|---|
| Files & Photos | cloud.YOURDOMAIN.com | Google Drive + Photos |
| Passwords | vault.YOURDOMAIN.com | 1Password |
| AI Chat (Claude) | ai.YOURDOMAIN.com | ChatGPT |
| Movies & Shows | media.YOURDOMAIN.com | Netflix (optional) |

---

## Before you start — create these accounts

These are all free. Do this first so you have everything ready.

**1. Cloudflare** — cloudflare.com
This is where you buy your domain name and manage your address on the internet.
Sign up for a free account.

**2. Hetzner** — hetzner.cloud
This is where you rent your server (the computer in Germany).
Sign up for a free account. They may ask for ID — normal, they're German.

**3. Anthropic** — console.anthropic.com
This is Claude (the AI). Sign up, go to **API Keys**, create a key, and save it somewhere.
Also go to **Billing** and add a payment method. You pay only when you use it — a normal conversation costs about $0.02.

**4. Backblaze** — backblaze.com
This is where your automatic backups go. Free up to 10GB.
Sign up, then go to **App Keys** → **Create an App Key**. Save the Key ID and the App Key.
Also go to **Buckets** → **Create a Bucket**, name it `cloud-home-backup`.

---

## Step 1 — Buy a domain name (5 min)

A domain is your address on the internet. Something like `galcloud.com` or `myprivatecloud.net`.

1. Log into **Cloudflare** → left menu → **Domain Registration** → **Register Domains**
2. Search for a name you like
3. Buy it (~$10/year)

You now have your address. ✅

---

## Step 2 — Rent your server (5 min)

1. Log into **Hetzner** → **New Project** → name it "Cloud Home"
2. Click **Add Server** and pick exactly these settings:

| Setting | Pick This |
|---|---|
| Location | Falkenstein |
| Image | Ubuntu 24.04 |
| Type | **CX22** (€3.29/mo) if you only want Claude AI |
| | **CX32** (€8.24/mo) if you also want free local AI models |
| SSH Keys | See note below ↓ |

**Setting up your SSH key (one time only):**
An SSH key is how your laptop proves to the server that it's you — like a key to a door.

On your laptop, open a terminal and run:
```
ssh-keygen -t ed25519
```
Press Enter three times (no need to set a passphrase).

Then run:
```
cat ~/.ssh/id_ed25519.pub
```
This prints a long line of text. Copy it.

Back on Hetzner, click **Add SSH Key**, paste that line, give it a name like "my laptop", save.

3. Click **Create & Buy Now**
4. **Write down the IP address** shown on the dashboard (looks like: 65.108.123.45)

Your server is running 24/7 from this moment. ✅

---

## Step 3 — Connect your domain to your server (5 min)

This is how `yourdomain.com` knows to point to your server.

1. In Cloudflare → click your domain → **DNS** in the left menu
2. Click **Add Record** and fill in:

| Field | Value |
|---|---|
| Type | A |
| Name | * |
| IPv4 address | your server IP |
| Proxy status | Grey cloud (DNS only — NOT orange) |

Click Save.

3. Click **Add Record** again:

| Field | Value |
|---|---|
| Type | A |
| Name | @ |
| IPv4 address | your server IP |
| Proxy status | Grey cloud |

Click Save. Wait 5 minutes.

Your domain now points to your server. ✅

---

## Step 4 — Connect to your server (1 min)

Open a terminal on your laptop and type (replace with your actual IP):
```
ssh root@YOUR_SERVER_IP
```

If it asks "Are you sure you want to continue?" → type `yes` and press Enter.

You're now inside your server. The commands you type here run on that computer in Germany. ✅

---

## Step 5 — Install the control panel (3 min)

Coolify is the software that manages all your apps. Install it by pasting this one line:

```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Wait about 3 minutes while it installs. When it's done, open your browser and go to:
```
http://YOUR_SERVER_IP:8000
```

Create your Coolify admin account (username + password). This is the login for your control panel.

Your control panel is live. You won't need the terminal again after this. ✅

---

## Step 6 — Set up your domain in Coolify (2 min)

1. In Coolify → **Settings** (left sidebar)
2. Find **Instance Domain** and set it to: `coolify.YOURDOMAIN.com`
3. Turn on **Auto SSL**

From now on, every app you deploy will automatically get a secure HTTPS connection. ✅

---

## Step 7 — Deploy your apps (10 min)

In Coolify, click **+ New Resource** → **Service**.
You'll see a list of apps. Find each one below and deploy it.

---

### 🔑 Vaultwarden — Passwords

1. Search "Vaultwarden" → click it → click **Deploy**
2. Set the domain to: `vault.YOURDOMAIN.com`
3. Click **Deploy** and wait ~30 seconds

**After it's running:**
- Go to `vault.YOURDOMAIN.com` in your browser
- Click **Create Account** → fill in your details → create your account
- **Important:** After you create your account, go back to Coolify → Vaultwarden → Environment Variables → change `SIGNUPS_ALLOWED` from `true` to `false` → click **Save + Restart**. This stops anyone else from registering.

On your phone/laptop: install the **Bitwarden** app → go to Settings → point it to `vault.YOURDOMAIN.com` → log in. Your passwords now sync to your own server. ✅

---

### ☁️ Nextcloud — Files & Photos

1. Search "Nextcloud" → pick **Nextcloud with PostgreSQL** → click **Deploy**
2. Set the domain to: `cloud.YOURDOMAIN.com`
3. Set an admin username and password
4. Click **Deploy** and wait ~1 minute

**After it's running:**
- Go to `cloud.YOURDOMAIN.com` → log in with the credentials you just set
- On your phone/laptop: install the **Nextcloud** app → enter your server address → log in
- On your phone: turn on auto photo backup in the app

Your files and photos now sync to your own server. ✅

---

### 🤖 Open WebUI — AI Chat

1. Search "Open WebUI" → click it → click **Deploy**
2. Set the domain to: `ai.YOURDOMAIN.com`
3. Add an environment variable:
   - Name: `ANTHROPIC_API_KEY`
   - Value: your Anthropic key (the one you saved earlier)
4. Click **Deploy** and wait ~30 seconds

**After it's running:**
- Go to `ai.YOURDOMAIN.com`
- Click **Sign up** → create your account (the first account automatically becomes admin)
- Pick **Claude** from the model dropdown → start chatting

You pay Anthropic per message, not per month. A normal back-and-forth conversation costs about $0.02. ✅

---

### 🎥 Jellyfin — Movies & Shows (optional)

Only set this up if you have movie/show files you want to watch.

1. Search "Jellyfin" → click it → click **Deploy**
2. Set the domain to: `media.YOURDOMAIN.com`
3. Click **Deploy** and wait ~30 seconds
4. Go to `media.YOURDOMAIN.com` → follow the setup wizard

To add media, you'll need to copy your files to the server. Ask Nicara when you're ready — it's a simple command. ✅

---

## Step 8 — Set up backups (5 min)

This protects everything if the server ever has a problem.

In Coolify → **Settings** → **Backup** → **Add S3 Storage**:

| Field | Value |
|---|---|
| Name | Backblaze |
| Endpoint | `https://s3.us-west-000.backblazeb2.com` |
| Bucket | cloud-home-backup |
| Access Key | your Backblaze Key ID |
| Secret Key | your Backblaze App Key |

Click **Save** → then **Backup Now** to test it.

Set it to run automatically every night. ✅

---

## That's it! 🎉

**What you have:**
- All your files syncing to your own server
- Your passwords on your own server
- Claude AI available at your own private URL
- Automatic nightly backups

**Your monthly cost:** €3–8 for the server + ~$10/year for the domain + a few dollars/month for Claude depending on how much you use it.

---

## Managing everything day-to-day

Go to `coolify.YOURDOMAIN.com` (or `http://YOUR_SERVER_IP:8000`).

- **Restart something:** click the service → click Restart
- **Something broke:** click the service → click Logs
- **Update an app:** click the service → click Update
- **Add a new app:** click New Resource

You never need to touch the terminal again.

---

## In 6 months — moving to your own hardware

When you get your own PC/mini server at home, the move is:
1. Install Coolify on the new machine (same one command)
2. Restore from your Backblaze backup (one click in Coolify)
3. Change your Cloudflare DNS to point to your home IP (2 minute change)
4. Delete the Hetzner server

Everything — files, passwords, AI history, settings — comes with you.
Your monthly cost drops to basically €0 (just the domain).

For full details: see [MIGRATION.md](MIGRATION.md)

---

## Troubleshooting

| Problem | What to do |
|---|---|
| App won't load | Coolify → find the service → click Logs |
| Forgot a password | Coolify → find the service → Environment Variables |
| Something crashed | Coolify → find the service → click Restart |
| Really confused | Ask Nicara 😊 |
