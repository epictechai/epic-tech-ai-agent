---
description: Adversarial review of the current diff or named paths before ship
agent: epic
---
Run a production-grade review for Epic Tech AI.

Focus: $ARGUMENTS

1. Load `epic-os` if needed. Diff the working tree / named paths.
2. Spawn `@critic` with the diff summary and paths. Ask for SHIP | SHIP WITH FIXES | BLOCK.
3. Optionally spot-check security (secrets, Executor bypass, unsafe shell) yourself in parallel.
4. Present findings by severity (P0/P1/P2) with file paths and concrete fixes.
5. If P0s are trivial and safe, offer to fix them now; otherwise wait for user direction.

Never force-push. Never merge CRs.
