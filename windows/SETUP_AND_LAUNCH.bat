@echo off
setlocal EnableExtensions
REM ============================================================
REM  Epic Tech AI — FIRST TIME Windows setup + launch
REM
REM  Put this file in:  C:\Users\epict\EpicTechAI\
REM  Double-click it. It will:
REM    1) clone the full repo if missing
REM    2) open LAUNCH.bat  ^(fully local agent^)
REM
REM  Direct download of THIS file:
REM  https://raw.githubusercontent.com/epictechai/epic-tech-ai-agent/main/SETUP_AND_LAUNCH.bat
REM ============================================================
title Epic Tech AI — Setup + Launch
color 0B
cd /d "%~dp0"

set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"
set "REPO_URL=https://github.com/epictechai/epic-tech-ai-agent.git"
set "ZIP_URL=https://github.com/epictechai/epic-tech-ai-agent/archive/refs/heads/main.zip"
set "TARGET=%ROOT%"

echo.
echo   ================================================
echo     EPIC TECH AI  -  WINDOWS SETUP + LAUNCH
echo     Target: %TARGET%
echo   ================================================
echo.

REM --- If we already have the full repo here, just launch ---
if exist "%ROOT%\.kortix\opencode\opencode.jsonc" (
  echo   [OK] Agent files found in this folder.
  goto :LAUNCH
)

REM --- If repo is in a subfolder epic-tech-ai-agent ---
if exist "%ROOT%\epic-tech-ai-agent\.kortix\opencode\opencode.jsonc" (
  echo   [OK] Found subfolder epic-tech-ai-agent
  cd /d "%ROOT%\epic-tech-ai-agent"
  goto :LAUNCH
)

echo   [!] Full agent repo not found yet. Installing into this folder...
echo.

REM --- Prefer git clone into current folder if empty-ish ---
where git >nul 2>&1
if not errorlevel 1 (
  echo   Cloning with git...
  REM clone into temp dir then robocopy into place if folder not empty
  if not exist "%ROOT%\.git" (
    git clone "%REPO_URL%" "%ROOT%\epic-tech-ai-agent"
    if errorlevel 1 (
      echo   [!] git clone failed. Trying ZIP download...
      goto :ZIP
    )
    cd /d "%ROOT%\epic-tech-ai-agent"
    echo   [OK] Cloned to %CD%
    goto :LAUNCH
  )
)

:ZIP
echo   Downloading ZIP...
set "ZIP=%TEMP%\epic-tech-ai-agent-main.zip"
set "UNZ=%TEMP%\epic-tech-ai-unzip"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try { Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%ZIP%' -UseBasicParsing } catch { exit 1 }"
if errorlevel 1 (
  echo   [!] Download failed. Open in browser and extract manually:
  echo   %ZIP_URL%
  start "" "%ZIP_URL%"
  pause
  exit /b 1
)

if exist "%UNZ%" rmdir /s /q "%UNZ%"
mkdir "%UNZ%" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Expand-Archive -Path '%ZIP%' -DestinationPath '%UNZ%' -Force"

if not exist "%ROOT%\epic-tech-ai-agent" mkdir "%ROOT%\epic-tech-ai-agent"
robocopy "%UNZ%\epic-tech-ai-agent-main" "%ROOT%\epic-tech-ai-agent" /E /NFL /NDL /NJH /NJS /nc /ns /np >nul
cd /d "%ROOT%\epic-tech-ai-agent"
echo   [OK] Extracted to %CD%

:LAUNCH
echo.
echo   Starting LAUNCH.bat ...
echo.
if not exist "%CD%\LAUNCH.bat" (
  echo   [!] LAUNCH.bat missing in %CD%
  pause
  exit /b 1
)
call "%CD%\LAUNCH.bat"
exit /b %ERRORLEVEL%
