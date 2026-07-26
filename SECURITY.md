# Security Policy — Epic Tech AI

**Contact:** epictechai@gmail.com  
**Project:** https://github.com/epictechai/epic-tech-ai-agent  
**Site:** https://epictechai.github.io/epic-tech-ai-agent/

## Supported versions

Security fixes are applied on the `main` branch of this repository.

## Reporting a vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Email **epictechai@gmail.com** with:

1. Description of the issue  
2. Steps to reproduce  
3. Impact assessment  
4. Any suggested fix (optional)  

We aim to acknowledge reports within **72 hours** and to provide a status update within **7 days**.

## Security posture (product)

- No API keys, tokens, or secrets should be committed to git.  
- Third-party SaaS calls should go through the Executor Gateway when running on Machine.  
- Money paths (e.g. Stripe) must use human-defined pricing / Checkout — agents must not invent charges.  
- Destructive operations should require confirmation.  
- This software must not be used to develop malware, exploits, or to commit crimes.

## Scope

In scope: this repository, the GitHub Pages documentation site, and documented default configurations.

Out of scope: third-party model providers, Pipedream/connectors you attach, and your own deployment secrets.
