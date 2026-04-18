# ☁️ Cloud Home + AI Workshop

Your private cloud and AI lab. Files, passwords, AI coding agent, research teams, automation.  
~€20/month. Copy-paste every step.

---

## What you'll have

| App | URL | Replaces |
|---|---|---|
| Passwords | vault.YOURDOMAIN.com | 1Password |
| Files & Photos | cloud.YOURDOMAIN.com | Google Drive + Photos |
| AI Chat | ai.YOURDOMAIN.com | ChatGPT |
| AI Coder | code.YOURDOMAIN.com | Cursor / Devin |
| Automation Engine | auto.YOURDOMAIN.com | Zapier |
| Research Agents | (runs on server) | Manual research |
| Movies (optional) | media.YOURDOMAIN.com | Netflix |

---

# PART 1 — Prep (do this now, before your PC arrives)

~30 minutes. All free.

### 1. Buy a domain — [cloudflare.com](https://cloudflare.com)
Sign up → left menu → **Domain Registration** → search a name → buy it (~$10/year).  
💾 Save your **domain name**.

### 2. Create a server account — [hetzner.cloud](https://hetzner.cloud)
Sign up → complete ID verification if asked (can take a day).  
Don't buy a server yet.  
💾 Save your **login**.

### 3. Get an AI key — [console.anthropic.com](https://console.anthropic.com)
Sign up → **API Keys** → **Create Key** → copy it.  
Go to **Billing** → add payment method.  
This one key powers every AI tool in the setup.  
💾 Save your **API key** (starts with `sk-ant-`).

### 4. Generate your SSH key

Open a terminal (Mac: Cmd+Space → Terminal / Windows: PowerShell):

```
ssh-keygen -t ed25519
```

Press Enter three times. Then:

```
cat ~/.ssh/id_ed25519.pub
```

💾 Save that entire line of text.

---

> ✅ **Part 1 done.** Keep all 4 things saved together. Continue when your PC arrives.

---

# PART 2 — Server setup (~15 min)

### Step 1 — Create the server

Hetzner → **New Project** → name it "Cloud Home" → **Add Server**:

| Setting | Pick this |
|---|---|
| Location | Falkenstein |
| Image | Ubuntu 24.04 |
| Type | **CPX31** — 4 AMD cores, 8GB RAM, 160GB disk |
| SSH Keys | **Add SSH Key** → paste your key from Part 1 |

Click **Create & Buy Now**.  
💾 Save the **server IP** (e.g. `65.108.123.45`).

### Step 2 — Point your domain to the server

Cloudflare → your domain → **DNS** → add two records:

| Type | Name | IPv4 address | Proxy |
|---|---|---|---|
| A | `*` | your server IP | **Grey cloud (DNS only)** |
| A | `@` | your server IP | **Grey cloud** |

> ⚠️ If the cloud icon is orange, click it to turn it grey. This is important.

Wait 5 minutes.

### Step 3 — Connect and install Coolify

```
ssh root@YOUR_SERVER_IP
```

Type `yes` if asked. Then paste:

```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Wait ~3 minutes. Open your browser:

```
http://YOUR_SERVER_IP:8000
```

Create your admin account. Then:

1. **Settings** → **Instance Domain** → type `coolify.YOURDOMAIN.com`
2. Turn on **Auto SSL** → **Save**

Coolify is now your control panel for everything.

---

# PART 3 — Personal cloud (quick)

All done through Coolify. Same flow each time:  
**+ New Resource** → **Service** → search → set domain → **Deploy**.

### 🔑 Vaultwarden (passwords)

1. Search "Vaultwarden" → domain: `vault.YOURDOMAIN.com` → **Deploy**
2. Open `https://vault.YOURDOMAIN.com` → **Create Account**
3. Back in Coolify → Vaultwarden → **Environment Variables** → `SIGNUPS_ALLOWED` = `false` → **Save** → **Restart**

Install the **Bitwarden** app on your phone → Settings → Self-hosted → `https://vault.YOURDOMAIN.com`.

### ☁️ Nextcloud (files & photos)

1. Search "Nextcloud" → pick **Nextcloud with PostgreSQL** → domain: `cloud.YOURDOMAIN.com` → set admin user/password → **Deploy**
2. Open `https://cloud.YOURDOMAIN.com` → log in

Install the **Nextcloud** app on your phone → auto upload photos.

### 🎥 Jellyfin (optional — movies & shows)

Search "Jellyfin" → domain: `media.YOURDOMAIN.com` → **Deploy** → follow the setup wizard.

---

# PART 4 — AI Workshop

This is the core. Four tools that work together.

---

## 🤖 Open WebUI — AI chat (your ChatGPT replacement)

1. Coolify → **+ New Resource** → **Service** → search "Open WebUI" → domain: `ai.YOURDOMAIN.com` → **Deploy**
2. Open `https://ai.YOURDOMAIN.com` → **Sign Up** (first account = admin)
3. Top-right → **Admin Panel** → **Settings** → **Connections**
4. Find **Anthropic** (or click "+" to add it) → paste your API key → verify → **Save**
5. Back to chat → model dropdown → pick **Claude Sonnet**

---

## ⚡ n8n — Automation engine (your Zapier replacement)

1. Coolify → **+ New Resource** → **Service** → search "n8n" → domain: `auto.YOURDOMAIN.com` → **Deploy**
2. Open `https://auto.YOURDOMAIN.com` → create your owner account
3. **Credentials** → **Add Credential** → search "Anthropic" → paste your API key → **Save**

Now any workflow you build can use Claude. You create automations by dragging and connecting blocks — no coding.

---

## 🖥️ OpenHands — AI coding agent (builds software for you)

You describe what you want in plain English. It writes the code, runs it, tests it, fixes bugs.

1. Coolify → **+ New Resource** → **Docker Compose**
2. Delete everything in the editor, paste this:

```yaml
services:
  openhands:
    image: docker.openhands.dev/openhands/openhands:latest
    container_name: openhands-app
    restart: unless-stopped
    environment:
      - AGENT_SERVER_IMAGE_REPOSITORY=ghcr.io/openhands/agent-server
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

3. **Save** → Coolify shows the service overview → find the **Domains** field → type `code.YOURDOMAIN.com` → **Deploy**
4. Wait ~2 minutes (first run downloads extra components), then open `https://code.YOURDOMAIN.com`
5. Settings ⚙️ → **Anthropic** → paste API key → model: **claude-sonnet-4-20250514** → **Save**

---

## 🧠 CrewAI — Multi-agent research teams

Multiple AI agents that collaborate: one researches, one analyzes, one writes. They talk to each other and build on each other's work.

SSH into your server:

```bash
ssh root@YOUR_SERVER_IP
```

Paste this entire block — it installs everything and creates a ready-to-use research crew:

```bash
# Install CrewAI
apt update && apt install -y python3 python3-pip python3-venv
mkdir -p /opt/crewai
python3 -m venv /opt/crewai/venv
/opt/crewai/venv/bin/pip install 'crewai[tools]'

# Create the research crew script
cat > /opt/crewai/research_crew.py << 'CREW'
import sys, os
from crewai import Agent, Task, Crew, Process

topic = sys.argv[1] if len(sys.argv) > 1 else "AI agent orchestration best practices"

researcher = Agent(
    role="Senior Research Analyst",
    goal=f"Find comprehensive, accurate information about: {topic}",
    backstory="Expert researcher. Finds primary sources, data, expert opinions. Never claims without evidence.",
    verbose=True, llm="anthropic/claude-sonnet-4-20250514"
)
analyst = Agent(
    role="Critical Analyst",
    goal="Evaluate research findings, identify patterns, draw conclusions",
    backstory="Sharp analytical thinker. Spots connections others miss. Separates strong findings from weak.",
    verbose=True, llm="anthropic/claude-sonnet-4-20250514"
)
writer = Agent(
    role="Report Writer",
    goal="Create a clear, actionable report from research and analysis",
    backstory="Writes thorough but readable reports. Focuses on what matters. Always includes next steps.",
    verbose=True, llm="anthropic/claude-sonnet-4-20250514"
)

research_task = Task(
    description=f"Research thoroughly: {topic}. Find at least 5 key findings with sources.",
    expected_output="Detailed research with findings, sources, and data points.",
    agent=researcher
)
analysis_task = Task(
    description="Analyze the research. Identify strongest insights, contradictions, and implications.",
    expected_output="Analysis with key patterns, reliability assessment, and strategic implications.",
    agent=analyst
)
report_task = Task(
    description="Write final report: summary, key findings, recommendations, next steps.",
    expected_output="Polished markdown report ready to read and act on.",
    agent=writer
)

crew = Crew(
    agents=[researcher, analyst, writer],
    tasks=[research_task, analysis_task, report_task],
    process=Process.sequential, verbose=True
)

print(f"\n🚀 Researching: {topic}\n{'='*60}\n")
result = crew.kickoff()
print(f"\n{'='*60}\n📋 FINAL REPORT\n{'='*60}\n{result}")
CREW

echo "✅ CrewAI installed and ready."
```

Now set your API key — **replace the placeholder with your actual key:**

```bash
echo 'ANTHROPIC_API_KEY=sk-ant-PASTE-YOUR-ACTUAL-KEY-HERE' > /opt/crewai/.env
```

Verify it saved:

```bash
cat /opt/crewai/.env
```

Test it:

```bash
cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
python research_crew.py "best self-hosted AI tools 2026"
```

Three agents work together in real time. Takes a few minutes, costs a few cents.

---

# PART 5 — How it all connects

```
You (or a schedule)
    │
    ▼
  n8n (auto.YOURDOMAIN.com) ← the brain
    │
    ├─→ OpenHands (code.YOURDOMAIN.com) — coding tasks
    ├─→ CrewAI (server) — deep research
    ├─→ Claude API — quick questions
    └─→ Nextcloud (cloud.YOURDOMAIN.com) — saves results
```

### Automations you can build in n8n

| Automation | What it does |
|---|---|
| Daily briefing | Claude researches your topics every morning, sends summary |
| GitHub watcher | New repo issue → OpenHands investigates automatically |
| Research pipeline | Drop topic in Nextcloud folder → research report appears |
| Trading research | CrewAI analyzes markets, writes strategy reports |

All visual. Drag, drop, connect. No coding needed.

---

# PART 6 — Backups (optional but recommended)

**Quick option:** Hetzner dashboard → your server → **Snapshots** → **Create Snapshot**. Enable automatic snapshots (~€2.80/month). Done.

**Full option (offsite):** Create a [Backblaze](https://backblaze.com) account (free) → create a bucket called `cloud-home-backup` → get your Key ID + App Key. Then:

Coolify → **Settings** → **Backup** → **Add S3 Storage**:

| Field | Value |
|---|---|
| Endpoint | your Backblaze endpoint URL |
| Bucket | `cloud-home-backup` |
| Access Key | your Backblaze Key ID |
| Secret Key | your Backblaze App Key |

**Save** → **Backup Now** to test → turn on **Scheduled Backups** (daily).

---

# 🎉 Done

## What's running

| Layer | What | Purpose |
|---|---|---|
| Personal | Vaultwarden, Nextcloud, Jellyfin | Passwords, files, media |
| AI Chat | Open WebUI + Claude | Your ChatGPT |
| AI Coder | OpenHands + Claude | Builds software for you |
| Automation | n8n + Claude | Connects everything |
| Research | CrewAI + Claude | Multi-agent research teams |

## 💰 Price

**Fixed:** ~€15/month (server €14 + domain €1)

**AI usage (Claude API):**

| How you use it | API cost | Total |
|---|---|---|
| Light — few chats, occasional research | ~€5/mo | **~€20/mo** |
| Medium — daily coding + research | ~€15/mo | **~€30/mo** |
| Heavy — constant agents running | ~€30+/mo | **~€45+/mo** |

> ChatGPT Plus is $20/month for just a chatbot. This gives you a full cloud + coding agent + research team + automation engine.

---

# Quick reference

### Manage apps
`https://coolify.YOURDOMAIN.com` — restart, update, check logs, change settings.

### AI Coder
`https://code.YOURDOMAIN.com` — type what you want in plain English.

### Research
```bash
ssh root@YOUR_SERVER_IP
cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
python research_crew.py "your topic"
```

### Automations
`https://auto.YOURDOMAIN.com` — drag, drop, connect, schedule.

### Update OpenHands
Coolify → OpenHands → **Redeploy**.

---

# Scale up later

**More power:** Hetzner → server → **Resize** → bigger plan (30 seconds, no data loss).  
**More research teams:** Create new scripts in `/opt/crewai/` for trading, code review, content, etc.  
**Go self-hosted:** Buy a mini PC (~$150) → install Coolify → restore backup → cancel Hetzner → €0/month. See [MIGRATION.md](MIGRATION.md).

---

# Troubleshooting

| Problem | Fix |
|---|---|
| App won't load | Coolify → service → **Logs** |
| OpenHands stuck | Coolify → OpenHands → **Redeploy** |
| CrewAI error | `cat /opt/crewai/.env` — key should start with `sk-ant-` |
| n8n workflow failed | n8n → **Executions** → click failed run |
| Domain not working | Cloudflare → DNS → IP correct? Proxy OFF (grey cloud)? |
| Connection refused | Wait 2 min (still starting), refresh |
| Out of space | Hetzner → **Volumes** → add storage |
