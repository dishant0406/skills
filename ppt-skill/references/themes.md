# Theme Presets (Themes)

Themes are managed through a separate scalable registry at `themes/registry.json`.

This file explains how to select, apply, and extend themes safely.

---

## Scalable Theme Source

- Source of truth: `themes/registry.json`
- Registry docs: `themes/README.md`
- Runtime apply target: `assets/template.html` (`:root` token block)

Do not maintain theme tokens in multiple places. Add or edit only in `themes/registry.json`.

## How To Apply A Theme

1. Open `themes/registry.json`
2. Pick a theme object from `themes[]`
3. Copy its six token values into `assets/template.html` `:root`
4. Keep one theme per deck

## URL Mode (Brand Colors From Website)

If the user gives a website URL and asks to match brand colors, use URL mode.

Command:

```bash
bash themes/theme-from-url.sh --url https://example.com --write
```

Prefer brandmd explicitly when available:

```bash
bash themes/theme-from-url.sh --url https://example.com --engine brandmd --write
```

What it does:

1. Tries brandmd JSON extraction first (`auto` mode), or uses curl extractor
2. Extracts brand-relevant color candidates
3. Builds a theme object (`--ink`, `--paper`, tints, rgb values)
4. Appends the theme into `themes/registry.json`

Then apply that new theme in `assets/template.html` as usual.

Required token keys:

- `--ink`
- `--ink-rgb`
- `--paper`
- `--paper-rgb`
- `--paper-tint`
- `--ink-tint`

---

## Current Presets In Registry

The registry currently ships with five presets:

1. Ink Classic
2. Indigo Porcelain
3. Forest Ink
4. Kraft Paper
5. Dune

## Ink Classic (Monocle default)

**Best for**: general presentations, business launches, and safe default use.
**Tone**: pure ink black + warm off-white, strongest magazine feel.

```css
--ink:#0a0a0b;
--ink-rgb:10,10,11;
--paper:#f1efea;
--paper-rgb:241,239,234;
--paper-tint:#e8e5de;
--ink-tint:#18181a;
```

---

## Indigo Porcelain

**Best for**: tech, research, data-heavy talks, engineering culture.
**Tone**: deep indigo + porcelain white, calm and analytical.

```css
--ink:#0a1f3d;
--ink-rgb:10,31,61;
--paper:#f1f3f5;
--paper-rgb:241,243,245;
--paper-tint:#e4e8ec;
--ink-tint:#152a4a;
```

---

## Forest Ink

**Best for**: nature, sustainability, culture, non-fiction topics.
**Tone**: deep forest green + ivory, grounded and calm.

```css
--ink:#1a2e1f;
--ink-rgb:26,46,31;
--paper:#f5f1e8;
--paper-rgb:245,241,232;
--paper-tint:#ece7da;
--ink-tint:#253d2c;
```

---

## Kraft Paper

**Best for**: nostalgic, humanist, literary, and indie-magazine moods.
**Tone**: deep brown + warm beige, notebook/envelope texture.

```css
--ink:#2a1e13;
--ink-rgb:42,30,19;
--paper:#eedfc7;
--paper-rgb:238,223,199;
--paper-tint:#e0d0b6;
--ink-tint:#3a2a1d;
```

---

## Dune

**Best for**: art, design, creative showcases, and gallery-like decks.
**Tone**: charcoal + sand, restrained and premium.

```css
--ink:#1f1a14;
--ink-rgb:31,26,20;
--paper:#f0e6d2;
--paper-rgb:240,230,210;
--paper-tint:#e3d7bf;
--ink-tint:#2d2620;
```

---

## Quick Selection Guide

| If your deck is... | Recommended theme |
|---|---|
| First use / not sure | Ink Classic |
| AI / technical / product launch | Indigo Porcelain |
| Industry observation / culture / long-form content | Forest Ink |
| Book review / lifestyle / humanist narrative | Kraft Paper |
| Design / art / branding | Dune |

---

## Switching Rules

- **One deck, one theme**. Do not switch midway.
- Default WebGL shader colors are compatible with all five themes.
- Borders/icons driven by `currentColor` adapt automatically per section.
- After choosing a theme, title/chrome copy can reinforce that mood.

## Add A New Theme (Scalable Flow)

1. Open `themes/registry.json`
2. Append a new object to `themes[]`
3. Use a unique `id` in kebab-case
4. Fill `name`, `bestFor`, `tone`, and all six token keys
5. Keep color relationships coherent (ink contrast, readable paper background)
6. Apply once in `assets/template.html` and test readability on both light/dark pages

## Do Not Do These

- Do not mix themes (for example ink from one preset and paper from another)
- Do not use ad-hoc one-off color edits outside registry-driven tokens
- Do not edit scattered color styles elsewhere in template; only update `:root` from registry values

After choosing a palette, state it clearly in the skill flow and save it in project notes so later iterations stay consistent.