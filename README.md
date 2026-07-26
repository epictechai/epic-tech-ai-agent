# Epic Tech AI

**Secure multi-agent system for real work — not a chatbot wrapper.**  
Orchestrates specialists, 60+ skills, tools, memory, and verification. Open source (MIT).

| | |
|---|---|
| **Windows (one click)** | [DO_EVERYTHING.bat](https://github.com/epictechai/epic-tech-ai-agent/releases/download/windows-latest/DO_EVERYTHING.bat) |
| **Download page** | [epictechai.github.io/…/download](https://epictechai.github.io/epic-tech-ai-agent/download/) |
| **Site** | [epictechai.github.io/epic-tech-ai-agent](https://epictechai.github.io/epic-tech-ai-agent/) |
| **GitHub** | [github.com/epictechai/epic-tech-ai-agent](https://github.com/epictechai/epic-tech-ai-agent) |
| **X** | [@EpicTechAI](https://x.com/EpicTechAI) |
| **Email** | epictechai@gmail.com |

---

## Launch

### Windows
1. Download [**DO_EVERYTHING.bat**](https://github.com/epictechai/epic-tech-ai-agent/releases/download/windows-latest/DO_EVERYTHING.bat)
2. Save to a folder (e.g. `C:\Users\epict\EpicTechAI`)
3. Double-click  

Fixes OpenCode on Windows 10 (baseline binary), installs the agent, starts local UI.

Optional release assets: `LAUNCH.bat` · `RUN_TUI.bat` · `INSTALL_OPENCODE_WINDOWS.bat`

### macOS / Linux
```bash
git clone https://github.com/epictechai/epic-tech-ai-agent.git
cd epic-tech-ai-agent
chmod +x LAUNCH.sh LAUNCH.command scripts/*.sh
./LAUNCH.sh
```

Requires [OpenCode](https://opencode.ai/docs) and a model provider (`opencode auth login`).

---

## What you get

| Layer | Role |
|---|---|
| **`epic`** | Primary orchestrator (Opus-class, max reasoning) |
| **12 specialists** | architect · builder · researcher · critic · ops · designer · writer · analyst · counsel · creator · seller · product |
| **`epic-os` / `epic-powers` / `epic-frontier`** | Mission loop · skill matrix · beat solo-model failure modes |
| **Commands** | `/anything` `/build` `/research` `/design` `/write` `/analyze` `/legal` `/create` `/sell` `/site` `/ops` `/ship` … |
| **Memory** | `.kortix/memory/` project brain |
| **Executor** | Third-party APIs without leaking keys (on Machine) |

**System > single model:** multi-agent routing, tools, memory, critic loop, verification before ship. See [whitepaper](https://epictechai.github.io/epic-tech-ai-agent/whitepaper.html).

---

## Repo layout

```
DO_EVERYTHING.bat          Windows master installer
LAUNCH.bat / LAUNCH.sh     Start agent
LAUNCH.command / LAUNCH.ps1
windows/                   Windows scripts + README.txt
docs/                      GitHub Pages (legal, guide, launcher)
.kortix/agents|skills|memory
scripts/                   setup-local.sh, run-local.sh
LICENSE · SECURITY.md · TERMS (site)
```

---

## Docs & legal

| | |
|---|---|
| Docs hub | https://epictechai.github.io/epic-tech-ai-agent/docs.html |
| User guide | https://epictechai.github.io/epic-tech-ai-agent/guide.html |
| Whitepaper | https://epictechai.github.io/epic-tech-ai-agent/whitepaper.html |
| Terms · Privacy · AUP · Disclaimer · License | [site footer](https://epictechai.github.io/epic-tech-ai-agent/) |
| Security | [SECURITY.md](SECURITY.md) |
| Contributing | [CONTRIBUTING.md](CONTRIBUTING.md) |
| Code of Conduct | [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) |
| Citation | [CITATION.cff](CITATION.cff) |

Software is **MIT**. Site use is subject to Terms & AUP. AI output is **not** professional advice.

### Secrets (bulletproof rule)

- **No API keys in this repo** — verified by `npm run secret-scan` / `bash scripts/secret-scan.sh`
- Use `opencode auth login` or a local `.env` (gitignored). See [`.env.example`](.env.example)
- If a key was ever pasted in chat: **revoke it** and create a new one

---

## After launch

```
/anything <mission>
```

Specialists: `@architect` `@builder` `@researcher` `@critic` `@ops` `@designer` `@writer` `@analyst` `@counsel` `@creator` `@seller` `@product`

---

**Epic Tech AI** — autonomous when it should be, secure when it must be.  
[github.com/epictechai](https://github.com/epictechai) · [x.com/EpicTechAI](https://x.com/EpicTechAI) · epictechai@gmail.com
