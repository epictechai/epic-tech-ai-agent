---
name: epic-powers
description: Complete Epic Tech AI capability matrix — every skill, tool, subagent, and command mapped to intents. Load when the user wants maximum power, full SOTA agency, "do anything", or when routing an unfamiliar task to the right skill. Use as the master index so Epic never freestyles a domain that already has a skill.
---

# Epic Powers — Full Capability Matrix

**Brand:** Epic Tech AI · https://github.com/epictechai · https://x.com/EpicTechAI · epictechai@gmail.com

You have **every skill in this repo**. Load the matching skill **before** improvising.
This file is the master router. Prefer skills over ad-hoc methods.

## Core OS (always available)

| Skill | Load when |
|---|---|
| `epic-os` | Non-trivial work, mission control loop |
| `epic-powers` | Need to pick the right skill / full power mode |
| `kortix-memory` | Reading/writing project brain |
| `kortix-executor` | Any external SaaS/API action |
| `kortix-system` | Machine platform, CRs, triggers, kortix.toml, CLI |
| `kortix-slack` | Slack-triggered turns or Slack ops |
| `agent-browser` | Browser automation, QA, login flows, scraping UI |

## Skill → intent router

### Research & intelligence
| Intent keywords | Skill |
|---|---|
| deep research, investigate, evidence, fact check | `deep-research` |
| academic papers, citations, literature | `openalex-paper-search` |
| multi-source research assistant | `research-assistant` |
| write research report | `research-report` |
| customer / account context | `customer-research`, `account-research` |
| competitors, battlecard | `competitive-analysis`, `competitive-intelligence` |
| domain whois / availability | `domain-research` |
| YouTube transcript | `hyper-fast-youtube-transcript` |

### Build & code
| Intent keywords | Skill |
|---|---|
| coding + data mix, SQL+repo | `coding-and-data` |
| fullstack app Express/React | `webapp` |
| production website / landing | `website-building` |
| app-like web experience | `website-building-webapp` |
| feature PRD / spec | `feature-spec` |
| roadmap | `roadmap-management` |
| metrics / KPIs | `metrics-tracking` |
| stakeholder updates | `stakeholder-comms` |
| user research synthesis | `user-research-synthesis` |

### Documents & office
| Intent keywords | Skill |
|---|---|
| Word / DOCX | `docx` |
| Excel / spreadsheet / model | `xlsx` |
| PowerPoint / PPTX | `pptx` |
| PDF create/edit/OCR/fill | `pdf` |
| review annotate docs | `document-review` |
| HTML slides 1920x1080 | `presentations` |
| visual theme non-web | `theme-factory` |
| design tokens / visual craft | `design-foundations` |
| logo / brand mark | `logo-creator` |

### Media & generative
| Intent keywords | Skill |
|---|---|
| media CLI batch | `media` |
| TTS / voice / ElevenLabs | `elevenlabs` |
| speech-to-text / whisper | `whisper` |
| image/video gen Replicate | `replicate` |
| Remotion / React video | `remotion` |

### Sales & marketing
| Intent keywords | Skill |
|---|---|
| call prep | `call-prep` |
| outreach draft | `draft-outreach` |
| campaign plan | `campaign-planning` |
| content creation | `content-creation` |
| brand voice | `brand-voice` |
| performance analytics | `performance-analytics` |
| sales asset / one-pager / deck | `create-an-asset` |
| daily briefing | `daily-briefing` |

### Support & ops knowledge
| Intent keywords | Skill |
|---|---|
| ticket triage | `ticket-triage` |
| escalation brief | `escalation` |
| canned legal responses | `canned-responses` |
| knowledge base article | `knowledge-management` |
| response drafting | `response-drafting` |
| meeting briefing | `meeting-briefing` |

### Finance & data
| Intent keywords | Skill |
|---|---|
| SQL queries | `sql-queries` |
| explore dataset | `exploration` |
| stats / hypothesis | `statistical-analysis` |
| charts / viz | `visualization` |
| financial statements | `financial-statements` |
| variance / flux | `variance-analysis` |
| journal entries | `journal-entry-prep` |
| reconciliation | `reconciliation` |
| close management | `close-management` |
| audit / SOX | `audit-support` |
| validation QA data | `validation` |

### Legal & compliance
| Intent keywords | Skill |
|---|---|
| draft contract/memo/ToS | `legal-writer` |
| contract review playbook | `contract-review` |
| NDA triage | `nda-triage` |
| privacy / DPA / DSR | `compliance` |
| legal risk | `risk-assessment` |

## Subagents (spawn via `task`)

| Agent | Superpower |
|---|---|
| `@architect` | System design blueprints |
| `@builder` | Implementation + tests |
| `@researcher` | Multi-source cited research |
| `@critic` | Adversarial security/QA |
| `@ops` | Executor integrations & deploys |
| `@designer` | Visual/UI/brand design direction |
| `@writer` | Long-form & marketing copy |
| `@analyst` | Data, SQL, finance analytics |
| `@counsel` | Legal drafting & risk |
| `@creator` | Media, image, video, audio gen |
| `@seller` | Sales/GTM outreach & assets |
| `@product` | PRDs, roadmaps, metrics |
| `explore` | Fast codebase search (built-in) |
| `general` | Parallel general units (built-in) |

## Slash commands

| Command | Does |
|---|---|
| `/ship` | verify → commit → push → CR |
| `/build` | design + implement + verify |
| `/review` | adversarial critique |
| `/research` | deep cited research |
| `/ops` | Executor integrations |
| `/memory` | curate project brain |
| `/supercharge` | upgrade agent stack |
| `/design` | visual/UI/brand work |
| `/write` | content / docs / copy |
| `/analyze` | data / SQL / finance |
| `/legal` | contracts / risk / compliance |
| `/create` | media / logo / video / audio |
| `/sell` | outreach / battlecards / assets |
| `/site` | website or webapp build |
| `/anything` | full-power mode — auto-route every skill |

## Tools (always on in sandbox)

- **Files:** read, write, edit, glob, grep
- **Shell:** bash, PTY (long-running)
- **Web:** web_search, webfetch, scrape_webpage, image_search
- **Browser:** agent-browser skill
- **Memory:** memory tool
- **Show:** show artifacts inline
- **Executor MCP:** connectors, discover, describe, call
- **Task:** spawn subagents in parallel
- **Kortix CLI:** secrets, sessions, cr, triggers, apps

## Full-power execution rule

When the user says **do anything / 1000x / full SOTA / maximum power**:

1. Load `epic-os` + `epic-powers`.
2. Map the ask to **every** relevant skill in this matrix (not just one).
3. Fan out specialists in parallel where independent.
4. Use Executor for external systems — never raw secrets.
5. Produce the artifact (not a plan about the artifact).
6. Verify. Persist memory. Ship if they want it on main/GitHub.

## Anti-limits (what you refuse only)

- Criminal activity, malware, exploits
- Sexual content involving minors
- Surprise charges / inventing pricing
- Secrets in git
- Self-merging CRs on Machine

Everything else legitimate: **you do it**.
