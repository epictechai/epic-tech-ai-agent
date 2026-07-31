@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM ################################################################
REM  EPIC TECH AI — DO EVERYTHING (Windows 10)
REM  1) Node check  2) OpenCode baseline  3) Install Epic
REM  4) Auth check  5) Launch (web, else TUI)
REM ################################################################
title EPIC TECH AI — DO EVERYTHING
color 0A

REM Install under the current user's profile (any Windows user)
set "DEST=%USERPROFILE%\EpicTechAI"
if not defined USERPROFILE set "DEST=%CD%\EpicTechAI"
set "APP=%DEST%\epic-tech-ai-agent"
set "REPO_ZIP=https://github.com/epictechai/epic-tech-ai-agent/archive/refs/heads/main.zip"
set "LOG=%TEMP%\epic-do-everything.log"
set "OC_EXE="

echo.>"%LOG%"
call :log "=== START %DATE% %TIME% ==="

echo.
echo   ################################################
echo   #   EPIC TECH AI — DO EVERYTHING (Windows)     #
echo   ################################################
echo   Log: %LOG%
echo   Dest: %DEST%
echo.

REM ---- Node ----
echo   [1/5] Node.js...
where node >nul 2>&1 || (start "" "https://nodejs.org" & call :fail "Install Node.js LTS, reopen CMD, re-run")
where npm >nul 2>&1 || call :fail "npm missing"
node -v
npm -v

REM ---- OpenCode baseline ----
echo.
echo   [2/5] OpenCode (Windows baseline)...
call npm uninstall -g opencode-ai >nul 2>&1
if exist "%APPDATA%\npm\opencode.cmd" del /f /q "%APPDATA%\npm\opencode.cmd" >nul 2>&1
if exist "%APPDATA%\npm\node_modules\opencode-ai" rmdir /s /q "%APPDATA%\npm\node_modules\opencode-ai" >nul 2>&1

call npm install -g opencode-windows-x64-baseline@latest >>"%LOG%" 2>&1
if errorlevel 1 call npm install -g opencode-ai@latest >>"%LOG%" 2>&1

call :find_oc
if not defined OC_EXE call :fail "opencode.exe not found — see log"

echo   Binary: !OC_EXE!
"!OC_EXE!" --version
if errorlevel 1 call :fail "opencode --version failed (incompatible binary)"

if not exist "%APPDATA%\npm" mkdir "%APPDATA%\npm"
> "%APPDATA%\npm\opencode.cmd" echo @echo off
>>"%APPDATA%\npm\opencode.cmd" echo "!OC_EXE!" %%*

REM ---- Install app ----
echo.
echo   [3/5] Epic files...
if not exist "%DEST%" mkdir "%DEST%"

if exist "%APP%\.kortix\opencode\opencode.jsonc" (
  echo   Already installed: %APP%
) else if exist "%~dp0.kortix\opencode\opencode.jsonc" (
  if not exist "%APP%" mkdir "%APP%"
  robocopy "%~dp0." "%APP%" /E /XD node_modules .git tmp docs\download /NFL /NDL /NJH /NJS /nc /ns /np >nul
) else if exist "%DEST%\EpicTechAI-Windows\.kortix\opencode\opencode.jsonc" (
  set "APP=%DEST%\EpicTechAI-Windows"
) else (
  echo   Downloading repo...
  set "ZIP=%TEMP%\epic-main.zip"
  set "UNZ=%TEMP%\epic-unz"
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%REPO_ZIP%' -OutFile '%TEMP%\epic-main.zip' -UseBasicParsing" >>"%LOG%" 2>&1
  if errorlevel 1 call :fail "download failed"
  if exist "%TEMP%\epic-unz" rmdir /s /q "%TEMP%\epic-unz"
  mkdir "%TEMP%\epic-unz"
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive '%TEMP%\epic-main.zip' '%TEMP%\epic-unz' -Force" >>"%LOG%" 2>&1
  if not exist "%APP%" mkdir "%APP%"
  robocopy "%TEMP%\epic-unz\epic-tech-ai-agent-main" "%APP%" /E /XD node_modules .git /NFL /NDL /NJH /NJS /nc /ns /np >nul
)

if not exist "%APP%\.kortix\opencode\opencode.jsonc" call :fail "install missing opencode.jsonc"

cd /d "%APP%"
if not exist "%APP%\.opencode\" (
  mklink /J "%APP%\.opencode" "%APP%\.kortix\opencode" >nul 2>&1
  if errorlevel 1 powershell -NoProfile -Command "New-Item -ItemType Junction -Path '%APP%\.opencode' -Target '%APP%\.kortix\opencode' -Force|Out-Null"
)

echo   Installing tool deps...
if exist "%APP%\.kortix\opencode\package.json" (
  pushd "%APP%\.kortix\opencode"
  call npm install --no-fund --no-audit >>"%LOG%" 2>&1
  popd
)

copy /Y "%~dp0DO_EVERYTHING.bat" "%DEST%\DO_EVERYTHING.bat" >nul 2>&1
copy /Y "%APP%\windows\LAUNCH.bat" "%DEST%\LAUNCH.bat" >nul 2>&1
copy /Y "%APP%\windows\RUN_TUI.bat" "%DEST%\RUN_TUI.bat" >nul 2>&1
> "%APP%\opencode.cmd" echo @echo off
>>"%APP%\opencode.cmd" echo "!OC_EXE!" %%*
> "%DEST%\opencode.cmd" echo @echo off
>>"%DEST%\opencode.cmd" echo "!OC_EXE!" %%*

REM ---- Auth ----
echo.
echo   [4/5] Credentials...
set "OPENCODE_CONFIG_DIR=%APP%\.kortix\opencode"
"!OC_EXE!" auth list > "%TEMP%\epic-auth.txt" 2>&1
type "%TEMP%\epic-auth.txt"
findstr /I "OPENAI ANTHROPIC GROQ xAI API credential" "%TEMP%\epic-auth.txt" >nul 2>&1
if errorlevel 1 (
  echo.
  echo   No API key yet. A login window will open.
  echo   Pick provider, paste key THERE only. Never in chat.
  echo.
  start "OpenCode Auth" cmd /k ""!OC_EXE!" auth login"
  echo   After login succeeds, press any key here...
  pause >nul
)

REM ---- Launch ----
echo.
echo   [5/5] Starting Epic...
cd /d "%APP%"
set "OPENCODE_CONFIG_DIR=%APP%\.kortix\opencode"
set "HOST=127.0.0.1"
set "PORT=4097"

REM write a tiny starter to avoid delayed-expansion bugs in start
set "STARTER=%TEMP%\epic-start-web.cmd"
set "SLOG=%TEMP%\epic-web-run.log"
del "%SLOG%" >nul 2>&1

(
  echo @echo off
  echo cd /d "%APP%"
  echo set OPENCODE_CONFIG_DIR=%APP%\.kortix\opencode
  echo set OPENCODE_PURE=1
  echo "!OC_EXE!" web --hostname 127.0.0.1 --port 4097 --pure --print-logs
) > "%STARTER%"

echo   Starting web on http://127.0.0.1:4097/
echo   Log: %SLOG%
echo.

start "EpicServer" /MIN cmd /c "call \"%STARTER%\" > \"%SLOG%\" 2>&1"

echo   Waiting for server...
set "READY=0"
for /L %%I in (1,1,60) do (
  powershell -NoProfile -Command "try{Invoke-WebRequest http://127.0.0.1:4097/ -UseBasicParsing -TimeoutSec 1|Out-Null;exit 0}catch{exit 1}" >nul 2>&1
  if not errorlevel 1 (set "READY=1" & goto :READY)
  REM if log shows hard error, break early
  findstr /I "Error error panic FATAL incompatible" "%SLOG%" >nul 2>&1 && goto :NOTREADY
  ping -n 2 127.0.0.1 >nul
)

:READY
if "%READY%"=="1" (
  echo.
  echo   ############################################
  echo   #  SUCCESS — http://127.0.0.1:4097/        #
  echo   #  Keep this window open.                  #
  echo   ############################################
  echo.
  start "" "http://127.0.0.1:4097/"
  echo   Live log (Ctrl+C stops viewing, not always the server):
  powershell -NoProfile -Command "Get-Content '%SLOG%' -Wait -ErrorAction SilentlyContinue"
  goto :eof
)

:NOTREADY
echo.
echo   [!] Web UI failed. Server log:
echo   ----------
type "%SLOG%" 2>nul
echo   ----------
echo.
echo   Starting TERMINAL UI instead (this usually works)...
echo   Type a message. Ctrl+C to exit.
echo.
cd /d "%APP%"
set "OPENCODE_CONFIG_DIR=%APP%\.kortix\opencode"
"!OC_EXE!" --agent epic .
echo.
echo   Stopped.
echo   Logs: %LOG%
echo         %SLOG%
pause
goto :eof

:find_oc
set "OC_EXE="
if exist "%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" set "OC_EXE=%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" & goto :eof
if exist "%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\opencode.exe" set "OC_EXE=%APPDATA%\npm\node_modules\opencode-windows-x64-baseline\opencode.exe" & goto :eof
if exist "%APPDATA%\npm\node_modules\opencode-ai\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" set "OC_EXE=%APPDATA%\npm\node_modules\opencode-ai\node_modules\opencode-windows-x64-baseline\bin\opencode.exe" & goto :eof
for /f "delims=" %%F in ('dir /s /b "%APPDATA%\npm\node_modules\opencode.exe" 2^>nul') do set "OC_EXE=%%F" & goto :eof
goto :eof

:log
echo %~1>>"%LOG%"
goto :eof

:fail
echo.
echo   [FAIL] %~1
echo   Log: %LOG%
pause
exit /b 1
