# 🚀 Getting Started — Day One With Your New Computer

> You just unboxed your laptop. Follow this guide top to bottom.
> Every step tells you exactly what to click and type.
> If you get stuck on ANY step — ask Nicara. I built all of this.

---

## Part 1: Your Laptop (15 min)

### Step 1: Basic setup
- [ ] Power on your new laptop
- [ ] Go through the Windows/Linux setup wizard
- [ ] Connect to your WiFi

### Step 2: Install 4 free apps
Download and install these — we'll connect them later:

| App | Where to Get It | What It's For |
|---|---|---|
| **Bitwarden** | bitwarden.com/download | Your passwords |
| **Nextcloud** | nextcloud.com/install | Your files |
| **Tailscale** | tailscale.com/download | Secure private access |
| **Immich** | Phone App Store / Play Store | Your photos (phone only) |

**Don't set them up yet.** Just install them.

---

## Part 2: Buy Your Cloud (15 min)

### Step 3: Buy a domain name (your digital address)

A domain is like your home address on the internet. You pick a name, and it's yours.

- [ ] Go to **cloudflare.com**
- [ ] Click "Sign Up" → create a free account
- [ ] On the left menu, click **"Domain Registration"**
- [ ] Search for a name you like (e.g., galcloud.com, galworld.net)
- [ ] Buy it (~$10-12 per year)
- [ ] ✅ You now own your digital address!

### Step 4: Rent your server

This is the computer in the cloud that will run everything 24/7.

- [ ] Go to **hetzner.cloud**
- [ ] Click "Sign Up" → create account
- [ ] They may ask to verify your ID — this is normal, they're a German company
- [ ] Once verified, click **"New Project"** → name it "Cloud Home"
- [ ] Click **"Add Server"** and pick these options:

| Setting | What to Pick |
|---|---|
| Location | **Falkenstein** or **Helsinki** |
| Image | **Ubuntu 24.04** |
| Type | **CAX21** (4 CPU, 8GB RAM) — €4.50/month |
| Networking | ✅ Enable **Public IPv4** |
| SSH Key | See below ⬇️ |

**Setting up your SSH key** (this is like a digital key to enter your server):

- [ ] On your laptop, find and open the **Terminal** app:
  - **Windows:** Press the Windows key, type "PowerShell", click it
  - **Mac:** Press Cmd+Space, type "Terminal", click it
  - **Linux:** Press Ctrl+Alt+T

- [ ] A black/dark window opens. This is the terminal. Type this and press Enter:
```
ssh-keygen -t ed25519
```

- [ ] It will ask questions — **just press Enter 3 times** (accepting all defaults)

- [ ] Now type this and press Enter:
```
cat ~/.ssh/id_ed25519.pub
```

- [ ] It will show a long line starting with `ssh-ed25519...` — **select ALL of it and copy it** (Ctrl+C or Cmd+C)

- [ ] Back on Hetzner's website, click **"Add SSH Key"**
- [ ] Paste what you copied into the box
- [ ] Give it a name like "My Laptop"
- [ ] Click **"Create & Buy Now"**

- [ ] ⚠️ **Write down your server's IP address** — it shows on the Hetzner dashboard (looks like: 65.108.123.45)

### Step 5: Connect your domain to your server

This tells the internet "when someone goes to my domain, send them to my server."

- [ ] Go back to **Cloudflare** → click on your domain
- [ ] Click **"DNS"** on the left menu
- [ ] Click **"Add Record"** and fill in:

**Record 1:**
| Field | What to Type |
|---|---|
| Type | **A** |
| Name | **\*** (just an asterisk) |
| IPv4 address | Your server IP (the number you wrote down) |
| Proxy status | Click the orange cloud so it turns **grey** (says "DNS only") |

Click **Save.**

**Record 2:**
| Field | What to Type |
|---|---|
| Type | **A** |
| Name | **@** |
| IPv4 address | Same server IP |
| Proxy status | **Grey cloud** (DNS only) |

Click **Save.**

- [ ] ✅ Wait 5 minutes for it to take effect.

---

## Part 3: Build Your Cloud Home (30 min)

### Step 6: Enter your server

This is where you connect to the computer you just rented.

- [ ] Open your terminal (same black window from before)
- [ ] Type this (replace the IP with YOUR server's IP):
```
ssh root@YOUR_SERVER_IP
```
Example: `ssh root@65.108.123.45`

- [ ] If it asks "Are you sure you want to continue?" → type **yes** and press Enter
- [ ] ✅ You're now inside your server! The prompt changes to something like `root@cloud:~#`

**From now on, everything you type happens on your server, not your laptop.**

### Step 7: Download your Cloud Home

Copy and paste these 3 lines, one at a time, pressing Enter after each:

```
apt install -y git
```
*(wait for it to finish)*

```
git clone https://github.com/galmizrahi15504-bot/cloud-home.git
```
*(wait for it to finish)*

```
cd cloud-home
```

### Step 8: Run the automatic setup

```
bash scripts/setup.sh
```

☕ **Wait about 5 minutes.** It's installing everything your server needs. You'll see lots of text scrolling — that's normal. When it's done, you'll see "SETUP COMPLETE!"

### Step 9: Create your secret passwords

```
cp .env.example .env
bash scripts/generate-secrets.sh
```

This auto-creates strong passwords for all your services. Now you just need to add YOUR details:

```
nano .env
```

**A text editor opens.** Use arrow keys to move around. Change these 3 lines:

| Find This Line | Change It To |
|---|---|
| `DOMAIN=yourdomain.com` | `DOMAIN=whatever-you-bought.com` |
| `ACME_EMAIL=you@yourdomain.com` | `ACME_EMAIL=your-real-email@gmail.com` |
| `TIMEZONE=UTC` | `TIMEZONE=Asia/Jerusalem` (or your timezone) |

**To save and exit:**
1. Press **Ctrl+X** (at the same time)
2. It asks "Save?" — press **Y**
3. Press **Enter**

### Step 10: Set up your login

First, create your password hash (a scrambled version of your password for security):

```
docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password 'CHOOSE_YOUR_PASSWORD_HERE'
```

⚠️ **Replace** `CHOOSE_YOUR_PASSWORD_HERE` **with an actual password you'll remember!** Keep the quotes around it.

It will print something like: `$argon2id$v=19$m=65536,t=3,p=4$abc123...`

**Select that entire line and copy it.**

Now open the user file:

```
nano authelia/users_database.yml
```

You'll see a file that looks like this:
```
users:
  gal:
    disabled: false
    displayname: "Gal"
    password: "$argon2id$v=19$m=65536,t=3,p=4$REPLACE_WITH_YOUR_HASH"
    email: gal@yourdomain.com
```

- [ ] Delete the old password line (everything between the quotes after `password:`)
- [ ] Paste your new hash there
- [ ] Change the email to your real email
- [ ] Save: **Ctrl+X** → **Y** → **Enter**

### Step 11: Launch! 🚀

```
bash scripts/start.sh
```

**Wait 2 minutes.** Then open your browser and go to:

```
https://dash.YOUR-DOMAIN.com
```

(replace with your actual domain)

- [ ] You should see a login page!
- [ ] Username: **gal**
- [ ] Password: the one you chose in Step 10
- [ ] It will ask you to set up 2FA — scan the QR code with your phone's camera or authenticator app

**🎉 YOUR CLOUD HOME IS LIVE!**

---

## Part 4: Connect Your Apps (15 min)

### Step 12: Your passwords (Vaultwarden)

- [ ] Open your browser → go to `https://vault.YOUR-DOMAIN.com`
- [ ] Click "Create Account"
- [ ] Set your email + master password
- [ ] Now open the **Bitwarden** app/extension you installed earlier
- [ ] Before logging in, look for **"Self-hosted"** in settings
- [ ] Enter: `https://vault.YOUR-DOMAIN.com`
- [ ] Log in with the account you just created
- [ ] ✅ Start saving passwords here from now on!

### Step 13: Your files (Nextcloud)

- [ ] Open browser → go to `https://cloud.YOUR-DOMAIN.com`
- [ ] Log in with:
  - Username: **admin**
  - Password: find `NEXTCLOUD_ADMIN_PASSWORD` in your .env file
    - (to check: go back to terminal and type `grep NEXTCLOUD .env`)
- [ ] Open the **Nextcloud desktop app** you installed
- [ ] Enter server: `https://cloud.YOUR-DOMAIN.com`
- [ ] Log in → choose folders to sync
- [ ] ✅ Your files now sync between laptop and cloud!

### Step 14: Your photos (Immich)

- [ ] Open browser → go to `https://photos.YOUR-DOMAIN.com`
- [ ] Click "Getting Started" → create your account
- [ ] On your **phone**: open the Immich app
- [ ] Enter server: `https://photos.YOUR-DOMAIN.com`
- [ ] Log in → enable automatic photo backup
- [ ] ✅ Every photo you take now backs up to YOUR server!

### Step 15: Lock it down

Go back to your terminal (where you're connected to the server) and run:

```
bash scripts/harden.sh
```

This adds extra security automatically. Done.

---

## Part 5: The Fun Stuff (Week 2, Take Your Time)

### Your private AI

- [ ] Go to `https://ai.YOUR-DOMAIN.com`
- [ ] Create an account
- [ ] In your terminal, download a free AI model:
```
docker exec ollama ollama pull phi3:mini
```
- [ ] Go back to the AI page → start chatting! It's your own private ChatGPT.

### Your Netflix (when you have movies)

- [ ] Go to `https://media.YOUR-DOMAIN.com`
- [ ] Follow the Jellyfin setup wizard

### Your Spotify (when you have music)

- [ ] Go to `https://music.YOUR-DOMAIN.com`
- [ ] Set up Navidrome

---

## Part 6: Make Sure Everything Works ✅

Open each of these in your browser:

- [ ] `https://dash.YOUR-DOMAIN.com` — Dashboard shows up
- [ ] `https://vault.YOUR-DOMAIN.com` — Password vault works
- [ ] `https://cloud.YOUR-DOMAIN.com` — File storage works
- [ ] `https://photos.YOUR-DOMAIN.com` — Photo backup works
- [ ] `https://ai.YOUR-DOMAIN.com` — AI chat works
- [ ] `https://status.YOUR-DOMAIN.com` — Shows all services green

### Turn on automatic backups

In your terminal:
```
bash scripts/backup.sh
```

If it finishes without errors, your backups are working. They'll now run automatically every night.

---

## 🎉 That's It. You're Done.

Your entire digital life is now:
- ✅ On YOUR server
- ✅ Protected by 2FA + firewall
- ✅ Backing up every night
- ✅ Accessible from anywhere
- ✅ ~€10/month

---

## 🆘 Something Went Wrong?

| What Happened | What To Do |
|---|---|
| **A page won't load** | In terminal: `bash scripts/start.sh` (restarts everything) |
| **Forgot your password** | Redo Step 10 to make a new one |
| **Server seems broken** | Delete it on Hetzner, make a new one, start from Step 6 (your domain stays) |
| **Totally lost** | Message Nicara. I built every piece. I'll walk you through it. |

The most important thing: **you can't permanently break anything.** Worst case, delete the server and start fresh. Your domain and backups survive everything.

---

*You got this, Gal. One afternoon. That's all it takes.* 🚀
