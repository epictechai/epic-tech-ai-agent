# Conventions

## Branding

- User-facing name: **Epic Tech AI**
- Links: https://github.com/epictechai · https://x.com/EpicTechAI
- Email: epictechai@gmail.com
- Do not reintroduce Smoke / Jarvis in UI copy

## Git / ship

- Commit messages say *why*
- `git push origin HEAD` then `kortix cr open`
- No force-push without explicit human ask
- No secrets in commits

## Memory

- Only via `memory` tool under `.kortix/memory/`
- Keep `MEMORY.md` index accurate
- Durable facts only (see kortix-memory rubric)

## External APIs

- Executor only — no bearer tokens in shell/prompts
- Prefer least-privilege restricted keys

## Code changes

- Smallest correct slice
- Verify before claiming done
- Prefer edit existing files over new scaffolding
