# Slack setup (owner)

Users who want API keys **through Epic Tech AI** use:

https://epictechai.github.io/epic-tech-ai-agent/keys.html

## Live channels (Epic Tech HQ)

| Channel | URL |
|---------|-----|
| API keys | https://epictechhq.slack.com/archives/C0BN49K7L4Q |
| Support | https://epictechhq.slack.com/archives/C0BN49QLNQG |

Configured in `docs/assets/community.json`.

## Optional: public invite link

Channel archive links work for people **already in** Epic Tech HQ.

For brand-new users, add a workspace invite:

1. Slack → Workspace menu → Invite people → Copy link  
2. Set in `docs/assets/community.json`:

```json
"inviteUrl": "https://join.slack.com/t/epictechhq/shared_invite/zt-xxxxx"
```

3. Commit + push. The keys page will show **Join Epic Tech HQ on Slack**.

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
