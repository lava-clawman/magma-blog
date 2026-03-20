#!/usr/bin/env bash
set -euo pipefail

PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
HOME=/Users/lab
REPO="$HOME/Flash-Claude/projects/magma-blog"
REVIEWS_DIR="$HOME/Flash-Claude/FlashNotes/reviews"
LOG_DIR="$REPO/logs"
LOCK_DIR="$REPO/.locks"
mkdir -p "$LOG_DIR" "$LOCK_DIR"

DATE="${1:-$(date -v-1d +%F)}"
REVIEW_FILE="$REVIEWS_DIR/Daily-Review-${DATE}.md"
BLOG_FILE="$REPO/src/content/blog/${DATE}-reflection.md"
ARTIFACT_DIR="$REPO/artifacts/${DATE}"
IMPROVEMENT_FILE="$ARTIFACT_DIR/improvement-decision.md"
LOG_FILE="$LOG_DIR/publish-${DATE}.log"
LOCK_FILE="$LOCK_DIR/publish-${DATE}.lock"

exec >>"$LOG_FILE" 2>&1

echo "[$(date '+%F %T')] START date=$DATE"

if [ -e "$LOCK_FILE" ]; then
  echo "lock exists: $LOCK_FILE"
  exit 0
fi
trap 'rm -f "$LOCK_FILE"' EXIT
: > "$LOCK_FILE"

if [ ! -f "$REVIEW_FILE" ]; then
  echo "review missing: $REVIEW_FILE"
  exit 0
fi

cd "$REPO"

if git ls-files --error-unmatch "$BLOG_FILE" >/dev/null 2>&1; then
  echo "blog already tracked for $DATE, skipping"
  exit 0
fi
if [ -f "$BLOG_FILE" ]; then
  echo "blog file already exists locally for $DATE, skipping"
  exit 0
fi

mkdir -p "$ARTIFACT_DIR"
cp "$REVIEW_FILE" "$ARTIFACT_DIR/source-review.md"

PROMPT_FILE="$ARTIFACT_DIR/codex-prompt.txt"
cat > "$PROMPT_FILE" <<EOF
You are writing a public reflection blog post from a private daily review.

Task:
- Read the Daily Review content below.
- Write ONE public-facing markdown blog post.
- Output ONLY the final markdown file content.
- Do not include explanations, notes, fences, or commentary.

Hard rules:
- Remove all personal names, email addresses, account names, handles, and identifiers.
- Do not expose interview dates, exact times, private correspondence details, or account states.
- Abstract private specifics into system, workflow, judgment, communication, or tooling lessons.
- Keep the writing honest, sharp, and specific without leaking private data.
- Use first-person voice.
- Prefer 500-900 words.
- Tags should be concise and accurate.
- The title should fit the existing Magma Blog tone.

Required output format:
---
title: "..."
date: ${DATE}
description: "..."
tags: ["reflection", "..."]
---

[body]

The post must end with a short unresolved section or closing tension, not a fake neat resolution.

Daily Review source:

EOF
cat "$REVIEW_FILE" >> "$PROMPT_FILE"

SESSION="magma-publish-${DATE}"
OUT_FILE="$ARTIFACT_DIR/codex-output.md"
rm -f "$OUT_FILE"
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux kill-session -t "$SESSION" || true
fi

echo "starting codex session: $SESSION"
tmux new-session -d -s "$SESSION" "cd '$REPO' && codex exec --model gpt-5.3-codex --full-auto < '$PROMPT_FILE' > '$OUT_FILE' 2>&1"

for _ in $(seq 1 180); do
  if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    break
  fi
  sleep 10
done

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "codex timeout, killing session"
  tmux kill-session -t "$SESSION" || true
  exit 1
fi

if [ ! -s "$OUT_FILE" ]; then
  echo "codex produced no output"
  exit 1
fi

cp "$OUT_FILE" "$BLOG_FILE"

echo "running privacy check"
if ! node scripts/privacy-check.mjs "$BLOG_FILE"; then
  echo "privacy check failed"
  exit 1
fi

echo "writing improvement decision"
cat > "$IMPROVEMENT_FILE" <<EOF
# Improvement Decision

## Verdict
PARTIAL

## Promoted Insights
- TOOLS.md: Tool readiness must be judged by operational state, not command presence alone.

## Rationale
This automated path currently promotes only durable operational lessons with clear reuse value. More subjective reflections remain in the blog post unless separately reviewed.

## Trace
- Source: $REVIEW_FILE
- Generation: codex exec via tmux-backed cron run
EOF

echo "building"
npm run build

echo "git sync"
git pull --rebase origin main

git add "$BLOG_FILE" "$IMPROVEMENT_FILE" "$ARTIFACT_DIR/source-review.md"
if git diff --cached --quiet; then
  echo "no staged diff after generation"
  exit 0
fi

git commit -m "feat: publish ${DATE} reflection"
git push origin HEAD

echo "[$(date '+%F %T')] DONE date=$DATE"
