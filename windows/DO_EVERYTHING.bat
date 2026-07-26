@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM ################################################################
REM  EPIC TECH AI — DO EVERYTHING (Windows 10)
REM  Double-click this ONE file. It will:
REM    1) Check Node
REM    2) Fix OpenCode (baseline Win10 binary)
REM    3) Install/update Epic into C:\Users\epict\EpicTechAI
REM    4) Launch the agent (web or TUI fallback)
REM ################################################################
title EPIC TECH AI — DO EVERYTHING
color 0A
cd /d "%~dp0"

set "DEST=C:\Users\epict\EpicTechAI"
set "APP=%DEST%\epic-tech-ai-agent"
set "REPO_ZIP=https://github.com/epictechai/epic-tech-ai-agent/archive/refs/heads/main.zip"
set "LOG=%TEMP%\epic-do-everything.log"
set "OC_EXE="

echo. > "%LOG%"
call :log "=== EPIC DO EVERYTHING %DATE% %TIME% ==="

echo.
echo   ################################################
echo   #   EPIC TECH AI — DO EVERYTHING ^(Windows^)    #
echo   ################################################
echo.
echo   Log file: %LOG%
echo   Target:   %DEST%
echo.

REM ========== STEP 0: Node ==========
echo   [0/6] Checking Node.js...
where node >nul 2>&1
if errorlevel 1 (
  echo   [!] Node.js missing. Opening installer page...
  echo   Install LTS, RESTART this window, run DO_EVERYTHING.bat again.
  start "" "https://nodejs.org"
  call :fail "Node.js not installed"
)
where npm >nul 2>&1
if errorlevel 1 call :fail "npm not found"
for /f "tokens=*" %%V in ('node -v 2^>nul') do echo   node %%V
for /f "tokens=*" %%V in ('npm -v 2^>nul') do echo   npm  %%V
call :log "node ok"

REM ========== STEP 1: Fix OpenCode baseline ==========
echo.
echo   [1/6] Fixing OpenCode for Windows 10 ^(baseline binary^)...
call :log "fixing opencode"

REM Remove broken global package that ships incompatible exe
call npm uninstall -g opencode-ai >nul 2>&1
if exist "%APPDATA%\npm\opencode.cmd" del /f /q "%APPDATA%\npm\opencode.cmd" >nul 2>&1
if exist "%APPDATA%\npm\opencode.ps1" del /f /q "%APPDATA%\npm\opencode.ps1" >nul 2>&1
if exist "%APPDATA%\npm\opencode" del /f /q "%APPDATA%\npm\opencode" >nul 2>&1
if exist "%APPDATA%\npm\node_modules\opencode-ai" rmdir /s /q "%APPDATA%\npm\node_modules\opencode-ai" >nul 2>&1

echo         Installing opencode-windows-x64-baseline...
call npm install -g opencode-windows-x64-baseline@latest >>"%LOG%" 2>&1
if errorlevel 1 (
  echo         baseline package failed, trying opencode-ai + nested baseline...
  call npm install -g opencode-ai@latest >>"%LOG%" 2>&1
)

call :find_oc
if not defined OC_EXE (
  echo.
  echo   [!] Could not locate a working opencode.exe
  echo   Trying desktop release download...
  call :try_desktop_download
  call :find_oc
)
if not defined OC_EXE (
  echo   [!] Still no opencode.exe — see %LOG%
  echo   Manual: https://github.com/sst/opencode/releases
  echo   Get windows x64 BASELINE or desktop win-x64
  start "" "https://github.com/sst/opencode/releases"
  call :fail "opencode binary missing"
)

echo   Found: !OC_EXE!
"!OC_EXE!" --version >>"%LOG%" 2>&1
"!OC_EXE!" --version
if errorlevel 1 (
  echo   [!] Binary still incompatible with this Windows.
  echo   Download desktop: opencode-desktop-win-x64.exe from GitHub releases.
  start "" "https://github.com/sst/opencode/releases"
  call :fail "opencode --version failed"
)

REM Shim so "opencode" works
if not exist "%APPDATA%\npm" mkdir "%APPDATA%\npm"
(
  echo @echo off
  echo " !OC_EXE! " %%*
) > "%APPDATA%\npm\opencode.cmd"
(
  echo @echo off
  echo " !OC_EXE! " %%*
) > "%DEST%\opencode.cmd" 2>nul
echo   [OK] OpenCode works
call :log "opencode ok !OC_EXE!"

REM ========== STEP 2: Install Epic files ==========
echo.
echo   [2/6] Installing Epic agent files to %APP% ...
if not exist "%DEST%" mkdir "%DEST%"

if exist "%APP%\.kortix\opencode\opencode.jsonc" (
  echo   [OK] Already present: %APP%
  goto :DEPS
)

REM Prefer copy from current folder if this bat lives inside a full pack
if exist "%~dp0.kortix\opencode\opencode.jsonc" (
  echo   Copying from current pack...
  if not exist "%APP%" mkdir "%APP%"
  robocopy "%~dp0." "%APP%" /E /XD node_modules .git tmp /NFL /NDL /NJH /NJS /nc /ns /np >nul
  goto :DEPS
)

if exist "%DEST%\EpicTechAI-Windows\.kortix\opencode\opencode.jsonc" (
  echo   Using existing EpicTechAI-Windows folder...
  set "APP=%DEST%\EpicTechAI-Windows"
  goto :DEPS
)

echo   Downloading latest repo ZIP...
set "ZIP=%TEMP%\epic-main.zip"
set "UNZ=%TEMP%\epic-unz-main"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try { Invoke-WebRequest -Uri '%REPO_ZIP%' -OutFile '%ZIP%' -UseBasicParsing } catch { exit 1 }" >>"%LOG%" 2>&1
if errorlevel 1 call :fail "ZIP download failed — check internet"

if exist "%UNZ%" rmdir /s /q "%UNZ%"
mkdir "%UNZ%"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Expand-Archive -Path '%ZIP%' -DestinationPath '%UNZ%' -Force" >>"%LOG%" 2>&1
if not exist "%APP%" mkdir "%APP%"
robocopy "%UNZ%\epic-tech-ai-agent-main" "%APP%" /E /XD node_modules .git /NFL /NDL /NJH /NJS /nc /ns /np >nul
if not exist "%APP%\.kortix\opencode\opencode.jsonc" call :fail "Extract failed — opencode.jsonc missing"

:DEPS
echo.
echo   [3/6] Installing tool dependencies...
cd /d "%APP%"
if not exist "%APP%\.opencode\" (
  mklink /J "%APP%\.opencode" "%APP%\.kortix\opencode" >nul 2>&1
  if errorlevel 1 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "New-Item -ItemType Junction -Path '%APP%\.opencode' -Target '%APP%\.kortix\opencode' -Force | Out-Null"
  )
)
if exist "%APP%\.kortix\opencode\package.json" (
  pushd "%APP%\.kortix\opencode"
  call npm install --no-fund --no-audit >>"%LOG%" 2>&1
  popd
)
echo   [OK] deps

REM Copy easy launchers to DEST root
copy /Y "%~dp0DO_EVERYTHING.bat" "%DEST%\DO_EVERYTHING.bat" >nul 2>&1
copy /Y "%APP%\LAUNCH.bat" "%DEST%\LAUNCH.bat" >nul 2>&1
copy /Y "%APP%\RUN_TUI.bat" "%DEST%\RUN_TUI.bat" >nul 2>&1
(
  echo @echo off
  echo " !OC_EXE! " %%*
) > "%APP%\opencode.cmd"
(
  echo @echo off
  echo " !OC_EXE! " %%*
) > "%DEST%\opencode.cmd"

REM ========== STEP 4: Auth check ==========
echo.
echo   [4/6] Checking model credentials...
set "OPENCODE_CONFIG_DIR=%APP%\.kortix\opencode"
"!OC_EXE!" auth list > "%TEMP%\epic-auth.txt" 2>&1
type "%TEMP%\epic-auth.txt"
findstr /I "OPENAI ANTHROPIC GROQ xAI credential API" "%TEMP%\epic-auth.txt" >nul 2>&1
if errorlevel 1 (
  echo.
  echo   ################################################
  echo   #  ACTION NEEDED: add an API key ^(once^)      #
  echo   ################################################
  echo.
  echo   A window will run:  opencode auth login
  echo   1. Pick your provider ^(OpenAI if key starts with sk-^)
  echo   2. Paste your API key
  echo   3. Come back here and press a key
  echo.
  echo   NEVER paste API keys into chat / Discord / email.
  echo.
  start "OpenCode Auth" cmd /k "\"!OC_EXE!\" auth login"
  pause
)

REM ========== STEP 5: Launch web ==========
echo.
echo   [5/6] Starting Epic web UI...
set "HOST=127.0.0.1"
set "PORT=4097"
for /L %%N in (0,1,20) do (
  set /a TRY=4097+%%N
  netstat -ano | findstr /R /C:":!TRY! .*LISTENING" >nul 2>&1
  if errorlevel 1 (
    set "PORT=!TRY!"
    goto :PORT_OK
  )
)
:PORT_OK

set "SLOG=%TEMP%\epic-web-run.log"
del "%SLOG%" >nul 2>&1
cd /d "%APP%"
set "OPENCODE_CONFIG_DIR=%APP%\.kortix\opencode"

echo   URL: http://%HOST%:!PORT%/
echo   Config: %OPENCODE_CONFIG_DIR%
echo   Binary: !OC_EXE!
echo.

start "EpicServer" /MIN cmd /c "cd /d \"%APP%\" && set OPENCODE_CONFIG_DIR=%OPENCODE_CONFIG_DIR%&& \"!OC_EXE!\" web --hostname %HOST% --port !PORT! --pure --print-logs > \"%SLOG%\" 2>&1"

echo   [6/6] Waiting for server...
set "READY=0"
for /L %%I in (1,1,45) do (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { $r=Invoke-WebRequest -Uri 'http://%HOST%:!PORT!/' -UseBasicParsing -TimeoutSec 2; exit 0 } catch { exit 1 }" >nul 2>&1
  if not errorlevel 1 (
    set "READY=1"
    goto :UP
  )
  ping -n 2 127.0.0.1 >nul
)

:UP
if "!READY!"=="1" (
  echo.
  echo   ##############################################
  echo   #  SUCCESS — Epic is running on this PC     #
  echo   ##############################################
  echo   Open: http://%HOST%:!PORT%/
  echo   Keep this window open.
  echo.
  start "" "http://%HOST%:!PORT%/"
  echo   Live log:
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Get-Content -Path '%SLOG%' -Wait -ErrorAction SilentlyContinue"
  goto :eof
)

echo.
echo   [!] Web UI did not start. Log:
type "%SLOG%" 2>nul
echo.
echo   Falling back to TERMINAL UI...
echo   Type a message after it starts. Ctrl+C to exit.
echo.
cd /d "%APP%"
set "OPENCODE_CONFIG_DIR=%APP%\.kortix\opencode"
"!OC_EXE!" --agent epic .
echo.
echo   Stopped. Log: %LOG% / %SLOG%
pause
goto :eof

REM ================= helpers =================
:find_oc
set "OC_EXE="
if exist "%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" (
  set "OC_EXE=%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" & goto :eof
)
if exist "%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\opencode.exe" (
  set "OC_EXE=%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\opencode.exe" & goto :eof
)
if exist "%APPDATA%\npm\node_modules\opencode-ai\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" (
  set "OC_EXE=%APPDATA%\npm\node_modules\opencode-ai\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" & goto :eof
)
if exist "%APPDATA%\npm\node_modules\opencode-windows-x64\bin\opencode.exe" (
  set "OC_EXE=%APPDATA%\npm\node_modules\opencode-windows-x64\bin\opencode.exe" & goto :eof
)
if exist "%LOCALAPPDATA%\opencode\opencode.exe" (
  set "OC_EXE=%LOCALAPPDATA%\opencode\opencode.exe" & goto :eof
)
if exist "%USERPROFILE%\opencode\opencode.exe" (
  set "OC_EXE=%USERPROFILE%\opencode\opencode.exe" & goto :eof
)
for /f "delims=" %%F in ('dir /s /b "%APPDATA%\npm\node_modules\opencode.exe" 2^>nul') do (
  set "OC_EXE=%%F"
  goto :eof
)
goto :eof

:try_desktop_download
set "DDL=%USERPROFILE%\opencode"
if not exist "%DDL%" mkdir "%DDL%"
echo   Downloading portable windows baseline zip if available...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop'; $api='https://api.github.com/repos/sst/opencode/releases/latest'; $r=Invoke-RestMethod -Uri $api -Headers @{'User-Agent'='EpicTechAI'}; $a=$r.assets | Where-Object { $_.name -match 'windows-x64-baseline|windows-x64.zip|opencode-windows' } | Select-Object -First 1; if (-not $a) { $a=$r.assets | Where-Object { $_.name -match 'win-x64' -and $_.name -match 'zip' } | Select-Object -First 1 }; if ($a) { Write-Host ('Downloading '+$a.name); Invoke-WebRequest -Uri $a.browser_download_url -OutFile ($env:TEMP+'\oc-win.zip') -UseBasicParsing; Expand-Archive ($env:TEMP+'\oc-win.zip') -DestinationPath '%DDL%' -Force; Get-ChildItem '%DDL%' -Recurse -Filter opencode.exe | Select-Object -First 1 -ExpandProperty FullName | Out-File '%TEMP%\oc-path.txt' -Encoding ascii } else { Write-Host 'No matching asset' }" >>"%LOG%" 2>&1
if exist "%TEMP%\oc-path.txt" (
  set /p OC_EXE=<"%TEMP%\oc-path.txt"
)
goto :eof

:log
echo %~1>>"%LOG%"
goto :eof

:fail
echo.
echo   [FAIL] %~1
echo   Full log: %LOG%
echo.
pause
exit /b 1
