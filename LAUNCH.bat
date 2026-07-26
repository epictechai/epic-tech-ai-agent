@echo off
REM Epic Tech AI — one-click Windows launcher
title Epic Tech AI — Local Agent
cd /d "%~dp0"

echo.
echo   ========================================
echo     EPIC TECH AI  -  LOCAL AGENT
echo     github.com/epictechai
echo   ========================================
echo.

where opencode >nul 2>&1
if errorlevel 1 (
  echo opencode CLI not found.
  echo Install from https://opencode.ai/docs then re-run LAUNCH.bat
  pause
  exit /b 1
)

if not exist ".opencode" (
  mklink /D ".opencode" ".kortix\opencode" >nul 2>&1
  if errorlevel 1 (
    REM fallback copy junction via powershell
    powershell -NoProfile -Command "New-Item -ItemType Junction -Path '.opencode' -Target '.kortix\opencode' -Force" >nul 2>&1
  )
)

set "OPENCODE_CONFIG_DIR=%cd%\.kortix\opencode"
set "PORT=4097"
set "HOST=127.0.0.1"

if not exist "%OPENCODE_CONFIG_DIR%\node_modules" (
  where bun >nul 2>&1 && (cd /d "%OPENCODE_CONFIG_DIR%" & bun install & cd /d "%~dp0")
  if errorlevel 1 (
    where npm >nul 2>&1 && (cd /d "%OPENCODE_CONFIG_DIR%" & call npm install & cd /d "%~dp0")
  )
)

echo Starting Epic web UI on http://%HOST%:%PORT%/
echo Default agent: epic
echo.

start "" "http://%HOST%:%PORT%/"
opencode web --hostname %HOST% --port %PORT%
pause
