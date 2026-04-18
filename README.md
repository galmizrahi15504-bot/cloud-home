# ☁️ Cloud Home + AI Workshop

Your private cloud and full AI lab on one server. Passwords, files, AI chat, AI coding agent, multi-agent research, and workflow automation.

**Cost:** ~€23–48/month depending on AI usage.  
**Time:** ~30 min prep (day before) + ~1 hour setup (setup day).  
**Skill needed:** None. Every command is copy-paste.

---

## What you'll have

| App | URL | Replaces |
|---|---|---|
| 🔑 Passwords | vault.YOURDOMAIN.com | 1Password / LastPass |
| ☁️ Files & Photos | cloud.YOURDOMAIN.com | Google Drive + Google Photos |
| 🤖 AI Chat | ai.YOURDOMAIN.com | ChatGPT |
| 🖥️ AI Coder | code.YOURDOMAIN.com | Cursor / Devin |
| ⚡ Automation | auto.YOURDOMAIN.com | Zapier / Make |
| 🧠 Research Agents | (runs on server) | Manual research |
| 🎥 Movies | media.YOURDOMAIN.com | Netflix (optional) |
| 🛠️ Control Panel | coolify.YOURDOMAIN.com | Manages everything above |

---

# THE DAY BEFORE — Checklist

Print this or keep it on your phone. Do everything you can the day before so setup day is just pasting commands.

### ✅ Accounts to create

- [ ] **Cloudflare** — [cloudflare.com](https://cloudflare.com) → create account → buy a domain (~$10/year) → 💾 write down your **domain name**
- [ ] **Hetzner** — [hetzner.cloud](https://hetzner.cloud) → create account → complete ID verification → 💾 write down your **login**
- [ ] **Anthropic** — [console.anthropic.com](https://console.anthropic.com) → create account → API Keys → Create Key → Billing → add payment method → 💾 write down your **API key** (starts with `sk-ant-`)
- [ ] **Tavily** *(optional, free)* — [tavily.com](https://tavily.com) → create account → copy API key → 💾 write down your **Tavily key**. Gives your AI coder web search. Free tier = 1,000 searches/month.
- [ ] **Backblaze** *(optional, for offsite backups)* — [backblaze.com](https://backblaze.com) → create account → Buckets → Create Bucket named `cloud-home-backup` → App Keys → Create App Key → 💾 write down **endpoint URL**, **Key ID**, **App Key**
- [ ] **Save everything in one note** — you'll need it all on setup day

> ⚠️ **Hetzner ID verification can take up to a day** — that's why you do it now. Everything else is instant.

> 💡 **The SSH key is the only thing that waits for setup day** — it must be generated on the actual PC you'll use.

---

# SETUP DAY

Everything below happens on your new PC, in order. ~1 hour total.

---

# PART 1 — Server & Coolify (~15 min)

### Step 1 — Generate your SSH key

Open a terminal on your new PC:
- **Mac:** Cmd+Space → type "Terminal" → open it
- **Windows:** Windows key → type "PowerShell" → open it

```
ssh-keygen -t ed25519
```

Press **Enter** three times (default location, no password).

Display your public key:

```
cat ~/.ssh/id_ed25519.pub
```

💾 Copy that entire line (starts with `ssh-ed25519`). You'll paste it in the next step.

---

### Step 2 — Create the server

1. Log into [Hetzner Cloud Console](https://console.hetzner.cloud)
2. **New Project** → name it `Cloud Home` → open it
3. **Add Server** with these settings:

| Setting | Value |
|---|---|
| Location | **Falkenstein** |
| Image | **Ubuntu 24.04** |
| Type | **CPX31** — 4 AMD cores, 8GB RAM, 160GB disk |
| SSH Keys | Click **Add SSH Key** → paste your key from Step 1 → name it `laptop` |

4. Click **Create & Buy Now**

💾 Save: **server IP address** from the dashboard (e.g. `65.108.123.45`)

> **Why CPX31?** x86/AMD — every Docker image works. 4 cores + 8GB RAM runs all services side by side. 160GB disk holds your files, photos, and media. Upgrade in 30 seconds if you outgrow it.

---

### Step 3 — Point your domain to the server

1. Log into [Cloudflare](https://cloudflare.com) → click your domain → **DNS** (left menu)
2. Add **two** DNS records:

**Record 1 — wildcard (covers all subdomains):**

| Field | Value |
|---|---|
| Type | `A` |
| Name | `*` |
| IPv4 address | your server IP |
| Proxy status | **DNS only** (grey cloud — if orange, click to toggle OFF) |

**Record 2 — root domain:**

| Field | Value |
|---|---|
| Type | `A` |
| Name | `@` |
| IPv4 address | your server IP |
| Proxy status | **DNS only** (grey cloud) |

> ⚠️ **The cloud MUST be grey, not orange.** Orange breaks Coolify's SSL certificates.

Wait 5 minutes for DNS to propagate.

---

### Step 4 — Install Coolify

Connect to your server:

```
ssh root@YOUR_SERVER_IP
```

Type `yes` when asked about fingerprint, press Enter.

Install Coolify:

```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Wait ~3 minutes. Open in your browser:

```
http://YOUR_SERVER_IP:8000
```

1. Create your admin account (strong password — this controls everything)
2. **Settings** → **Instance Domain** → type `coolify.YOURDOMAIN.com`
3. Turn on **Auto SSL** → **Save**

Your control panel is now live at `https://coolify.YOURDOMAIN.com`.

---

### Step 5 — Lock down your server

Still in the SSH terminal:

```bash
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP (SSL certificate generation)
ufw allow 443/tcp   # HTTPS (all your apps)
ufw allow 8000/tcp  # Coolify panel
ufw --force enable
```

This blocks everything else from the internet. Your apps are only reachable through their proper `https://` domains.

> OpenHands sandboxes still work — Docker internal traffic bypasses the firewall.

---

> ✅ **Server is live and secured.** Everything from here is through Coolify's web UI (except CrewAI).

---

# PART 2 — Personal Cloud (~10 min)

For each app: Coolify → **+ New Resource** → **Service** → search → set domain → **Deploy**.

---

### 🔑 Vaultwarden — Password manager

1. Search `Vaultwarden` → select it
2. Domain: `vault.YOURDOMAIN.com` → **Deploy**
3. Wait ~30 seconds → open `https://vault.YOURDOMAIN.com`
4. Click **Create Account** → register with your email + a strong master password
5. **Lock it down:** Coolify → Vaultwarden → **Environment Variables** → `SIGNUPS_ALLOWED` = `false` → **Save** → **Restart**

**Phone/laptop:** Install the **Bitwarden** app → Settings → Self-hosted → `https://vault.YOURDOMAIN.com` → log in.

---

### ☁️ Nextcloud — Files, photos, documents

1. Search `Nextcloud` → pick **Nextcloud with PostgreSQL**
2. Domain: `cloud.YOURDOMAIN.com` → set admin username + password → **Deploy**
3. Wait ~2 minutes → open `https://cloud.YOURDOMAIN.com` → log in

**Phone:** Install the **Nextcloud** app → `https://cloud.YOURDOMAIN.com` → log in → Settings → Auto Upload → enable for photos.

---

### 🎥 Jellyfin — Movies & shows (optional)

1. Search `Jellyfin` → domain: `media.YOURDOMAIN.com` → **Deploy**
2. Open `https://media.YOURDOMAIN.com` → follow the setup wizard

---

# PART 3 — AI Workshop (~25 min)

Four tools that form your AI system. One Anthropic key powers all of them.

---

### 🤖 Open WebUI — AI chat

Your private ChatGPT. Doesn't train on your conversations.

1. Coolify → **+ New Resource** → **Service** → search `Open WebUI` → select it
2. Domain: `ai.YOURDOMAIN.com` → **Deploy**
3. Wait ~30 seconds → open `https://ai.YOURDOMAIN.com`
4. Click **Sign Up** → create your account (first account = admin)
5. Top-right avatar → **Admin Panel** → **Settings** → **Connections**
6. Find **Anthropic** (or click **+** / **Add Connection** if not visible)
7. Paste your Anthropic API key → click ✓ to verify → **Save**
8. Back to chat → model dropdown → select **Claude Sonnet**

---

### ⚡ n8n — Automation engine

Your private Zapier. Build workflows visually — drag blocks, connect them, set schedules.

1. Coolify → **+ New Resource** → **Service** → search `n8n` → select it
2. Domain: `auto.YOURDOMAIN.com` → **Deploy**
3. Wait ~30 seconds → open `https://auto.YOURDOMAIN.com`
4. Create your owner account (name, email, password)

**Connect Claude to n8n:**

5. Left sidebar → **Credentials** → **Add Credential**
6. Search `Anthropic` → paste your API key → **Save**

---

### 🖥️ OpenHands — AI coding agent

Writes, runs, tests, and debugs code autonomously. Describe what you want in English — it builds it.

1. Coolify → **+ New Resource** → **Docker Compose**
2. **Delete** everything in the editor, paste this exactly:

```yaml
services:
  openhands:
    image: docker.openhands.dev/openhands/openhands:1.6
    container_name: openhands-app
    restart: unless-stopped
    environment:
      - AGENT_SERVER_IMAGE_REPOSITORY=ghcr.io/openhands/agent-server
      - AGENT_SERVER_IMAGE_TAG=1.15.0-python
      - LOG_ALL_EVENTS=true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - openhands-data:/.openhands
    ports:
      - "3000:3000"
    extra_hosts:
      - "host.docker.internal:host-gateway"

volumes:
  openhands-data:
```

3. Click **Save**
4. Find the **Domains** field → type `code.YOURDOMAIN.com`
5. Click **Deploy** → wait ~2 minutes (downloads ~2GB on first run)
6. Open `https://code.YOURDOMAIN.com`

**Configure OpenHands:**

7. Click **Settings** ⚙️
8. **LLM Provider** → **Anthropic**
9. **API Key** → paste your Anthropic key
10. **Model** → `claude-sonnet-4-20250514`
11. *(Optional)* **Search API Key (Tavily)** → paste your Tavily key — lets the AI search the web while coding
12. Click **Save**

Try it: *"Build a Python API that fetches Bitcoin prices every hour and stores them in a database"*

> **Tip:** Sonnet for everyday coding (fast + cheap). Switch to `claude-opus-4-0` for complex architecture decisions.

> **Why port 3000?** OpenHands spawns sandbox containers to run code safely. They connect back through this port. The firewall blocks external access — only Coolify's proxy routes your domain to it.

---

### 🧠 CrewAI — Multi-agent research teams

Teams of AI agents that collaborate — one researches, one analyzes, one writes. The only tool that needs terminal access.

SSH into your server:

```bash
ssh root@YOUR_SERVER_IP
```

**Install everything** (copy-paste this entire block):

```bash
apt update && apt install -y python3 python3-pip python3-venv
mkdir -p /opt/crewai
python3 -m venv /opt/crewai/venv
/opt/crewai/venv/bin/pip install 'crewai[tools]'

cat > /opt/crewai/research_crew.py << 'CREW'
import sys, os
from crewai import Agent, Task, Crew, Process

topic = sys.argv[1] if len(sys.argv) > 1 else "AI agent orchestration best practices"

researcher = Agent(
    role="Senior Research Analyst",
    goal=f"Find comprehensive, accurate information about: {topic}",
    backstory="Expert researcher who digs deep into topics, finding primary sources, data, and expert opinions. Never makes claims without evidence.",
    verbose=True, llm="anthropic/claude-sonnet-4-20250514"
)
analyst = Agent(
    role="Critical Analyst",
    goal="Evaluate research findings for accuracy, identify patterns, and draw meaningful conclusions",
    backstory="Sharp analytical thinker who spots connections others miss. Evaluates evidence critically and separates strong findings from weak ones.",
    verbose=True, llm="anthropic/claude-sonnet-4-20250514"
)
writer = Agent(
    role="Report Writer",
    goal="Create a clear, actionable report from the research and analysis",
    backstory="Writes reports that are thorough but easy to understand. Focuses on what matters and always includes concrete next steps.",
    verbose=True, llm="anthropic/claude-sonnet-4-20250514"
)

t1 = Task(description=f"Research thoroughly: {topic}. Find at least 5 key findings with sources.",
          expected_output="Detailed research with findings, sources, and data points.", agent=researcher)
t2 = Task(description="Analyze the research. Identify strongest insights, contradictions, and implications.",
          expected_output="Analysis with key patterns, reliability assessment, and strategic implications.", agent=analyst)
t3 = Task(description="Write final report: executive summary, key findings, recommendations, next steps.",
          expected_output="Polished markdown report ready to read and act on.", agent=writer)

crew = Crew(agents=[researcher, analyst, writer], tasks=[t1, t2, t3], process=Process.sequential, verbose=True)
print(f"\n🚀 Researching: {topic}\n{'='*60}\n")
result = crew.kickoff()
print(f"\n{'='*60}\n📋 FINAL REPORT\n{'='*60}\n{result}")
CREW

echo ""
echo "✅ CrewAI installed. Research crew ready."
```

**Set your API key** — replace the placeholder with your actual key:

```bash
echo 'ANTHROPIC_API_KEY=sk-ant-PASTE-YOUR-ACTUAL-KEY-HERE' > /opt/crewai/.env
```

**Verify:**

```bash
cat /opt/crewai/.env
```

Should show your real key starting with `sk-ant-`. If it shows the placeholder, run the echo command again.

**Test it:**

```bash
cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
python research_crew.py "best self-hosted AI tools 2026"
```

Three agents collaborate in real time. Takes ~3 minutes, costs a few cents.

---

> ✅ **Full AI Workshop running.** AI chat, AI coder, multi-agent research, and automation — all on your server.

---

# PART 4 — Wiring

How the pieces work together:

```
You (or a schedule / trigger / webhook)
    │
    ▼
┌─────────────────────────────────────┐
│  n8n (auto.YOURDOMAIN.com)          │
│  The brain — orchestrates everything │
│                                      │
│  ┌──→ OpenHands (code.YOURDOMAIN.com)│
│  │      AI writes & tests code       │
│  │                                   │
│  ├──→ CrewAI (server terminal)       │
│  │      Multi-agent deep research    │
│  │                                   │
│  ├──→ Claude API (via Anthropic)     │
│  │      Quick AI questions & tasks   │
│  │                                   │
│  └──→ Nextcloud (cloud.YOURDOMAIN)   │
│         Stores all results           │
└─────────────────────────────────────┘
```

### Automations you can build in n8n

| Workflow | Trigger | What happens |
|---|---|---|
| **Daily briefing** | Every morning at 8am | Claude researches your topics → emails you a summary |
| **GitHub auto-fix** | New issue in your repo | OpenHands investigates → opens a pull request |
| **Research pipeline** | File dropped in Nextcloud folder | CrewAI runs research → saves report to Nextcloud |
| **Trading research** | Daily at market open | CrewAI analyzes market conditions → writes strategy report |
| **Backup checker** | Daily | Verifies backups ran → alerts you if something failed |

All built visually. Drag, drop, connect. No coding.

---

# PART 5 — Backups (~5 min)

### Quick option — Hetzner Snapshots

Hetzner dashboard → your server → **Snapshots** → enable **Automatic Snapshots**.

~€2.80/month. Full server image daily. One click to restore everything.

### Full option — Offsite to Backblaze

If you created a Backblaze account in the day-before prep:

Coolify → **Settings** → **Backup** → **Add S3 Storage**:

| Field | Value |
|---|---|
| Endpoint | your Backblaze endpoint URL |
| Bucket | `cloud-home-backup` |
| Access Key | your Backblaze Key ID |
| Secret Key | your Backblaze App Key |

**Save** → **Backup Now** to test → enable **Scheduled Backups** (daily).

---

# 🎉 Done!

---

# 💰 Monthly cost

### Fixed (always the same)

| Item | Cost |
|---|---|
| Hetzner CPX31 server | €14/month |
| Hetzner snapshots | €3/month |
| Cloudflare domain | ~€1/month |
| **Fixed total** | **~€18/month** |

### AI usage (pay as you go)

| Usage level | Claude API cost | Examples |
|---|---|---|
| Light | ~€5/month | Few AI chats/day, occasional research |
| Medium | ~€15/month | Daily coding + research + automations |
| Heavy | ~€30+/month | Constant OpenHands, multiple daily research crews |

### Monthly totals

| Scenario | Total |
|---|---|
| 💤 Light | **~€23/month** |
| 📊 Medium | **~€33/month** |
| 🔥 Heavy | **~€48+/month** |

> **You're replacing:** ChatGPT Plus ($20/mo) + GitHub Copilot ($10/mo) + Zapier ($20/mo) + 1Password ($3/mo) + Google One ($2/mo) = **$55/month of subscriptions → included.**

---

# Day-to-day reference

| What | Where |
|---|---|
| Manage all apps | `https://coolify.YOURDOMAIN.com` |
| AI chat | `https://ai.YOURDOMAIN.com` |
| AI coding | `https://code.YOURDOMAIN.com` |
| Automations | `https://auto.YOURDOMAIN.com` |
| Files & photos | `https://cloud.YOURDOMAIN.com` |
| Passwords | `https://vault.YOURDOMAIN.com` |
| Movies | `https://media.YOURDOMAIN.com` |

### Research (terminal)
```bash
ssh root@YOUR_SERVER_IP
cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
python research_crew.py "your topic here"
```

### Update OpenHands
Coolify → OpenHands → **Redeploy**.

### More research crews
Add scripts to `/opt/crewai/`: `trading_crew.py`, `code_review_crew.py`, `content_crew.py`, etc.

---

# Scaling

| Need | Solution |
|---|---|
| More power | Hetzner → **Resize** (30 sec, no data loss) |
| Recommended upgrade | CPX31 → **CPX41** (8 cores, 16GB — ~€28/mo) |
| Stop paying monthly | Mini PC (~$150) → install Coolify → restore backup → update DNS → cancel Hetzner. See [MIGRATION.md](MIGRATION.md) |

---

# Troubleshooting

| Problem | Fix |
|---|---|
| Any app won't load | Coolify → service → **Logs** |
| OpenHands stuck | Coolify → OpenHands → **Redeploy** |
| OpenHands won't start | Check Coolify logs. Verify compose YAML is exact. |
| CrewAI API error | `cat /opt/crewai/.env` — must start with `sk-ant-` |
| n8n workflow failed | n8n → **Executions** → click failed run |
| Claude not in Open WebUI | Admin Panel → Connections → verify Anthropic key → refresh |
| Domain "not found" | Cloudflare DNS → IP correct? Proxy OFF (grey cloud)? |
| "Connection refused" | Wait 2 min (still starting) → refresh |
| SSL error | Cloudflare proxy must be OFF (grey). Coolify handles SSL. |
| Out of disk space | `docker system prune` or Hetzner → add Volume |
| Forgot Coolify password | `ssh root@IP` → `docker exec coolify php artisan user:reset-password` |
