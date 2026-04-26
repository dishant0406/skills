---
name: ppt-skill
description: Generate an "editorial magazine x electronic ink" horizontal swipe web PPT as a single HTML file, including WebGL fluid backgrounds, serif headlines plus sans-serif body text, act divider pages, big-number posters, and image-grid layouts. Use this when the user asks for share/talk/launch style web slides, or mentions "magazine-style PPT", "horizontal swipe deck", "editorial magazine", or "e-ink presentation".
---

# Magazine Web PPT

## What This Skill Does

Generate a **single-file HTML** horizontal swipe deck with this visual DNA:

- **Editorial magazine + electronic ink** hybrid aesthetic
- **WebGL fluid / contour / dispersion backgrounds** (visible on hero pages)
- **Serif headlines (Noto Serif SC + Playfair Display) + sans-serif body (Noto Sans SC + Inter) + monospaced metadata (IBM Plex Mono)**
- **Lucide line icons** (no emoji)
- **Horizontal page turns** (keyboard left/right, mouse wheel, touch swipe, bottom dots, ESC index)
- **Smooth theme interpolation**: color and shader transitions when moving into hero pages

This skill is not "business PPT" and not "consumer internet UI". It should feel like *Monocle* magazine with code layered into it.

## When To Use

**Good fit**:
- Offline talks / internal industry talks / private salons
- AI product launch / demo day
- Talks with strong personal style
- Browser slides that are "done in one file" without traditional slide tools

**Not a good fit**:
- Heavy table/chart overlays (use normal PPT tools)
- Training material (information density is too low)
- Multi-person collaborative editing (this is static HTML)

## Workflow

### Step 1 · Clarify Requirements (**mandatory before building**)

**If the user already has a full outline + images**, you can skip straight to Step 2.

**If the user only gives a topic or vague idea**, align on these 6 questions before writing slides. Do not start from guesses. If structure is wrong early, rework cost is high.

#### 6-question alignment list

| # | Question | Why it matters |
|---|------|-----------|
| 1 | **Who is the audience? What is the speaking context?** (internal, launch, demo day, private salon) | Determines tone and depth |
| 2 | **Talk duration?** | 15 min ~= 10 pages, 30 min ~= 20 pages, 45 min ~= 25-30 pages |
| 3 | **Any source material?** (docs/data/old decks/article links) | If material exists, build from it; otherwise scaffold with user |
| 4 | **Any images? Where are they?** | See "Image conventions" below |
| 5 | **Which theme palette or brand URL?** | Pick from `themes/registry.json` or generate from a website URL |
| 6 | **Any hard constraints?** (must include X / must avoid Y) | Prevent avoidable rework |

#### Outline assistance (if user has no outline)

Use this narrative-arc skeleton first, then fill content:

```
Hook            -> 1 page    : drop a contrast/question/hard stat to make people stop
Context         -> 1-2 pages : explain background / who you are / why this topic
Core            -> 3-5 pages : core content, mix layouts 4/5/6/9/10
Shift           -> 1 page    : break expectation / introduce new framing
Takeaway        -> 1-2 pages : memorable line / unresolved question / action prompt
```

Only move to Step 2 after narrative arc + page plan + theme rhythm table (see `layouts.md`) are aligned.

Save the outline as `project-notes.md` or `outline-v1.md` for iteration history.

#### Image conventions (tell user up front)

Before implementation, tell the user:

- **Folder location**: under `project/XXX/ppt/images/` (same level as `index.html`)
- **Naming convention**: `{page-number}-{semantic}.{ext}`, e.g. `01-cover.jpg` / `03-figma.jpg` / `05-dashboard.png`
  - zero-pad page numbers for sorting
  - semantic name should be short, specific, and content-matched
- **Spec guidance**:
  - single image width >= 1600px (avoid blur on big screens)
  - JPG for photos/screenshots, PNG for transparent UI/charts
  - keep total image size under 10MB (turning performance)
- **How to replace**: same-filename overwrite is safest (no path edits in HTML). If filename changes, global replace `images/old-name` to new name.
- **No images yet**: align with the user to use color-block placeholders first; add real images later. But warn that mixed text-image layouts (4/5/10) cannot be visually validated without images.

### Step 2 · Copy The Template

Copy `assets/template.html` into the target location (usually `project/XXX/ppt/index.html`) and create a sibling `images/` folder.

```bash
mkdir -p "project/XXX/ppt/images"
cp "<SKILL_ROOT>/assets/template.html" "project/XXX/ppt/index.html"
```

`template.html` is **fully runnable**: CSS, WebGL shaders, navigation JS, and font/icon CDNs are preconfigured. Only `<main id="deck">` contains sample slides (cover, act divider, and blank filler).

#### 2.1 · Required placeholder replacement (**easy to miss**)

Replace placeholders immediately after copy, or the browser tab will show awkward defaults.

| Location | Original | Replace with |
|------|------|--------|
| `<title>` | `[Required] Replace with PPT title · Deck Title` | Real deck title (for example `A New Way of Working · Luke Wroblewski`) |

First action after copy: grep for `[Required]` and make sure all are replaced.

#### 2.2 · Pick one theme palette (registry-based, scalable)

This skill uses a scalable theme registry in `themes/registry.json`. Add themes there as the single source of truth. Do not use ad-hoc one-off hex values.

| # | Theme | Best for |
|---|------|------|
| 1 | Ink Classic | General / commercial launch / safe default |
| 2 | Indigo Porcelain | Tech / research / data / technical keynote |
| 3 | Forest Ink | Nature / sustainability / culture / non-fiction |
| 4 | Kraft Paper | Nostalgic / humanist / literary / indie magazine |
| 5 | Dune | Art / design / creative / gallery |

**How to apply**:
1. Recommend one from content context or let user choose
2. Open `themes/registry.json` and locate the selected theme's token block
3. **Replace the whole theme variable block** in the copied `template.html` (`--ink` / `--ink-rgb` / `--paper` / `--paper-rgb` / `--paper-tint` / `--ink-tint`)
4. All other CSS uses `var(--...)`; no further CSS edits required

#### 2.3 · Brand URL mode (auto theme from website)

If user provides a website URL and asks for brand matching:

1. Run URL extractor:

```bash
bash themes/theme-from-url.sh --url https://example.com --write
```

Prefer brandmd-powered extraction when available:

```bash
bash themes/theme-from-url.sh --url https://example.com --engine brandmd --write
```

2. This appends a new theme object to `themes/registry.json`
3. Use that generated theme's token block in `assets/template.html`
4. Continue normal deck generation flow

Optional custom id/name:

```bash
bash themes/theme-from-url.sh --url https://example.com --id brand-theme --name "Brand Theme" --write
```

**Hard rules**:
- One deck uses one theme only; do not switch mid-deck
- Do not accept arbitrary one-off hex values; add new themes through registry entries
- No mix-and-match (for example ink from one theme + paper from another)

### Step 3 · Fill Content

#### 3.0 · Pre-flight: required classes must exist in `template.html` (**most important**)

This is the root cause behind most generation failures. `layouts.md` uses many classes (`h-hero`, `h-xl`, `stat-card`, `pipeline`, `grid-2-7-5`, etc.). If the `<style>` block in `assets/template.html` does not define them, the browser falls back to defaults.

Before writing any slide code:

1. **Read `assets/template.html` first** (at least until the end of `<style>`)
2. **Cross-check with the pre-flight list in `layouts.md`** to verify every needed class exists
3. If a class is missing: **add it in the template `<style>`**, not as per-slide inline rewrites
4. **`template.html` is the only class source**. Do not invent new class names. If custom styling is needed, use inline `style="..."`.

Commonly missed classes to verify:
`h-hero` / `h-xl` / `h-sub` / `h-md` / `lead` / `kicker` / `meta-row` / `stat-card` / `stat-label` / `stat-nb` / `stat-unit` / `stat-note` / `pipeline-section` / `pipeline-label` / `pipeline` / `step` / `step-nb` / `step-title` / `step-desc` / `grid-2-7-5` / `grid-2-6-6` / `grid-2-8-4` / `grid-3-3` / `grid-6` / `grid-3` / `grid-4` / `frame` / `frame-img` / `img-cap` / `callout` / `callout-src` / `chrome` / `foot`

#### 3.0.5 · Plan theme rhythm (**same priority as class pre-flight**)

Before selecting layouts, list each page's theme class (`hero dark` / `hero light` / `light` / `dark`) in notes first. See "Theme rhythm planning" in `references/layouts.md`.

**Hard rules**:

- Every section must include one of `light` / `dark` / `hero light` / `hero dark`; never just `hero`
- 3+ consecutive pages with the same theme = visual fatigue (not allowed)
- Decks with 8+ pages must include >=1 `hero dark` and >=1 `hero light`
- Deck cannot be only `light` body pages; include `dark` body pages for breathing rhythm
- Insert one hero page every 3-4 pages (cover/divider/question/big quote)

**Post-generation self-check**: `grep 'class="slide' index.html` and manually validate rhythm.

#### 3.1 · Select layouts

**Do not author slides from scratch**. `references/layouts.md` includes 10 paste-ready `<section>` skeletons:

| Layout | Use |
|---|---|
| 1. Hero cover | Page 1 |
| 2. Act divider | Start of each act |
| 3. Big numbers poster | Hard stats |
| 4. Left text + right image (quote + image) | Identity contrast / story |
| 5. Image grid | Multi-image comparison / screenshot evidence |
| 6. Two-column pipeline | Workflow |
| 7. Suspense close / question page | End of act / ending |
| 8. Big quote page | Serif quote / takeaway |
| 9. Side-by-side comparison (before/after) | Old mode vs new mode |
| 10. Mixed image-text (lead image + side text) | Dense information page |

Pick the matching layout, paste it, then change copy and image paths. **Always complete 3.0 pre-flight first**.

#### 3.2 · Image ratio standards

Always use **standard ratios**. Never use odd source-image ratios (for example `2592/1798`):

| Scenario | Recommended ratio |
|------|---------|
| Main image in left-text-right-image layout | 16:10 or 4:3 + `max-height:56vh` |
| Image grid (multi-image compare) | **fixed `height:26vh`**, no aspect-ratio |
| Left small image + right text | 1:1 or 3:2 |
| Full-screen key visual | 16:9 + `max-height:64vh` |
| Small image in mixed layout | 3:2 or 3:4 |

**Never use `align-self:end` for images**. It pushes images to the cell bottom and can overlap with browser UI. Use grid container + `align-items:start` (already set in template) so images anchor at the top. If the left column should feel bottom-aligned, use flex column + `justify-content:space-between` in the left column.

Component details (type, color, grid, icon, callout, stat-card, etc.) are documented in `references/components.md`.

### Step 4 · Self-check against checklist

After generation, always open `references/checklist.md` and verify item by item. It captures **real production pitfalls**. All P0 issues (emoji, image overflow, bad line wrapping, typography role mix-ups) must pass.

Pay extra attention to:

1. **Big headlines must be serif**. If they render sans-serif, 99% likely Step 3.0 was skipped and `h-hero` is missing in template styles.
2. **Image grids must use `height:Nvh`, not `aspect-ratio`** (aspect-ratio can overflow grid containers).
3. **Images must not sink to page bottom**. Do not use `align-self:end`; use grid + `align-items:start` (Step 3.2).
4. **Use only standard ratios** (16:10 / 4:3 / 3:2 / 1:1 / 16:9), never raw source-image ratios.
5. **Chinese headline <= 5 characters and nowrap** (if Chinese copy is used in localized decks).
6. **Use Lucide, not emoji**.
7. **Headlines in serif, body in sans-serif, metadata in mono**.

### Step 5 · Local Preview

Open `index.html` directly in browser. On macOS:

```bash
open "project/XXX/ppt/index.html"
```

No local server needed. Images use relative paths `images/xxx.png`.

### Step 6 · Iterate

Refine based on user feedback. Template CSS is highly parameterized; 90% of tweaks are inline style adjustments (`font-size:Xvw` / `height:Yvh` / `gap:Zvh`).

---

## Resource File Guide

```
ppt-skill/
├── SKILL.md              <- you are here
├── assets/
│   └── template.html     <- complete runnable template (seed file)
├── themes/
│   ├── README.md         <- scalable theme system docs
│   └── registry.json     <- source of truth for all theme tokens
└── references/
    ├── components.md     <- component guide (type, color, grid, icon, callout, stat, pipeline...)
    ├── layouts.md        <- 10 page layout skeletons (paste-ready)
    ├── themes.md         <- how to apply and extend themes via registry
    └── checklist.md      <- quality checklist (P0/P1/P2/P3)
```

**Recommended read order**:
1. Read `SKILL.md` (this file) first for end-to-end understanding
2. After Step 1 clarification, read `themes/registry.json` and `references/themes.md` to select one palette
3. **Before implementation, read the `<style>` block in `assets/template.html`**. This is the only class source.
4. Read `layouts.md` to choose layouts (includes pre-flight class list and theme rhythm planning)
5. Use `components.md` during detail tuning
6. After generation, run `checklist.md` self-check (P0-0 pre-flight at top is mandatory)

## Core Design Principles (Philosophy)

> These principles come from five rounds of iteration on a one-person-company talk deck. Breaking any one of them weakens the visual result.

1. **Restraint beats show-off** - WebGL backgrounds only show strongly on hero pages
2. **Structure beats decoration** - no heavy shadows, no floating cards, no padding boxes; hierarchy comes from **large type + type contrast + grid whitespace**
3. **Hierarchy is jointly defined by font and scale** - largest serif = primary title, medium serif = subtitle, large sans = lead, small sans = body, mono = metadata
4. **Images are first-class** - crop only bottom; keep top and sides intact; image grids should use fixed `height:Nvh`, not aspect-ratio stretching
5. **Rhythm comes from hero pages** - alternate hero and non-hero pages to reduce fatigue
6. **Terminology must stay consistent** - keep core terms consistent across the deck

## Reference Works

Visual anchors behind this skill:

- Reference talk: "One-Person Company: Organizations Folded by AI" (2026-04-22, 27 pages)
- *Monocle* magazine layout language
- YC President Garry Tan's "Thin Harness, Fat Skills" post demo

Use these as style anchors.
