@echo off
REM Shortcut name — double-click START_EPIC.bat
cd /d "%~dp0"
if exist "%~dp0LAUNCH.bat" (
  call "%~dp0LAUNCH.bat"
) else (
  call "%~dp0SETUP_AND_LAUNCH.bat"
)
