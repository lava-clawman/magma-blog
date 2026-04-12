#!/usr/bin/env bash
set -euo pipefail

PATH=/Users/lab/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
HOME=/Users/lab
REPO="$HOME/Flash-Claude/projects/magma-blog"
REVIEWS_DIR="$HOME/Flash-Claude/FlashNotes/reviews"
ORCH="$REPO/scripts/orchestrate-reflection-finalization.py"
LOCK_DIR="$REPO/.locks"
mkdir -p "$LOCK_DIR"

run_publish_stage() {
  local date="$1"
  local review_file="$REVIEWS_DIR/Daily-Review-${date}.md"
  local blog_file="$REPO/src/content/blog/${date}-reflection.md"
  local artifact_dir="$REPO/artifacts/${date}"
  local draft_ready="$artifact_dir/draft-ready.json"
  local final_file="$artifact_dir/final-reflection.md"
  local success_flag="$artifact_dir/.success-notified"
  local stage_lock="$LOCK_DIR/retry-${date}.lock"

  if [ ! -f "$review_file" ]; then
    return 1
  fi

  if [ -f "$success_flag" ] || [ -f "$blog_file" ]; then
    return 1
  fi

  if [ -e "$stage_lock" ]; then
    echo "retry lock exists for $date, skipping"
    return 1
  fi
  trap 'rm -f "$stage_lock"' RETURN
  : > "$stage_lock"

  if [ -f "$final_file" ] || [ -f "$draft_ready" ]; then
    /usr/bin/python3 "$ORCH" "$date" || true
    return 0
  fi

  "$REPO/scripts/publish-from-review.sh" "$date" || true
  return 0
}

pick_target_date() {
  local date

  for offset in 1 2 3; do
    date="$(date -v-${offset}d +%F)"
    if run_publish_stage "$date"; then
      return 0
    fi
  done

  return 0
}

pick_target_date
