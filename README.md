# skills

Personal skill pack for running high-quality, manual X (Twitter) workflows with clear constraints, repeatable steps, and explicit completion reporting.

## What this repository contains

This repo includes four focused skills:

- `x-comment-feed-posts`: discover relevant posts in the X home feed and leave short, thread-specific comments.
- `x-reply-unreplied`: process mentions/notifications and reply only where a response is actually needed.
- `x-topic-tweet`: research a topic, draft one strong post, then publish with a short context pass.
- `blog-writer`: research a subject using the browser, write a complete 1200-1500 word blog post in a casual-direct style, and save it as a .md file in ~/blogs.

Each skill has:

- `SKILL.md` with intent, workflow, quality bar, and guardrails.
- `references/` docs with tactical rules used during execution.

## Repository structure

```text
.
├── README.md
├── version.txt
├── publish.sh
├── blog-writer/
│   ├── SKILL.md
│   └── references/
│       ├── research.md
│       ├── writing-style.md
│       └── structure.md
├── x-comment-feed-posts/
│   ├── SKILL.md
│   └── references/
│       ├── comment-rules.md
│       └── feed-workflow.md
├── x-reply-unreplied/
│   ├── SKILL.md
│   └── references/
│       ├── inbox-workflow.md
│       └── reply-rules.md
└── x-topic-tweet/
    ├── SKILL.md
    └── references/
        ├── post-workflow.md
        └── research-checklist.md
```

## Core operating principles

These rules are consistent across skills:

- Manual execution, one item at a time.
- First-person, thread-aware writing.
- Keep output short: default to 1-2 short sentences unless user explicitly asks for longer.
- Prefer specificity over hype.
- Avoid forced product mentions unless requested.
- Close all opened `x.com` tabs at the end of a run.

Safety boundaries:

- Do not use these skills for enforcement evasion, detection-avoidance behavior, or indiscriminate mass engagement.
- Use social sentiment as supporting context, not as sole source of truth for factual claims.

## Skills at a glance

### 1) x-comment-feed-posts

**Use when:** user wants comments on posts from their feed (usually indie tech/new tech/AI, unless they provide another topic set).

**Key behavior:**

- Source posts from home feed only by default.
- Do not use search unless the user explicitly asks.
- Do not batch source all posts first; do one full loop per comment:
  find post -> open -> read context -> draft -> post -> return to feed.
- Prefer fresh and specific posts.

**Reference docs:**

- `x-comment-feed-posts/references/feed-workflow.md`
- `x-comment-feed-posts/references/comment-rules.md`

---

### 2) x-reply-unreplied

**Use when:** user wants help replying to unreplied mentions/notifications.

**Key behavior:**

- Process one thread at a time.
- Reply only if account has not already replied in that branch.
- Skip spam, bait, abuse without upside, and low-confidence fact traps.
- Default processing cap: up to 5 suitable opportunities when no limit is given.

**Reference docs:**

- `x-reply-unreplied/references/inbox-workflow.md`
- `x-reply-unreplied/references/reply-rules.md`

---

### 3) x-topic-tweet

**Use when:** user provides a topic/angle/link and wants one post published.

**Key behavior:**

- Research first, then draft offline.
- Pull concrete notes before writing (fact, implication, angle, named detail).
- Open X only after draft is ready.
- Perform a brief context pass before composing/publishing.

**Reference docs:**

- `x-topic-tweet/references/research-checklist.md`
- `x-topic-tweet/references/post-workflow.md`

---

### 4) blog-writer

**Use when:** user provides a subject and wants a complete blog post written and saved to ~/blogs.

**Key behavior:**

- Research using browser (Google, Reddit, Hacker News, official sources) before writing.
- Never open with a day/time phrase. Start with a real-world fact or documented reaction.
- 5-part structure: setup, deep dive, random break, real talk, ending.
- Casual-direct style: short sentences, simple words, lowercase i, no em dashes, no clichés.
- Target 1200-1500 words. Save as `~/blogs/<subject-slug>.md`.
- Self-editing checklist must be run before saving.

**Reference docs:**

- `blog-writer/references/research.md`
- `blog-writer/references/writing-style.md`
- `blog-writer/references/structure.md`

## Standard run flow

Use this default sequence for any skill run:

1. Confirm input constraints (topic, count, tone, freshness, links).
2. Follow skill-specific workflow strictly.
3. Apply reference rules while drafting.
4. Execute one action at a time.
5. Produce completion report with final posted text.
6. Confirm cleanup (all `x.com` tabs closed).

## Completion report template

Use this structure after each run:

```text
Run Summary
- Skill used:
- Requested scope:
- Actual actions completed:

Output
- Item 1 final text:
- Item 2 final text:
- ...

Notes
- Skips and reasons:
- Any source/search constraints followed:
- Cleanup confirmation (all x.com tabs closed):
```

## How to extend this repo

When adding a new skill:

1. Create `<skill-name>/SKILL.md` with:
   - frontmatter (`name`, `description`)
   - use cases
   - workflow
   - quality bar
   - completion report requirements
2. Add a `references/` folder with small, task-focused docs.
3. Keep rules concrete and executable.
4. Update this README with the new skill summary.

## Notes

- These are execution skills, not scheduling/automation scripts.
- If a companion voice-polishing skill (for example, `twitter-humanizer`) exists in your environment, use it as an optional enhancement without violating brevity or topic constraints.
