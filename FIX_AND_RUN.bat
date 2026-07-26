@echo off
setlocal EnableExtensions
REM Quick repair + launch for C:\Users\epict\EpicTechAI\EpicTechAI-Windows
title Epic Tech AI — Fix and Run
cd /d "%~dp0"
color 0B

echo.
echo   Epic Tech AI — FIX AND RUN
echo   Folder: %CD%
echo.

where node >nul 2>&1 || (
  echo [!] Node not found. Install LTS from https://nodejs.org then re-run.
  pause & exit /b 1
)
where npm >nul 2>&1 || (
  echo [!] npm not found.
  pause & exit /b 1
)

echo [1/4] Ensuring OpenCode...
where opencode >nul 2>&1 || call npm install -g opencode-ai
opencode --version
if errorlevel 1 (
  echo [!] opencode still missing. Try: npm install -g opencode-ai
  pause & exit /b 1
)

echo [2/4] Tool deps...
if exist ".kortix\opencode\package.json" (
  pushd ".kortix\opencode"
  call npm install --no-fund --no-audit
  popd
)

echo [3/4] Auth check...
opencode auth list
echo.
echo   If no credentials: run   opencode auth login
echo   then re-run this file.
echo.

echo [4/4] Launching...
if exist "%~dp0LAUNCH.bat" (
  call "%~dp0LAUNCH.bat"
) else (
  echo LAUNCH.bat missing
  pause
)
endlocal
