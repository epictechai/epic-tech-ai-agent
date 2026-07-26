# Epic Tech AI — Full SOTA Super-Agent

**A system designed to outperform any single frontier-lab model on real work — every skill, every specialist, verification before ship, secure by default.**

| | |
|---|---|
| **Launch (GitHub Pages)** | **[epictechai.github.io/epic-tech-ai-agent](https://epictechai.github.io/epic-tech-ai-agent/)** |
| GitHub | [github.com/epictechai/epic-tech-ai-agent](https://github.com/epictechai/epic-tech-ai-agent) |
| Org | [github.com/epictechai](https://github.com/epictechai) |
| X | [x.com/EpicTechAI](https://x.com/EpicTechAI) |
| Email | epictechai@gmail.com |

### Why Epic > a raw frontier chat model

| Single lab model | Epic system |
|---|---|
| One reasoning pass | Multi-agent + `@critic` loop (`epic-frontier`) |
| Session amnesia | Project memory brain |
| Talks about code | Runs your stack (shell, browser, media) |
| Same weights for all jobs | Routes Opus / Sonnet / Gemini / Haiku |
| Draft text | Verify → ship |
| Keys in prompts | Executor Gateway |

Mechanism is documented in `.kortix/opencode/skills/epic-frontier/` — not slogans.
---

## What you get

| Layer | Power |
|---|---|
| **`epic`** | Primary orchestrator — Claude Opus 4.8 **max** thinking |
| **12 specialists** | architect · builder · researcher · critic · ops · designer · writer · analyst · counsel · creator · seller · product |
| **`epic-powers`** | Master matrix routing **60+ domain skills** |
| **`epic-os`** | Stable mission loop (models can change; OS doesn't) |
| **15 commands** | `/anything` plus ship/build/design/write/analyze/legal/create/sell/site/… |
| **Executor** | Third-party APIs with server-side secrets + audit |
| **Memory brain** | `.kortix/memory/` across sessions |
| **Browser + media** | agent-browser, Replicate, ElevenLabs, Remotion, Whisper |

---

## Full-power entry points

```
/anything <do this end-to-end>
/build <feature>
/research <question>
/design <brief>
/write <assignment>
/analyze <data question>
/legal <matter>
/create <media brief>
/sell <target>
/site <website brief>
/ops <integration>
/ship
/supercharge
```

---

## Skill surface (all loaded via epic-powers)

- **Research** — deep-research, OpenAlex, competitive intel, account research, domain whois  
- **Build** — webapp, website-building, coding-and-data, PRDs, roadmaps  
- **Docs** — docx, xlsx, pptx, pdf, presentations, logos, themes  
- **Media** — Replicate, ElevenLabs, Whisper, Remotion  
- **GTM** — outreach, call prep, campaigns, battlecards, assets  
- **Finance/data** — SQL, stats, variance, reconciliation, audit  
- **Legal** — contracts, NDA, compliance, risk  
- **Platform** — Executor, memory, Slack, browser, Machine system  

---

## Model map

| Role | Model |
|---|---|
| epic / architect / counsel / plan | `kortix/anthropic/claude-opus-4.8` (max/high) |
| builder / critic / ops / most specialists | `kortix/anthropic/claude-sonnet-5` |
| researcher | `kortix/google/gemini-3.1-pro-preview` |
| explore / small_model | `kortix/anthropic/claude-haiku-4.5` |

Swap IDs only in `.kortix/opencode/opencode.jsonc` + agent frontmatter.

---

## Security

- No keys in git  
- Executor-only third parties  
- Human-owned Stripe pricing  
- No malware / criminal assistance  
- CRs for Machine `main` (agents never self-merge)  

---

## Repo layout

```
AGENTS.md
README.md
kortix.toml
.kortix/memory/          # project brain
.kortix/opencode/
  agents/                # epic + 12 specialists
  commands/              # /anything and domain modes
  skills/                # epic-os, epic-powers, GKW library, platform
  tools/                 # memory, show, search, scrape
  opencode.jsonc         # default agent + SOTA models
```

---

## One-click launch — local

| OS | What to do |
|---|---|
| **macOS** | Double-click `LAUNCH.command` |
| **Linux / Mac terminal** | `./LAUNCH.sh` |
| **Windows** | Double-click `LAUNCH.bat` (or `LAUNCH.ps1`) |
| **npm** | `npm start` |

That starts the **Epic** web UI (default agent, full SOTA) and opens your browser.

```bash
git clone https://github.com/epictechai/epic-tech-ai-agent.git
cd epic-tech-ai-agent
chmod +x LAUNCH.sh LAUNCH.command scripts/*.sh   # first time only
./LAUNCH.sh                    # web UI (one-click)
./LAUNCH.sh tui                # terminal UI
./LAUNCH.sh doctor             # health check
npm start                      # same as ./LAUNCH.sh
npm run agent:run -- "your task"
```

Requires [OpenCode](https://opencode.ai/docs) on PATH and a model provider
(`opencode providers` / Machine Kortix gateway credentials).

## Quick start — Machine

1. Import this repo as a Machine project (or copy `.kortix/` + `kortix.toml`).  
2. Set dashboard secrets as needed (Stripe restricted, Tavily, Replicate, ElevenLabs, …).  
3. Start a session — default agent is **`epic`**.  
4. Run `/anything <your mission>`.  

---

**Epic Tech AI — every legitimate power, zero key leakage, ship by default.**
