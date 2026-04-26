# Quality Checklist

This checklist comes from real-world deck iterations. Every item is written from actual failures and sorted by severity.

Read it once before generating slides. After generation, verify item by item.

---

## P0 · Never break these

### 0. Class-name validation before generation (most important)

**Symptom**: You paste `layouts.md` skeletons into a new HTML file and all styling collapses. Headlines render sans-serif, data cards look like body text, pipeline rows collapse, images sink to the bottom.

**Root cause**: If the `<style>` block in `template.html` does not define required classes, browser fallback styles take over.

**Fix**:
- **Before generation, read `assets/template.html` first** and confirm classes used in `layouts.md` exist
- Most frequently missed classes: `h-hero / h-xl / h-sub / h-md / lead / meta-row / stat-card / stat-label / stat-nb / stat-unit / stat-note / pipeline-section / pipeline-label / pipeline / step / step-nb / step-title / step-desc / grid-2-7-5 / grid-2-6-6 / grid-2-8-4 / grid-3-3 / frame / img-cap / callout-src`
- If a class is missing, **add it to `<style>` in `template.html`**, not per-slide inline rewrites
- If you see serif failures or single-line pipeline squeeze after generation, this is almost always the cause

### 1. Do not use emoji as icons

**Symptom**: Emoji (`🎯 💡 ✅`) instantly damages the editorial look.

**Fix**: Use Lucide icon CDN:

```html
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
...
<i data-lucide="target" class="ico-md"></i>
...
<script>lucide.createIcons();</script>
```

Common icon names: `target / palette / search-check / compass / share-2 / crown / check-circle / x-circle / plus / arrow-right / grid-2x2 / network`

### 2. Images may only crop from bottom; never crop top or sides

**Symptom**: Using `aspect-ratio` to force image boxes causes grid overflow or crops key top regions (like screenshot header bars).

**Fix**: Use **fixed height + overflow hidden**, with `object-fit:cover + object-position:top`:

```html
<figure class="frame-img" style="height:26vh">
  <img src="screenshot.png">
</figure>
```

`.frame-img img` already defaults to `object-position:top` in CSS.

**Do not use** this in grids:

```html
<!-- Bad -->
<figure class="frame-img" style="aspect-ratio: 16/9">...</figure>
```

**Exception**: Single hero visuals (not inside grids) may use `aspect-ratio + max-height`.

### 2b. Light pages with dark WebGL haze (theme switching failure)

**Symptom**: Light pages look gray and muddy, including `hero light`.

**Root cause**: JS swaps two canvas opacities by theme. If the deck starts `hero dark` and classes are wrong or missing, `light-bg` never applies.

**Fix**:
- `go()` infers theme from class (`light` / `dark`), so **every slide must explicitly include one**
- Hero pages use `hero light` or `hero dark`; body pages use `light` or `dark`
- Do not use only `hero` without a concrete theme
- Include at least one non-hero light page so body can switch to `light-bg`

### 2b-2. Entire deck is only light pages (no rhythm)

**Symptom**: Aside from cover, all pages are `light`; deck becomes visually flat.

**Root cause**: Layout defaults are often copied without rhythm planning.

**Fix**:
- **Create a theme rhythm table before generation** with one of: `hero dark / hero light / light / dark` for each page
- **Hard rules**: no 3 consecutive same-theme pages; for 8+ page decks include >=1 `hero dark` and >=1 `hero light`; include at least one dark body page
- Recommended theme by layout (see `layouts.md`):
  - Layout 4/8/10: alternate `light` and `dark`
  - Big numbers / image grid / pipeline / compare: `light`
  - Cover / question: `hero dark`
  - Act divider: alternate `hero dark` and `hero light`
- Self-check with `grep 'class="slide' index.html`

### 2c. Do not duplicate meaning between chrome and kicker

**Symptom**: `.chrome` and `.kicker` say the same thing in two forms.

**Fix**:
- **chrome** = persistent magazine header/navigation label across multiple pages
- **kicker** = one-line page-specific hook above title
- They must complement each other, never translate each other

### 3. Headline size must respect viewport and text length

**Symptom**: Oversized headlines cause one-character-per-line wrapping.

**Fix**:
- `h-hero`: 10vw, headline length <= 5 Chinese characters when using Chinese decks
- `h-xl`: 6vw-7vw
- Use manual `<br>` breaks for long titles
- Add `white-space:nowrap` when needed

### 4. Font role split: serif title, sans body

**Rules**:
- Headlines, key quotes, large numbers -> **serif**
- Body and descriptions -> **sans-serif**
- Metadata/code/tags -> **mono**

All are preloaded in template via Google Fonts.

### 4b. Do not bottom-align images with `align-self:end`

**Symptom**: Images may fall under browser UI or footers on low-height screens.

**Fix**:
- Mixed content pages must use `.frame.grid-2-7-5` (or `.grid-2-6-6`/`.grid-2-8-4`)
- Use standard image ratio 16/10 or 4/3 + `max-height:56vh`
- If left-column callout should feel bottom-anchored, apply flex column + `justify-content:space-between` to **left** column only

### 4c. Do not use odd source-image aspect ratios

**Symptom**: `aspect-ratio:2592/1798` and similar raw ratios create awkward overflow/whitespace.

**Fix**: Use only standard layout ratios: `16/10 / 4/3 / 3/2 / 1/1 / 16/9`.

### 5. No heavy borders or shadows on images

**Symptom**: Strong shadows and thick borders make the deck look like generic business slides.

**Fix**: Keep radius subtle (1-4px), minimal texture only. Avoid heavy `box-shadow` and thick borders.

---

## P1 · Layout rhythm

### 6. Alternate hero and non-hero pages

Recommended rhythm (25-30 pages):

```
Hero Cover -> Act Divider (hero) -> 3-4 non-hero pages -> Act Divider (hero)
-> 4-5 non-hero pages -> Hero Question -> ... -> Hero Close
```

2+ consecutive hero pages is tiring. 4+ non-hero pages in a row feels flat.

### 7. Alternate poster pages and dense pages

Big-number/hero-question pages should alternate with dense pages (pipeline/image-grid) to reduce eye strain.

### 8. Keep term usage consistent

**Symptom**: Terms drift across pages and read like unedited AI output.

**Fix**:
- Keep key terms stable deck-wide
- Avoid forced literal translations that sound unnatural
- One concept, one term

### 9. Keep chrome page numbering consistent

Use `XX / Total` format (for example `05 / 27`). Do not add separate dynamic page numbers in corners that duplicate chrome.

---

## P2 · Visual polish

### 10. WebGL mask opacity by page type

- **Dark hero**: 12-15% (WebGL should be clear)
- **Light hero**: 16-20% (visible but text-safe)
- **Normal pages**: 92-95% (almost hidden)

If text is sparse, mask may be lighter. If text is dense, mask must be stronger.

### 11. Light hero shader should avoid aggressive center focus

**Symptom**: Strong radial vortex effects on light themes feel outdated.

**Fix**: Use no-center flowing FBM domain-warp style for light hero, with paper-like base and subtle chromatic offsets.

### 12. Dark hero can take stronger visual impact

Dark hero pages can handle stronger centered structures (for example holographic dispersion) because dark backgrounds support more visual contrast.

### 13. Alignment in left-text-right-image layouts

- Left text group uses `justify-content:space-between` (title near top, quote near bottom)
- Right image aligns naturally with grid start
- Grid container should use `align-items:start`

### 14. Subtle image radius

Use `border-radius:4px` on `.frame-img` and image. Do not exceed 8px.

---

## P3 · Operational details

### 15. Use relative image paths

Store images under `images/` and reference as `images/xxx.png`. Do not use absolute paths.

### 16. `.chrome` page totals are static text

Bottom nav dots and total pages are dynamic in JS, but `XX / N` in `.chrome` is static and must be updated manually when page count changes.

### 17. Keep navigation logic intact

Template defaults: left/right keys, wheel, touch swipe, dots, Home/End. Do not remove these JS behaviors.

### 18. Prefer `min-height:80vh` over hard `height:100vh`

`100vh` can overflow behind browser UI. `min-height:80vh + align-content:center` is more robust.

---

## Final verification checklist

After deck generation, verify each item:

```
Pre-flight (before generation)
  [ ] Read template `<style>` and verified required classes exist
  [ ] Chosen layout per page (1-10)
  [ ] Built theme rhythm table (hero dark / hero light / light / dark)
  [ ] Rhythm passes hard rules (no 3 same-theme pages in a row / includes hero dark + hero light for 8+ pages / includes dark body page)
  [ ] `<title>` replaced with real deck title (`grep "[Required]"` returns nothing)

Content
  [ ] Act page distribution is balanced
  [ ] No emoji icons
  [ ] Key terminology usage is consistent
  [ ] Kicker + headline + body hierarchy is clear

Layout
  [ ] No one-character-per-line title wraps
  [ ] Image grids use height:Nvh, not aspect-ratio
  [ ] Images crop only from bottom; top and sides remain visible
  [ ] Serif/sans role split follows template
  [ ] Pipeline groups have visible separation

Visual
  [ ] Hero and non-hero pages alternate
  [ ] WebGL background is visible on hero pages
  [ ] Images use subtle radius
  [ ] No heavy shadows or thick borders

Interaction
  [ ] Left/right navigation works
  [ ] Bottom dots match total pages
  [ ] Chrome page labels match real page positions
  [ ] ESC opens index view (if retained)
```

Only after this full pass is the deck considered production quality.