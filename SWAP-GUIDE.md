# 🔄 Swap Guide

Every app in this stack can be swapped out. Nothing is locked in.
This is how you replace any service without losing your data.

---

## General process for swapping any app

1. Export your data from the old app (instructions below per app)
2. In Coolify → stop the old service
3. Deploy the new service (same domain)
4. Import your data
5. Done — DNS stays the same, URL stays the same

---

## Nextcloud (Files & Photos)

**What your data is:** Files, calendar, contacts, photos

**Export:**
- Files: use the Nextcloud desktop app to sync everything to your laptop first
- Calendar/Contacts: Nextcloud → Settings → export as .ical / .vcf

**Alternatives:**

| App | Good for | Notes |
|---|---|---|
| **Seafile** | Pure file sync, faster than Nextcloud | No calendar/contacts |
| **Syncthing** | Peer-to-peer sync, no server needed | No web UI |
| **Immich** | Photos only, better face recognition | Just photos, not files |

**Import into alternative:** Most accept standard file uploads or WebDAV.

---

## Vaultwarden (Passwords)

**What your data is:** All your passwords, logins, secure notes

**Export:**
- Bitwarden/Vaultwarden app → Settings → **Export Vault** → choose .json or .csv

**Alternatives:**

| App | Notes |
|---|---|
| **Bitwarden** (official) | Same app, official hosted version. Paid but easier. |
| **KeePassXC** | Local-only, no server needed, very secure |
| **Passbolt** | Team-focused, more complex |

**Import:** All accept Bitwarden .json export format.

---

## Open WebUI (AI Chat)

**What your data is:** Chat history, model settings, API keys

**Export:**
- Open WebUI → Settings → **Export Data** (downloads all conversations as JSON)

**Alternatives:**

| App | Good for | Notes |
|---|---|---|
| **LibreChat** | More AI providers, more features | Slightly more complex to set up |
| **Lobe Chat** | Beautiful UI, great UX | Good Claude support |
| **AnythingLLM** | Document chat, RAG | Best if you want to chat with your files |

**Import:** Most have conversation import. API keys (like your Anthropic key) just get re-entered in settings.

---

## Ollama (Local AI Models)

**What your data is:** Downloaded AI models (large files, no real "data" to export)

**Swap process:**
- Just stop Ollama, deploy the alternative
- Re-download the models on the new system (they're public downloads)

**Alternatives:**

| App | Notes |
|---|---|
| **LM Studio** | Desktop app, much easier, no server needed |
| **Jan** | Desktop app, clean UI |

**Note:** If you decide local AI isn't worth it, just remove Ollama entirely and use Claude API only. That's the simplest option.

---

## Jellyfin (Media)

**What your data is:** Watch history, metadata, playlists, user settings

**Export:**
- Jellyfin → Dashboard → **Export Library Metadata** (saves .nfo files alongside media)

**Alternatives:**

| App | Notes |
|---|---|
| **Plex** | More polished, but requires account + can be pushy about subscriptions |
| **Emby** | Between Plex and Jellyfin in complexity |

**Import:** Plex and Emby both read the same media files + .nfo metadata files.

---

## Coolify itself (the control panel)

If you ever want to stop using Coolify:

**Export:** Coolify → Settings → export your service configs
Your data (Docker volumes) lives independently of Coolify and isn't affected.

**Alternatives:**

| App | Notes |
|---|---|
| **Portainer** | More technical, raw Docker UI |
| **Dokku** | Git-based deployments, very lightweight |
| **Raw Docker Compose** | Maximum control, no UI |

---

## The bottom line

You own all your data. Every app here stores it in standard formats.
Passwords → .json. Files → just files. Calendar → .ical. 

If any app stops working, gets abandoned, or you just find something better — you can move without losing anything.
