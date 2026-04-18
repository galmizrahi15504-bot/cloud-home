# ☁️ Cloud Home + AI Workshop

Your own private cloud **and** AI-powered research & project lab.  
Files, passwords, AI chat, coding agents, multi-agent orchestration.  
~€15/month. No technical knowledge needed. Everything is copy-paste.

---

## What you'll have when done

| App | Your URL | What it does |
|---|---|---|
| Files & Photos | cloud.YOURDOMAIN.com | Google Drive + Google Photos replacement |
| Passwords | vault.YOURDOMAIN.com | 1Password replacement |
| AI Chat | ai.YOURDOMAIN.com | ChatGPT replacement (uses Claude) |
| AI Coder | code.YOURDOMAIN.com | AI that writes & runs code for you |
| Workflow Engine | auto.YOURDOMAIN.com | Connects everything, runs automations |
| Movies & Shows | media.YOURDOMAIN.com | Netflix replacement (optional) |

---

# PART 1 — Before your new computer arrives

All free. ~30 minutes. Do this now so there's zero waiting later.

## ✅ Create these 4 accounts

### 1. Cloudflare — [cloudflare.com](https://cloudflare.com)
- Sign up (free)
- Left menu → **Domain Registration** → search a name you like → buy it (~$10/year)
- This is your address on the internet (e.g. `galcloud.com`)
- 💾 **Write down:** your domain name

### 2. Hetzner — [hetzner.cloud](https://hetzner.cloud)
- Sign up (free)
- They may ask for ID verification — do it now, can take a day
- Don't buy a server yet — just the account
- 💾 **Write down:** your login

### 3. Anthropic — [console.anthropic.com](https://console.anthropic.com)
- Sign up → **API Keys** → **Create Key** → copy the key
- Go to **Billing** → add a payment method (you won't be charged until you use it)
- This is what powers all your AI tools — one key runs everything
- 💾 **Write down:** your API key (starts with `sk-ant-`)

### 4. Backblaze — [backblaze.com](https://backblaze.com)
- Sign up (free)
- **Buckets** → **Create Bucket** → name it `cloud-home-backup` → create it
- On the bucket page, note the **Endpoint URL** (looks like `https://s3.us-west-004.backblazeb2.com`)
- **App Keys** → **Create App Key** → copy both the Key ID and the App Key
- 💾 **Write down:** Endpoint URL, Key ID, App Key

## ✅ Generate your SSH key

This is how your laptop securely talks to your server — like a house key.

Open a terminal:
- **Mac:** Cmd+Space → type Terminal → open it
- **Windows:** Windows key → type PowerShell → open it

Run:
```
ssh-keygen -t ed25519
```
Press Enter three times (no password needed).

Then run:
```
cat ~/.ssh/id_ed25519.pub
```
This prints one long line of text.

💾 **Copy and save** that entire line — you'll paste it during server setup.

---

> ✅ **Part 1 done.** Save everything in one place (notes app, doc, whatever). When your new computer arrives, continue to Part 2.

---

# PART 2 — Set up your server

Total time: ~15 minutes.

## Step 1 — Buy and start the server (5 min)

1. Log into **Hetzner** → **New Project** → name it "Cloud Home"
2. Click **Add Server** → pick these settings:

| Setting | Choose |
|---|---|
| Location | Falkenstein (cheapest, fast in Europe) |
| Image | Ubuntu 24.04 |
| Type | **CPX31** — 4 cores, 8GB RAM, 160GB disk — ~€14/mo |
| SSH Keys | Click **Add SSH Key** → paste the line from Part 1 → name it "my laptop" |

3. Click **Create & Buy Now**
4. 💾 **Write down** the server IP address (looks like `65.108.123.45`)

> **Why CPX31?** It's x86-based (AMD), which means every tool we'll install is guaranteed to work. 4 cores and 8GB RAM handles all your personal apps + AI tools comfortably. If you outgrow it, Hetzner lets you upgrade in 30 seconds.

## Step 2 — Point your domain to the server (5 min)

1. Log into **Cloudflare** → click your domain → **DNS** in the left menu
2. Click **Add Record**:

| Field | Value |
|---|---|
| Type | A |
| Name | `*` |
| IPv4 address | your server IP |
| Proxy status | **Grey cloud — DNS only** (click the orange cloud to toggle it OFF) |

Click Save.

3. Click **Add Record** again:

| Field | Value |
|---|---|
| Type | A |
| Name | `@` |
| IPv4 address | your server IP |
| Proxy status | **Grey cloud** |

Click Save. Wait 5 minutes for it to spread.

## Step 3 — Connect to your server (1 min)

Open a terminal on your new computer and run (replace YOUR_SERVER_IP with the actual IP):
```
ssh root@YOUR_SERVER_IP
```
If asked "Are you sure you want to continue connecting?" → type `yes` → Enter.

You're now inside your server. Everything below is pasted into this terminal window.

## Step 4 — Install Coolify (3 min)

Coolify is your control panel — a website where you manage all your apps. After this, you barely need the terminal again.

```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Wait ~3 minutes. When it finishes, open your browser and go to:
```
http://YOUR_SERVER_IP:8000
```
Create your admin account (pick a strong password — this controls everything).

## Step 5 — Set your domain in Coolify (2 min)

1. Coolify → **Settings** (left sidebar)
2. **Instance Domain** → type `coolify.YOURDOMAIN.com`
3. Turn on **Auto SSL**
4. Save

Now every app you deploy gets a secure HTTPS address automatically.

---

> ✅ **Server is live.** Now let's put things on it.

---

# PART 3 — Deploy your personal cloud apps

In Coolify, click **+ New Resource** → **Service** for each app below.

## 🔑 Vaultwarden — Your password manager

1. Search "Vaultwarden" → Deploy
2. Domain: `vault.YOURDOMAIN.com` → Deploy → wait 30 seconds
3. Open `https://vault.YOURDOMAIN.com` → **Create Account** → register with your email
4. **Lock it down:** Back in Coolify → Vaultwarden → **Environment Variables** → set `SIGNUPS_ALLOWED` to `false` → Save → Restart

**On your phone & laptop:** Install the **Bitwarden** app (free) → Settings → Self-hosted → enter `https://vault.YOURDOMAIN.com` → log in with the account you just created.

---

## ☁️ Nextcloud — Your files & photos

1. Search "Nextcloud" → pick **Nextcloud with PostgreSQL** → Deploy
2. Domain: `cloud.YOURDOMAIN.com` → set an admin username + password → Deploy → wait ~2 minutes
3. Open `https://cloud.YOURDOMAIN.com` → log in

**On your phone:** Install the **Nextcloud** app (free) → enter `https://cloud.YOURDOMAIN.com` → log in → Settings → Auto Upload → turn it on for photos.

---

## 🤖 Open WebUI — Your AI chat

1. Search "Open WebUI" → Deploy
2. Domain: `ai.YOURDOMAIN.com` → Deploy → wait 30 seconds
3. Open `https://ai.YOURDOMAIN.com` → **Sign Up** → create your account (first account becomes admin)
4. **Connect Claude:** Click your profile icon (top-right) → **Admin Panel** → **Settings** → **Connections**
5. Scroll to **Anthropic** → paste your API key → click the green checkmark to verify → **Save**
6. Go back to the chat → click the model dropdown at the top → you'll see Claude models listed → pick **Claude Sonnet**

> **If Claude doesn't appear after step 5:** Refresh the page, then check the model dropdown again. Sometimes it takes a few seconds to load the model list.

---

## 🎥 Jellyfin — Movies & shows (optional)

1. Search "Jellyfin" → Deploy
2. Domain: `media.YOURDOMAIN.com` → Deploy → wait 30 seconds
3. Open `https://media.YOURDOMAIN.com` → follow the setup wizard

---

> ✅ **Personal cloud done.** Now for the powerful stuff.

---

# PART 4 — Deploy your AI Workshop

This turns your server from a file cabinet into a research & project powerhouse.

## ⚡ n8n — Your automation brain

n8n connects all your tools together. Think of it as a robot secretary: "When X happens, do Y, then Z."

1. Coolify → **+ New Resource** → **Service** → search "n8n" → Deploy
2. Domain: `auto.YOURDOMAIN.com` → Deploy → wait 30 seconds
3. Open `https://auto.YOURDOMAIN.com`
4. n8n will ask you to create an owner account — fill in your name, email, and a strong password
5. You're in! This is where you'll build automations later

### Connect Claude to n8n

1. Left menu → **Credentials** → **Add Credential**
2. Search "Anthropic" → paste your API key → Save
3. Now any workflow you build can use Claude as its brain

---

## 🖥️ OpenHands — Your AI coding agent

OpenHands is an AI that writes code, runs it, tests it, and fixes bugs — all by itself. You describe what you want, it builds it.

**Important:** This one needs a couple terminal commands. SSH back into your server:

```bash
ssh root@YOUR_SERVER_IP
```

Now paste this entire block — it creates a startup script for OpenHands:

```bash
cat > /opt/start-openhands.sh << 'EOF'
#!/bin/bash
docker pull docker.openhands.dev/openhands/openhands:latest
docker stop openhands-app 2>/dev/null
docker rm openhands-app 2>/dev/null
docker run -d \
  --restart unless-stopped \
  -e AGENT_SERVER_IMAGE_REPOSITORY=ghcr.io/openhands/agent-server \
  -e LOG_ALL_EVENTS=true \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /root/.openhands:/.openhands \
  -p 3000:3000 \
  --add-host host.docker.internal:host-gateway \
  --name openhands-app \
  docker.openhands.dev/openhands/openhands:latest
EOF
chmod +x /opt/start-openhands.sh
```

Now run it:

```bash
/opt/start-openhands.sh
```

Wait ~2 minutes for it to download everything. Then set up Caddy as a reverse proxy so you can access it at your domain:

```bash
apt install -y caddy
```

```bash
cat > /etc/caddy/Caddyfile << EOF
code.YOURDOMAIN.com {
    reverse_proxy localhost:3000
}
EOF
```

**⚠️ Replace `YOURDOMAIN.com` with your actual domain** in the line above, then run:

```bash
systemctl restart caddy
```

Now open `https://code.YOURDOMAIN.com` in your browser.

### Configure OpenHands

1. Click the **Settings** gear icon
2. **LLM Provider** → select **Anthropic**
3. **API Key** → paste your Anthropic key
4. **Model** → select **claude-sonnet-4-20250514** (best balance of speed + quality for coding)
5. Click **Save**

You're ready — type any coding task in plain English and watch it work.

> **Tip:** Sonnet is great for everyday coding. For complex architecture decisions, switch the model to **claude-opus-4-0** in Settings.

---

## 🧠 CrewAI — Your multi-agent research team

CrewAI lets you assemble teams of AI agents that collaborate. One researches, one analyzes, one writes — and they coordinate automatically.

Still in the server terminal:

### Install CrewAI

```bash
apt install -y python3 python3-pip python3-venv
mkdir -p /opt/crewai
python3 -m venv /opt/crewai/venv
/opt/crewai/venv/bin/pip install crewai 'crewai[tools]'
```

### Save your API key

Replace `sk-ant-YOUR-KEY-HERE` with your actual Anthropic API key:

```bash
cat > /opt/crewai/.env << 'EOF'
ANTHROPIC_API_KEY=sk-ant-YOUR-KEY-HERE
EOF
```

### Create your research crew

Paste this entire block:

```bash
cat > /opt/crewai/research_crew.py << 'CREW'
"""
Deep Research Crew — 3 agents that collaborate on any research topic.
Usage: cd /opt/crewai && source venv/bin/activate && source .env && python research_crew.py "your topic"
"""
import sys
import os
from crewai import Agent, Task, Crew, Process

topic = sys.argv[1] if len(sys.argv) > 1 else "AI agent orchestration best practices"

researcher = Agent(
    role="Senior Research Analyst",
    goal=f"Find comprehensive, accurate information about: {topic}",
    backstory="You are an expert researcher who digs deep, finding primary sources, data, and expert opinions. You never make claims without evidence.",
    verbose=True,
    llm="anthropic/claude-sonnet-4-20250514"
)

analyst = Agent(
    role="Critical Analyst",
    goal="Evaluate research findings for accuracy, identify patterns, and draw conclusions",
    backstory="You are a sharp analytical thinker who spots connections others miss. You separate strong findings from weak ones.",
    verbose=True,
    llm="anthropic/claude-sonnet-4-20250514"
)

writer = Agent(
    role="Report Writer",
    goal="Create a clear, actionable report from the research and analysis",
    backstory="You write reports that are easy to understand but thorough. You focus on what matters and always include concrete next steps.",
    verbose=True,
    llm="anthropic/claude-sonnet-4-20250514"
)

research_task = Task(
    description=f"Research this topic thoroughly: {topic}. Find at least 5 key findings with sources.",
    expected_output="A detailed research document with findings, sources, and key data points.",
    agent=researcher
)

analysis_task = Task(
    description="Analyze the research findings. Identify the strongest insights, any contradictions, and what it all means.",
    expected_output="An analysis highlighting key patterns, reliability of findings, and strategic implications.",
    agent=analyst
)

report_task = Task(
    description="Write a final report combining the research and analysis. Include: summary, key findings, recommendations, and next steps.",
    expected_output="A polished report in markdown format, ready to read and act on.",
    agent=writer
)

crew = Crew(
    agents=[researcher, analyst, writer],
    tasks=[research_task, analysis_task, report_task],
    process=Process.sequential,
    verbose=True
)

print(f"\n🚀 Starting deep research on: {topic}\n{'='*60}\n")
result = crew.kickoff()
print(f"\n{'='*60}\n📋 FINAL REPORT\n{'='*60}\n")
print(result)
CREW
```

### Test it

```bash
cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
python research_crew.py "best self-hosted AI tools 2026"
```

You'll see three AI agents discussing and building on each other's work in real time. The final output is a polished research report.

---

> ✅ **AI Workshop deployed.** Now let's make everything talk to each other.

---

# PART 5 — Wire it all together

## How the pieces cooperate

```
You (or a schedule/trigger)
    │
    ▼
  n8n — your automation brain (auto.YOURDOMAIN.com)
    │
    ├──→ OpenHands — for coding tasks (code.YOURDOMAIN.com)
    │       AI writes, tests, and deploys code
    │
    ├──→ CrewAI — for research tasks (runs on server)
    │       Multiple AI agents collaborate on complex research
    │
    ├──→ Open WebUI / Claude — for quick AI questions (ai.YOURDOMAIN.com)
    │
    └──→ Nextcloud — saves all results to your files (cloud.YOURDOMAIN.com)
```

## Example: Automated research pipeline in n8n

1. Open `https://auto.YOURDOMAIN.com`
2. **Workflows** → **Add Workflow** → name it "Deep Research"
3. Build this flow by dragging nodes from the left panel:

**Manual Trigger** (click to start)  
→ **AI Agent** node (set to Anthropic Claude — uses the credential you added earlier)  
→ **HTTP Request** node (to save results to Nextcloud via its API)

This is visual — you drag, drop, and connect boxes. No coding.

### More automations you can build

| Automation | What it does |
|---|---|
| Daily briefing | Every morning, Claude researches topics you care about and sends you a summary |
| GitHub watcher | When a new issue appears in your repo, triggers OpenHands to investigate |
| Research pipeline | Drop a topic in a Nextcloud folder → full report appears an hour later |
| Backup monitor | Checks if backups ran, alerts you if something failed |
| Trading research | CrewAI agents analyze market data and write strategy reports |

---

# PART 6 — Backups

Coolify → **Settings** → **Backup** → **Add S3 Storage**:

| Field | Value |
|---|---|
| Name | Backblaze |
| Endpoint | your Backblaze endpoint URL from Part 1 |
| Bucket | `cloud-home-backup` |
| Access Key | your Backblaze Key ID |
| Secret Key | your Backblaze App Key |

Click Save → **Backup Now** to test → turn on **Scheduled Backups** (daily).

---

# 🎉 You're done

## What you're running

| Layer | Apps | Purpose |
|---|---|---|
| **Personal Cloud** | Nextcloud, Vaultwarden, Jellyfin | Your digital life |
| **AI Chat** | Open WebUI + Claude | Ask AI anything, anytime |
| **AI Coder** | OpenHands + Claude | AI builds code projects for you |
| **Automation** | n8n | Connects everything, runs workflows |
| **Research** | CrewAI + Claude | Teams of AI agents research together |

## Monthly cost

| Item | Cost |
|---|---|
| Hetzner CPX31 | ~€14/month |
| Domain (Cloudflare) | ~€1/month |
| Claude AI usage | ~€5–30/month (pay as you go) |
| Backblaze backups | ~€1/month |
| **Total** | **~€20–45/month** |

---

# Day-to-day usage

## Managing your apps

Go to `https://coolify.YOURDOMAIN.com` anytime.

| Task | How |
|---|---|
| Restart an app | Click the service → Restart |
| Check what went wrong | Click the service → Logs |
| Update an app | Click the service → Update |
| Add a new app | New Resource → Service |
| Change a setting | Click the service → Environment Variables |

## Using OpenHands (AI Coder)

1. Open `https://code.YOURDOMAIN.com`
2. Type what you want in plain English: "Build me a Python script that tracks stock prices"
3. Watch it work — it writes code, creates files, runs tests, fixes its own mistakes
4. Download or copy the result when done

## Using CrewAI (Research Teams)

```bash
ssh root@YOUR_SERVER_IP
cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
python research_crew.py "your research topic here"
```

Or trigger it automatically from n8n.

## Using n8n (Automations)

1. Open `https://auto.YOURDOMAIN.com`
2. Create workflows visually — drag, drop, connect
3. Trigger manually or set a schedule (every hour, daily, weekly, etc.)

## Updating OpenHands

When a new version comes out:

```bash
ssh root@YOUR_SERVER_IP
/opt/start-openhands.sh
```

That's it — it pulls the latest version and restarts.

---

# Adding more power later

## More CrewAI teams

Create new scripts in `/opt/crewai/` for different jobs:
- `trading_crew.py` — analyzes markets and trading strategies
- `code_review_crew.py` — reviews code for bugs and improvements
- `content_crew.py` — researches and writes articles or reports

## Upgrade the server

If things feel slow:
1. Hetzner dashboard → your server → **Resize** → pick a bigger plan
2. Takes ~30 seconds, everything keeps running
3. Recommended upgrade path: CPX31 → CPX41 (8 cores, 16GB — ~€28/mo)

## Move to your own hardware

When you want to stop paying monthly:
1. Get a mini PC (~$150 one-time cost)
2. Install Coolify on it (same command as Part 2 Step 4)
3. Restore from backup
4. Update your Cloudflare DNS to your home IP
5. Cancel Hetzner — monthly cost drops to ~€0

See [MIGRATION.md](MIGRATION.md) for the full walkthrough.

---

# Troubleshooting

| Problem | Fix |
|---|---|
| App won't load | Coolify → click that service → Logs |
| OpenHands stuck or crashed | `ssh root@YOUR_SERVER_IP` then `/opt/start-openhands.sh` |
| CrewAI gives an error | Check your key: `cat /opt/crewai/.env` — make sure it starts with `sk-ant-` |
| n8n workflow failed | n8n → Executions tab → click the failed run → see exactly which step broke |
| Domain shows "not found" | Cloudflare → DNS → make sure IP is correct and proxy is OFF (grey cloud, not orange) |
| "Connection refused" on any app | Wait 2 minutes (app might still be starting), then try again |
| Out of disk space | Hetzner dashboard → server → Volumes → add more storage |
| Something else | Ask Nicara 😊 |
