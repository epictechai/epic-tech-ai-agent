@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM ============================================================
REM  Install OpenCode for Windows 10 (x64 BASELINE build)
REM  Fixes: "not compatible with the version of Windows"
REM ============================================================
title Epic Tech AI — Install OpenCode (Windows baseline)
color 0B
cd /d "%~dp0"

echo.
echo   ================================================
echo     INSTALL OPENCODE FOR WINDOWS 10
echo     Uses: opencode-windows-x64-baseline
echo   ================================================
echo.

where node >nul 2>&1
if errorlevel 1 (
  echo   [!] Node.js not found. Install LTS from https://nodejs.org
  start "" "https://nodejs.org"
  pause
  exit /b 1
)
where npm >nul 2>&1
if errorlevel 1 (
  echo   [!] npm not found.
  pause
  exit /b 1
)

echo   node:
node -v
echo   npm:
npm -v
echo.

echo   [1/5] Removing broken global opencode-ai ^(if any^)...
call npm uninstall -g opencode-ai >nul 2>&1
call npm uninstall -g opencode-windows-x64 >nul 2>&1
call npm uninstall -g opencode-windows-x64-baseline >nul 2>&1

REM Clean leftover shim
set "NPM_ROOT="
for /f "tokens=*" %%R in ('npm root -g 2^>nul') do set "NPM_ROOT=%%R"
set "NPM_BIN="
for /f "tokens=*" %%B in ('npm bin -g 2^>nul') do set "NPM_BIN=%%B"
if defined NPM_BIN (
  if exist "%NPM_BIN%\opencode.cmd" del /f /q "%NPM_BIN%\opencode.cmd" >nul 2>&1
  if exist "%NPM_BIN%\opencode" del /f /q "%NPM_BIN%\opencode" >nul 2>&1
  if exist "%NPM_BIN%\opencode.exe" del /f /q "%NPM_BIN%\opencode.exe" >nul 2>&1
)
if exist "%APPDATA%\npm\opencode.cmd" del /f /q "%APPDATA%\npm\opencode.cmd" >nul 2>&1
if exist "%APPDATA%\npm\opencode.ps1" del /f /q "%APPDATA%\npm\opencode.ps1" >nul 2>&1
if exist "%APPDATA%\npm\opencode" del /f /q "%APPDATA%\npm\opencode" >nul 2>&1
if exist "%APPDATA%\npm\node_modules\opencode-ai" rmdir /s /q "%APPDATA%\npm\node_modules\opencode-ai" >nul 2>&1

echo   [2/5] Installing baseline Windows binary package...
call npm install -g opencode-windows-x64-baseline@latest
if errorlevel 1 (
  echo   [!] npm install baseline failed. Trying full package + baseline optional...
  call npm install -g opencode-ai@latest
)

echo   [3/5] Locating opencode.exe ...
set "OC_EXE="

REM Common locations for baseline package
if exist "%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" (
  set "OC_EXE=%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\bin\opencode.exe"
)
if not defined OC_EXE if exist "%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\opencode.exe" (
  set "OC_EXE=%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\opencode.exe"
)
if not defined OC_EXE if exist "%APPDATA%\npm\node_modules\opencode-ai\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" (
  set "OC_EXE=%APPDATA%\npm\node_modules\opencode-ai\node_modules\opencode-windows-x64-baseline\bin\opencode.exe"
)
if not defined OC_EXE if exist "%ProgramFiles%\nodejs\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" (
  set "OC_EXE=%ProgramFiles%\nodejs\node_modules\opencode-windows-x64-baseline\bin\opencode.exe"
)

REM Search under npm root
if not defined OC_EXE if defined NPM_ROOT (
  for /f "delims=" %%F in ('dir /s /b "%NPM_ROOT%\opencode.exe" 2^>nul') do (
    echo %%F | findstr /I "baseline windows-x64" >nul
    if not errorlevel 1 (
      set "OC_EXE=%%F"
      goto :FOUND
    )
    if not defined OC_EXE set "OC_EXE=%%F"
  )
)

:FOUND
if not defined OC_EXE (
  echo   [!] Could not find opencode.exe after install.
  echo       Search manually under:
  echo       %APPDATA%\npm\node_modules\
  echo.
  echo   Alternative: install desktop app
  echo   https://github.com/sst/opencode/releases
  echo   Download: opencode-desktop-win-x64.exe  OR  opencode-windows zip baseline
  start "" "https://github.com/sst/opencode/releases"
  pause
  exit /b 1
)

echo   Found: !OC_EXE!

echo   [4/5] Writing launcher shim to %%APPDATA%%\npm\opencode.cmd
if not exist "%APPDATA%\npm" mkdir "%APPDATA%\npm"
(
  echo @echo off
  echo " !OC_EXE! " %%*
) > "%APPDATA%\npm\opencode.cmd"

REM Also local shim in this folder / user EpicTechAI
(
  echo @echo off
  echo " !OC_EXE! " %%*
) > "%~dp0opencode.cmd"

if exist "C:\Users\epict\EpicTechAI" (
  copy /Y "%~dp0opencode.cmd" "C:\Users\epict\EpicTechAI\opencode.cmd" >nul 2>&1
)
if exist "C:\Users\epict\EpicTechAI\EpicTechAI-Windows" (
  copy /Y "%~dp0opencode.cmd" "C:\Users\epict\EpicTechAI\EpicTechAI-Windows\opencode.cmd" >nul 2>&1
)

echo   [5/5] Testing...
call "%APPDATA%\npm\opencode.cmd" --version
if errorlevel 1 (
  echo.
  echo   [!] Still failed. Your CPU/Windows may need the desktop installer:
  echo   https://github.com/sst/opencode/releases
  echo   File: opencode-desktop-win-x64.exe
  start "" "https://github.com/sst/opencode/releases"
  pause
  exit /b 1
)

echo.
echo   [OK] OpenCode works.
echo.
echo   Next:
echo     1^) opencode auth login
echo     2^) cd C:\Users\epict\EpicTechAI\EpicTechAI-Windows
echo     3^) FIX_AND_RUN.bat
echo.
echo   If 'opencode' is still not found in a NEW terminal, use full path:
echo   %APPDATA%\npm\opencode.cmd --version
echo   Or the local:  %~dp0opencode.cmd --version
echo.
pause
endlocal
