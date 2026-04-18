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
- 💾 **Write down:** your API key

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
| Type | **CAX31** — 8 cores, 16GB RAM — €11.49/mo |
| SSH Keys | Click **Add SSH Key** → paste the line from Part 1 → name it "my laptop" |

3. Click **Create & Buy Now**
4. 💾 **Write down** the server IP address (looks like `65.108.123.45`)

> **Why CAX31?** It's ARM-based (very efficient), has enough power for all your personal apps AND AI tools running at the same time, and it's cheaper than the Intel equivalent.

## Step 2 — Point your domain to the server (5 min)

1. Log into **Cloudflare** → click your domain → **DNS** in the left menu
2. Click **Add Record**:

| Field | Value |
|---|---|
| Type | A |
| Name | `*` |
| IPv4 address | your server IP |
| Proxy status | **Grey cloud — DNS only** (NOT orange!) |

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

Open a terminal on your new computer:
```
ssh root@YOUR_SERVER_IP
```
If asked "Are you sure?" → type `yes` → Enter.

You're now inside your server. Everything below is pasted into this terminal.

## Step 4 — Install Coolify (3 min)

Coolify is your control panel — a website where you manage all your apps. After this step, you barely need the terminal again.

```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Wait ~3 minutes. When done, open your browser:
```
http://YOUR_SERVER_IP:8000
```
Create your admin account (pick a strong password — this controls everything).

## Step 5 — Set your domain in Coolify (2 min)

1. Coolify → **Settings** (left sidebar)
2. **Instance Domain** → type `coolify.YOURDOMAIN.com`
3. Turn on **Auto SSL**
4. Save

Now every app you deploy gets a secure address automatically.

---

> ✅ **Server is live.** Now let's put things on it.

---

# PART 3 — Deploy your personal cloud apps

## 🔑 Vaultwarden — Your password manager

1. Coolify → **+ New Resource** → **Service** → search "Vaultwarden" → Deploy
2. Domain: `vault.YOURDOMAIN.com` → Deploy → wait 30 seconds
3. Open `https://vault.YOURDOMAIN.com` → **Create Account** → register
4. **Important:** Back in Coolify → Vaultwarden → **Environment Variables** → set `SIGNUPS_ALLOWED` to `false` → Save → Restart

**On your phone & laptop:** Install the **Bitwarden** app → Settings → Self-hosted → enter `https://vault.YOURDOMAIN.com` → log in.

---

## ☁️ Nextcloud — Your files & photos

1. Coolify → **+ New Resource** → **Service** → search "Nextcloud" → pick **Nextcloud with PostgreSQL** → Deploy
2. Domain: `cloud.YOURDOMAIN.com` → set an admin username + password → Deploy → wait ~2 minutes
3. Open `https://cloud.YOURDOMAIN.com` → log in

**On your phone:** Install the **Nextcloud** app → enter your server address → log in → turn on auto photo backup.

---

## 🤖 Open WebUI — Your AI chat

1. Coolify → **+ New Resource** → **Service** → search "Open WebUI" → Deploy
2. Domain: `ai.YOURDOMAIN.com`
3. Add environment variable: `ANTHROPIC_API_KEY` = your key from Part 1
4. Deploy → wait 30 seconds
5. Open `https://ai.YOURDOMAIN.com` → Sign up → pick **Claude** from the model dropdown

> If Claude doesn't appear: Admin Panel → Settings → Connections → Anthropic → confirm the key → Save.

---

## 🎥 Jellyfin — Movies & shows (optional)

1. Coolify → **+ New Resource** → **Service** → search "Jellyfin" → Deploy
2. Domain: `media.YOURDOMAIN.com` → Deploy → wait 30 seconds
3. Open `https://media.YOURDOMAIN.com` → follow the setup wizard

---

> ✅ **Personal cloud done.** Now for the powerful stuff.

---

# PART 4 — Deploy your AI Workshop

This is what turns your server from a file cabinet into a research & project powerhouse.

## ⚡ n8n — Your automation brain

n8n is the glue that connects everything. Think of it as a robot secretary that can chain tasks together: "When X happens, do Y, then do Z."

1. Coolify → **+ New Resource** → **Service** → search "n8n" → Deploy
2. Domain: `auto.YOURDOMAIN.com`
3. Add these environment variables:

| Variable | Value |
|---|---|
| `N8N_ENCRYPTION_KEY` | (make up a random string — e.g. `mySecretKey2026xyz`) |
| `N8N_BASIC_AUTH_ACTIVE` | `true` |
| `N8N_BASIC_AUTH_USER` | (pick a username) |
| `N8N_BASIC_AUTH_PASSWORD` | (pick a strong password) |

4. Deploy → wait 30 seconds
5. Open `https://auto.YOURDOMAIN.com` → log in with the username/password you set

---

## 🖥️ OpenHands — Your AI coding agent

OpenHands is an AI that can actually write code, run it, test it, and fix bugs — all by itself. You describe what you want in plain English, and it builds it.

1. Coolify → **+ New Resource** → **Docker Compose**
2. Paste this entire block:

```yaml
services:
  openhands:
    image: ghcr.io/openhands/openhands:latest
    container_name: openhands
    pull_policy: always
    restart: unless-stopped
    environment:
      - SANDBOX_RUNTIME_CONTAINER_IMAGE=ghcr.io/openhands/runtime:latest
      - LOG_ALL_EVENTS=true
    ports:
      - "3100:3000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - openhands-state:/opt/workspace_base

volumes:
  openhands-state:
```

3. Deploy → wait ~2 minutes (it downloads a lot the first time)
4. Now set up the web address. In Coolify, add a **Proxy** rule:
   - Domain: `code.YOURDOMAIN.com`
   - Forward to: `http://openhands:3000`
5. Open `https://code.YOURDOMAIN.com`
6. In OpenHands settings → **LLM Provider** → pick **Anthropic** → paste your API key → pick **Claude Sonnet** (best balance of speed and quality for coding)

> **Tip:** Use Claude Sonnet for everyday coding tasks (fast + cheap). Switch to Claude Opus for complex architecture decisions.

---

## 🧠 CrewAI — Your multi-agent research team

CrewAI lets you assemble teams of AI agents that work together. One researches, one analyzes, one writes — and they coordinate automatically.

1. Still in the server terminal (SSH in if you disconnected):

```bash
ssh root@YOUR_SERVER_IP
```

2. Create the CrewAI workspace:

```bash
mkdir -p /opt/crewai && cd /opt/crewai
```

3. Install Python and CrewAI:

```bash
apt update && apt install -y python3 python3-pip python3-venv
python3 -m venv venv
source venv/bin/activate
pip install crewai crewai-tools
```

4. Create your first crew — a deep research team. Paste this entire block:

```bash
cat > /opt/crewai/research_crew.py << 'CREW'
"""
Deep Research Crew — 3 agents that work together to research any topic.
Run: cd /opt/crewai && source venv/bin/activate && python research_crew.py "your topic here"
"""
import sys
import os
from crewai import Agent, Task, Crew, Process

os.environ["ANTHROPIC_API_KEY"] = os.getenv("ANTHROPIC_API_KEY", "YOUR_KEY_HERE")

topic = sys.argv[1] if len(sys.argv) > 1 else "AI agent orchestration best practices"

# Agent 1: The Researcher — finds information
researcher = Agent(
    role="Senior Research Analyst",
    goal=f"Find comprehensive, accurate information about: {topic}",
    backstory="You are an expert researcher who digs deep into topics, finding primary sources, data, and expert opinions. You never make claims without evidence.",
    verbose=True,
    llm="anthropic/claude-sonnet-4-20250514"
)

# Agent 2: The Analyst — evaluates and connects findings
analyst = Agent(
    role="Critical Analyst",
    goal="Evaluate the research findings for accuracy, identify patterns, and draw meaningful conclusions",
    backstory="You are a sharp analytical thinker who spots connections others miss. You evaluate evidence critically and separate strong findings from weak ones.",
    verbose=True,
    llm="anthropic/claude-sonnet-4-20250514"
)

# Agent 3: The Writer — creates the final report
writer = Agent(
    role="Report Writer",
    goal="Create a clear, actionable report from the research and analysis",
    backstory="You write reports that are easy to understand but don't oversimplify. You focus on what matters and always include concrete next steps.",
    verbose=True,
    llm="anthropic/claude-sonnet-4-20250514"
)

# Tasks — each agent gets one job
research_task = Task(
    description=f"Research this topic thoroughly: {topic}\nFind at least 5 key findings with sources.",
    expected_output="A detailed research document with findings, sources, and key data points.",
    agent=researcher
)

analysis_task = Task(
    description="Analyze the research findings. Identify the strongest insights, any contradictions, and what it all means.",
    expected_output="An analysis document highlighting key patterns, reliability of findings, and strategic implications.",
    agent=analyst
)

report_task = Task(
    description="Write a final report combining the research and analysis. Include: summary, key findings, recommendations, and next steps.",
    expected_output="A polished report in markdown format, ready to read and act on.",
    agent=writer
)

# Assemble the crew — they work in sequence (researcher → analyst → writer)
crew = Crew(
    agents=[researcher, analyst, writer],
    tasks=[research_task, analysis_task, report_task],
    process=Process.sequential,
    verbose=True
)

print(f"\n🚀 Starting deep research on: {topic}\n")
result = crew.kickoff()
print("\n" + "="*60)
print("📋 FINAL REPORT")
print("="*60)
print(result)
CREW
```

5. Set your API key so it's always available:

```bash
echo 'export ANTHROPIC_API_KEY="your-actual-key-here"' >> /opt/crewai/.env
```

6. Test it:

```bash
cd /opt/crewai && source venv/bin/activate && source .env
python research_crew.py "best self-hosted AI tools 2026"
```

You'll see three AI agents discussing and working together in your terminal. The final output is a polished research report.

---

> ✅ **AI Workshop deployed.** Now let's connect everything.

---

# PART 5 — Wire it all together

This is where the magic happens — making all your tools cooperate as one system.

## Connect n8n to everything

Open `https://auto.YOURDOMAIN.com` (your n8n).

### Add your AI connection

1. Left menu → **Credentials** → **Add Credential**
2. Search "Anthropic" → paste your API key → Save
3. Now any workflow can use Claude as its brain

### Add your OpenHands connection

1. **Credentials** → **Add Credential** → search "HTTP Header Auth"
2. Name it "OpenHands"
3. You'll use this to trigger OpenHands tasks from workflows

### Your first automation: Research → Report → Save

1. **Workflows** → **Add Workflow** → name it "Deep Research"
2. Add these nodes (drag from the left panel):

**Trigger:** Manual trigger (click to run) or Schedule (runs automatically)

↓

**AI Agent node:** 
- Model: Anthropic Claude
- Prompt: "Research [topic] thoroughly and write a detailed report"

↓

**Nextcloud node:**
- Action: Upload file
- Path: `/Research Reports/`
- File name: `report-{date}.md`
- Content: output from AI Agent

3. Save → click **Execute Workflow** to test

This researches a topic using Claude, then saves the report directly into your Nextcloud files. You can access it from your phone, laptop, anywhere.

### Useful automations to set up later

| Automation | What it does |
|---|---|
| Daily briefing | Every morning, researches your interests and emails you a summary |
| GitHub watcher | When a new issue appears, OpenHands automatically investigates and suggests a fix |
| Research pipeline | You drop a topic into a folder → full research report appears an hour later |
| Backup monitor | Checks if backups ran successfully, alerts you if not |

---

# PART 6 — Backups

## Set up automatic backups (5 min)

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
| **AI Chat** | Open WebUI + Claude | Talk to AI anytime |
| **AI Coder** | OpenHands + Claude | AI builds projects for you |
| **Automation** | n8n | Connects everything, runs workflows |
| **Research** | CrewAI | Teams of AI agents research together |

## Monthly cost

| Item | Cost |
|---|---|
| Hetzner CAX31 | ~€12/month |
| Domain (Cloudflare) | ~€1/month |
| Claude AI usage | ~€5-30/month (pay as you go) |
| Backblaze backups | ~€1/month |
| **Total** | **~€20-45/month** |

---

# Day-to-day usage

## Managing your apps

Go to `https://coolify.YOURDOMAIN.com` anytime.

| Task | How |
|---|---|
| Restart an app | Click the service → Restart |
| See why something broke | Click the service → Logs |
| Update an app | Click the service → Update |
| Add a new app | New Resource → Service |
| Change a setting | Click the service → Environment Variables |

## Using OpenHands (AI Coder)

1. Open `https://code.YOURDOMAIN.com`
2. Type what you want in plain English: "Build me a Python script that tracks stock prices"
3. Watch it work — it writes code, creates files, runs tests
4. Download or copy the result

## Using CrewAI (Research Teams)

SSH into your server and run:
```bash
cd /opt/crewai && source venv/bin/activate && source .env
python research_crew.py "your topic here"
```

Or trigger it from n8n for fully automated research.

## Using n8n (Automations)

1. Open `https://auto.YOURDOMAIN.com`
2. Create workflows visually — drag, drop, connect
3. Trigger manually or on a schedule

---

# How everything cooperates

```
You (or a schedule)
    │
    ▼
  n8n (automation brain)
    │
    ├──→ OpenHands (code tasks)
    │       └── writes, tests, deploys code
    │
    ├──→ CrewAI (research tasks)
    │       └── multiple AI agents collaborate
    │
    ├──→ Open WebUI (chat tasks)
    │       └── quick AI conversations
    │
    └──→ Nextcloud (storage)
            └── saves all results to your files
```

n8n is the conductor. It decides which tool to use and passes results between them. You can build any workflow you can imagine.

---

# Adding more power later

## More AI agents

Create new CrewAI scripts in `/opt/crewai/` for different purposes:
- `trading_crew.py` — analyzes markets and trading strategies
- `code_review_crew.py` — reviews code for bugs and improvements
- `content_crew.py` — researches and writes articles

## Upgrade the server

If you need more power:
1. Hetzner → your server → **Resize** → pick a bigger plan
2. Takes ~30 seconds, everything keeps running

## Move to your own hardware

1. Get a mini PC (~$150 one-time)
2. Install Coolify on it (same command as Part 2 Step 4)
3. Restore from backup
4. Update your Cloudflare DNS to your home IP
5. Cancel Hetzner

See [MIGRATION.md](MIGRATION.md) for the full guide.

---

# Troubleshooting

| Problem | Fix |
|---|---|
| App won't load | Coolify → service → Logs |
| OpenHands stuck | Coolify → OpenHands → Restart |
| CrewAI error | Check your API key in `/opt/crewai/.env` |
| n8n workflow failed | n8n → Executions → click the failed run → see which step broke |
| Domain not working | Cloudflare → DNS → make sure IP is correct and proxy is OFF (grey cloud) |
| Out of disk space | Hetzner → server → Volumes → add more storage |
| Confused about anything | Ask Nicara 😊 |
