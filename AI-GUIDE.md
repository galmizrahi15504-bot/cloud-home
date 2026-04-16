# 🤖 AI Guide — Which AI Should You Use?

> Short answer: Use a mix. Small stuff → free local AI. Big stuff → pay per use via API.

---

## The 3 Ways to Use AI in Your Cloud Home

### 1. 🏠 Local AI (Free, Private, Runs on Your Server)

**Ollama** runs AI models directly on your server. Completely free, completely private — nothing leaves your machine.

| Model | Size | Good For | Works on €4.50 server? |
|---|---|---|---|
| **Phi-3 Mini** | 2.3GB | Quick questions, summaries | ✅ Yes, fast |
| **Llama 3.1 8B** | 4.7GB | General conversations, writing | ✅ Yes, slower |
| **Mistral 7B** | 4.1GB | Great all-rounder | ✅ Yes |
| **Gemma 2 9B** | 5.4GB | Google's model, very capable | ⚠️ Tight on 8GB |

**Best starter model:** `phi3:mini` — fast, light, handles everyday stuff well.

To install: `docker exec ollama ollama pull phi3:mini`

### 2. ☁️ API AI (Pay Per Use, Most Powerful)

Connect cloud AI through **Open WebUI**. You pay only when you use them — no subscription.

| Provider | Best Model | Strength | Cost |
|---|---|---|---|
| **Anthropic** | **Claude Sonnet 4** | Best for conversations, writing, thinking | ~$3 per 1M tokens |
| **Anthropic** | **Claude Opus 4** | Most powerful overall | ~$15 per 1M tokens |
| **OpenAI** | **GPT-4o** | Fast, great for coding | ~$5 per 1M tokens |
| **Google** | **Gemini 2.5 Pro** | Huge context, good for long documents | ~$7 per 1M tokens |

**What does that cost in real life?**
- A normal conversation (20 back-and-forths) ≈ $0.01-0.05
- Analyzing a 50-page document ≈ $0.10-0.30
- Heavy daily use ≈ $5-15/month

**Compare:** ChatGPT Plus subscription = $20/month whether you use it or not. Pay-per-use via API is almost always cheaper unless you're chatting 8 hours a day.

### 3. 🔀 The Hybrid (Best Approach)

Open WebUI lets you switch between models in one interface:

```
Quick question → Phi-3 (free, local, instant)
  "What's the capital of France?"

Serious thinking → Claude Sonnet (API, ~$0.02)
  "Help me plan my business strategy"

Deep research → Claude Opus (API, ~$0.10)
  "Analyze this complex financial report"
```

**You pick the right tool for the job.** Casual stuff stays free. Important stuff uses the best AI available. You never overpay.

---

## Which AI Provider Is Best?

### 🏆 My Recommendation: **Anthropic (Claude)**

Here's why:

| | Anthropic (Claude) | OpenAI (GPT) | Google (Gemini) |
|---|---|---|---|
| **Conversation quality** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Thinking & reasoning** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Writing** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Coding** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Privacy stance** | Strong | Moderate | Weaker |
| **Price** | Good | Good | Good |
| **Feels like talking to** | A thoughtful partner | A fast assistant | A search engine that talks |

**Claude feels the most human.** It thinks deeper, gives more honest answers, and admits when it's unsure. You're already using Claude Opus right now (that's me!) so you know the quality.

**For Golden Route specifically** — Claude's reasoning ability is a big advantage for financial analysis and strategy.

---

## How to Set It Up

### Get Anthropic API Access:
1. Go to **console.anthropic.com**
2. Create account
3. Add payment method (pay-as-you-go, no minimum)
4. Go to API Keys → create a new key
5. Copy the key

### Connect to Open WebUI:
1. Go to `https://ai.yourdomain.com`
2. Settings → Connections
3. Add OpenAI-compatible connection:
   - URL: `https://api.anthropic.com/v1`
   - API Key: paste your key
4. Now you can select Claude from the model dropdown!

### Add Multiple Providers:
You can add ALL of them and switch freely:
- Anthropic (Claude) for deep thinking
- OpenAI (GPT) for coding
- Ollama (local) for quick private stuff

**One interface. All the AI in the world. You choose per conversation.**

---

## Monthly AI Cost Estimate

| Usage Level | Local (Ollama) | API (Claude/GPT) | Total |
|---|---|---|---|
| **Light** (few questions/day) | Free | ~$1-2/month | ~$1-2 |
| **Moderate** (daily conversations) | Free | ~$5-10/month | ~$5-10 |
| **Heavy** (business use, research) | Free | ~$15-25/month | ~$15-25 |
| **ChatGPT Plus for comparison** | — | — | $20/month fixed |

Most people land at **$5-10/month** with the hybrid approach, and get access to BETTER models than a $20 ChatGPT subscription gives you.

---

## The Bottom Line

Don't pick one AI. **Pick all of them:**

- **Phi-3** on Ollama → free daily driver (private, instant)
- **Claude Sonnet** via API → your go-to for real work (~$0.02 per conversation)
- **Claude Opus** via API → when you need the absolute best (~$0.10 per conversation)

Set them all up in Open WebUI and switch with one click. That's the interchangeable future-proof way. If a better model comes out tomorrow, you just add it. Nothing else changes.

*You're not locked to anyone. That's the whole point.* 🔓
