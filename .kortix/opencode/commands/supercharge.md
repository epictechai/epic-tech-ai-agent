---
description: Audit and upgrade the agent stack toward 1000x SOTA (agents, skills, models, memory)
agent: epic
---
Supercharge the Epic Tech AI agent platform.

Focus: $ARGUMENTS

1. Load `epic-os`, `customize-opencode`, `kortix-system`.
2. Audit:
   - `.kortix/opencode/agents/` — coverage gaps, weak prompts, stale models
   - skills + commands — missing high-leverage loops
   - `opencode.jsonc` — default agent/model, permissions, compaction
   - `kortix.toml` — connectors, triggers, env contract
   - `.kortix/memory/` — empty or stale brain
3. Propose a short upgrade plan (max 7 items), then **implement the highest-ROI items now**.
4. Keep model IDs only in frontmatter/config for easy future swaps.
5. Preserve brand: Epic Tech AI · https://github.com/epictechai · https://x.com/EpicTechAI · epictechai@gmail.com
6. Verify config shape against OpenCode schema mentally; don't break startup.
7. Commit + open CR if changes should land on main.
