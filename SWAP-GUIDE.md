# 🔄 Swap Guide — Interchangeability Reference

> Every component in Cloud Home can be replaced. Here's how.

## How to Swap a Service

1. Stop the service: `docker compose -f <file> stop <service>`
2. Export your data (see table below)
3. Update the compose file with the new image + config
4. Import your data into the new service
5. Start: `docker compose -f <file> up -d <service>`
6. Update Caddyfile if port changed

---

## Service Swap Table

| Current | Swap With | Data Export Method | Effort |
|---------|-----------|-------------------|--------|
| **Caddy** | Traefik, Nginx PM, HAProxy | Rewrite Caddyfile as Traefik labels/nginx.conf | Medium |
| **Authelia** | Authentik, Keycloak | Recreate users in new system | Low |
| **Redis** | Valkey, KeyDB, Dragonfly | Drop-in replacement (same protocol) | Trivial |
| **PostgreSQL** | Another PG, CockroachDB | `pg_dump` → `pg_restore` | Low |
| **Nextcloud** | Seafile, OwnCloud | Copy files + export .ics/.vcf for calendar/contacts | Medium |
| **Immich** | PhotoPrism, LibrePhotos | Original photos in `immich_upload` volume — just reimport | Low |
| **Vaultwarden** | Bitwarden, Passbolt | Export via Bitwarden app (JSON/CSV) | Low |
| **Gitea** | Forgejo, GitLab CE | `git clone --mirror` + `git push --mirror` | Low |
| **Ollama** | LocalAI, vLLM, llama.cpp | GGUF model files are standard. Update API URL. | Low |
| **Open WebUI** | LibreChat, LobeChat | Export chats as JSON. Point new UI at same Ollama. | Low |
| **n8n** | Activepieces, Node-RED | Export workflows as JSON. Rebuild triggers. | Medium |
| **Jellyfin** | Plex, Emby | Media files are read-only mounts. Point new server at same dir. | Trivial |
| **Navidrome** | Funkwhale, Airsonic | Music files are read-only mounts. Subsonic API is standard. | Trivial |
| **SearXNG** | Whoogle, Perplexica | Stateless — just swap the image | Trivial |
| **AdGuard Home** | Pi-hole, Blocky | Export blocklists, recreate config | Low |
| **Homepage** | Homarr, Dashy, Flame | Rewrite YAML config for new dashboard | Low |

## Effort Scale

- **Trivial** = Change one line in docker-compose, done
- **Low** = Export data, swap image, import data (~30 min)
- **Medium** = Some config rewriting needed (~1-2 hours)

## Cloud Provider Migration

Moving from Hetzner to anywhere else:

1. Spin up new VPS (DigitalOcean, Vultr, Oracle, AWS, etc.)
2. Run `setup.sh` on new server
3. Run `restore.sh` to pull backups
4. Update DNS A record to new IP
5. Done — same domain, same services, new provider

**Time: ~1 hour including DNS propagation.**

## Key Principle

> Your data is always in **standard, open formats**. Photos are JPEG/PNG. Music is MP3/FLAC. Notes are Markdown. Code is Git. Databases are SQL. Nothing is trapped.
