---
description: Deep multi-source research with citations and a structured brief
agent: epic
---
Deep research for Epic Tech AI.

Topic: $ARGUMENTS

1. Load `epic-os` and `deep-research` (and `openalex-paper-search` if academic).
2. Spawn `@researcher` with the topic, required output format, and "cite primary sources".
3. In parallel, do your own web/docs pass on the core claim so you can cross-check the subagent.
4. Return:
   - Direct answer first
   - Evidence table (claim · source URL · confidence)
   - Unknowns
   - Recommended next actions for Epic Tech AI
5. If the result is durable product/tech knowledge, offer to write it into `.kortix/memory/` via the memory tool + CR.
