# ☁️ Cloud Home — Setup Guide

> Total time: ~30 minutes.
> After setup you never need the terminal again — everything runs from a web UI.

---

## What you'll have when done

| Service | Address | Replaces |
|---|---|---|
| Files & Photos | cloud.YOURDOMAIN.com | Google Drive + Photos |
| Passwords | vault.YOURDOMAIN.com | 1Password |
| AI Chat (Claude) | ai.YOURDOMAIN.com | ChatGPT |
| Media | media.YOURDOMAIN.com | Netflix (optional) |

---

## Step 1 — Buy a domain (5 min)

1. Go to **cloudflare.com** → Sign up (free)
2. Left menu → **Domain Registration** → search a name
3. Buy it (~$10/year)

✅ Done.

---

## Step 2 — Rent a server (5 min)

1. Go to **hetzner.cloud** → Sign up
2. **New Project** → name it "Cloud Home"
3. **Add Server**:

| Setting | Choose |
|---|---|
| Location | Falkenstein |
| Image | **Ubuntu 24.04** |
| Type | **CX22 — €3.29/month** (if Claude API only, no local AI) |
| | **CX32 — €8.24/month** (if you also want local AI models) |
| SSH Keys | Add your SSH key (see below) |

> **SSH key (one-time setup):** Open terminal on your laptop and run:
> `ssh-keygen -t ed25519` (press Enter 3 times)
> Then run: `cat ~/.ssh/id_ed25519.pub` and paste the result into Hetzner.

4. **Write down your server IP** (shown on the dashboard)

✅ Server is running.

---

## Step 3 — Connect domain to server (5 min)

1. Go to **Cloudflare** → your domain → **DNS**
2. Add two records:

| Type | Name | Value | Proxy |
|---|---|---|---|
| A | * | your server IP | Grey (DNS only) |
| A | @ | your server IP | Grey (DNS only) |

Wait 5 minutes.

✅ Domain points to your server.

---

## Step 4 — Install Coolify (5 min)

Coolify is the control panel for your cloud. Install it once, manage everything from a browser after that.

SSH into your server:
```
ssh root@YOUR_SERVER_IP
```

Run this one command:
```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Wait ~3 minutes.

When it finishes, open your browser and go to:
```
http://YOUR_SERVER_IP:8000
```

Create your Coolify admin account.

✅ You now have a control panel for your server.

---

## Step 5 — Configure your domain in Coolify (2 min)

1. In Coolify → **Settings** (left sidebar)
2. Under **Instance** → set your domain: `coolify.YOURDOMAIN.com`
3. Enable **Auto SSL** (Coolify will get HTTPS certificates automatically)

✅ SSL is now automatic for every app you deploy.

---

## Step 6 — Deploy your apps (10 min)

In Coolify, click **+ New Resource** → **Service** to browse the one-click app catalog.

Deploy each of these:

### 🔑 Vaultwarden (Passwords)
- Search "Vaultwarden" → Deploy
- Set domain: `vault.YOURDOMAIN.com`
- Note the admin token it generates — save it somewhere safe
- Click Deploy → wait ~30 seconds → it's live

### ☁️ Nextcloud (Files & Photos)
- Search "Nextcloud" → Deploy
- Set domain: `cloud.YOURDOMAIN.com`
- Set an admin username and password
- Click Deploy → wait ~1 minute → it's live

### 🤖 Open WebUI (AI Chat)
- Search "Open WebUI" → Deploy
- Set domain: `ai.YOURDOMAIN.com`
- Add environment variable: `ANTHROPIC_API_KEY` = your Claude API key (see Step 7)
- Click Deploy → wait ~30 seconds → it's live

### 🎥 Jellyfin (Media) — optional
- Search "Jellyfin" → Deploy
- Set domain: `media.YOURDOMAIN.com`
- Click Deploy

---

## Step 7 — Add Claude AI (5 min)

1. Go to **console.anthropic.com** → Sign up
2. **API Keys** → **Create Key** → copy it
3. In Coolify → find your Open WebUI service → **Environment Variables**
4. Add: `ANTHROPIC_API_KEY` = paste your key
5. Click **Save** → **Restart**

Go to `ai.YOURDOMAIN.com` → create your account → Claude appears in the model picker.

> **Cost:** Pay only when you use it. ~$0.01–0.05 per conversation. No monthly fee.

---

## Step 8 — Free local AI (optional, CX32 only)

If you picked the CX32 server and want a free private AI model:

In Coolify, find your Open WebUI service and add this environment variable:
```
OLLAMA_BASE_URL=http://ollama:11434
```

Then also deploy **Ollama** from the service catalog.

After it starts, open a terminal and run:
```bash
docker exec ollama ollama pull phi3:mini
```

A free 2.3GB model, runs entirely on your server.

---

## Step 9 — Backups (optional)

In Coolify → **Backups** — you can configure S3-compatible backups (Backblaze B2 works great, free up to 10GB).

Backblaze: **backblaze.com** → sign up → create a bucket and App Key → paste into Coolify.

---

## 🎉 Done!

Monthly cost: **€3–9/month** depending on server size.

---

## Managing everything going forward

Forget the terminal. Everything lives at `http://YOUR_SERVER_IP:8000` (or `coolify.YOURDOMAIN.com` once you set it up):
- **Restart a service** → click Restart
- **Update an app** → click Update (one click, zero downtime)
- **Change a setting** → edit environment variables, click Save
- **Add a new app** → click New Resource

---

## Troubleshooting

| Problem | Fix |
|---|---|
| App won't start | Coolify → your service → click Logs |
| Forgot password | Coolify → service → environment variables |
| Something broke | Coolify → service → Restart |
| Really broken | Coolify → service → Redeploy |
| Confused | Ask Nicara 😊 |
