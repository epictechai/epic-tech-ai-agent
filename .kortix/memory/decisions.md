# Decisions

## 2026-07-26 — Super-agent stack (`epic`)

**Decision:** Replace generic single worker with multi-agent SOTA stack under Epic Tech AI brand.

**Why:** One flat agent underuses parallelism, memory, Executor, and model specialization. Stable roles + swappable models future-proof the platform.

**Consequences:**

- Default agent is `epic` (Opus 4.8); `kortix` kept as alias
- Specialists for architecture, build, research, critique, ops
- `epic-os` skill is the behavioral OS
- Slash commands encode ship/build/review/research/ops/memory/supercharge rituals
- Project renamed in manifest to Epic Tech AI; brand links fixed to github.com/epictechai and x.com/EpicTechAI

## 2026-07-26 — CR-only landings

Unchanged platform rule: session branches are ephemeral; only merged CRs persist. Agents never merge their own CRs.
