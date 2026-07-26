# Epic Tech AI — one-click PowerShell launcher
# Right-click → Run with PowerShell  (or: powershell -File LAUNCH.ps1)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host ""
Write-Host "  EPIC TECH AI  ·  LOCAL AGENT" -ForegroundColor Magenta
Write-Host "  github.com/epictechai  ·  x.com/EpicTechAI" -ForegroundColor DarkGray
Write-Host ""

if (-not (Get-Command opencode -ErrorAction SilentlyContinue)) {
  Write-Host "opencode CLI not found. Install: https://opencode.ai/docs" -ForegroundColor Red
  exit 1
}

if (-not (Test-Path ".opencode")) {
  New-Item -ItemType Junction -Path ".opencode" -Target ".kortix\opencode" -Force | Out-Null
}

$env:OPENCODE_CONFIG_DIR = (Resolve-Path ".kortix\opencode").Path
$env:EPIC_ROOT = (Resolve-Path ".").Path
$port = if ($env:PORT) { $env:PORT } else { 4097 }
$hostName = "127.0.0.1"

$nm = Join-Path $env:OPENCODE_CONFIG_DIR "node_modules"
if (-not (Test-Path $nm)) {
  Push-Location $env:OPENCODE_CONFIG_DIR
  if (Get-Command bun -ErrorAction SilentlyContinue) { bun install }
  elseif (Get-Command npm -ErrorAction SilentlyContinue) { npm install }
  Pop-Location
}

$url = "http://${hostName}:${port}/"
Write-Host "Starting Epic → $url" -ForegroundColor Green
Write-Host "Agent: epic (full SOTA)" -ForegroundColor Green
Start-Process $url
& opencode web --hostname $hostName --port $port
