#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
#  Epic Tech AI — ONE-CLICK local agent launch
#  Double-click or:  ./LAUNCH.sh
#  Brand: github.com/epictechai · x.com/EpicTechAI
# ═══════════════════════════════════════════════════════════
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

# --- colors (safe if no TTY) ---
if [ -t 1 ]; then
  C_VIOLET=$'\033[38;5;141m'; C_DIM=$'\033[2m'; C_OK=$'\033[32m'
  C_ERR=$'\033[31m'; C_RST=$'\033[0m'; C_BOLD=$'\033[1m'
else
  C_VIOLET=; C_DIM=; C_OK=; C_ERR=; C_RST=; C_BOLD=
fi

banner() {
  echo ""
  echo "${C_VIOLET}${C_BOLD}  ╔══════════════════════════════════════════╗${C_RST}"
  echo "${C_VIOLET}${C_BOLD}  ║     EPIC TECH AI  ·  LOCAL AGENT         ║${C_RST}"
  echo "${C_VIOLET}${C_BOLD}  ║     1000x SOTA  ·  one-click launch      ║${C_RST}"
  echo "${C_VIOLET}${C_BOLD}  ╚══════════════════════════════════════════╝${C_RST}"
  echo "${C_DIM}  github.com/epictechai  ·  x.com/EpicTechAI${C_RST}"
  echo ""
}

die() { echo "${C_ERR}ERROR:${C_RST} $*" >&2; exit 1; }
ok()  { echo "${C_OK}✓${C_RST} $*"; }
info(){ echo "${C_DIM}→${C_RST} $*"; }

# Mode: web (default one-click) | tui | serve | doctor
MODE="${1:-web}"
PORT="${PORT:-4097}"
HOST="${HOST:-127.0.0.1}"

banner

# 1) Link standard OpenCode layout
if [ ! -e .opencode ]; then
  ln -sfn .kortix/opencode .opencode
  ok "linked .opencode → .kortix/opencode"
else
  ok ".opencode ready"
fi

# Force THIS repo's config (ignore parent Machine session env)
export OPENCODE_CONFIG_DIR="$ROOT/.kortix/opencode"
export EPIC_ROOT="$ROOT"
# Prevent parent /workspace OpenCode config from leaking in
unset OPENCODE_CONFIG 2>/dev/null || true
# Prefer project-local resolution from ROOT
cd "$ROOT"

# 2) Find or install opencode
if ! command -v opencode >/dev/null 2>&1; then
  info "opencode CLI not found — attempting install..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://opencode.ai/install | bash || true
    # common install locations
    export PATH="$HOME/.opencode/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
  fi
fi
command -v opencode >/dev/null 2>&1 || die "opencode not on PATH. Install: https://opencode.ai/docs then re-run ./LAUNCH.sh"
ok "opencode $(opencode --version 2>/dev/null || echo present)"

# 3) Tool deps
if [ ! -d "$OPENCODE_CONFIG_DIR/node_modules" ]; then
  info "installing tool dependencies..."
  if command -v bun >/dev/null 2>&1; then
    (cd "$OPENCODE_CONFIG_DIR" && bun install)
  elif command -v npm >/dev/null 2>&1; then
    (cd "$OPENCODE_CONFIG_DIR" && npm install)
  else
    info "no bun/npm — skipping (core agent still runs)"
  fi
fi
ok "deps ready"

# 4) Validate config quickly
if ! OPENCODE_CONFIG_DIR="$OPENCODE_CONFIG_DIR" opencode debug config >/dev/null 2>&1; then
  echo "${C_ERR}Config validation failed:${C_RST}"
  OPENCODE_CONFIG_DIR="$OPENCODE_CONFIG_DIR" opencode debug config 2>&1 | tail -20
  die "fix opencode.jsonc and retry"
fi
ok "config valid · default agent: epic"

# 5) Free port helper
port_busy() {
  if command -v ss >/dev/null 2>&1; then
    ss -tln 2>/dev/null | grep -q ":${1} "
  elif command -v lsof >/dev/null 2>&1; then
    lsof -iTCP:"$1" -sTCP:LISTEN >/dev/null 2>&1
  else
    return 1
  fi
}
if [ "$MODE" = "web" ] || [ "$MODE" = "serve" ]; then
  BASE="$PORT"
  for try in $(seq 0 20); do
    CAND=$((BASE + try))
    if ! port_busy "$CAND"; then
      PORT=$CAND
      break
    fi
  done
fi

# 6) Open browser (best-effort)
open_browser() {
  local url="$1"
  if command -v open >/dev/null 2>&1; then
    open "$url" >/dev/null 2>&1 || true
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url" >/dev/null 2>&1 || true
  elif command -v wslview >/dev/null 2>&1; then
    wslview "$url" >/dev/null 2>&1 || true
  fi
}

# 7) Write status for humans
mkdir -p "$ROOT/tmp"
cat > "$ROOT/tmp/LAUNCHED.md" <<EOF
# Epic Tech AI — launched

- Time: $(date -u +%Y-%m-%dT%H:%M:%SZ)
- Mode: $MODE
- Agent: epic (Opus 4.8 max)
- Config: $OPENCODE_CONFIG_DIR
- URL: http://${HOST}:${PORT}/
- Repo: https://github.com/epictechai/epic-tech-ai-agent
EOF

case "$MODE" in
  doctor)
    exec bash "$ROOT/scripts/run-local.sh" doctor
    ;;
  tui)
    echo ""
    echo "${C_BOLD}Starting Epic TUI…${C_RST}  (default agent: epic)"
    echo "${C_DIM}Tip: type /anything <mission>${C_RST}"
    echo ""
    exec opencode "$ROOT"
    ;;
  serve)
    echo ""
    ok "headless server → http://${HOST}:${PORT}/"
    exec opencode serve --hostname "$HOST" --port "$PORT"
    ;;
  web|*)
    URL="http://${HOST}:${PORT}/"
    echo ""
    ok "Web UI → ${C_BOLD}${URL}${C_RST}"
    ok "Agent  → epic (full SOTA)"
    echo "${C_DIM}  Press Ctrl+C to stop${C_RST}"
    echo ""
    # open browser shortly after bind
    ( sleep 1.5; open_browser "$URL" ) &
    exec opencode web --hostname "$HOST" --port "$PORT"
    ;;
esac
