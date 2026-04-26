#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Generate a theme from a website URL by scraping brand color hints with curl.

Usage:
  themes/theme-from-url.sh --url https://example.com [--id custom-id] [--name "Custom Name"] [--engine auto|brandmd|curl] [--write]

Options:
  --url URL       Website URL to analyze (required)
  --id ID         Override generated theme id
  --name NAME     Override generated theme name
  --engine MODE   Extraction mode: auto (default), brandmd, or curl
  --write         Append generated theme object to themes/registry.json
  --help          Show this help

Output:
  - Prints a JSON theme object
  - Prints the :root token block for template.html
EOF
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Error: '$1' is required but not installed." >&2
    exit 1
  }
}

normalize_hex() {
  local hex="${1#\#}"
  hex="$(echo "$hex" | tr '[:upper:]' '[:lower:]')"
  if [[ ${#hex} -eq 3 ]]; then
    echo "#${hex:0:1}${hex:0:1}${hex:1:1}${hex:1:1}${hex:2:1}${hex:2:1}"
  else
    echo "#$hex"
  fi
}

hex_to_rgb() {
  local h="${1#\#}"
  local r=$((16#${h:0:2}))
  local g=$((16#${h:2:2}))
  local b=$((16#${h:4:2}))
  echo "$r,$g,$b"
}

resolve_url() {
  local href="$1"
  local origin="$2"
  local base_dir="$3"
  local scheme="$4"

  if [[ "$href" =~ ^https?:// ]]; then
    echo "$href"
  elif [[ "$href" =~ ^// ]]; then
    echo "${scheme}:$href"
  elif [[ "$href" =~ ^/ ]]; then
    echo "${origin}${href}"
  else
    echo "${base_dir}${href}"
  fi
}

URL=""
THEME_ID=""
THEME_NAME=""
ENGINE="auto"
WRITE_MODE="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --url)
      URL="${2:-}"
      shift 2
      ;;
    --id)
      THEME_ID="${2:-}"
      shift 2
      ;;
    --name)
      THEME_NAME="${2:-}"
      shift 2
      ;;
    --engine)
      ENGINE="${2:-}"
      shift 2
      ;;
    --write)
      WRITE_MODE="1"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$URL" ]]; then
  echo "Error: --url is required." >&2
  usage
  exit 1
fi

if [[ "$ENGINE" != "auto" && "$ENGINE" != "brandmd" && "$ENGINE" != "curl" ]]; then
  echo "Error: --engine must be one of: auto, brandmd, curl" >&2
  exit 1
fi

if [[ ! "$URL" =~ ^https?:// ]]; then
  URL="https://$URL"
fi

need_cmd curl
need_cmd rg
need_cmd awk
need_cmd sed

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY_PATH="$SCRIPT_DIR/registry.json"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

HTML_PATH="$TMP_DIR/index.html"
CSS_PATH="$TMP_DIR/styles.css"
COLORS_PATH="$TMP_DIR/colors.txt"
COUNTS_PATH="$TMP_DIR/color-counts.txt"
PICKS_PATH="$TMP_DIR/picks.env"
OBJ_PATH="$TMP_DIR/theme-object.json"
BRANDMD_JSON="$TMP_DIR/brandmd.json"

extract_colors_with_brandmd() {
  command -v npx >/dev/null 2>&1 || return 1

  if ! npx -y brandmd "$URL" --json > "$BRANDMD_JSON" 2>/dev/null; then
    return 1
  fi

  rg -o '#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})\b' "$BRANDMD_JSON" > "$COLORS_PATH" || true
  [[ -s "$COLORS_PATH" ]]
}

extract_colors_with_curl() {
  curl -LsS -A "Mozilla/5.0 (ppt-skill-theme-extractor)" --max-time 20 "$URL" -o "$HTML_PATH"

  touch "$CSS_PATH"

  # Collect likely stylesheet links and fetch a small set for better color sampling.
  rg -oN 'href=["'"'"'][^"'"'"']+["'"'"']' "$HTML_PATH" \
    | sed -E 's/^href=["'"'"'](.*)["'"'"']$/\1/' \
    | rg -i '\.css($|\?|#)|stylesheet' \
    | head -n 20 \
    | while IFS= read -r href; do
        css_url="$(resolve_url "$href" "$ORIGIN" "$BASE_DIR" "$SCHEME")"
        curl -LsS --max-time 10 "$css_url" >> "$CSS_PATH" || true
        echo >> "$CSS_PATH"
      done

  {
    cat "$HTML_PATH"
    cat "$CSS_PATH"
  } | rg -o '#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})\b' > "$COLORS_PATH" || true

  [[ -s "$COLORS_PATH" ]]
}

EFFECTIVE_URL="$(curl -Ls -o /dev/null -w '%{url_effective}' --max-time 20 "$URL")"

SCHEME="$(echo "$EFFECTIVE_URL" | sed -E 's#^(https?)://.*#\1#')"
ORIGIN="$(echo "$EFFECTIVE_URL" | sed -E 's#^(https?://[^/]+).*#\1#')"
BASE_DIR="$(echo "$EFFECTIVE_URL" | sed -E 's#[?#].*$##; s#[^/]*$##')"
HOST="$(echo "$EFFECTIVE_URL" | sed -E 's#^https?://([^/:]+).*#\1#' | sed -E 's/^www\.//')"

EXTRACTION_SOURCE=""

if [[ "$ENGINE" == "brandmd" ]]; then
  if ! extract_colors_with_brandmd; then
    echo "Error: brandmd extraction failed. Install with 'npm i -g brandmd' or use --engine curl." >&2
    exit 1
  fi
  EXTRACTION_SOURCE="brandmd"
elif [[ "$ENGINE" == "curl" ]]; then
  if ! extract_colors_with_curl; then
    echo "Error: curl extraction failed for '$URL'." >&2
    exit 1
  fi
  EXTRACTION_SOURCE="curl"
else
  if extract_colors_with_brandmd; then
    EXTRACTION_SOURCE="brandmd"
  elif extract_colors_with_curl; then
    EXTRACTION_SOURCE="curl"
  else
    echo "Error: no hex colors found for '$URL' via brandmd or curl extraction." >&2
    exit 1
  fi
fi

awk '
  {
    c=tolower($0)
    gsub("#","",c)
    if (length(c)==3) {
      c=substr(c,1,1) substr(c,1,1) substr(c,2,1) substr(c,2,1) substr(c,3,1) substr(c,3,1)
    }
    print "#" c
  }
' "$COLORS_PATH" | sort | uniq -c | sort -nr > "$COUNTS_PATH"

awk '
function hex2dec(h,    i, n, c, d) {
  n = 0
  for (i = 1; i <= length(h); i++) {
    c = substr(h, i, 1)
    if (c >= "0" && c <= "9") d = c + 0
    else d = 10 + index("abcdef", c) - 1
    n = n * 16 + d
  }
  return n
}
function luminance(hex,    h, r, g, b) {
  h = substr(hex, 2)
  r = hex2dec(substr(h, 1, 2))
  g = hex2dec(substr(h, 3, 2))
  b = hex2dec(substr(h, 5, 2))
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
}
{
  count = $1
  hex = $2
  lum = luminance(hex)

  if (lum <= 120) {
    if (count > dark_count && hex != dark1) {
      dark2 = dark1
      dark_count2 = dark_count
      dark1 = hex
      dark_count = count
    } else if (count > dark_count2 && hex != dark1) {
      dark2 = hex
      dark_count2 = count
    }
  }

  if (lum >= 190) {
    if (count > light_count && hex != light1) {
      light2 = light1
      light_count2 = light_count
      light1 = hex
      light_count = count
    } else if (count > light_count2 && hex != light1) {
      light2 = hex
      light_count2 = count
    }
  }
}
END {
  if (dark1 == "") dark1 = "#1f2937"
  if (dark2 == "") dark2 = dark1
  if (light1 == "") light1 = "#f5f5f4"
  if (light2 == "") light2 = light1

  print "INK=" dark1
  print "INK_TINT=" dark2
  print "PAPER=" light1
  print "PAPER_TINT=" light2
}
' "$COUNTS_PATH" > "$PICKS_PATH"

source "$PICKS_PATH"

if [[ -z "$THEME_ID" ]]; then
  THEME_ID="$(echo "$HOST" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
fi

if [[ -z "$THEME_NAME" ]]; then
  THEME_NAME="$(echo "$HOST" | sed -E 's/\.[^.]+$//' | tr '.-' ' ' | awk '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) substr($i,2)}; print}')"
  if [[ -z "$THEME_NAME" ]]; then
    THEME_NAME="Brand Theme"
  fi
fi

INK_RGB="$(hex_to_rgb "$INK")"
PAPER_RGB="$(hex_to_rgb "$PAPER")"

cat > "$OBJ_PATH" <<EOF
{
  "id": "$THEME_ID",
  "name": "$THEME_NAME",
  "bestFor": "brand-aligned decks generated from website colors",
  "tone": "auto-extracted from $HOST using $EXTRACTION_SOURCE-based color sampling",
  "source": {
    "type": "url-scrape",
    "engine": "$EXTRACTION_SOURCE",
    "url": "$EFFECTIVE_URL"
  },
  "tokens": {
    "--ink": "$INK",
    "--ink-rgb": "$INK_RGB",
    "--paper": "$PAPER",
    "--paper-rgb": "$PAPER_RGB",
    "--paper-tint": "$PAPER_TINT",
    "--ink-tint": "$INK_TINT"
  }
}
EOF

if [[ "$WRITE_MODE" == "1" ]]; then
  need_cmd jq
  if jq -e --arg id "$THEME_ID" '.themes[] | select(.id == $id)' "$REGISTRY_PATH" >/dev/null; then
    echo "Error: theme id '$THEME_ID' already exists in registry. Use --id to set a unique id." >&2
    exit 1
  fi

  TMP_REG="$(mktemp)"
  jq --slurpfile obj "$OBJ_PATH" '.themes += $obj' "$REGISTRY_PATH" > "$TMP_REG"
  mv "$TMP_REG" "$REGISTRY_PATH"
  echo "Added theme '$THEME_ID' to $REGISTRY_PATH"
fi

echo
echo "Generated theme object:"
cat "$OBJ_PATH"

echo
echo "Paste these tokens into assets/template.html :root:"
echo "--ink:$INK;"
echo "--ink-rgb:$INK_RGB;"
echo "--paper:$PAPER;"
echo "--paper-rgb:$PAPER_RGB;"
echo "--paper-tint:$PAPER_TINT;"
echo "--ink-tint:$INK_TINT;"
