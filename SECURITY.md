# Security Policy — Epic Tech AI

**Contact:** epictechai@gmail.com  
**Project:** https://github.com/epictechai/epic-tech-ai-agent  
**Site:** https://epictechai.github.io/epic-tech-ai-agent/

## Supported versions

Security fixes land on the `main` branch.

## Reporting a vulnerability

**Do not** open a public GitHub issue for security vulnerabilities.

Email **epictechai@gmail.com** with:

1. Description  
2. Steps to reproduce  
3. Impact  
4. Optional suggested fix  

We aim to acknowledge within **72 hours** and update within **7 days**.

## Hard rule: no secrets in git

This repository must **never** contain:

- API keys, tokens, passwords, private keys  
- `.env` files with real values  
- `auth.json` / credential dumps  

### How to store secrets (local)

```bat
opencode auth login
```

Or user environment variables (Windows):

```bat
setx OPENAI_API_KEY "your-key-here"
```

On Machine/Kortix: use the **dashboard Secrets Manager** / Executor — never paste keys into agent files.

### Verify before every push

```bash
bash scripts/secret-scan.sh
```

CI/humans should reject PRs that fail this scan.

### If a key was pasted in chat or committed

1. **Revoke/rotate immediately** at the provider  
2. Remove from git history if committed (`git filter-repo` / support)  
3. Never reuse the exposed key  

## Product posture

- Third-party SaaS via Executor Gateway when on Machine (no raw keys in prompts)  
- Human-defined Stripe/Checkout pricing only  
- Confirm destructive ops  
- No malware, exploits, or criminal use (see Acceptable Use on the site)  

## Scope

**In scope:** this repo, GitHub Pages docs, default configs.  
**Out of scope:** third-party model providers, your local `.env`, connectors you attach.
