---
name: x-comment-feed-posts
description: Find posts in the user's X feed and leave comments on them one by one. Use when the user wants to comment on N posts from the feed, usually about indie tech launches, new tech, or AI, while keeping comments short, first-person, thread-specific, and manually executed.
---

# X Comment Feed Posts

Use this skill for manual commenting from the feed.
It assumes browser access, and it works best when a `twitter-humanizer` skill is also available.

Default topic focus:

- Indie tech launches
- New tech products or releases
- AI launches, model updates, tooling, or practical AI workflows

If the user provides a different topic set, use that instead.
If the user does not provide `N`, ask for it.

Do not use this skill to evade platform enforcement, fake human browsing patterns, or mass-engage indiscriminately.
By default, use the home feed to discover posts. Do not use the X search bar unless the user explicitly tells you to.
CRITICAL: never find posts by searching when sourcing comments for this skill. Scroll the feed until you find relevant posts.
CRITICAL: do not refresh the feed in between comments while working toward `N` unless X is broken and the user explicitly wants that fallback.

## Comment standard

- One post at a time
- Use first person
- CRITICAL: keep every comment to 1 or 2 short sentences. Do not avoid, relax, or override this unless the user explicitly asks for longer comments.
- Stay on the thread topic only
- Slightly playful or provocative is fine if it still sounds friendly
- No forced product mentions
- Fresh posts are preferred; target posts that look recent, ideally within the last hour when timestamps are visible

## Workflow

1. Open X and start from the feed.
2. Scroll and inspect candidates one by one.
   - Content quality matters more than popularity.
   - Prefer posts that say something specific enough to answer.
   - Read [references/feed-workflow.md](references/feed-workflow.md).
3. For each chosen post:
   - Open the post
   - Read the post and enough surrounding context to understand the thread
   - Decide on one comment before typing
   - If the `twitter-humanizer` skill is available, use it to refine the comment without making it longer
   - Read [references/comment-rules.md](references/comment-rules.md).
   - Post the comment
   - Return to the feed, scroll more, then find the next candidate
4. Repeat until `N` comments are posted or the feed stops yielding good candidates.
5. Close every `x.com` tab opened during the run.

## If the feed is weak

- Keep scrolling instead of lowering the quality bar immediately
- If you truly cannot find enough fresh posts on the requested topic, say so in the completion report
- Only widen the freshness window or topic scope if the user explicitly allows it or the run would otherwise fail

## Completion report

At the end, report:

- Requested `N`
- Actual number of comments posted
- Which topics or posts were chosen
- The final text used for each comment
- Whether search was avoided
- Confirmation that all `x.com` tabs were closed
