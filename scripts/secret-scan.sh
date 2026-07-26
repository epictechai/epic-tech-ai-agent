#!/usr/bin/env bash
# Fail if high-risk secret patterns appear in tracked files.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> Epic Tech AI secret scan (tracked files only)"

# Real-looking tokens (not placeholders like your_key_here or sk-…)
PATTERNS=(
  'sk-[A-Za-z0-9]{20,}'
  'sk-proj-[A-Za-z0-9_-]{20,}'
  'sk-ant-[A-Za-z0-9_-]{20,}'
  'ghp_[A-Za-z0-9]{36}'
  'gho_[A-Za-z0-9]{36}'
  'github_pat_[A-Za-z0-9_]{20,}'
  'xox[baprs]-[A-Za-z0-9-]{10,}'
  'AKIA[0-9A-Z]{16}'
  'AIza[0-9A-Za-z_-]{35}'
  '-----BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY-----'
)

HIT=0
while IFS= read -r -d '' f; do
  # skip binary-ish
  case "$f" in
    *.png|*.jpg|*.jpeg|*.gif|*.webp|*.ico|*.woff*|*.zip) continue ;;
  esac
  for pat in "${PATTERNS[@]}"; do
    if grep -nE "$pat" "$f" 2>/dev/null | grep -vE 'your_key_here|YOUR_|<.*>|sk-…|example|placeholder|\$\{|process\.env|getEnv\(|Bearer \$|Bearer <' >/tmp/ss-hit.txt 2>/dev/null; then
      if [ -s /tmp/ss-hit.txt ]; then
        echo "POSSIBLE SECRET in $f"
        cat /tmp/ss-hit.txt
        HIT=1
      fi
    fi
  done
done < <(git ls-files -z)

# Block .env tracked
if git ls-files | grep -E '(^|/)\.env($|\.)' | grep -v '.env.example'; then
  echo "TRACKED ENV FILE — remove from git"
  HIT=1
fi

if [ "$HIT" -ne 0 ]; then
  echo "==> FAIL: secrets or risky patterns found"
  exit 1
fi
echo "==> PASS: no hardcoded secrets detected in tracked files"
exit 0
