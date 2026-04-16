# 🚀 Cloud Home — Setup Guide

> Time: ~1 hour. Everything is copy-paste.
> This is your 6-month cloud setup. At month 6, we move to your own hardware.
> Stuck? Ask Nicara. Can't break anything — worst case, delete and redo.

---

## Step 1: Buy a Domain Name (5 min)

This is your address on the internet. You pick a name, it's yours.

1. Go to **cloudflare.com** → Sign Up → make a free account
2. Left menu → **Domain Registration** → search a name you like
3. Buy it (~$10/year)

✅ Done. You now own your digital address.

---

## Step 2: Rent a Server (10 min)

This is the computer in the cloud that runs 24/7 for you.

1. Go to **hetzner.cloud** → Sign Up
2. They may ask for ID verification — normal, it's a German company
3. Click **New Project** → name it "Cloud Home"
4. Click **Add Server** and pick:

| Setting | Pick This |
|---|---|
| Location | **Falkenstein** |
| Image | **Ubuntu 24.04** |
| Type | **CAX21** — €4.50/month |
| Networking | ✅ Public IPv4 |
| SSH Key | Skip for now — pick **no SSH key** |

5. Under **Root Password** — choose a password and **write it down**
6. Click **Create & Buy Now**
7. **Write down the server IP address** (shown on dashboard, looks like: 65.108.123.45)

✅ Done. Your server is running.

---

## Step 3: Connect Domain to Server (5 min)

1. Go to **Cloudflare** → click your domain → **DNS** on left menu
2. Click **Add Record**:

| Field | Type This |
|---|---|
| Type | **A** |
| Name | **\*** |
| IPv4 address | **your server IP** |
| Proxy | Click orange cloud so it's **grey** |

3. Click Save
4. Click **Add Record** again:

| Field | Type This |
|---|---|
| Type | **A** |
| Name | **@** |
| IPv4 address | **your server IP** |
| Proxy | **Grey cloud** |

5. Click Save

✅ Done. Wait 5 minutes.

---

## Step 4: Open the Terminal (1 min)

The terminal is a window where you type commands. That's all it is.

- **Windows:** Press Windows key → type **PowerShell** → click it
- **Mac:** Press Cmd+Space → type **Terminal** → click it
- **Linux:** Press Ctrl+Alt+T

A dark window opens. This is your terminal.

---

## Step 5: Enter Your Server (1 min)

Type this (replace with YOUR server IP):

```
ssh root@YOUR_SERVER_IP
```

It asks for a password → type the password you chose in Step 2.

> **Note:** When you type the password, nothing shows on screen — that's normal! Just type it and press Enter.

If it asks "Are you sure?" → type **yes** → Enter.

✅ You're inside your server now!

---

## Step 6: Install Everything (10 min)

Copy-paste these commands **one at a time**. Press Enter after each. Wait for each to finish before the next.

**Download the code:**
```
apt install -y git
```

```
git clone https://github.com/galmizrahi15504-bot/cloud-home.git
```

```
cd cloud-home
```

**Run the setup:**
```
bash scripts/setup.sh
```
☕ Wait ~5 minutes. When you see "SETUP COMPLETE" → continue.

---

## Step 7: Add Your Details (5 min)

**Generate all passwords automatically:**
```
cp .env.example .env
```

```
bash scripts/generate-secrets.sh
```

**Now add your domain.** This opens a text editor:
```
nano .env
```

Use arrow keys to find and change these 3 lines:

```
DOMAIN=yourdomain.com        ← change to YOUR domain
ACME_EMAIL=you@yourdomain.com  ← change to YOUR email
TIMEZONE=UTC                   ← change to your timezone (e.g. Asia/Jerusalem)
```

Save: press **Ctrl+X** → press **Y** → press **Enter**

---

## Step 8: Create Your Login (5 min)

**Make your password hash** (replace `MyPassword123` with a real password):
```
docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password 'MyPassword123'
```

It prints a long line starting with `$argon2id$...` — **copy that whole line.**

**Put it in the user file:**
```
nano authelia/users_database.yml
```

Find the line that says `password:` → delete the stuff after it → paste your hash.
Also change the email to yours.

Save: **Ctrl+X** → **Y** → **Enter**

---

## Step 9: Launch 🚀 (2 min)

```
bash scripts/start.sh
```

Wait 2 minutes. Then open your browser and go to:

```
https://dash.YOURDOMAIN.com
```

Log in with:
- Username: **gal**
- Password: what you chose in Step 8

It shows a QR code for 2FA → scan it with your phone camera.

**🎉 Your Cloud Home is live!**

---

## Step 10: Connect Your Apps (10 min)

### Passwords
1. Open browser → go to `https://vault.YOURDOMAIN.com`
2. Create an account
3. Open **Bitwarden** app on laptop → Settings → Self-hosted
4. Enter `https://vault.YOURDOMAIN.com` → log in
5. ✅ Start saving all passwords here

### Files
1. Go to `https://cloud.YOURDOMAIN.com`
2. Log in (username: **admin**, password: type this in your terminal to find it):
```
grep NEXTCLOUD_ADMIN_PASSWORD .env
```
3. Open **Nextcloud** app on laptop → enter your cloud URL → log in
4. ✅ Files sync between laptop and cloud

### Photos
1. On your phone → open **Immich** app
2. Enter `https://photos.YOURDOMAIN.com`
3. Create account → turn on auto backup
4. ✅ Every photo backs up to YOUR server

---

## Step 11: Set Up Your AI (5 min)

### Free local AI (runs on your server, completely private)

Download a free AI model — in your terminal:
```
docker exec ollama ollama pull phi3:mini
```

Now open your browser:
1. Go to `https://ai.YOURDOMAIN.com`
2. Create an account
3. Start chatting! Pick **phi3:mini** from the model dropdown.

✅ You now have your own private ChatGPT. Free forever.

### Want smarter AI? Add Anthropic (Claude) — Optional

This connects the same AI that powers me (Nicara). Pay only when you use it — no subscription.

1. Go to **console.anthropic.com**
2. Click **Sign Up** → create account
3. Click **Plans & Billing** → add a payment method (pay-as-you-go)
4. Click **API Keys** → **Create Key** → copy the key

Now connect it to your AI chat:
1. Go to `https://ai.YOURDOMAIN.com`
2. Click your profile icon (top right) → **Admin Panel**
3. Go to **Settings** → **Connections**
4. Under "OpenAI API", click the **+** button
5. Fill in:

| Field | What to Type |
|---|---|
| URL | `https://api.anthropic.com/v1` |
| API Key | Paste your Anthropic key |

6. Click Save

Now when you chat, you can pick **Claude** from the model dropdown.

| Model | Good For | Cost Per Chat |
|---|---|---|
| phi3:mini (local) | Quick questions | Free |
| Claude Sonnet | Real work, thinking | ~$0.02 |
| Claude Opus | Deep research | ~$0.10 |

**Tip:** Use the free local model for everyday stuff. Switch to Claude when you need the big brain. One click to switch.

---

## Step 12: Turn On Backups (2 min)

```
bash scripts/backup.sh
```

If it finishes without errors → ✅ backups work.

They run automatically every night from now on.

---

## 🎉 That's Everything!

**What you have now:**

| Service | URL | What It Does |
|---|---|---|
| Dashboard | dash.YOURDOMAIN.com | See all your services |
| Passwords | vault.YOURDOMAIN.com | Your own 1Password |
| Files | cloud.YOURDOMAIN.com | Your own Google Drive |
| Photos | photos.YOURDOMAIN.com | Your own Google Photos |
| AI Chat | ai.YOURDOMAIN.com | Your own ChatGPT |
| Monitoring | status.YOURDOMAIN.com | Check everything's running |
| Search | search.YOURDOMAIN.com | Private search engine |
| Movies | media.YOURDOMAIN.com | Your own Netflix |
| Music | music.YOURDOMAIN.com | Your own Spotify |

**Monthly cost: ~€10**

**At month 6:** We buy a mini PC (~$150), move everything home, and drop to ~€4.50/month. I'll write that guide when the time comes.

---

## 🆘 Help!

| Problem | Do This |
|---|---|
| Something won't load | In terminal: `bash scripts/start.sh` |
| Forgot password | Redo Step 8 |
| Totally broken | Delete server on Hetzner → start from Step 2 (domain stays, costs €0.01) |
| Confused | Ask Nicara 😊 |
