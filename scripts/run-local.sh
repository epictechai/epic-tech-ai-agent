#!/usr/bin/env bash
# Epic Tech AI — run the full SOTA agent locally
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

MODE="${1:-tui}"
shift || true

# Prefer linked .opencode; always set CONFIG_DIR explicitly
if [ ! -e .opencode ]; then
  ln -sfn .kortix/opencode .opencode
fi

export OPENCODE_CONFIG_DIR="${OPENCODE_CONFIG_DIR:-$ROOT/.kortix/opencode}"
export OPENCODE_CONFIG_DIR
# Project root for tools/memory paths
export EPIC_ROOT="$ROOT"

if ! command -v opencode >/dev/null 2>&1; then
  echo "opencode CLI not found. Run: npm run setup"
  echo "Or install: curl -fsSL https://opencode.ai/install | bash"
  exit 1
fi

# Ensure deps once
if [ ! -d "$OPENCODE_CONFIG_DIR/node_modules" ]; then
  if command -v bun >/dev/null 2>&1; then
    (cd "$OPENCODE_CONFIG_DIR" && bun install)
  elif command -v npm >/dev/null 2>&1; then
    (cd "$OPENCODE_CONFIG_DIR" && npm install)
  fi
fi

doctor() {
  echo "Epic Tech AI — doctor"
  echo "  root:     $ROOT"
  echo "  config:   $OPENCODE_CONFIG_DIR"
  echo "  opencode: $(opencode --version 2>/dev/null || echo missing)"
  echo "  default:  epic (see opencode.jsonc)"
  echo ""
  echo "Agents:"
  ls -1 "$OPENCODE_CONFIG_DIR/agents"/*.md 2>/dev/null | xargs -I{} basename {} .md | sed 's/^/  - /'
  echo ""
  echo "Commands:"
  ls -1 "$OPENCODE_CONFIG_DIR/commands"/*.md 2>/dev/null | xargs -I{} basename {} .md | sed 's/^/  - \//'
  echo ""
  echo "Skills (top-level):"
  ls -1 "$OPENCODE_CONFIG_DIR/skills" 2>/dev/null | sed 's/^/  - /'
  echo ""
  if opencode debug config >/tmp/epic-oc-config.txt 2>&1; then
    echo "Config: OK"
    # show default agent if present
    grep -E 'default_agent|model' /tmp/epic-oc-config.txt | head -10 || true
  else
    echo "Config: FAIL"
    cat /tmp/epic-oc-config.txt | tail -30
    exit 1
  fi
  echo ""
  echo "Agent epic:"
  opencode debug agent epic 2>&1 | head -40 || true
  echo ""
  echo "Skills loaded (sample):"
  opencode debug skill 2>&1 | head -50 || true
}

case "$MODE" in
  doctor)
    doctor
    ;;
  tui|"")
    echo "Starting Epic Tech AI agent (TUI) — default agent: epic"
    exec opencode "$ROOT" "$@"
    ;;
  web)
    echo "Starting Epic Tech AI agent (web)"
    exec opencode web --hostname 127.0.0.1 --port "${PORT:-4096}" "$@"
    ;;
  serve)
    echo "Starting Epic Tech AI agent (headless serve)"
    exec opencode serve --hostname 127.0.0.1 --port "${PORT:-4096}" "$@"
    ;;
  run)
    if [ "$#" -eq 0 ]; then
      echo "Usage: npm run agent:run -- \"your task\""
      exit 1
    fi
    # Non-interactive one-shot
    exec opencode run --agent epic "$@"
    ;;
  *)
    echo "Unknown mode: $MODE"
    echo "Usage: run-local.sh [tui|web|serve|run|doctor] [args...]"
    exit 1
    ;;
esac
