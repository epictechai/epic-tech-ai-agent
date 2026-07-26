@echo off
REM Terminal UI fallback — works when browser UI misbehaves
cd /d "%~dp0"
title Epic Tech AI — TUI
set "OPENCODE_CONFIG_DIR=%~dp0.kortix\opencode"
if not exist "%OPENCODE_CONFIG_DIR%\opencode.jsonc" (
  echo Missing agent config.
  pause
  exit /b 1
)
where opencode >nul 2>&1 || (
  echo Install: npm install -g opencode-ai
  pause
  exit /b 1
)
echo Starting Epic TUI ^(agent: epic^)...
echo Type a message. Exit with Ctrl+C.
echo.
opencode --agent epic .
pause
