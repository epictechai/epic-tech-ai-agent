@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM Epic Tech AI — start agent (repo already installed)
title Epic Tech AI — Launch
color 0A
cd /d "%~dp0\.." 2>nul
if not exist "%CD%\.kortix\opencode\opencode.jsonc" cd /d "%~dp0"
if not exist "%CD%\.kortix\opencode\opencode.jsonc" (
  echo Run DO_EVERYTHING.bat first.
  pause
  exit /b 1
)

set "APP=%CD%"
set "OPENCODE_CONFIG_DIR=%APP%\.kortix\opencode"
set "OC_EXE="

if exist "%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" set "OC_EXE=%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\bin\opencode.exe"
if not defined OC_EXE if exist "%APPDATA%\npm\opencode.cmd" set "OC_EXE=opencode"
if not defined OC_EXE set "OC_EXE=opencode"

echo.
echo   Epic Tech AI
echo   Folder: %APP%
echo   Binary: %OC_EXE%
echo.

"%OC_EXE%" --version
if errorlevel 1 (
  echo OpenCode broken. Run DO_EVERYTHING.bat or INSTALL_OPENCODE_WINDOWS.bat
  pause
  exit /b 1
)

if not exist "%APP%\.opencode\" (
  mklink /J "%APP%\.opencode" "%APP%\.kortix\opencode" >nul 2>&1
)

echo   Starting web UI http://127.0.0.1:4097/
echo   Keep this window open.
echo.

set "SLOG=%TEMP%\epic-launch.log"
(
  echo @echo off
  echo cd /d "%APP%"
  echo set OPENCODE_CONFIG_DIR=%APP%\.kortix\opencode
  echo "%OC_EXE%" web --hostname 127.0.0.1 --port 4097 --pure --print-logs
) > "%TEMP%\epic-launch-web.cmd"

start "EpicServer" /MIN cmd /c "call \"%TEMP%\epic-launch-web.cmd\" > \"%SLOG%\" 2>&1"

set READY=0
for /L %%I in (1,1,45) do (
  powershell -NoProfile -Command "try{Invoke-WebRequest http://127.0.0.1:4097/ -UseBasicParsing -TimeoutSec 1|Out-Null;exit 0}catch{exit 1}" >nul 2>&1
  if not errorlevel 1 (set READY=1 & goto :OK)
  findstr /I "Error error panic incompatible" "%SLOG%" >nul 2>&1 && goto :FALLBACK
  ping -n 2 127.0.0.1 >nul
)

:OK
if "%READY%"=="1" (
  echo   [OK] Server up — opening browser
  start "" "http://127.0.0.1:4097/"
  powershell -NoProfile -Command "Get-Content '%SLOG%' -Wait -ErrorAction SilentlyContinue"
  goto :eof
)

:FALLBACK
echo   Web failed. Log:
type "%SLOG%" 2>nul
echo.
echo   Terminal UI fallback...
cd /d "%APP%"
set OPENCODE_CONFIG_DIR=%APP%\.kortix\opencode
"%OC_EXE%" --agent epic .
pause
