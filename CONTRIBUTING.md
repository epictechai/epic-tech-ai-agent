# Contributing to Epic Tech AI

Thanks for helping improve the Epic Tech AI super-agent stack.

**Repo:** https://github.com/epictechai/epic-tech-ai-agent  
**Docs:** https://epictechai.github.io/epic-tech-ai-agent/  
**Contact:** epictechai@gmail.com  

## Before you start

1. Read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md), [SECURITY.md](SECURITY.md), and the site legal pages (Terms, Privacy, Acceptable Use).  
2. Do not commit secrets, API keys, or personal data.  
3. Keep changes focused; prefer small PRs.  

## Development setup

```bash
git clone https://github.com/epictechai/epic-tech-ai-agent.git
cd epic-tech-ai-agent
chmod +x LAUNCH.sh LAUNCH.command scripts/*.sh
./LAUNCH.sh doctor
```

Requires [OpenCode](https://opencode.ai/docs) and a configured model provider.

## What to contribute

- Agent prompts, skills, commands, docs, legal clarity  
- Bug fixes and launcher improvements  
- Tests and verification helpers  

Avoid: malware, exploit code, instructions for criminal activity, or scraping private data.

## Pull requests

1. Fork and branch from `main`.  
2. Describe *why* the change matters.  
3. Note how you verified (`./LAUNCH.sh doctor`, manual run, etc.).  
4. Ensure LICENSE/NOTICE headers stay intact on substantial copies.  

## License

By contributing, you agree that your contributions are licensed under the MIT License (see [LICENSE](LICENSE)).
