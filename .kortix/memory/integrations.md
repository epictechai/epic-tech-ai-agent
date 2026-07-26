# Integrations

Secrets live in the Machine dashboard only. Agents use **kortix-executor**.

## Connectors (`kortix.toml`)

| Slug | App | Notes |
|---|---|---|
| `github` | GitHub | Repos, issues, PRs via Pipedream |
| `supabase` | Supabase | Backend/data |
| `vercel_token_auth` | Vercel | Deploys / projects |
| `slack_v2` | Slack | Messaging |
| `stripe` | Stripe | Restricted key recommended; human-owned pricing |

## Executor protocol

```
connectors → discover(intent) → describe(tool) → call(connector, action, args)
```

On `not_shared` / `needs_auth`: fix sharing in dashboard Customize → Connectors.

## Optional env (declared, not committed)

- `STRIPE_API_KEY` (restricted)
- `GROQ_API_KEY`
- `TAVILY_API_KEY` / `FIRECRAWL_API_KEY` (search/scrape tools)
- `REPLICATE_API_TOKEN` / `ELEVENLABS_API_KEY` (media skills)

## Money policy

Checkout/pricing defined by humans. Agents may create sessions and report charges; no surprise charges.
