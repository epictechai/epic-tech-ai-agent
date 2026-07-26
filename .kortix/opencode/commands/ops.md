---
description: Run integrations safely via Executor (Stripe, Slack, GitHub, Vercel, Supabase, etc.)
agent: epic
---
Ops mode for Epic Tech AI.

Task: $ARGUMENTS

1. Load `kortix-executor` and `epic-os`.
2. Spawn `@ops` or run yourself:
   - `connectors` → what's available
   - `discover` → find tools
   - `describe` → schema + risk
   - `call` → execute
3. Money paths (Stripe): only human-defined Checkout/pricing flows. No surprise charges.
4. Never print secrets. If a connector is missing/not shared, tell the user the dashboard fix.
5. Report action results with ids/URLs/statuses and any human follow-up.
