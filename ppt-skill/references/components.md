# Components Reference

This is the component handbook for `ppt-skill`. `template.html` already defines all styles. This document explains visual intent and usage patterns.

## Table of Contents

- [Base Slide Shell](#base-slide-shell)
- [Typography](#typography)
- [Chrome and Foot](#chrome-and-foot)
- [Callout Quote Box](#callout-quote-box)
- [Stat Number Matrix](#stat-number-matrix)
- [Platform Card](#platform-card)
- [Rowline Table Rows](#rowline-table-rows)
- [Pillar Cards](#pillar-cards)
- [Tag and Kicker](#tag-and-kicker)
- [Figure Image Frame](#figure-image-frame)
- [Icons](#icons)
- [Ghost Oversized Background Text](#ghost-oversized-background-text)
- [Highlight Marker](#highlight-marker)

---

## Base Slide Shell

Each page is a `<section class="slide ...">`.

```html
<section class="slide light" data-theme="light">   <!-- Light page -->
<section class="slide dark" data-theme="dark">     <!-- Dark page -->
<section class="slide light hero" data-theme="light">  <!-- Hero page: light + thin mask -->
<section class="slide dark hero" data-theme="dark">    <!-- Hero page: dark + thin mask -->
```

**Theme usage**: alternate light/dark every 2-3 pages. Avoid more than 3 same-theme pages in a row.

**Hero usage**: reserve for visually dominant pages (cover, key quote, act transition, ending). Hero pages use thinner masks and expose more WebGL background, so keep text content minimal.

---

## Typography

Font role split is the most important rule. Do not mix roles.

| Class | Purpose | Font |
|---|---|---|
| `.display` | Ultra-large English headline | Playfair Display 700, 11vw |
| `.display-zh` | Ultra-large Chinese headline | Noto Serif SC 700, 7.8vw |
| `.h1-zh` | Main page title | Noto Serif SC 700, 4.6vw |
| `.h2-zh` | Subtitle | Noto Serif SC 600, 3.2vw |
| `.h3-zh` | Pipeline step title | Noto Serif SC 500, 1.9vw |
| `.lead` | Lead paragraph | Noto Serif SC 400, 1.9vw |
| `.body-zh` | Body description (sans) | Noto Sans SC 400, 1.22vw |
| `.body-serif` | Body text (serif) | Noto Serif SC 400, 1.3vw |
| `.kicker` | Small prefix above title | IBM Plex Mono, 12px uppercase |
| `.meta` | Metadata label | IBM Plex Mono, 0.88vw uppercase |
| `.big-num` | Extra-large number | Playfair Display 800, 10vw |
| `.mid-num` | Medium number | Playfair Display 700, 5.5vw |

**Core rule**:
- Serif (`serif-zh` / `serif-en`) for headlines, emphasized quotes, and key numbers
- Sans (`sans-zh`) for body copy and dense information
- Mono (`mono`) for kicker/meta/foot labels

**Useful emphasis tricks**:
- `<em class="en">English term</em>` for italic Playfair highlight
- `<em style="opacity:.65">secondary phrase</em>` to soften part of a headline

---

## Chrome and Foot

Top and bottom metadata bars. Most pages should include both.

```html
<div class="chrome">
  <div class="left">
    <span>Act I · Hard Numbers</span>
    <span class="sep"></span>
    <span>Act I</span>
  </div>
  <div class="right"><span>02 / 27</span></div>
</div>

<!-- ... page content ... -->

<div class="foot">
  <div class="title">Project Name · CodePilot | github.com/codepilot</div>
  <div>Act I · Dev Numbers</div>
</div>
```

Rules:
- `chrome.right` uses page number format `NN / TOTAL`
- `foot.title` is description text, `foot.right` is concise act marker
- Together they create the magazine header/footer rhythm

---

## Callout Quote Box

Used for key statements and citations.

```html
<div class="callout" style="max-width:80vw">
  <div class="q-big">"Three years ago,<br>this required a ten-person team for a year."</div>
  <span class="cite">- An observer's judgment</span>
</div>
```

Variants:
- Remove `<span class="cite">` for citation-free callout
- English quote emphasis: `<em class="en">"Thin Harness, Fat Skills."</em>`
- On hero pages, add `style="position:relative;z-index:2"` if needed to stay above overlays

---

## Stat Number Matrix

For KPI-like metric blocks, usually with `.grid-6` or `.grid-4`.

```html
<div class="grid-6">
  <div class="stat">
    <span class="m">Duration</span>
    <span class="n">64<em style="font-size:.4em;opacity:.5;font-style:normal"> days</em></span>
    <span class="l">From zero to now</span>
  </div>
  <!-- ... more stat blocks ... -->
</div>
```

Three-layer structure: `.m` label -> `.n` number -> `.l` note.

Common containers:
- `.grid-6`: 3x2 (most common)
- `.grid-4`: 2x2
- `.grid-3`: 3 columns

---

## Platform Card

For social/platform channels and follower counts.

```html
<div class="plat">
  <div class="sub">Weibo</div>
  <div class="name">Weibo</div>
  <div class="nb">289K</div>
</div>
```

Optional fourth line:

```html
<div class="body-zh" style="font-size:max(11px,.8vw);opacity:.5;margin-top:.6vh">
  Includes mirrored channels
</div>
```

"Also On" variant:

```html
<div class="plat" style="border-top-style:dashed;opacity:.72">
  <div class="sub">Also On</div>
  <div class="body-zh" style="font-weight:600;margin-top:.8vh">
    Bilibili · Zhihu
  </div>
</div>
```

---

## Rowline Table Rows

For list-style rows with three columns.

```html
<div class="rowline">
  <div class="k">CLAUDE.md</div>
  <div class="v">How to work: behavior rules, preferences, and constraints.</div>
  <div class="m">EMPLOYEE · HANDBOOK</div>
</div>
```

Structure: `.k` keyword, `.v` description, `.m` right-aligned metadata tag.

2-column variant: use `style="grid-template-columns:1fr 3fr"` and remove `.m`.

---

## Pillar Cards

For three-pillar conceptual pages.

```html
<div class="grid-3">
  <div class="pillar">
    <div class="ic">01</div>
    <div class="t">Three-layer<br>documentation</div>
    <div class="d">CLAUDE.md<br>+ project knowledge base<br>+ guardrail files</div>
  </div>
  <!-- ... more pillars ... -->
</div>
```

Icon pillar variant:

```html
<div class="pillar" style="padding:4vh 2vw;border:1px solid currentColor;border-color:rgba(10,10,11,.2)">
  <div class="ic"><i data-lucide="compass" class="ico-lg"></i></div>
  <div class="t">Judgment</div>
  <div class="d">Authority over decisions and direction.<br>Trade-offs, taste, and orientation.</div>
</div>
```

`.ic` can be number labels or Lucide icons.

---

## Tag and Kicker

Kicker is the small monospaced prompt above title:

```html
<div class="kicker">Last 64 Days · Development Track</div>
<div class="h1-zh">What one person built.</div>
```

Tag is a standalone bordered label capsule:

```html
<div style="display:flex;gap:1.6vw;flex-wrap:wrap">
  <div class="tag">Wake up at 10am</div>
  <div class="tag">Gym on Tue/Thu afternoon</div>
  <div class="tag">Still watch shows and play games at night</div>
</div>
```

---

## Figure Image Frame

This is the most error-prone component. Follow strictly.

### Base structure

```html
<figure class="tile">
  <div class="frame-img" style="height:26vh">
    <img src="images/xxx.png" alt="description">
  </div>
  <figcaption class="frame-cap">
    <span class="pf">Twitter</span>
    <span class="nb">137K</span>
  </figcaption>
</figure>
```

### Hard constraints

1. Use fixed `height:Nvh`; do not use `aspect-ratio` in image grids.
2. Keep `object-position:top center` so only bottom is cropped.
3. For multi-image rows, use inline `display:grid` wrappers.
4. Avoid `align-self:end` in unstable contexts.

Recommended heights:
- `18vh` compact strip
- `22vh` standard grid
- `26vh` emphasized grid
- `28vh` large image

### Frame caption variants

```html
<!-- Standard -->
<figcaption class="frame-cap">
  <span class="pf">Twitter</span>
  <span class="nb">137K</span>
</figcaption>

<!-- Numbered -->
<figcaption class="frame-cap">
  <span class="idx">01</span>
  <span class="pf">AI Polish</span>
  <span>Polish</span>
</figcaption>
```

### Image placeholder (design-phase)

```html
<div class="img-slot r-4x3">  <!-- r-4x3 / r-16x9(default) / r-3x2 / r-1x1 -->
  <span class="plus">+</span>
  <span class="label">Screenshot placeholder</span>
</div>
```

---

## Icons

No emoji. Use Lucide via CDN (already in template).

```html
<i data-lucide="compass" class="ico-lg"></i>
<i data-lucide="target" class="ico-md"></i>
<i data-lucide="check-circle" class="ico-sm"></i>
```

Common groups:
- Decision: `compass`, `target`, `crosshair`, `search-check`
- Relations: `share-2`, `users`, `network`, `link`, `handshake`
- Brand: `crown`, `gem`, `award`, `star`, `badge-check`
- Flow: `workflow`, `route`, `arrow-right-left`, `repeat`
- Data: `grid-2x2`, `bar-chart-3`, `trending-up`, `activity`
- Visual: `palette`, `brush`, `eye`, `sparkles`
- Correctness: `check-circle`, `x-circle`, `check`, `x`
- Direction: `arrow-right`, `arrow-up-right`, `corner-down-right`

Inline icon + text:

```html
<div class="h3-zh" style="display:flex;align-items:center;gap:.8em">
  <i data-lucide="target" class="ico-md"></i>
  Judgment - What is worth writing
</div>
```

---

## Ghost Oversized Background Text

Decorative low-opacity background words for editorial mood.

```html
<div class="ghost" style="right:-6vw;top:-8vh">BUT</div>
<div class="ghost" style="left:-8vw;bottom:-18vh;font-style:italic">Harness</div>
```

- Typical size: `34vw`, opacity `0.06`
- Typical positions: right-top overflow or left-bottom overflow
- Content: English words or sequence numbers (01/02/03)

On pages with ghost text, foreground content should use `position:relative;z-index:2`.

---

## Highlight Marker

Inline fluorescent-marker effect:

```html
<span class="hi">not</span>
<span class="hi">one-time burst</span>
```

Use for only 1-3 key terms per section.