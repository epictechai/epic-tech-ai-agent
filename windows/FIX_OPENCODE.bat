@echo off
REM Alias — same as INSTALL_OPENCODE_WINDOWS.bat
cd /d "%~dp0"
if exist "%~dp0INSTALL_OPENCODE_WINDOWS.bat" (
  call "%~dp0INSTALL_OPENCODE_WINDOWS.bat"
) else if exist "%~dp0..\INSTALL_OPENCODE_WINDOWS.bat" (
  call "%~dp0..\INSTALL_OPENCODE_WINDOWS.bat"
) else (
  echo Missing INSTALL_OPENCODE_WINDOWS.bat
  pause
)
