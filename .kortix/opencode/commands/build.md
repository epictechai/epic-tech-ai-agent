---
description: Design then implement a feature end-to-end with verification
agent: epic
---
Build mode for Epic Tech AI.

Request: $ARGUMENTS

1. Load `epic-os`. Read memory + relevant code.
2. If the change is multi-file or architectural, spawn `@architect` for a short blueprint first.
3. Implement with `@builder` (or yourself if small). Prefer smallest correct slice.
4. Verify (tests/build/smoke).
5. Spawn `@critic` on security-sensitive or money-touching changes.
6. Summarize: what shipped, how to verify, residual risks, whether a CR is ready.
7. If the user wants it on main, run the same path as `/ship`.
