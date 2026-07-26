# Agent stack — FULL SOTA (1000x)

Updated: 2026-07-26

## Design principle

**Roles and loops are stable; model IDs are swappable.**  
Change models only in `opencode.jsonc` + agent frontmatter.

## Primary

| Agent | Model | Notes |
|---|---|---|
| `epic` | `kortix/anthropic/claude-opus-4.8` variant **max** | Full orchestrator — every skill |
| `kortix` | same | Legacy alias |

## Specialists

| Agent | Model | Domain |
|---|---|---|
| `architect` | opus-4.8 high | System design |
| `builder` | sonnet-5 high | Implementation |
| `researcher` | gemini-3.1-pro-preview | Deep research |
| `critic` | sonnet-5 high | Adversarial QA |
| `ops` | sonnet-5 | Integrations / deploys |
| `designer` | sonnet-5 | Visual / brand / UI |
| `writer` | sonnet-5 | Prose / copy / docs |
| `analyst` | sonnet-5 high | Data / finance |
| `counsel` | opus-4.8 high | Legal / risk |
| `creator` | sonnet-5 | Media gen |
| `seller` | sonnet-5 | GTM / sales |
| `product` | sonnet-5 | PRD / roadmap |
| `explore` | haiku-4.5 | Fast codebase |
| `general` | sonnet-5 high | Parallel units |
| `memory-reflector` | sonnet-5 | Memory cron |

`subagent_depth = 3` for deep fan-out.

## OS skills

- `epic-frontier` — doctrine to outperform any single frontier model (ensemble, critic, verify)
- Public launcher: https://epictechai.github.io/epic-tech-ai-agent/


- `epic-os` — mission loop
- `epic-powers` — **master skill matrix** (every GKW + platform skill)
- Platform: kortix-executor, kortix-system, kortix-memory, kortix-slack, agent-browser
- 60+ domain skills under `GENERAL-KNOWLEDGE-WORKER/`

## Commands

`/anything` `/ship` `/build` `/review` `/research` `/ops` `/memory` `/supercharge`  
`/design` `/write` `/analyze` `/legal` `/create` `/sell` `/site`

## Upgrade path

1. `opencode models` → pick stronger IDs  
2. Swap only config/frontmatter  
3. Add skills for new domains; keep epic as router  
4. Push to https://github.com/epictechai/epic-tech-ai-agent  
