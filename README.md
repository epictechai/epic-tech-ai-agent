# Epic Tech AI

**The secure autonomous platform that gives agents real power — SOTA models, Stripe, Executor Gateway, and a living project memory — without ever leaking a key.**

| | |
|---|---|
| GitHub | [github.com/epictechai](https://github.com/epictechai) |
| X | [x.com/EpicTechAI](https://x.com/EpicTechAI) |
| Email | epictechai@gmail.com |

---

## What you get

Most "agent platforms" give you chatbots that can read files. Epic Tech AI gives you a **1000x super-agent stack**:

| Piece | Role |
|---|---|
| **`epic`** | Primary SOTA orchestrator (Claude Opus 4.8) — plans, fans out, ships |
| **`architect`** | Systems design blueprints before big builds |
| **`builder`** | Focused implementation + tests |
| **`researcher`** | Multi-source cited investigation |
| **`critic`** | Adversarial security/QA gate |
| **`ops`** | Stripe / Slack / GitHub / Vercel / Supabase via Executor |
| **`epic-os` skill** | Stable operating system (models can change; the loop doesn't) |
| **Slash commands** | `/ship` `/build` `/review` `/research` `/ops` `/memory` `/supercharge` |
| **Executor Gateway** | Third-party APIs with server-side credentials + audit |
| **Memory brain** | `.kortix/memory/` curated across sessions |
| **Change requests** | Only path to `main` — humans merge |

---

## Architecture

### 1. Super-agent OS

```
boot memory → load skills → classify → plan
→ parallel tools + subagents → verify → persist (memory/git/CR) → report
```

Roles stay fixed. **Model IDs live only in** agent frontmatter + `.kortix/opencode/opencode.jsonc`, so upgrading to the next SOTA model is a one-line swap.

### 2. Executor Gateway (`kortix-executor`)

Agents never receive raw API keys. Four MCP tools:

| Tool | Purpose |
|------|---------|
| `connectors` | List integrations available to this session |
| `discover` | Intent search ("create a charge", "send slack message") |
| `describe` | Full JSON schema + risk before calling |
| `call` | Execute with gateway-injected credential |

### 3. Restricted Stripe key (never in git)

Dashboard secret name: `STRIPE_API_KEY`. Use a **restricted** key with only the scopes you need (`charges.create`, `customers.create`, `payment_intents.create`, `checkout.sessions.create`, …). No refunds/payouts/admin unless you explicitly want them.

### 4. Memory brain (`.kortix/memory/`)

- Agents `view` memory before real work
- Durable facts written via the `memory` tool
- `memory-reflector` cron (03:00 UTC) opens `memory: …` CRs for human review

### 5. Change requests — only way to land work

```sh
git add .
git commit -m "feat: …"
git push origin HEAD
kortix cr open --title "…" --description "…"
```

Humans review. Humans merge. Agents stay in their lane.

---

## Quick start

1. Clone / open this Machine project.
2. **Secrets** in the Machine dashboard (as needed):
   - `STRIPE_API_KEY` (restricted)
   - Optional: `GROQ_API_KEY`, `TAVILY_API_KEY`, `FIRECRAWL_API_KEY`, `REPLICATE_API_TOKEN`, `ELEVENLABS_API_KEY`
3. **Connectors** already declared in `kortix.toml` — share them with your user in Customize → Connectors.
4. Start a session — default agent is **`epic`**.
5. Try:
   - `/build <feature>`
   - `/research <question>`
   - `/ops create a stripe checkout for …`
   - `/ship`
   - `/supercharge` (audit + upgrade the agent stack)

---

## Model map (current SOTA wiring)

| Agent | Model (Kortix gateway) |
|---|---|
| `epic`, `architect`, `plan` | `kortix/anthropic/claude-opus-4.8` |
| `builder`, `critic`, `ops`, `general`, `build` | `kortix/anthropic/claude-sonnet-5` |
| `researcher` | `kortix/google/gemini-3.1-pro-preview` |
| `explore`, `small_model` | `kortix/anthropic/claude-haiku-4.5` |

When a stronger model ships, change the IDs in `opencode.jsonc` + agent frontmatter only.

---

## Pricing & profit (human-controlled)

Agents can create Checkout sessions and report on charges via Executor.  
A human still owns pricing tiers and the "charge $X" moment. Compliant and profitable — no rogue charges.

---

## Repo map

| Path | Purpose |
|---|---|
| `kortix.toml` | Project manifest, triggers, connectors, env contract |
| `AGENTS.md` | Project-wide rules every agent loads |
| `.kortix/opencode/opencode.jsonc` | Default agent/models/permissions |
| `.kortix/opencode/agents/` | `epic` + specialists + permission patterns |
| `.kortix/opencode/skills/epic-os/` | Super-agent playbook |
| `.kortix/opencode/commands/` | `/ship` `/build` `/review` … |
| `.kortix/memory/` | Living project brain |
| `README.md` | This file |

---

## Security posture

- No keys in git, prompts, agent memory, or env files committed to the repo
- Outside world only through Executor Gateway
- Narrowest connector scopes
- Risky tools declared; destructive ops confirmed
- Memory + code land through human-reviewed CRs
- All Executor calls audited

---

**Epic Tech AI — autonomous when it should be, secure when it must be, profitable by design.**

[github.com/epictechai](https://github.com/epictechai) · [x.com/EpicTechAI](https://x.com/EpicTechAI) · epictechai@gmail.com
