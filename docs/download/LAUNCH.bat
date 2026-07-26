@echo off
setlocal EnableExtensions
REM ============================================================
REM  Epic Tech AI — FULLY LOCAL Windows launcher
REM  Double-click this file from the repo folder.
REM  Path example: C:\Users\epict\EpicTechAI\LAUNCH.bat
REM  https://github.com/epictechai/epic-tech-ai-agent
REM ============================================================
title Epic Tech AI — Local Agent
color 0A
cd /d "%~dp0"

echo.
echo   ================================================
echo     EPIC TECH AI  -  FULLY LOCAL AGENT ^(Windows^)
echo     github.com/epictechai/epic-tech-ai-agent
echo   ================================================
echo.
echo   Folder: %CD%
echo.

REM --- Must be inside the repo (has .kortix\opencode) ---
if not exist "%~dp0.kortix\opencode\opencode.jsonc" (
  echo   [!] This folder is missing the agent files.
  echo   [!] Use SETUP_AND_LAUNCH.bat first ^(clones the full repo^).
  echo.
  if exist "%~dp0SETUP_AND_LAUNCH.bat" (
    echo   Running SETUP_AND_LAUNCH.bat ...
    call "%~dp0SETUP_AND_LAUNCH.bat"
    exit /b %ERRORLEVEL%
  )
  echo   Download:
  echo   https://github.com/epictechai/epic-tech-ai-agent/archive/refs/heads/main.zip
  echo   Or run SETUP_AND_LAUNCH.bat from:
  echo   https://raw.githubusercontent.com/epictechai/epic-tech-ai-agent/main/SETUP_AND_LAUNCH.bat
  echo.
  pause
  exit /b 1
)

REM --- Find opencode on PATH ---
where opencode >nul 2>&1
if errorlevel 1 (
  echo   [!] opencode CLI not found on PATH.
  echo.
  echo   Install ONE of these, then close this window and double-click LAUNCH.bat again:
  echo.
  echo   A^) Official installer:
  echo      https://opencode.ai/docs
  echo.
  echo   B^) npm ^(if you have Node.js^):
  echo      npm install -g opencode-ai
  echo.
  echo   C^) winget ^(Windows 11^):
  echo      winget search opencode
  echo.
  start "" "https://opencode.ai/docs"
  pause
  exit /b 1
)

for /f "tokens=*" %%V in ('opencode --version 2^>nul') do set "OCVER=%%V"
echo   opencode: %OCVER%

REM --- Link .opencode -^> .kortix\opencode ---
if not exist "%~dp0.opencode" (
  echo   Linking .opencode ...
  mklink /J "%~dp0.opencode" "%~dp0.kortix\opencode" >nul 2>&1
  if errorlevel 1 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "New-Item -ItemType Junction -Path '%~dp0.opencode' -Target '%~dp0.kortix\opencode' -Force | Out-Null" 2>nul
  )
)

set "OPENCODE_CONFIG_DIR=%~dp0.kortix\opencode"
set "HOST=127.0.0.1"
set "PORT=4097"

REM --- Pick free port if 4097 busy ---
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p=4097; while (Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue) { $p++ }; Set-Content -Path '%TEMP%\epic-port.txt' -Value $p" 2>nul
if exist "%TEMP%\epic-port.txt" (
  set /p PORT=<"%TEMP%\epic-port.txt"
)

REM --- Tool deps ---
if not exist "%OPENCODE_CONFIG_DIR%\node_modules\" (
  echo   Installing tool dependencies...
  pushd "%OPENCODE_CONFIG_DIR%"
  where bun >nul 2>&1 && (
    bun install
  ) || (
    where npm >nul 2>&1 && call npm install
  )
  popd
)

echo.
echo   Starting Epic web UI...
echo   URL:     http://%HOST%:%PORT%/
echo   Agent:   epic  ^(fully local on THIS PC^)
echo   Config:  %OPENCODE_CONFIG_DIR%
echo.
echo   Keep this window open. Press Ctrl+C to stop.
echo.

timeout /t 2 /nobreak >nul
start "" "http://%HOST%:%PORT%/"

opencode web --hostname %HOST% --port %PORT%
set "ERR=%ERRORLEVEL%"

echo.
if not "%ERR%"=="0" (
  echo   [!] opencode exited with code %ERR%
  echo   Tip: run  opencode providers   to configure a model API key.
)
echo   Agent stopped.
pause
endlocal
exit /b %ERR%
