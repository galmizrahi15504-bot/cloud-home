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

Do this the day before you want to set everything up. Print this or keep it on your phone.

### ✅ To-do list

- [ ] **Cloudflare** — create account, buy a domain (~$10/year) → write down the **domain name**
- [ ] **Hetzner** — create account, complete ID verification → write down **login**
- [ ] **Anthropic** — create account, create API key, add payment method → write down the **API key** (starts with `sk-ant-`)
- [ ] **Tavily** (optional, free) — [tavily.com](https://tavily.com) → create account → copy API key. Gives your AI coder the ability to search the web while working. Free = 1,000 searches/month.
- [ ] **Backblaze** (optional, for offsite backups) — create account, create bucket `cloud-home-backup`, create app key → write down **endpoint URL, Key ID, App Key**
- [ ] **Save everything** in one note

The **SSH key** is the only thing you can't do now — it must be generated on setup day on the actual PC you'll use to connect to the server.

> ⚠️ **Hetzner ID verification can take up to a day** — that's why you do this now. Everything else is instant.

---

# PART 1 — Preparation (detailed steps)

~30 minutes, all free.

You need **3 accounts**. Save everything in one place (a note, a doc, whatever — you'll need it all in Part 2).

---

### 1. Domain — [cloudflare.com](https://cloudflare.com)

This is your address on the internet (e.g. `galcloud.com`).

1. Create a free account
2. Left menu → **Domain Registration** → search for a name → buy it (~$10/year)

💾 Save: **your domain name**

---

### 2. Server account — [hetzner.cloud](https://hetzner.cloud)

1. Create a free account
2. Complete ID verification if asked (can take up to a day)
3. Don't buy anything yet

💾 Save: **your login credentials**

---

### 3. AI key — [console.anthropic.com](https://console.anthropic.com)

This single key powers every AI tool in the entire setup.

1. Create an account
2. Go to **API Keys** → **Create Key** → copy it
3. Go to **Billing** → add a payment method (you're only charged when AI is actually used)

💾 Save: **your API key** (starts with `sk-ant-`)

---

> ✅ **Part 1 complete.** You have: domain name, Hetzner login, Anthropic API key. Keep them handy.

---

# PART 2 — Server & Coolify

### Step 1 — Generate your SSH key

This is how your PC securely connects to your server — like a physical key to a door.

Open a terminal on your **new PC**:
- **Mac:** Cmd+Space → type "Terminal" → open it
- **Windows:** Windows key → type "PowerShell" → open it

```
ssh-keygen -t ed25519
```

Press **Enter** three times (default location, no password).

Now display it:

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
| SSH Keys | Click **Add SSH Key** → paste your key from Step 1 above → name it `laptop` |

4. Click **Create & Buy Now**

💾 Save: **server IP address** from the dashboard (e.g. `65.108.123.45`)

> **Why CPX31?** x86/AMD architecture — every Docker image works. 4 cores + 8GB RAM runs all services comfortably side by side. 160GB disk holds your files, photos, and media. If you outgrow it, Hetzner lets you resize in 30 seconds with zero downtime.

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
| Proxy status | **DNS only** (grey cloud — click orange to toggle OFF) |

**Record 2 — root domain:**

| Field | Value |
|---|---|
| Type | `A` |
| Name | `@` |
| IPv4 address | your server IP |
| Proxy status | **DNS only** (grey cloud) |

> ⚠️ **The cloud icon MUST be grey, not orange.** Orange means Cloudflare proxies the traffic, which breaks Coolify's SSL certificates.

Wait 5 minutes for DNS to propagate.

---

### Step 4 — Connect and install Coolify

Connect to your server (replace the IP):

```
ssh root@YOUR_SERVER_IP
```

Type `yes` when asked about fingerprint, press Enter.

Now install Coolify:

```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Wait ~3 minutes. When finished, open in your browser:

```
http://YOUR_SERVER_IP:8000
```

1. Create your admin account (strong password — this controls your entire server)
2. Go to **Settings** → **Instance Domain** → type `coolify.YOURDOMAIN.com`
3. Turn on **Auto SSL**
4. Click **Save**

You now have a web-based control panel at `https://coolify.YOURDOMAIN.com`. Every app below is deployed through it.

---

### Step 5 — Lock down your server

Still in the SSH terminal, set up a basic firewall so only the right ports are open:

```bash
ufw allow 22/tcp    # SSH (so you can still connect)
ufw allow 80/tcp    # HTTP (for SSL certificate generation)
ufw allow 443/tcp   # HTTPS (all your apps)
ufw allow 8000/tcp  # Coolify panel
ufw --force enable
```

This blocks everything else — including port 3000 (OpenHands) from being accessed directly by IP. Your apps are only reachable through their proper `https://` domains, which is what you want.

> OpenHands sandboxes still work because Docker internal traffic bypasses the firewall.

---

> ✅ **Server running, Coolify ready.** Everything from here is done through Coolify's web interface (except CrewAI).

---

# PART 3 — Personal Cloud

For each app: Coolify → **+ New Resource** → **Service** → search → set domain → **Deploy**.

---

### 🔑 Vaultwarden — Password manager

1. Search `Vaultwarden` → select it
2. Domain: `vault.YOURDOMAIN.com` → **Deploy**
3. Wait ~30 seconds, then open `https://vault.YOURDOMAIN.com`
4. Click **Create Account** → register with your email + a strong master password
5. **Disable public signups:** Coolify → Vaultwarden → **Environment Variables** → add or find `SIGNUPS_ALLOWED` → set to `false` → **Save** → **Restart**

**Phone/laptop setup:** Install the **Bitwarden** app → Settings → Self-hosted → enter `https://vault.YOURDOMAIN.com` → log in.

---

### ☁️ Nextcloud — Files, photos, documents

1. Search `Nextcloud` → pick **Nextcloud with PostgreSQL**
2. Domain: `cloud.YOURDOMAIN.com` → set admin username + password → **Deploy**
3. Wait ~2 minutes, then open `https://cloud.YOURDOMAIN.com` → log in

**Phone setup:** Install the **Nextcloud** app → enter `https://cloud.YOURDOMAIN.com` → log in → Settings → Auto Upload → enable for photos.

---

### 🎥 Jellyfin — Movies & shows (optional)

1. Search `Jellyfin` → select it
2. Domain: `media.YOURDOMAIN.com` → **Deploy**
3. Open `https://media.YOURDOMAIN.com` → follow the setup wizard

---

# PART 4 — AI Workshop

Four tools that form your AI system. One API key powers all of them.

---

### 🤖 Open WebUI — AI chat

Your private ChatGPT. Supports Claude, GPT, and local models.

1. Coolify → **+ New Resource** → **Service** → search `Open WebUI` → select it
2. Domain: `ai.YOURDOMAIN.com` → **Deploy**
3. Wait ~30 seconds, open `https://ai.YOURDOMAIN.com`
4. Click **Sign Up** → create your account (first account = admin)
5. Click your avatar (top-right) → **Admin Panel** → **Settings** → **Connections**
6. Find the **Anthropic** section (or click **+** / **Add Connection** if not visible)
7. Paste your API key → click the ✓ checkmark to verify → **Save**
8. Return to chat → click the **model dropdown** at the top → select **Claude Sonnet**

You now have a private AI chatbot that doesn't train on your data.

---

### ⚡ n8n — Automation engine

Your private Zapier. Connects services, schedules tasks, triggers workflows — all visual, no coding.

1. Coolify → **+ New Resource** → **Service** → search `n8n` → select it
2. Domain: `auto.YOURDOMAIN.com` → **Deploy**
3. Wait ~30 seconds, open `https://auto.YOURDOMAIN.com`
4. Create your owner account (name, email, password)

**Connect Claude to n8n:**

5. Left sidebar → **Credentials** → **Add Credential**
6. Search `Anthropic` → select it → paste your API key → **Save**

Any workflow you build can now use Claude. You create automations by dragging and connecting blocks.

---

### 🖥️ OpenHands — AI coding agent

An AI that writes, runs, tests, and debugs code autonomously. You describe what you want in plain English — it builds it. 71,000+ stars on GitHub, used by engineers at Netflix, Amazon, TikTok.

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
5. Click **Deploy** → wait ~2 minutes (downloads ~2GB of components on first run)
6. Open `https://code.YOURDOMAIN.com`

**Configure OpenHands:**

7. Click the **Settings** gear icon ⚙️
8. **LLM Provider** → **Anthropic**
9. **API Key** → paste your Anthropic key
10. **Model** → `claude-sonnet-4-20250514`
11. (Optional) **Search API Key (Tavily)** → paste your Tavily key — this lets the AI search the web while coding
12. Click **Save**

Type any task in English: *"Build a Python API that fetches Bitcoin prices every hour and stores them in a database"* — and watch it code, test, and fix issues automatically.

> **Tip:** Use Sonnet for everyday coding (fast + cheap). Switch to `claude-opus-4-0` for complex architecture decisions.

> **Why ports 3000?** OpenHands spawns temporary sandbox containers to run your code safely. Those sandboxes connect back to OpenHands through this port. Coolify's proxy still handles your `code.YOURDOMAIN.com` domain on top of it.

---

### 🧠 CrewAI — Multi-agent research teams

This is the only tool that needs terminal access. CrewAI runs teams of AI agents that collaborate — one researches, one analyzes, one writes — passing work between each other automatically.

SSH into your server:

```bash
ssh root@YOUR_SERVER_IP
```

**Install everything in one block** (copy-paste the whole thing):

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
echo ""
echo "Next: set your API key with:"
echo "  echo 'ANTHROPIC_API_KEY=sk-ant-YOUR-KEY' > /opt/crewai/.env"
```

**Set your API key** (replace `sk-ant-YOUR-KEY` with your actual key):

```bash
echo 'ANTHROPIC_API_KEY=sk-ant-YOUR-ACTUAL-KEY-HERE' > /opt/crewai/.env
```

**Verify it saved:**

```bash
cat /opt/crewai/.env
```

Should show your key starting with `sk-ant-`. If it shows the placeholder, run the echo command again with your real key.

**Run your first research:**

```bash
cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
python research_crew.py "best self-hosted AI tools 2026"
```

You'll see three agents collaborating in real time — researching, analyzing, writing. Final output is a polished report. Takes ~3 minutes, costs a few cents.

---

> ✅ **Full AI Workshop running.** You now have AI chat, AI coding, multi-agent research, and automation — all on your server.

---

# PART 5 — Connecting everything

Here's how the pieces work together:

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

### What you can automate with n8n

| Workflow | Trigger | What happens |
|---|---|---|
| **Daily briefing** | Every morning at 8am | Claude researches your chosen topics → emails you a summary |
| **GitHub auto-fix** | New issue in your repo | OpenHands investigates and opens a pull request |
| **Research pipeline** | You drop a topic in a Nextcloud folder | CrewAI runs a full research crew → saves report to Nextcloud |
| **Trading research** | Daily at market open | CrewAI agents analyze market conditions → write strategy report |
| **Backup checker** | Daily | Verifies backups ran → alerts you if something failed |

All built visually in n8n. Drag blocks, connect them, set schedules. No coding needed.

---

# PART 6 — Backups

### Quick option — Hetzner Snapshots

Hetzner dashboard → your server → **Snapshots** → enable **Automatic Snapshots**.

Cost: ~20% of server price (~€2.80/month). Creates a full server image daily. One click to restore.

### Full option — Offsite backups to Backblaze

For an extra layer of safety (your data is stored outside Hetzner too):

1. Create a free [Backblaze](https://backblaze.com) account
2. **Buckets** → **Create Bucket** → name: `cloud-home-backup`
3. Note the **Endpoint URL** (e.g. `https://s3.us-west-004.backblazeb2.com`)
4. **App Keys** → **Create App Key** → save both the Key ID and the Application Key

Then in Coolify → **Settings** → **Backup** → **Add S3 Storage**:

| Field | Value |
|---|---|
| Endpoint | your Backblaze endpoint URL |
| Bucket | `cloud-home-backup` |
| Access Key | your Backblaze Key ID |
| Secret Key | your Backblaze App Key |

**Save** → **Backup Now** to test → enable **Scheduled Backups** (daily).

---

# 💰 Price breakdown

### Fixed monthly costs

| Item | Cost |
|---|---|
| Hetzner CPX31 server | ~€14/month |
| Domain (Cloudflare) | ~€1/month |
| Backups (Hetzner snapshots) | ~€3/month |
| **Total fixed** | **~€18/month** |

### AI usage (Claude API — pay as you go)

| How you use it | Estimated cost | Examples |
|---|---|---|
| **Light** | ~€5/month | A few AI chats per day, occasional research crew |
| **Medium** | ~€15/month | Daily coding with OpenHands, regular research, automations |
| **Heavy** | ~€30+/month | Constant OpenHands sessions, multiple daily research crews |

### Total

| Scenario | Monthly cost |
|---|---|
| Light use | **~€23/month** |
| Medium use | **~€33/month** |
| Heavy use | **~€48+/month** |

> **For comparison:** ChatGPT Plus = $20/month for just a chatbot. GitHub Copilot = $10/month for just code completion. Zapier = $20+/month for basic automations. You're replacing all three and more.

---

# Day-to-day reference

### Control panel
`https://coolify.YOURDOMAIN.com` — restart apps, check logs, update, deploy new services.

### AI Chat
`https://ai.YOURDOMAIN.com` — chat with Claude. Pick different models from the dropdown.

### AI Coder
`https://code.YOURDOMAIN.com` — describe what you want, OpenHands builds it.

### Automations
`https://auto.YOURDOMAIN.com` — create and manage workflows visually.

### Research
```bash
ssh root@YOUR_SERVER_IP
cd /opt/crewai && source venv/bin/activate && export $(cat .env | xargs)
python research_crew.py "your topic here"
```

### Update OpenHands
Coolify → click OpenHands service → **Redeploy**.

### Create more research crews
Add new Python scripts to `/opt/crewai/`:
- `trading_crew.py` — market analysis and strategy
- `code_review_crew.py` — automated code reviews
- `content_crew.py` — article research and writing

---

# Scaling

| Need | Solution |
|---|---|
| More CPU/RAM | Hetzner → your server → **Resize** (30 seconds, no data loss) |
| Recommended upgrade | CPX31 → **CPX41** (8 cores, 16GB RAM — ~€28/month) |
| Stop paying monthly | Buy a mini PC (~$150) → install Coolify → restore backup → update DNS → cancel Hetzner. See [MIGRATION.md](MIGRATION.md) |

---

# Troubleshooting

| Problem | Fix |
|---|---|
| Any app won't load | Coolify → click that service → **Logs** |
| OpenHands stuck or slow | Coolify → OpenHands → **Redeploy** |
| OpenHands won't start | Check Coolify logs — it needs Docker socket access. Verify the compose YAML is exact |
| CrewAI gives API error | Verify key: `cat /opt/crewai/.env` — must start with `sk-ant-` |
| n8n workflow failed | n8n → **Executions** tab → click failed run → see which step broke |
| Claude not in Open WebUI | Admin Panel → Settings → Connections → verify Anthropic key → refresh page |
| Domain shows "not found" | Cloudflare → DNS → verify IP is correct AND proxy is OFF (grey cloud) |
| "Connection refused" | App still starting — wait 2 minutes and refresh |
| SSL certificate error | Make sure Cloudflare proxy is OFF (grey cloud). Coolify handles SSL itself |
| Out of disk space | Hetzner → Volumes → add more, or `docker system prune` to clear old images |
| Forgot Coolify password | SSH in → `docker exec coolify php artisan user:reset-password` |
