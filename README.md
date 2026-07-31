# Epic Tech AI

Local multi-agent stack (OpenCode). **You run it on your machine. You bring the API key.**

| | |
|---|---|
| **Install site** | https://epictechai.github.io/epic-tech-ai-agent/ |
| **Windows installer** | [DO_EVERYTHING.bat](https://github.com/epictechai/epic-tech-ai-agent/releases/download/windows-latest/DO_EVERYTHING.bat) |
| **Get API keys (Slack)** | https://epictechai.github.io/epic-tech-ai-agent/keys.html |
| **GitHub** | https://github.com/epictechai/epic-tech-ai-agent |
| **License** | MIT |

---

## Quick start

### Windows
1. Install [Node.js LTS](https://nodejs.org) → open a **new** terminal → `node -v`
2. Download [**DO_EVERYTHING.bat**](https://github.com/epictechai/epic-tech-ai-agent/releases/download/windows-latest/DO_EVERYTHING.bat)
3. Double-click it (Unblock in file Properties if Windows blocks it)
4. When prompted: `opencode auth login` (paste key **only there**)
5. Open **http://127.0.0.1:4097/** — keep the console window open

### macOS / Linux
```bash
git clone https://github.com/epictechai/epic-tech-ai-agent.git
cd epic-tech-ai-agent
chmod +x LAUNCH.sh scripts/*.sh
# Install OpenCode: https://opencode.ai/docs
opencode auth login
./LAUNCH.sh
```

### Verify
```bash
opencode --version
opencode auth list
npm run secret-scan    # optional: confirm no secrets in git
```

---

## What this is

- Agent **`epic`** + specialists (build, research, design, ops, …)
- Skills, slash commands, project memory under `.kortix/`
- **No API keys in the repository** — use `opencode auth login` or a gitignored `.env`

This is **not** a hosted chatbot. The GitHub Pages site only documents and links installers.

---

## Repo layout

```
DO_EVERYTHING.bat     Windows: install + launch
LAUNCH.bat / LAUNCH.sh
windows/              Windows scripts
docs/                 GitHub Pages site
.kortix/              agents, skills, config
scripts/secret-scan.sh
LICENSE · SECURITY.md · .env.example
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Not compatible with Windows | [INSTALL_OPENCODE_WINDOWS.bat](https://github.com/epictechai/epic-tech-ai-agent/releases/download/windows-latest/INSTALL_OPENCODE_WINDOWS.bat) |
| Web UI won’t start | [RUN_TUI.bat](https://github.com/epictechai/epic-tech-ai-agent/releases/download/windows-latest/RUN_TUI.bat) · check `%TEMP%\epic-web-run.log` |
| No model / server error | `opencode auth login` · pick a model your key supports |
| SmartScreen blocks .bat | Properties → Unblock · or git clone and run `windows\DO_EVERYTHING.bat` |

Full guide: https://epictechai.github.io/epic-tech-ai-agent/guide.html

---

## Docs & legal

[Terms](https://epictechai.github.io/epic-tech-ai-agent/terms.html) ·
[Privacy](https://epictechai.github.io/epic-tech-ai-agent/privacy.html) ·
[AUP](https://epictechai.github.io/epic-tech-ai-agent/aup.html) ·
[Disclaimer](https://epictechai.github.io/epic-tech-ai-agent/disclaimer.html) ·
[License](LICENSE) ·
[Security](SECURITY.md)

---

## After it runs

In the UI, agent **epic**. Try:

```
/anything hello — what can you do?
```

---

**Epic Tech AI** · [github.com/epictechai](https://github.com/epictechai) · [x.com/EpicTechAI](https://x.com/EpicTechAI) · epictechai@gmail.com
