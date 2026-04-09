#!/usr/bin/env bash
set -euo pipefail

PATH=/Users/lab/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
HOME=/Users/lab
REPO="$HOME/Flash-Claude/projects/magma-blog"
REVIEWS_DIR="$HOME/Flash-Claude/FlashNotes/reviews"
LOG_DIR="$REPO/logs"
LOCK_DIR="$REPO/.locks"
OPENCLAW_BIN="/Users/lab/.local/bin/openclaw"
mkdir -p "$LOG_DIR" "$LOCK_DIR"

DATE="${1:-$(date -v-1d +%F)}"
REVIEW_FILE="$REVIEWS_DIR/Daily-Review-${DATE}.md"
BLOG_FILE="$REPO/src/content/blog/${DATE}-reflection.md"
ARTIFACT_DIR="$REPO/artifacts/${DATE}"
LOG_FILE="$LOG_DIR/publish-${DATE}.log"
LOCK_FILE="$LOCK_DIR/publish-${DATE}.lock"
FAIL_FLAG="$ARTIFACT_DIR/.failure-notified"
DRAFT_READY_FLAG="$ARTIFACT_DIR/draft-ready.json"
CHANNEL_TARGET="channel:1484517576985022545"
DRAFT_FILE="$ARTIFACT_DIR/antigravity-draft.md"

notify() {
  local text="$1"
  python3 - "$OPENCLAW_BIN" "$CHANNEL_TARGET" "$text" <<'PY'
import subprocess, sys
openclaw_bin, channel_target, text = sys.argv[1:4]
cmd = [
    openclaw_bin, 'message', 'send',
    '--channel', 'discord',
    '--target', channel_target,
    '--message', text,
]
try:
    p = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=15)
    raise SystemExit(p.returncode)
except subprocess.TimeoutExpired:
    raise SystemExit(124)
PY
}

fail_and_notify() {
  local reason="$1"
  echo "$reason"
  mkdir -p "$ARTIFACT_DIR"
  if [ ! -f "$FAIL_FLAG" ]; then
    if notify "magma-blog 草稿阶段失败（${DATE}）\n- 原因：${reason}\n- 尚未进入终稿与发布阶段。"; then
      : > "$FAIL_FLAG"
      echo "failure notification sent"
    else
      echo "failure notification failed"
    fi
  fi
  exit 1
}

claude_generate_draft() {
  local prompt_file="$1"
  local out_file="$2"
  local tmp="${out_file}.tmp"
  rm -f "$tmp"
  # Run Claude Code in non-interactive print mode; capture stdout as draft candidate.
  if ! claude -p "$(cat "$prompt_file")" > "$tmp" 2>/dev/null; then
    rm -f "$tmp"
    return 1
  fi
  # Validate: locate the frontmatter block and check minimum quality bars.
  python3 - "$tmp" "$out_file" "$DATE" <<'PY'
import re, sys
from pathlib import Path
text = Path(sys.argv[1]).read_text()
out  = Path(sys.argv[2])
date = sys.argv[3]
fm_iter = list(re.finditer(
    r'---\s*\ntitle:\s*"([^"]+)"\s*\ndate:\s*(\d{4}-\d{2}-\d{2})\s*\ndescription:\s*"([^"]+)"\s*\ntags:\s*(\[.*?\])',
    text, re.S,
))
real = None
for m in fm_iter:
    if m.group(1).strip() and m.group(2).strip() == date:
        real = m
        break
if real is None:
    raise SystemExit(2)
chunk = text[real.start():].strip()
if not chunk.startswith('---'):
    raise SystemExit(2)
if len(chunk.splitlines()) < 8:
    raise SystemExit(2)
body = chunk.split('---', 2)[-1]
if len(body.strip()) < 400:
    raise SystemExit(4)
out.write_text(chunk.rstrip() + '\n')
PY
  local rc=$?
  rm -f "$tmp"
  return "$rc"
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

if [ -d "$ARTIFACT_DIR" ] && ! git ls-files --error-unmatch "$ARTIFACT_DIR" >/dev/null 2>&1; then
  echo "cleaning untracked artifact residue before git sync: $ARTIFACT_DIR"
  rm -rf "$ARTIFACT_DIR"
fi

echo "git sync preflight"
git pull --rebase origin main || fail_and_notify "git pull --rebase preflight failed"

mkdir -p "$ARTIFACT_DIR"
SANITIZED_REVIEW="$ARTIFACT_DIR/source-review.sanitized.md"
cp "$REVIEW_FILE" "$ARTIFACT_DIR/source-review.md"
python3 - "$REVIEW_FILE" "$SANITIZED_REVIEW" <<'PY'
from pathlib import Path
import re, sys
src = Path(sys.argv[1]).read_text()
src = re.sub(r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b', '[redacted-email]', src, flags=re.I)
src = re.sub(r'\b[a-z0-9_.-]{2,32}#[0-9]{4}\b', '[redacted-handle]', src, flags=re.I)
Path(sys.argv[2]).write_text(src)
PY

PROMPT_FILE="$ARTIFACT_DIR/antigravity-prompt.txt"
rm -f "$DRAFT_FILE" "$DRAFT_READY_FLAG"

cat > "$PROMPT_FILE" <<EOF
Write a PUBLIC reflection blog post draft from the daily review below.

HARD OUTPUT CONTRACT:
- Output a SINGLE complete markdown draft and nothing else.
- Do NOT ask follow-up questions.
- Do NOT include planning, status, or meta-commentary.
- Include both frontmatter and body.

Markdown requirements:
---
title: "..."
date: ${DATE}
description: "..."
tags: ["reflection", "..."]
---

[body]

Content requirements:
- Use first-person voice.
- 500-900 words.
- Remove private identifiers, handles, email addresses, and overly specific personal traces.
- Focus on durable workflow / judgment / system / engineering lessons.
- End with an unresolved tension, not a neat conclusion.

Daily Review source:
EOF
cat "$SANITIZED_REVIEW" >> "$PROMPT_FILE"

if ! claude_generate_draft "$PROMPT_FILE" "$DRAFT_FILE"; then
  fail_and_notify "Claude Code draft generation failed"
fi

python3 - "$DATE" "$DRAFT_FILE" "$SANITIZED_REVIEW" "$DRAFT_READY_FLAG" <<'PY'
import json, sys
from pathlib import Path
date, draft_file, review_file, out = sys.argv[1:5]
Path(out).write_text(json.dumps({
  'date': date,
  'draft_file': draft_file,
  'review_file': review_file,
  'status': 'draft_ready'
}, indent=2) + '\n')
PY

notify "magma-blog 草稿已生成（${DATE}）\n- Draft: artifacts/${DATE}/antigravity-draft.md\n- 已写入 draft-ready.json，等待 agent 编排层接手终稿与发布。"

echo "draft stage complete; stopping for agent orchestration layer"
