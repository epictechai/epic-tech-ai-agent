@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM ============================================================
REM  Epic Tech AI — FULLY LOCAL Windows launcher (fixed)
REM  Double-click from the repo folder.
REM  C:\Users\epict\EpicTechAI\EpicTechAI-Windows\LAUNCH.bat
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

if not exist "%~dp0.kortix\opencode\opencode.jsonc" (
  echo   [!] Missing agent files in this folder.
  echo   [!] Expected: .kortix\opencode\opencode.jsonc
  echo.
  pause
  exit /b 1
)

where opencode >nul 2>&1
if errorlevel 1 (
  echo   [!] opencode not found on PATH.
  echo       npm install -g opencode-ai
  echo       then close this window and run LAUNCH.bat again
  pause
  exit /b 1
)

for /f "tokens=*" %%V in ('opencode --version 2^>nul') do set "OCVER=%%V"
echo   opencode: !OCVER!
if not defined OCVER (
  echo   [!] opencode --version returned nothing. Reinstall:
  echo       npm install -g opencode-ai
  pause
  exit /b 1
)

REM Junction .opencode -^> .kortix\opencode
if not exist "%~dp0.opencode\" (
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

REM Free port starting at 4097
for /L %%N in (0,1,30) do (
  set /a TRY=4097+%%N
  netstat -ano | findstr /R /C:":!TRY! .*LISTENING" >nul 2>&1
  if errorlevel 1 (
    set "PORT=!TRY!"
    goto :PORT_OK
  )
)
:PORT_OK
echo   Port: !PORT!

REM Tool deps once
if not exist "%OPENCODE_CONFIG_DIR%\node_modules\" (
  echo   Installing tool dependencies...
  pushd "%OPENCODE_CONFIG_DIR%"
  where npm >nul 2>&1 && call npm install --no-fund --no-audit
  popd
)

REM Auth hint ^(non-fatal^)
echo.
opencode auth list 2>nul | findstr /I "credential Environment OPENAI ANTHROPIC GROQ xAI" >nul
if errorlevel 1 (
  echo   [!] No provider credentials detected yet.
  echo       In another window run:  opencode auth login
  echo       Or:  setx OPENAI_API_KEY "your-new-key"
  echo       ^(never paste keys into chat^)
  echo.
)

echo   Starting server...
echo   URL will be: http://%HOST%:!PORT%/
echo   Agent: epic
echo.
echo   Keep this window OPEN while you use the agent.
echo   Press Ctrl+C to stop.
echo.

REM Log file for debugging
set "LOG=%TEMP%\epic-opencode-web.log"
echo   Log: %LOG%
echo.

REM Start opencode web in background via start /b so we can wait-for-port then open browser
REM Use --pure first on Windows ^(avoids plugin crashes^); fallback without pure if needed.
set "MODE=pure"
del "%LOG%" >nul 2>&1

start "EpicOpenCode" /MIN cmd /c "set OPENCODE_CONFIG_DIR=%OPENCODE_CONFIG_DIR%&& opencode web --hostname %HOST% --port !PORT! --pure --print-logs > \"%LOG%\" 2>&1"

echo   Waiting for server to become ready...
set "READY=0"
for /L %%I in (1,1,40) do (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { $r=Invoke-WebRequest -Uri 'http://%HOST%:!PORT!/' -UseBasicParsing -TimeoutSec 2; if ($r.StatusCode -ge 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
  if not errorlevel 1 (
    set "READY=1"
    goto :OPEN_BROWSER
  )
  rem still starting
  ping -n 2 127.0.0.1 >nul
)

:OPEN_BROWSER
if "!READY!"=="1" (
  echo.
  echo   [OK] Server is UP
  echo   Opening browser: http://%HOST%:!PORT%/
  echo.
  start "" "http://%HOST%:!PORT%/"
  echo   If the page is blank, refresh once.
  echo   In the UI pick agent: epic
  echo.
  echo   This window stays open so the server keeps running.
  echo   Close it or press Ctrl+C to stop Epic.
  echo.
  REM Keep launcher alive while child runs — attach to log tail
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Write-Host '--- server log (live) ---' -ForegroundColor DarkGray; Get-Content -Path '%LOG%' -Wait -ErrorAction SilentlyContinue"
  goto :END
)

echo.
echo   [!] Web UI did not become ready in time.
echo   Trying fallback: opencode TUI in this window...
echo.
type "%LOG%" 2>nul
echo.

REM Kill failed background attempt if any
taskkill /FI "WINDOWTITLE eq EpicOpenCode*" /F >nul 2>&1

echo   === FALLBACK: terminal UI ===
echo   Type your message and press Enter. Agent: epic
echo.
set "OPENCODE_CONFIG_DIR=%OPENCODE_CONFIG_DIR%"
opencode --agent epic .
set "ERR=%ERRORLEVEL%"

echo.
if not "%ERR%"=="0" (
  echo   [!] opencode failed code %ERR%
  echo   1^) opencode auth login
  echo   2^) opencode auth list
  echo   3^) type log: %LOG%
)
pause

:END
endlocal
exit /b 0
