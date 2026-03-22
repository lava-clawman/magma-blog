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
FAIL_FLAG="$ARTIFACT_DIR/.failure-notified"
SUCCESS_FLAG="$ARTIFACT_DIR/.success-notified"
CHANNEL_TARGET="channel:1484517576985022545"

notify() {
  local text="$1"
  openclaw message send --channel discord --target "$CHANNEL_TARGET" --message "$text" >/dev/null 2>&1 || true
}

fail_and_notify() {
  local reason="$1"
  echo "$reason"
  mkdir -p "$ARTIFACT_DIR"
  if [ ! -f "$FAIL_FLAG" ]; then
    notify "magma-blog 自动发布失败（${DATE}）\n- 原因：${reason}\n- 将在下个整点后每小时继续重试，直到成功。"
    : > "$FAIL_FLAG"
    rm -f "$SUCCESS_FLAG"
  fi
  exit 1
}

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
RAW_OUT="$ARTIFACT_DIR/codex-output.raw.md"
OUT_FILE="$ARTIFACT_DIR/codex-output.md"
rm -f "$RAW_OUT" "$OUT_FILE"

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
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux kill-session -t "$SESSION" || true
fi

echo "starting codex session: $SESSION"
tmux new-session -d -s "$SESSION" "cd '$REPO' && codex exec --model gpt-5.3-codex --full-auto < '$PROMPT_FILE' > '$RAW_OUT' 2>&1"

for _ in $(seq 1 180); do
  if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    break
  fi
  sleep 10
done

if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux kill-session -t "$SESSION" || true
  fail_and_notify "codex timeout"
fi

if [ ! -s "$RAW_OUT" ]; then
  fail_and_notify "codex raw output missing"
fi

python3 - "$RAW_OUT" "$OUT_FILE" <<'PY'
from pathlib import Path
import re, sys
raw = Path(sys.argv[1]).read_text()
out = Path(sys.argv[2])
pattern = re.compile(r'(?ms)^---\ntitle:.*?(?:\n---\n.*)$')
matches = pattern.findall(raw)
if not matches:
    sys.exit(1)
out.write_text(matches[-1].strip() + "\n")
PY
if [ $? -ne 0 ] || [ ! -s "$OUT_FILE" ]; then
  fail_and_notify "no valid markdown document extracted from codex output"
fi

if ! grep -q '^title:' "$OUT_FILE" || ! grep -q '^date: ' "$OUT_FILE" || ! grep -q '^description:' "$OUT_FILE" || ! grep -q '^tags:' "$OUT_FILE"; then
  fail_and_notify "frontmatter validation failed"
fi

cp "$OUT_FILE" "$BLOG_FILE"

echo "running privacy check"
if ! node scripts/privacy-check.mjs "$BLOG_FILE"; then
  fail_and_notify "privacy check failed"
fi

echo "writing improvement decision"
cat > "$IMPROVEMENT_FILE" <<EOF
# Improvement Decision

## Verdict
PARTIAL

## Promoted Insights
- TOOLS.md: Use browser-backed capture and explicit partial labeling when dynamic social fetch paths are unreliable.
- TOOLS.md: Memory flush workflows need post-flush delta checks to avoid silent omissions.

## Rationale
This automated path promotes only durable operational and knowledge-management lessons with reuse value across days.

## Trace
- Source: $REVIEW_FILE
- Generation: codex exec via tmux-backed cron run
EOF

echo "building"
npm run build || fail_and_notify "build failed"

echo "git sync"
git pull --rebase origin main || fail_and_notify "git pull --rebase failed"

git add "$BLOG_FILE" "$IMPROVEMENT_FILE" "$ARTIFACT_DIR/source-review.md" "$OUT_FILE" "$RAW_OUT"
if git diff --cached --quiet; then
  echo "no staged diff after generation"
  exit 0
fi

git commit -m "feat: publish ${DATE} reflection" || fail_and_notify "git commit failed"
git push origin HEAD || fail_and_notify "git push failed"

rm -f "$FAIL_FLAG"
if [ ! -f "$SUCCESS_FLAG" ]; then
  notify "magma-blog 自动发布已恢复（${DATE}）\n- 状态：发布成功\n- 后续同日期不会再重试。"
  : > "$SUCCESS_FLAG"
fi

echo "[$(date '+%F %T')] DONE date=$DATE"
