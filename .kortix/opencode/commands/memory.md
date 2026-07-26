---
description: Curate project memory from recent work and open a memory CR
agent: epic
---
Memory curation for Epic Tech AI.

Focus: $ARGUMENTS

1. Load `kortix-memory` and `epic-os`.
2. Survey: git log, recent CRs, current session learnings, existing `.kortix/memory/`.
3. Apply the rubric — durable team facts only. No secrets, no transient junk.
4. CRUD only via the `memory` tool. Keep `MEMORY.md` index in sync.
5. Commit + push + `kortix cr open` with title `memory: ...`.
6. If nothing durable, say so and do not open an empty CR.
