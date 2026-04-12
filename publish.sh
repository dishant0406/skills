#!/usr/bin/env zsh
set -uo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <version>  (e.g. $0 1.0.3)"
  exit 1
fi

VERSION="$1"
SCRIPT_DIR="${0:A:h}"
VERSION_FILE="$SCRIPT_DIR/version.txt"
LOG_FILE="$SCRIPT_DIR/publish.log"

# Update version.txt
echo "$VERSION" > "$VERSION_FILE"
echo "Version set to $VERSION"

SKILLS=(
  x-comment-feed-posts
  x-reply-unreplied
  x-topic-tweet
  re-blog-writer
  re-blog-meta
  re-blog-image
)

ERRORS=0

for SKILL in "${SKILLS[@]}"; do
  echo ""
  echo "Publishing $SKILL @ $VERSION ..."
  if clawhub publish --slug "$SKILL" "./$SKILL" --version "$VERSION" 2>&1; then
    echo "[OK] $SKILL $VERSION" | tee -a "$LOG_FILE"
  else
    MSG="[ERROR] $SKILL $VERSION — failed at $(date '+%Y-%m-%d %H:%M:%S')"
    echo "$MSG" | tee -a "$LOG_FILE"
    ERRORS=$(( ERRORS + 1 ))
  fi
done

echo ""
if [[ $ERRORS -eq 0 ]]; then
  echo "All skills published successfully."
else
  echo "$ERRORS skill(s) failed. See $LOG_FILE for details."
  exit 1
fi
