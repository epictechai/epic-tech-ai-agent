# Agent stack (SOTA wiring)

Updated: 2026-07-26

## Design principle

**Roles and loops are stable; model IDs are swappable.**  
Change models only in:

- `.kortix/opencode/opencode.jsonc` (`model`, `small_model`, `agent.*.model`)
- Agent frontmatter `model:` lines

Do not bake model names into skill prose except as examples.

## Default models (Kortix gateway)

| Agent | Model | Why |
|---|---|---|
| `epic`, `architect`, `plan` | `kortix/anthropic/claude-opus-4.8` | Deep reasoning / orchestration |
| `builder`, `critic`, `ops`, `general`, `build` | `kortix/anthropic/claude-sonnet-5` | Fast strong implementation/review |
| `researcher` | `kortix/google/gemini-3.1-pro-preview` | Long-context multi-source research |
| `explore`, titles (`small_model`) | `kortix/anthropic/claude-haiku-4.5` | Cheap/fast reads |

`subagent_depth = 2` so orchestrator can nest light specialist chains.

## Core loop (`epic-os`)

```
memory boot → skills → classify → plan
→ parallel tools/subagents → verify → persist → report
```

## Commands

| Command | Purpose |
|---|---|
| `/ship` | verify → commit → push → `kortix cr open` |
| `/build` | architect (if needed) → builder → verify → optional critic |
| `/review` | `@critic` on diff |
| `/research` | `@researcher` + cross-check |
| `/ops` | Executor integrations |
| `/memory` | curate brain + memory CR |
| `/supercharge` | audit/upgrade agent stack |

## Upgrade checklist

1. Run `opencode models` and pick stronger IDs when available.
2. Swap IDs in `opencode.jsonc` + frontmatter only.
3. Keep `epic-os` as the behavioral source of truth.
4. Add skills/commands for repeated rituals rather than growing one mega-prompt.
5. Land via CR; new sessions boot from `main`.
