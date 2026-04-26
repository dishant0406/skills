# Layout Library (Layouts)

This document includes 10 high-frequency layout skeletons. Each is a complete paste-ready `<section class="slide ...">...</section>` block.

---

## Pre-flight (required before generation)

### A. Class names must come from template.html

All classes used in this file (`h-hero`, `h-xl`, `h-sub`, `h-md`, `lead`, `meta-row`, `stat-card`, `stat-label`, `stat-nb`, `stat-unit`, `stat-note`, `pipeline-section`, `pipeline-label`, `pipeline`, `step`, `step-nb`, `step-title`, `step-desc`, `grid-2-7-5`, `grid-2-6-6`, `grid-2-8-4`, `grid-3-3`, `grid-6`, `grid-3`, `grid-4`, `frame`, `frame-img`, `img-cap`, `callout`, `callout-src`, `kicker`) are pre-defined in `assets/template.html`.

Do not invent new class names. If customization is required, use inline `style="..."`.

### B. Image ratio standards (critical)

Always use standard ratios. Never use odd source ratios like `2592/1798`.

| Scenario | Recommended | Syntax |
|------|---------|------|
| Main image in text-image layout | 16:10 or 4:3 | `aspect-ratio:16/10; max-height:54vh` |
| Multi-image grid | uniform | **fixed `height:26vh`, no aspect-ratio** |
| Small image + text | 1:1 or 3:2 | `aspect-ratio:1/1; max-width:40vw` |
| Full visual | 16:9 | `aspect-ratio:16/9; max-height:64vh` |
| Small insert image | 3:2 | `aspect-ratio:3/2; max-width:30vw` |

Images must be wrapped by `<figure class="frame-img">`. The nested `<img>` uses `object-fit:cover + object-position:top center`, so only bottoms are cropped.

### C. Image positioning rules (avoid bottom overlap)

Do not:
- use `align-self:end` in non-grid contexts
- use `position:absolute; bottom:0` to pin images
- use only `height:Nvh` without `max-height` for large standalone images

Do:
- use `.frame.grid-2-7-5` (or `.grid-2-6-6` / `.grid-2-8-4`) for mixed layouts
- keep container `align-items:start`
- if left callout should appear bottom-anchored, use flex column + `justify-content:space-between` in the left column
- add top breathing space like `style="padding-top:6vh"` in grid wrappers

### D. Theme palette and rhythm

- Pick palette from `references/themes.md` (5 presets only)
- Theme rhythm (`light` / `dark` / `hero light` / `hero dark`) must be planned before choosing layouts

---

## 0. Base slide structure

```html
<section class="slide [light|dark|hero light|hero dark]">
  <div class="chrome">
    <div>Context Label · Sub Label</div>
    <div>ACT · Page / Total</div>
  </div>
  <!-- Main content -->
  <div class="foot">
    <div>Footer note · Page Description</div>
    <div>- · -</div>
  </div>
</section>
```

- Use `light` or `dark` for non-hero pages
- Use `hero light` or `hero dark` for hero pages
- `chrome` and `foot` are optional but recommended

### chrome vs kicker (do not duplicate)

| Position | Role | Content type | Example |
|------|------|---------|------|
| `.chrome` left | magazine header/navigation metadata | stable category label, can repeat across pages | `Act II · Workflow` |
| `.chrome` right | page info | fixed format | `Act II · 15 / 25` |
| `.kicker` | page-level hook line | unique per page | `BUT`, `The Question`, `Phase 01` |

### Theme rhythm planning (mandatory)

Each `<section>` must include one of `light` / `dark` / `hero light` / `hero dark`.

#### Recommended default by layout

| Layout | Default theme | Why |
|---|---|---|
| 1 Cover | `hero dark` | strong opening ceremony |
| 2 Act Divider | alternate `hero dark` and `hero light` | breathing rhythm |
| 3 Big Numbers | `light` | numbers need clear paper base |
| 4 Quote + Image | alternate `light` and `dark` | main body rhythm driver |
| 5 Image Grid | `light` | screenshots read better on light base |
| 6 Pipeline | `light` | process clarity |
| 7 Hero Question | `hero dark` | high-impact suspense |
| 8 Big Quote | `dark` preferred, occasional `light` | ceremony and focus |
| 9 Before/After | `light` | side-by-side readability |
| 10 Lead Image + Side Text | alternate `light` and `dark` | rhythm |

#### Hard rhythm rules

- Do not allow 3+ consecutive pages with same theme
- For 8+ page decks, include at least one `hero dark` and one `hero light`
- Do not build body pages in only `light`; include at least one `dark` body page
- Recommended: insert one hero page every 3-4 pages

---

## Layout 1: Hero Cover

```html
<section class="slide hero dark">
  <div class="chrome">
    <div>A Talk · 2026.04.22</div>
    <div>Vol.01</div>
  </div>
  <div class="frame" style="display:grid; gap:4vh; align-content:center; min-height:80vh">
    <div class="kicker">Private Session · Speaker Name</div>
    <h1 class="h-hero">One-Person Company</h1>
    <h2 class="h-sub">Organizations Folded by AI</h2>
    <p class="lead" style="max-width:60vw">
      One creator built 110K lines in 64 days while maintaining normal life rhythm.
    </p>
    <div class="meta-row">
      <span>Speaker Name</span><span>·</span><span>Independent Creator / CodePilot Author</span>
    </div>
  </div>
  <div class="foot">
    <div>A talk on AI, organizations, and individuals</div>
    <div>- 2026 -</div>
  </div>
</section>
```

---

## Layout 2: Act Divider

```html
<section class="slide hero light">
  <div class="chrome">
    <div>Act I · Hard Numbers</div>
    <div>Act I · 01 / 25</div>
  </div>
  <div class="frame" style="display:grid; gap:6vh; align-content:center; min-height:80vh">
    <div class="kicker">Act I</div>
    <h1 class="h-hero" style="font-size:8.5vw">Hard Numbers</h1>
    <p class="lead" style="max-width:55vw">Look at the numbers first, then methods.</p>
  </div>
  <div class="foot">
    <div>Act opening</div>
    <div>- · -</div>
  </div>
</section>
```

---

## Layout 3: Big Numbers Grid

```html
<section class="slide light">
  <div class="chrome">
    <div>Last 64 Days · Development Track</div>
    <div>Act I / Dev · 02 / 25</div>
  </div>
  <div class="frame" style="padding-top:6vh">
    <div class="kicker">What one person built</div>
    <h2 class="h-xl">Last 64 Days</h2>
    <p class="lead" style="margin-bottom:5vh">From zero to open-source CodePilot.</p>

    <div class="grid-6" style="margin-top:6vh">
      <div class="stat-card">
        <div class="stat-label">Duration</div>
        <div class="stat-nb">64 <span class="stat-unit">days</span></div>
        <div class="stat-note">From zero to now</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Lines of Code</div>
        <div class="stat-nb">110K+</div>
        <div class="stat-note">Built by one person</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">GitHub Stars</div>
        <div class="stat-nb">5,166</div>
        <div class="stat-note">Single repository</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Downloads</div>
        <div class="stat-nb">41K+</div>
        <div class="stat-note">Installed on tens of thousands of machines</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">AI Providers</div>
        <div class="stat-nb">19</div>
        <div class="stat-note">Cross-provider integrations</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Commits</div>
        <div class="stat-nb">608+</div>
        <div class="stat-note">No collaborator</div>
      </div>
    </div>
  </div>
  <div class="foot">
    <div>Project · CodePilot | github.com/codepilot</div>
    <div>Act I · Dev Numbers</div>
  </div>
</section>
```

---

## Layout 4: Quote + Image (left text, right visual)

```html
<section class="slide light">
  <div class="chrome">
    <div>Identity Twist · The Contrast</div>
    <div>03 / 25</div>
  </div>
  <div class="frame grid-2-7-5" style="padding-top:6vh">
    <div style="display:flex; flex-direction:column; justify-content:space-between; gap:3vh">
      <div>
        <div class="kicker">BUT</div>
        <h2 class="h-xl" style="white-space:nowrap; font-size:7.2vw">I am not an engineer.</h2>
        <p class="lead" style="margin-top:3vh">I spent the last decade in UI design and AI visual effects, not coding.</p>
      </div>
      <div class="callout">
        "Three years ago,<br>
        this needed a ten-person team for a year."
        <div class="callout-src">- Observer's note</div>
      </div>
    </div>
    <figure class="frame-img" style="aspect-ratio:16/10; max-height:56vh">
      <img src="images/codepilot.png" alt="CodePilot screenshot">
      <figcaption class="img-cap">CodePilot · Product Screenshot</figcaption>
    </figure>
  </div>
  <div class="foot">
    <div>Page 03 · Identity Contrast</div>
    <div>- · -</div>
  </div>
</section>
```

---

## Layout 5: Image Grid (multi-image comparison)

```html
<section class="slide light">
  <div class="chrome">
    <div>Cross-platform Evidence</div>
    <div>Act I / Ops · 05 / 27</div>
  </div>
  <div class="frame" style="padding-top:5vh">
    <div class="kicker">Proof · Screenshots</div>
    <h2 class="h-xl">10 Platforms · 6 Screens</h2>

    <div class="grid-3-3" style="margin-top:4vh">
      <figure class="frame-img" style="height:26vh"><img src="images/weibo.png" alt="Weibo 289K"><figcaption class="img-cap">Weibo · 289K</figcaption></figure>
      <figure class="frame-img" style="height:26vh"><img src="images/twitter.png" alt="Twitter 137K"><figcaption class="img-cap">Twitter · 137K</figcaption></figure>
      <figure class="frame-img" style="height:26vh"><img src="images/wechat.png" alt="Newsletter 96K"><figcaption class="img-cap">Newsletter · 96K</figcaption></figure>
      <figure class="frame-img" style="height:26vh"><img src="images/jike.png" alt="Jike 26K"><figcaption class="img-cap">Jike · 26K</figcaption></figure>
      <figure class="frame-img" style="height:26vh"><img src="images/xhs.png" alt="Xiaohongshu 19K"><figcaption class="img-cap">Xiaohongshu · 19K</figcaption></figure>
      <figure class="frame-img" style="height:26vh"><img src="images/douyin.png" alt="Douyin 10K"><figcaption class="img-cap">Douyin · 10K</figcaption></figure>
    </div>
  </div>
  <div class="foot">
    <div>Captured · 2026.04</div>
    <div>Page 05 · Evidence</div>
  </div>
</section>
```

---

## Layout 6: Two-Column Pipeline

```html
<section class="slide light">
  <div class="chrome">
    <div>My Workflow</div>
    <div>Act II · 15 / 27</div>
  </div>
  <div class="frame">
    <div class="kicker">Pipeline</div>
    <h2 class="h-xl">Two Production Pipelines</h2>

    <div class="pipeline-section">
      <div class="pipeline-label">Text Pipeline</div>
      <div class="pipeline">
        <div class="step"><div class="step-nb">01</div><div class="step-title">Draft</div><div class="step-desc">AI drafts the first pass</div></div>
        <div class="step"><div class="step-nb">02</div><div class="step-title">Polish</div><div class="step-desc">Refine and de-AI the tone</div></div>
        <div class="step"><div class="step-nb">03</div><div class="step-title">Morph</div><div class="step-desc">Adapt for X and Xiaohongshu</div></div>
        <div class="step"><div class="step-nb">04</div><div class="step-title">Illustrate</div><div class="step-desc">Generate information graphics</div></div>
        <div class="step"><div class="step-nb">05</div><div class="step-title">Distribute</div><div class="step-desc">One-click publish to 9 channels</div></div>
      </div>
    </div>

    <div class="pipeline-section">
      <div class="pipeline-label">Visual and Video Pipeline</div>
      <div class="pipeline">
        <div class="step"><div class="step-nb">06</div><div class="step-title">Cut</div><div class="step-desc">AI-assisted edit</div></div>
        <div class="step"><div class="step-nb">07</div><div class="step-title">Wrap</div><div class="step-desc">AI-assisted packaging</div></div>
        <div class="step"><div class="step-nb">08</div><div class="step-title">Cover</div><div class="step-desc">Generate cover visuals</div></div>
      </div>
    </div>
  </div>
  <div class="foot">
    <div>Page 15 · Content Factory</div>
    <div>Workflow</div>
  </div>
</section>
```

---

## Layout 7: Hero Question (suspense close)

```html
<section class="slide hero dark">
  <div class="chrome">
    <div>The Question</div>
    <div>24 / 27</div>
  </div>
  <div class="frame" style="display:grid; gap:8vh; align-content:center; min-height:80vh">
    <div class="kicker">The Question</div>
    <h1 class="h-hero" style="font-size:7vw; line-height:1.15">
      Which roles in your company<br>
      should no longer be done<br>
      by humans?
    </h1>
    <p class="lead" style="max-width:50vw">This is not only a technology question. It is an architecture question.</p>
  </div>
  <div class="foot">
    <div>Page 24 · The Question</div>
    <div>- · -</div>
  </div>
</section>
```

---

## Layout 8: Big Quote

```html
<section class="slide light">
  <div class="chrome">
    <div>The Takeaway</div>
    <div>18 / 25</div>
  </div>
  <div class="frame" style="display:grid; gap:5vh; align-content:center; min-height:80vh">
    <div class="kicker">Quote</div>
    <blockquote style="font-family:var(--serif-zh); font-weight:700; font-size:5.8vw; line-height:1.2; letter-spacing:-.01em; max-width:72vw">
      "Without handoff,<br>everyone builds."
    </blockquote>
    <p class="lead" style="max-width:55vw; opacity:.65">
      Without the handoff, everyone builds.<br>
      And that changes everything.
    </p>
    <div class="meta-row"><span>- Luke Wroblewski</span><span>·</span><span>2026.04.16</span></div>
  </div>
  <div class="foot">
    <div>Page 18 · Key Quote</div>
    <div>- · -</div>
  </div>
</section>
```

---

## Layout 9: Before vs After

```html
<section class="slide light">
  <div class="chrome">
    <div>Before vs After · The Shift</div>
    <div>12 / 25</div>
  </div>
  <div class="frame" style="padding-top:5vh">
    <div class="kicker">Before / After · Paradigm Shift</div>
    <h2 class="h-xl" style="margin-bottom:4vh">From handoff to co-building</h2>

    <div class="grid-2-6-6" style="gap:5vw 4vh">
      <div style="padding:3vh 2vw; border-left:3px solid currentColor; opacity:.55">
        <div class="kicker" style="opacity:.9">Before</div>
        <h3 class="h-md" style="margin-top:2vh">Design -> Dev -> Handoff</h3>
        <ul style="margin-top:3vh; padding-left:1.2em; display:flex; flex-direction:column; gap:1.4vh; font-family:var(--sans-zh); font-size:max(14px,1.1vw); line-height:1.55">
          <li>Designer produces files in Figma</li>
          <li>Developers translate pixels by inspection</li>
          <li>Long PR back-and-forth for alignment</li>
          <li>Non-technical teammates cannot touch code</li>
        </ul>
      </div>
      <div style="padding:3vh 2vw; border-left:3px solid currentColor">
        <div class="kicker" style="opacity:.9">After</div>
        <h3 class="h-md" style="margin-top:2vh">Shared Tools · Parallel · Co-build</h3>
        <ul style="margin-top:3vh; padding-left:1.2em; display:flex; flex-direction:column; gap:1.4vh; font-family:var(--sans-zh); font-size:max(14px,1.1vw); line-height:1.55">
          <li>Three roles collaborate in one intent space</li>
          <li>`agents.md` as shared context</li>
          <li>Agents resolve alignment and conflicts</li>
          <li>Anyone can contribute safely</li>
        </ul>
      </div>
    </div>
  </div>
  <div class="foot">
    <div>Page 12 · Paradigm Shift</div>
    <div>Before / After</div>
  </div>
</section>
```

---

## Layout 10: Lead Image + Side Text

```html
<section class="slide light">
  <div class="chrome">
    <div>Design First</div>
    <div>08 / 16</div>
  </div>
  <div class="frame grid-2-8-4" style="padding-top:6vh">
    <div>
      <div class="kicker">Phase 01 · Design</div>
      <h2 class="h-xl" style="margin-top:1vh; margin-bottom:3vh">Design First · 2 Weeks</h2>

      <p class="lead" style="margin-bottom:3vh">
        Build visual exploration and design system in Figma: grid, typography, color variables, reusable components, desktop/mobile rounds.
      </p>

      <p style="font-family:var(--sans-zh); font-size:max(14px,1.15vw); line-height:1.75; opacity:.78; margin-bottom:2.4vh">
        In two weeks, style direction and structural content become stable. This is a strong traditional design process.
      </p>

      <div class="callout" style="margin-top:3vh">
        "This phase was pretty standard.<br>Just a solid web design process."
        <div class="callout-src">- Luke Wroblewski</div>
      </div>
    </div>
    <figure class="frame-img" style="aspect-ratio:3/4; max-height:60vh">
      <img src="images/figma.png" alt="Figma design system">
      <figcaption class="img-cap">Figma · Design System</figcaption>
    </figure>
  </div>
  <div class="foot">
    <div>Page 08 · Design First</div>
    <div>About 2 weeks</div>
  </div>
</section>
```

---

## Appendix: Common Grid Templates

| Class | Ratio | Use |
|---|---|---|
| `.grid-2-6-6` | 6:6 (1:1) | half split |
| `.grid-2-7-5` | 7:5 | text-primary + supporting visual |
| `.grid-2-8-4` | 8:4 (2:1) | dense text + small image/data |
| `.grid-3` | 1:1:1 | three parallel items |
| `.grid-3-3` | 3x2 | six-image matrix |
| `.grid-6` | 3x2 | six stat cards |

Default grid gaps are around `3vw 4vh` and can be overridden inline.

---

## Suggested Rhythm

For a 25-30 page talk:

1. Hero Cover (page 1)
2. Act Divider (hero)
3. Big Numbers
4. Quote + Image
5. Image Grid
6. Hero Question
7. Repeat rhythm for later acts
8. Hero Close

Recommended alternation ratio between hero and non-hero pages: roughly 1 hero per 2-3 body pages.