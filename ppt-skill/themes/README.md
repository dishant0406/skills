# Theme System

This folder is the scalable source of truth for deck themes.

## Files

- `registry.json`: all themes and tokens
- `theme-from-url.sh`: extract a brand-like theme from a website URL using curl

## Add A New Theme

1. Open `registry.json`
2. Add a new object to `themes[]`
3. Use a unique `id` (kebab-case)
4. Fill all token fields:
   - `--ink`
   - `--ink-rgb`
   - `--paper`
   - `--paper-rgb`
   - `--paper-tint`
   - `--ink-tint`
5. Keep `bestFor` and `tone` short and specific

## Apply A Theme

1. Pick the theme object from `registry.json`
2. Copy the six token values into `assets/template.html` under `:root`
3. Keep one theme per deck

## Generate Theme From URL

Use the extractor to sample colors from a brand website.

Engine behavior:

- `auto` (default): tries `brandmd --json` first, falls back to curl extraction
- `brandmd`: force brandmd-only extraction
- `curl`: force curl-only extraction

Preview only (no registry write):

```bash
bash themes/theme-from-url.sh --url https://stripe.com
```

Generate and append into `registry.json`:

```bash
bash themes/theme-from-url.sh --url https://stripe.com --write
```

Force brandmd:

```bash
bash themes/theme-from-url.sh --url https://stripe.com --engine brandmd --write
```

Custom id/name:

```bash
bash themes/theme-from-url.sh \
   --url https://stripe.com \
   --id stripe-brand \
   --name "Stripe Brand" \
   --write
```

Notes:

- `brandmd` usually gives better brand fidelity (tokens from rendered pages)
- If brandmd is unavailable/fails in `auto`, script falls back to curl extraction
- It appends only when `--write` is passed
- If the id already exists, it stops and asks for a new `--id`
