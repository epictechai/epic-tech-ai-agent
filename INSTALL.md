# Install Epic Tech AI (local)

Same content as the website, in the repo.

## You need
1. **Node.js LTS** — https://nodejs.org  
2. **API key** (OpenAI etc.) — never commit it  
3. **Installer** below  

## Windows
1. `node -v` works in a new terminal  
2. Download https://github.com/epictechai/epic-tech-ai-agent/releases/download/windows-latest/DO_EVERYTHING.bat  
3. Double-click  
4. `opencode auth login` when asked  
5. Browser: http://127.0.0.1:4097/  

## macOS / Linux
```bash
git clone https://github.com/epictechai/epic-tech-ai-agent.git
cd epic-tech-ai-agent
chmod +x LAUNCH.sh scripts/*.sh
opencode auth login   # after installing OpenCode
./LAUNCH.sh
```

## Optional Windows tools
- LAUNCH.bat — start if already installed  
- RUN_TUI.bat — terminal UI  
- INSTALL_OPENCODE_WINDOWS.bat — fix “not compatible with Windows”  

Release: https://github.com/epictechai/epic-tech-ai-agent/releases/tag/windows-latest  
Site: https://epictechai.github.io/epic-tech-ai-agent/  
