#!/usr/bin/env bash
# Epic Tech AI — local agent setup
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Epic Tech AI local setup"
echo "    root: $ROOT"

# Standard OpenCode layout: .opencode → Machine config dir
if [ -L .opencode ] || [ -d .opencode ]; then
  echo "==> .opencode already present"
else
  ln -s .kortix/opencode .opencode
  echo "==> linked .opencode -> .kortix/opencode"
fi

# Ensure AGENTS.md visible from config expectations
if [ ! -f .opencode/../../AGENTS.md ] && [ ! -f AGENTS.md ]; then
  echo "WARN: AGENTS.md missing at repo root"
fi

# Install tool/plugin deps
if command -v bun >/dev/null 2>&1; then
  echo "==> bun install (opencode tools)"
  (cd .kortix/opencode && bun install)
elif command -v npm >/dev/null 2>&1; then
  echo "==> npm install (opencode tools)"
  (cd .kortix/opencode && npm install)
else
  echo "WARN: no bun/npm — skip dependency install"
fi

# Check opencode CLI
if command -v opencode >/dev/null 2>&1; then
  echo "==> opencode $(opencode --version 2>/dev/null || echo present)"
else
  echo "==> installing opencode CLI..."
  if command -v npm >/dev/null 2>&1; then
    npm install -g opencode-ai 2>/dev/null || npm install -g @opencode-ai/cli 2>/dev/null || true
  fi
  if ! command -v opencode >/dev/null 2>&1; then
    echo "Install OpenCode: https://opencode.ai/docs"
    echo "  curl -fsSL https://opencode.ai/install | bash"
  fi
fi

echo "==> validating config"
export OPENCODE_CONFIG_DIR="$ROOT/.kortix/opencode"
if opencode debug config >/dev/null 2>&1; then
  echo "    config: OK"
else
  # still print errors
  opencode debug config 2>&1 | tail -20 || true
fi

echo ""
echo "Setup complete."
echo "  npm run agent          # interactive TUI"
echo "  npm run agent:web      # web UI"
echo "  npm run doctor         # health check"
echo "  npm run agent:run -- \"your task\""
echo ""
echo "Brand: https://github.com/epictechai · https://x.com/EpicTechAI"
