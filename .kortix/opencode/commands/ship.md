---
description: Verify, commit, push, and open a change request to land work on main
agent: epic
---
Ship the current work for Epic Tech AI.

Arguments (optional focus): $ARGUMENTS

Steps:
1. `git status` + `git diff` + recent log — know exactly what changed.
2. Run the best available verification (tests, lint, build, smoke). Fix failures.
3. Stage only intentional files. No secrets, no junk.
4. Commit with a why-focused message (conventional if the repo uses it).
5. `git push origin HEAD`
6. `kortix cr open --title "..." --description "..."` with test plan + risks.
7. Report the CR number/URL to the user. Do NOT merge it yourself.

Brand context: Epic Tech AI · https://github.com/epictechai · https://x.com/EpicTechAI · epictechai@gmail.com
