#!/usr/bin/env bash
set -euo pipefail

PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
HOME=/Users/lab
REPO="$HOME/Flash-Claude/projects/magma-blog"
REVIEWS_DIR="$HOME/Flash-Claude/FlashNotes/reviews"

for offset in 1 2 3; do
  DATE="$(date -v-${offset}d +%F)"
  REVIEW_FILE="$REVIEWS_DIR/Daily-Review-${DATE}.md"
  BLOG_FILE="$REPO/src/content/blog/${DATE}-reflection.md"
  if [ -f "$REVIEW_FILE" ] && [ ! -f "$BLOG_FILE" ]; then
    "$REPO/scripts/publish-from-review.sh" "$DATE" || true
  fi
done
