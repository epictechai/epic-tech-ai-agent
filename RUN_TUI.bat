@echo off
setlocal
cd /d "%~dp0\.." 2>nul
if not exist "%CD%\.kortix\opencode\opencode.jsonc" cd /d "%~dp0"
if not exist "%CD%\.kortix\opencode\opencode.jsonc" (
  echo Run DO_EVERYTHING.bat first.
  pause
  exit /b 1
)
set "OPENCODE_CONFIG_DIR=%CD%\.kortix\opencode"
set "OC=%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\bin\opencode.exe"
if not exist "%OC%" set "OC=opencode"
title Epic Tech AI — TUI
echo Agent: epic  ^|  Ctrl+C to exit
echo.
"%OC%" --agent epic .
pause
