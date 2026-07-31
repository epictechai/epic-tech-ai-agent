# Slack invite setup (owner)

Users who want API keys **through Epic Tech AI** use the site page:

https://epictechai.github.io/epic-tech-ai-agent/keys.html

## 1. Create a Slack workspace (or use existing)

1. https://slack.com → create workspace **Epic Tech AI** (or your name)
2. Create channels:
   - `#api-keys` — key setup requests
   - `#support` — install help
3. **Invite link:** Workspace menu → Invite people → Copy invite link  
   Prefer a link that doesn’t expire soon (or rotate it in config when it does).

## 2. Put the link in the site config

Edit `docs/assets/community.json`:

```json
{
  "slack": {
    "inviteUrl": "https://join.slack.com/t/YOUR_WORKSPACE/shared_invite/zt-xxxxx",
    "channelKeys": "#api-keys",
    "channelSupport": "#support",
    "enabled": true
  }
}
```

Commit + push to `main`. GitHub Pages will pick it up.

Until `inviteUrl` is a real `join.slack.com` link, the **Get keys** button falls back to **email** (`epictechai@gmail.com`).

## 3. How you fulfill requests (ops)

1. User joins Slack → posts in `#api-keys`
2. You reply in-thread or DM
3. Guide them to create a key **in their provider account** (recommended)
4. They run locally: `opencode auth login`
5. **Never** ask them to paste a live key in a public channel
6. If you ever issue a managed key, send it only via secure DM and tell them to rotate if exposed

## 4. Optional: Slack bot on Machine

`kortix.toml` can include a `slack_v2` connector for agent replies inside Slack.
That is separate from the **invite link** on the marketing site.

## 5. Security

- No API keys in git (see `scripts/secret-scan.sh`)
- No keys in public channels
- Users revoke any key pasted in chat/email by mistake
