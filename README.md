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
| Type | **CPX31** — 4 AMD cores, 8GB RAM, 160GB disk — ~€14/mo |
| SSH Keys | Click **Add SSH Key** → paste the line from Part 1 → name it "my laptop" |

3. Click **Create & Buy Now**
4. 💾 **Write down** the server IP address shown on the dashboard (looks like `65.108.123.45`)

> **Why CPX31?** It's x86/AMD — every tool we'll install is guaranteed to work (ARM servers are cheaper but many AI tools don't support them yet). 4 cores and 8GB RAM handles all your personal apps + AI tools comfortably. If you outgrow it, Hetzner lets you upgrade in 30 seconds with no data loss.

## Step 2 — Point your domain to the server (5 min)

1. Log into **Cloudflare** → click your domain → **DNS** in the left menu
2. Click **Add Record**:

| Field | Value |
|---|---|
| Type | A |
| Name | `*` |
| IPv4 address | your server IP |
| Proxy status | **Grey cloud — DNS only** (if it's orange, click it to toggle OFF) |

Click **Save**.

3. Click **Add Record** again:

| Field | Value |
|---|---|
| Type | A |
| Name | `@` |
| IPv4 address | your server IP |
| Proxy status | **Grey cloud** |

Click **Save**. Wait 5 minutes for it to spread across the internet.

## Step 3 — Connect to your server (1 min)

Open a terminal on your new computer and run (replace YOUR_SERVER_IP with the actual IP):
```
ssh root@YOUR_SERVER_IP
```
If asked "Are you sure you want to continue connecting?" → type `yes` → press Enter.

You're now inside your server. Everything from here is pasted into this terminal window.

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
2. **Instance Domain** → type `coolify.YOURDOMAIN.com` (replace with your actual domain)
3. Turn on **Auto SSL**
4. Click **Save**

Now every app you deploy through Coolify gets a secure HTTPS address automatically.

---

> ✅ **Server is live.** Now let's put things on it.

---

# PART 3 — Deploy your personal cloud apps

For each app below: Coolify → **+ New Resource** → **Service**.

## 🔑 Vaultwarden — Your password manager

1. Search "Vaultwarden" → select it
2. Set domain to `vault.YOURDOMAIN.com` (replace with your actual domain) → click **Deploy**
3. Wait 30 seconds, then open `https://vault.YOURDOMAIN.com` in your browser
4. Click **Create Account** → register with your email and a strong password
5. **Lock it down:** Back in Coolify → click on Vaultwarden → **Environment Variables** → find or add `SIGNUPS_ALLOWED` → set it to `false` → **Save** → click **Restart**

**On your phone & laptop:** Install the **Bitwarden** app (free) → Settings → Self-hosted → enter `https://vault.YOURDOMAIN.com` → log in with the account you just created.

---

## ☁️ Nextcloud — Your files & photos

1. Coolify → **+ New Resource** → **Service** → search "Nextcloud" → pick **Nextcloud with PostgreSQL**
2. Set domain to `cloud.YOURDOMAIN.com` → set an admin username and password → click **Deploy**
3. Wait ~2 minutes, then open `https://cloud.YOURDOMAIN.com` → log in with the admin credentials you set

**On your phone:** Install the **Nextcloud** app (free) → enter `https://cloud.YOURDOMAIN.com` → log in → go to Settings → Auto Upload → turn it on for photos.

---

## 🤖 Open WebUI — Your AI chat

1. Coolify → **+ New Resource** → **Service** → search "Open WebUI" → select it
2. Set domain to `ai.YOURDOMAIN.com` → click **Deploy**
3. Wait 30 seconds, then open `https://ai.YOURDOMAIN.com`
4. Click **Sign Up** → create your account (the first account automatically becomes the admin)
5. **Connect Claude:** Click your name/icon (top-right) → **Admin Panel** → **Settings** → **Connections**
6. Look for an **Anthropic** section → paste your API key → click the checkmark/verify button → **Save**

> **If you don't see an Anthropic section:** Look for an "Add Connection" or "+" button on the Connections page. Select "Anthropic" as the provider, paste your API key, and save. Then refresh the page.

7. Go back to the main chat → click the **model dropdown** at the top → pick any Claude model (Claude Sonnet is a great default)

---

## 🎥 Jellyfin — Movies & shows (optional)

1. Coolify → **+ New Resource** → **Service** → search "Jellyfin" → select it
2. Set domain to `media.YOURDOMAIN.com` → click **Deploy**
3. Wait 30 seconds, then open `https://media.YOURDOMAIN.com` → follow the setup wizard

---

> ✅ **Personal cloud is running.** Now for the AI powerhouse.

---

# PART 4 — Deploy your AI Workshop

## ⚡ n8n — Your automation brain

n8n connects all your tools together. Think of it as a robot secretary: "When X happens, do Y, then Z."

1. Coolify → **+ New Resource** → **Service** → search "n8n" → select it
2. Set domain to `auto.YOURDOMAIN.com` → click **Deploy**
3. Wait 30 seconds, then open `https://auto.YOURDOMAIN.com`
4. n8n asks you to create an owner account — fill in your name, email, and a strong password
5. You're in!

### Connect Claude to n8n

1. Left sidebar → **Credentials** → **Add Credential**
2. Search "Anthropic" → select it → paste your API key → click **Save**
3. Done — now any workflow you build can use Claude as its brain

---

## 🖥️ OpenHands — Your AI coding agent

OpenHands is an AI that writes code, runs it, tests it, and fixes bugs — all by itself. You describe what you want in plain English, it builds it.

1. Coolify → **+ New Resource** → **Docker Compose** (not "Service" — this one uses a custom setup)
2. In the editor that appears, **delete everything** and paste this:

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

3. Click **Save**
4. In the service settings, set domain to `code.YOURDOMAIN.com`
5. Click **Deploy** → wait ~2 minutes (it downloads a lot the first time)
6. Open `https://code.YOURDOMAIN.com` in your browser

### Configure OpenHands

1. Click the **Settings** gear icon (⚙️)
2. **LLM Provider** → select **Anthropic**
3. **API Key** → paste your Anthropic API key
4. **Model** → select **claude-sonnet-4-20250514** (best balance of speed and quality for coding)
5. Click **Save**

You're ready! Type any task in plain English and watch it work.

> **Tip:** Use Sonnet for everyday coding. For complex architecture or design decisions, switch the model to **claude-opus-4-0** in Settings.

---

## 🧠 CrewAI — Your multi-agent research team

CrewAI lets you assemble teams of AI agents that collaborate on complex tasks. One researches, one analyzes, one writes — they coordinate automatically.

This one needs a few terminal commands. Open a terminal and connect to your server:

```bash
ssh root@YOUR_SERVER_IP
```

### Step 1 — Install CrewAI

Paste this block:

```bash
apt update && apt install -y python3 python3-pip python3-venv
mkdir -p /opt/crewai
python3 -m venv /opt/crewai/venv
/opt/crewai/venv/bin/pip install 'crewai[tools]'
```

Wait ~1 minute for it to install.

### Step 2 — Save your API key

Run this command, but **first replace `sk-ant-PASTE-YOUR-ACTUAL-KEY-HERE` with your real Anthropic API key:**

```bash
echo 'ANTHROPIC_API_KEY=sk-ant-PASTE-YOUR-ACTUAL-KEY-HERE' > /opt/crewai/.env
```

To verify it saved correctly:
```bash
cat /opt/crewai/.env
```
You should see your key. If it still says the placeholder text, run the command again with your real key.

### Step 3 — Create your research crew

Paste this entire block as-is (no edits needed):

```bash
cat > /opt/crewai/research_crew.py << 'CREW'
"""
Deep Research Crew — 3 AI agents that collaborate on any research topic.

Usage:
  cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
  python research_crew.py "your topic here"
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

### Step 4 — Test it

```bash
cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
python research_crew.py "best self-hosted AI tools 2026"
```

You'll see three AI agents discussing and building on each other's work in real time. The final output is a polished research report. (This takes a few minutes and costs a few cents in API usage.)

---

> ✅ **AI Workshop deployed.** Now let's connect the pieces.

---

# PART 5 — How everything works together

```
You (or a schedule/trigger)
    │
    ▼
  n8n — your automation brain (auto.YOURDOMAIN.com)
    │
    ├──→ OpenHands — for coding tasks (code.YOURDOMAIN.com)
    │       AI writes, tests, and deploys code
    │
    ├──→ CrewAI — for research tasks (runs on server via SSH)
    │       Multiple AI agents collaborate on deep research
    │
    ├──→ Claude (via API) — for quick AI questions
    │
    └──→ Nextcloud — saves all results to your files (cloud.YOURDOMAIN.com)
```

### Example automations you can build in n8n

| Automation | What it does |
|---|---|
| Daily briefing | Every morning, Claude researches topics you care about and sends a summary |
| GitHub watcher | New issue in your repo → OpenHands automatically investigates |
| Research pipeline | Drop a topic in a Nextcloud folder → full research report appears later |
| Backup monitor | Checks if backups ran successfully, alerts you if not |
| Trading research | CrewAI agents analyze market data and write strategy reports |

All built visually in n8n — drag, drop, connect. No coding.

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

Click **Save** → **Backup Now** to test → turn on **Scheduled Backups** (daily).

---

# 🎉 You're done!

## Everything you're running

| Layer | Apps | Purpose |
|---|---|---|
| **Personal Cloud** | Nextcloud, Vaultwarden, Jellyfin | Your digital life |
| **AI Chat** | Open WebUI + Claude | Ask AI anything, anytime |
| **AI Coder** | OpenHands + Claude | AI builds code projects for you |
| **Automation** | n8n + Claude | Connects everything, runs workflows |
| **Research** | CrewAI + Claude | Teams of AI agents research together |

---

## 💰 Price breakdown

### One-time costs

| Item | Cost |
|---|---|
| Domain name (Cloudflare) | ~$10/year (~$0.83/month) |
| **Total one-time** | **~$10/year** |

### Monthly costs (fixed)

| Item | Cost | What it is |
|---|---|---|
| Hetzner CPX31 server | ~€14/month | Your server (4 cores, 8GB RAM, 160GB disk) |
| Backblaze backups | ~€1/month | Automatic daily backups of everything |
| **Total fixed** | **~€15/month** |

### Monthly costs (usage-based)

| Usage level | Claude API cost | What that looks like |
|---|---|---|
| Light | ~€5/month | A few AI chats per day, occasional CrewAI research |
| Medium | ~€15/month | Daily AI coding with OpenHands, regular research crews, n8n automations |
| Heavy | ~€30+/month | Constant OpenHands coding, multiple research crews daily, many automations |

### Total monthly cost

| Scenario | Total |
|---|---|
| **Light use** | **~€20/month** |
| **Medium use** | **~€30/month** |
| **Heavy use** | **~€45+/month** |

> **For comparison:** ChatGPT Plus alone is $20/month and gives you way less than this. You're getting an entire private cloud + AI coding agent + research team + automation engine.

---

# Day-to-day usage

## Managing your apps

Go to `https://coolify.YOURDOMAIN.com` anytime.

| Task | How |
|---|---|
| Restart an app | Click the service → **Restart** |
| Check what went wrong | Click the service → **Logs** |
| Update an app | Click the service → **Update** |
| Add a new app | **+ New Resource** → **Service** |
| Change a setting | Click the service → **Environment Variables** |

## Using OpenHands (AI Coder)

1. Open `https://code.YOURDOMAIN.com`
2. Type what you want: "Build me a Python script that tracks stock prices"
3. Watch it work — it writes code, creates files, runs tests, fixes its own mistakes
4. Download or copy the result

## Using CrewAI (Research Teams)

```bash
ssh root@YOUR_SERVER_IP
cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
python research_crew.py "your research topic here"
```

## Using n8n (Automations)

1. Open `https://auto.YOURDOMAIN.com`
2. Create workflows visually — drag, drop, connect
3. Trigger manually or set a schedule (hourly, daily, weekly)

## Updating OpenHands

Coolify → click OpenHands → **Redeploy** (pulls the latest version automatically).

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
2. Takes ~30 seconds, no data loss
3. Recommended upgrade: CPX31 → CPX41 (8 cores, 16GB — ~€28/mo)

## Move to your own hardware

Stop paying monthly forever:
1. Get a mini PC (~$150 one-time)
2. Install Coolify on it (same command as Part 2 Step 4)
3. Restore from backup
4. Update Cloudflare DNS to your home IP
5. Cancel Hetzner — monthly server cost drops to €0

See [MIGRATION.md](MIGRATION.md) for the full walkthrough.

---

# Troubleshooting

| Problem | Fix |
|---|---|
| App won't load | Coolify → click that service → **Logs** |
| OpenHands stuck | Coolify → OpenHands → **Redeploy** |
| CrewAI error | Verify your key: `cat /opt/crewai/.env` — should start with `sk-ant-` |
| n8n workflow failed | n8n → **Executions** tab → click the failed run → see which step broke |
| Domain shows "not found" | Cloudflare → DNS → check IP is correct + proxy is OFF (grey cloud, not orange) |
| "Connection refused" | Wait 2 minutes (app still starting), then refresh |
| Out of disk space | Hetzner dashboard → server → **Volumes** → add more storage |
| Something else | Ask Nicara 😊 |
