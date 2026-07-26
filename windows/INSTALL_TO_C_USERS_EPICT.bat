@echo off
setlocal EnableExtensions
REM ============================================================
REM  Epic Tech AI — installs into C:\Users\epict\EpicTechAI
REM  Double-click this file from Downloads (or anywhere).
REM ============================================================
title Epic Tech AI — Install to C:\Users\epict\EpicTechAI
color 0A

set "DEST=C:\Users\epict\EpicTechAI"
set "REPO=https://github.com/epictechai/epic-tech-ai-agent.git"
set "ZIP=https://github.com/epictechai/epic-tech-ai-agent/archive/refs/heads/main.zip"
set "ZIPFILE=%TEMP%\epic-tech-ai-agent-main.zip"
set "UNZ=%TEMP%\epic-unz"

echo.
echo   Installing Epic Tech AI to:
echo   %DEST%
echo.

if not exist "%DEST%" mkdir "%DEST%"

REM If already installed with agent files, just launch
if exist "%DEST%\.kortix\opencode\opencode.jsonc" (
  echo   [OK] Already installed.
  cd /d "%DEST%"
  goto :RUN
)
if exist "%DEST%\epic-tech-ai-agent\.kortix\opencode\opencode.jsonc" (
  echo   [OK] Found epic-tech-ai-agent subfolder.
  cd /d "%DEST%\epic-tech-ai-agent"
  goto :RUN
)

where git >nul 2>&1
if not errorlevel 1 (
  echo   Cloning with git...
  git clone "%REPO%" "%DEST%\epic-tech-ai-agent"
  if not errorlevel 1 (
    cd /d "%DEST%\epic-tech-ai-agent"
    goto :RUN
  )
)

echo   Downloading ZIP...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Invoke-WebRequest -Uri '%ZIP%' -OutFile '%ZIPFILE%' -UseBasicParsing"
if errorlevel 1 (
  echo   [!] Download failed. Opening browser...
  start "" "%ZIP%"
  pause
  exit /b 1
)

if exist "%UNZ%" rmdir /s /q "%UNZ%"
mkdir "%UNZ%"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Expand-Archive -Path '%ZIPFILE%' -DestinationPath '%UNZ%' -Force"

if not exist "%DEST%\epic-tech-ai-agent" mkdir "%DEST%\epic-tech-ai-agent"
robocopy "%UNZ%\epic-tech-ai-agent-main" "%DEST%\epic-tech-ai-agent" /E /NFL /NDL /NJH /NJS /nc /ns /np >nul
cd /d "%DEST%\epic-tech-ai-agent"
echo   [OK] Installed to %CD%

:RUN
echo.
echo   Copying easy launchers to %DEST% ...
copy /Y "%CD%\LAUNCH.bat" "%DEST%\2_RUN_EPIC.bat" >nul 2>&1
copy /Y "%CD%\LAUNCH.bat" "%DEST%\LAUNCH.bat" >nul 2>&1
copy /Y "%CD%\START_EPIC.bat" "%DEST%\START_EPIC.bat" >nul 2>&1
if exist "%CD%\SETUP_AND_LAUNCH.bat" copy /Y "%CD%\SETUP_AND_LAUNCH.bat" "%DEST%\1_FIRST_TIME_SETUP.bat" >nul 2>&1

echo.
echo   Launching agent from:
echo   %CD%
echo.
if exist "%CD%\LAUNCH.bat" (
  call "%CD%\LAUNCH.bat"
) else (
  echo   [!] LAUNCH.bat missing
  pause
  exit /b 1
)
endlocal
