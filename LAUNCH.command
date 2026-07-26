#!/bin/bash
# macOS double-click launcher — Epic Tech AI
cd "$(dirname "$0")" || exit 1
chmod +x LAUNCH.sh scripts/*.sh 2>/dev/null || true
./LAUNCH.sh web
echo ""
echo "Agent stopped. Press any key to close…"
read -n 1 -s -r || true
