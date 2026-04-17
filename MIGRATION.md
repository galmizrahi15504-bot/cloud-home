# 🚚 Migration Guide

Moving your Cloud Home to new hardware. Takes about 30 minutes.
Everything comes with you — files, passwords, AI history, settings.

---

## When to use this

- Moving from VPS to a home server (mini PC, old laptop, Raspberry Pi 5)
- Upgrading to a bigger server
- Switching hosting providers

---

## Before you migrate: make sure backups are running

Your data lives in Coolify's Docker volumes. To move it, you need a backup on Backblaze B2.

**Set this up now, not when you need to migrate.**

In Coolify → **Settings** → **Backup**:
- Add your Backblaze B2 credentials
- Enable automatic daily backups
- Click **Backup Now** once to confirm it works

If you see a green checkmark — you're protected. ✅

---

## Migration steps

### Step 1 — Set up the new server

On your new machine (home server or new VPS):

```bash
# Install Coolify (same as original setup)
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Go to `http://NEW_SERVER_IP:8000` → create your admin account.

### Step 2 — Restore from backup

In Coolify on the new server:
1. **Settings** → **Backup** → add your Backblaze B2 credentials
2. Click **Restore** → select the most recent backup
3. Coolify restores all your app configs, environment variables, and data volumes

Wait ~10 minutes depending on how much data you have.

### Step 3 — Update DNS

In Cloudflare → DNS:
- Change the `*` and `@` A records from the old server IP to the new server IP

Wait 5 minutes for DNS to update.

### Step 4 — Verify everything works

Open each service in your browser and confirm:
- [ ] `cloud.YOURDOMAIN.com` — your files are there
- [ ] `vault.YOURDOMAIN.com` — your passwords are there
- [ ] `ai.YOURDOMAIN.com` — your Claude connection works
- [ ] `media.YOURDOMAIN.com` — Jellyfin loads (if using)

### Step 5 — Shut down the old server

Once everything is confirmed working on the new machine, delete the old VPS on Hetzner.

---

## What comes with you

| Data | How it migrates |
|---|---|
| All your files (Nextcloud) | Volume backup → restore |
| All your passwords (Vaultwarden) | Volume backup → restore |
| AI chat history (Open WebUI) | Volume backup → restore |
| Media library config (Jellyfin) | Volume backup → restore |
| All app settings and env vars | Coolify config backup → restore |
| SSL certificates | Coolify re-issues them automatically |

---

## Media files (Jellyfin)

Your actual movie/show files are stored wherever you put them on the server (not in a Docker volume). You'll need to copy those separately:

```bash
# From your laptop, copy media files to the new server
scp -r root@OLD_IP:/path/to/media root@NEW_IP:/path/to/media
```

Or use a USB drive if moving to a home server.

---

## Home server setup (month 6)

The recommended home server for this stack:

| Option | Cost | RAM | Good for |
|---|---|---|---|
| Mini PC (N100 chip) | ~$150 one-time | 16GB | Full stack + AI |
| Raspberry Pi 5 (8GB) | ~$80 one-time | 8GB | No heavy local AI |
| Old laptop | Free | Whatever it has | Great if you have one |

After the one-time hardware cost, your monthly cost drops to ~€1/month (just the domain).

Coolify runs identically on home hardware — same setup command, same web UI, same everything.

---

## Not happy with an app? Swap it

Every app in this stack is replaceable. See [SWAP-GUIDE.md](SWAP-GUIDE.md).
Your data is always exportable — you're never locked in.
