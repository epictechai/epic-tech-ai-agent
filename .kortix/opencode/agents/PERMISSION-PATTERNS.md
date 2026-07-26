# Agent Permission Patterns — Epic Tech AI

Brand: [github.com/epictechai](https://github.com/epictechai) · [x.com/EpicTechAI](https://x.com/EpicTechAI) · epictechai@gmail.com

## Super-agent (primary) — full power in sandbox

```yaml
---
description: Epic Tech AI primary super-agent
mode: primary
model: openai/gpt-4.1
permission:
  "*": allow
  mcp:
    "kortix-executor": allow
  bash:
    "*": allow
    "git push --force*": ask
    "rm -rf /*": deny
  task:
    "*": allow
---
```

## Specialist implementer

```yaml
---
description: Focused builder
mode: subagent
model: openai/gpt-4.1-mini
permission:
  "*": allow
  mcp:
    "kortix-executor": allow
  task:
    "explore": allow
    "general": allow
    "*": deny
---
```

## Read-heavy reviewer / researcher

```yaml
---
description: Critic or research style
mode: subagent
permission:
  edit: allow
  write: allow
  bash:
    "*": allow
    "git push*": deny
  mcp:
    "kortix-executor": allow
  task:
    "explore": allow
    "*": deny
---
```

## Memory reflector (cron)

```yaml
---
mode: primary
permission:
  edit: allow
  write: allow
  bash:
    "git *": allow
    "kortix cr *": allow
    "kortix sessions *": allow
    "*": ask
  mcp:
    "kortix-executor": allow
---
```

## Rules

What Executor grants:

- Full use of `connectors` / `discover` / `describe` / `call`
- Server-side secret injection — agent never sees the key
- Audited calls; `risk: write|destructive` on dangerous tools

Never grant:

- Raw `curl` + bearer tokens when Executor can do the job
- Secrets in agent files or repo
- Force-push without `ask`
- Unscoped prod destroy commands

## Adding connectors

1. Add `[[connectors]]` in `kortix.toml` (slug + provider only).
2. Machine dashboard → Customize → Connectors → paste restricted key / OAuth and share with users/agents.
3. Next session sees it via `connectors`.

## Model swap (future-proof)

Keep roles stable. Change only:

- `.kortix/opencode/opencode.jsonc` → `model` / `agent.*.model`
- Agent frontmatter `model:` lines

Current SOTA map lives in `README.md` and `.kortix/memory/agent-stack.md`.
