#!/usr/bin/env bash
set -euo pipefail

PATH=/Users/lab/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
HOME=/Users/lab
REPO="$HOME/Flash-Claude/projects/magma-blog"
REVIEWS_DIR="$HOME/Flash-Claude/FlashNotes/reviews"
LOG_DIR="$REPO/logs"
LOCK_DIR="$REPO/.locks"
OPENCLI_BIN="/opt/homebrew/bin/opencli"
OPENCLAW_BIN="/Users/lab/.local/bin/openclaw"
ANTIGRAVITY_APP="/Applications/Antigravity.app/Contents/MacOS/Electron"
OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9224"
export OPENCLI_CDP_ENDPOINT
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
MODEL_LABEL="Claude Opus 4.6 (Thinking)"
ARTIFACT_NAME="reflection_post.md"

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
    if notify "magma-blog 自动发布失败（${DATE}）\n- 原因：${reason}\n- 将在下个整点后每小时继续重试，直到成功。"; then
      : > "$FAIL_FLAG"
      rm -f "$SUCCESS_FLAG"
      echo "failure notification sent"
    else
      echo "failure notification failed"
    fi
  fi
  exit 1
}

restart_antigravity() {
  echo "restarting controlled Antigravity instance"
  pkill -f "$ANTIGRAVITY_APP --remote-debugging-port=9224" || true
  pkill -f "$ANTIGRAVITY_APP" || true
  sleep 3
  "$ANTIGRAVITY_APP" --remote-debugging-port=9224 >/tmp/antigravity-opencli.log 2>&1 &
  sleep 8
}

ensure_antigravity() {
  if curl -fsS "$OPENCLI_CDP_ENDPOINT/json/version" >/dev/null 2>&1; then
    return 0
  fi
  if [ ! -x "$ANTIGRAVITY_APP" ]; then
    fail_and_notify "Antigravity app not found at $ANTIGRAVITY_APP"
  fi
  echo "starting Antigravity CDP instance"
  "$ANTIGRAVITY_APP" --remote-debugging-port=9224 >/tmp/antigravity-opencli.log 2>&1 &
  sleep 8
  curl -fsS "$OPENCLI_CDP_ENDPOINT/json/version" >/dev/null 2>&1 || return 1
}

run_opencli_step() {
  local label="$1"
  shift
  local attempts=0
  local max_attempts=3
  until "$@"; do
    attempts=$((attempts + 1))
    if [ "$attempts" -ge "$max_attempts" ]; then
      return 1
    fi
    echo "$label failed, restarting Antigravity and retrying ($attempts/$max_attempts)"
    restart_antigravity || true
    ensure_antigravity || true
  done
}

current_model_is_target() {
  local model_read
  if ! model_read="$($OPENCLI_BIN antigravity read -f json 2>/dev/null || true)"; then
    return 1
  fi
  echo "$model_read" | grep -Fq "$MODEL_LABEL"
}

switch_model_if_needed() {
  if current_model_is_target; then
    echo "model already on target: $MODEL_LABEL"
    return 0
  fi

  sleep 3
  if current_model_is_target; then
    echo "model already on target after settle: $MODEL_LABEL"
    return 0
  fi

  if run_opencli_step "opencli antigravity model switch" $OPENCLI_BIN antigravity model "$MODEL_LABEL" -f json >/dev/null 2>&1; then
    sleep 3
    if current_model_is_target; then
      echo "model switch confirmed: $MODEL_LABEL"
      return 0
    fi
  fi

  # One more read-based confirmation before failing hard.
  if current_model_is_target; then
    echo "model appears to be target despite switch instability: $MODEL_LABEL"
    return 0
  fi

  return 1
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
  echo "removing stale local blog file for retry: $BLOG_FILE"
  rm -f "$BLOG_FILE"
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
READ_JSON="$ARTIFACT_DIR/antigravity-read.json"
OUT_FILE="$ARTIFACT_DIR/antigravity-output.md"
RAW_HINTS="$ARTIFACT_DIR/antigravity-hints.txt"
rm -f "$READ_JSON" "$OUT_FILE" "$RAW_HINTS"

cat > "$PROMPT_FILE" <<EOF
Write a PUBLIC reflection blog post from the daily review below.

Requirements:
- Use first-person voice.
- 500-900 words.
- Remove private identifiers, handles, email addresses, and overly specific personal traces.
- Focus on durable workflow / judgment / system / engineering lessons.
- End with an unresolved tension, not a neat conclusion.
- Save the final markdown to a file named ${ARTIFACT_NAME}.
- Then reply in chat with exactly one line in this format:
ARTIFACT_PATH: <absolute path to ${ARTIFACT_NAME}>
- Do not paste the article body into chat.

Exact markdown file format:
---
title: "..."
date: ${DATE}
description: "..."
tags: ["reflection", "..."]
---

[body]

Daily Review source:
EOF
cat "$SANITIZED_REVIEW" >> "$PROMPT_FILE"

ensure_antigravity || fail_and_notify "Antigravity CDP endpoint unavailable"
run_opencli_step "opencli antigravity status" $OPENCLI_BIN antigravity status -f json >/dev/null 2>&1 || fail_and_notify "opencli antigravity status failed"
run_opencli_step "opencli antigravity new" $OPENCLI_BIN antigravity new -f json >/dev/null 2>&1 || fail_and_notify "opencli antigravity new failed"
switch_model_if_needed || fail_and_notify "opencli antigravity model switch failed"
run_opencli_step "opencli antigravity send" $OPENCLI_BIN antigravity send "$(cat "$PROMPT_FILE")" -f json >/dev/null 2>&1 || fail_and_notify "opencli antigravity send failed"

START_EPOCH="$(date +%s)"
ABSOLUTE_ARTIFACT_PATH=""
for _ in $(seq 1 30); do
  sleep 15
  if $OPENCLI_BIN antigravity read -f json > "$READ_JSON" 2>/dev/null; then
    set +e
    ABSOLUTE_ARTIFACT_PATH="$(python3 - "$READ_JSON" "$RAW_HINTS" <<'PY'
import json, re, sys
from pathlib import Path
p = Path(sys.argv[1])
out = Path(sys.argv[2])
try:
    data = json.loads(p.read_text())
except Exception:
    sys.exit(1)
text = "\n".join(item.get("content", "") for item in data if isinstance(item, dict))
out.write_text(text)
m = re.search(r'ARTIFACT_PATH:\s*(\S+reflection_post\.md)', text)
if not m:
    sys.exit(2)
print(m.group(1))
PY
)"
    status=$?
    set -e
    if [ $status -eq 0 ] && [ -n "$ABSOLUTE_ARTIFACT_PATH" ]; then
      break
    fi
  fi
  CANDIDATE="$(find "$HOME/.gemini/antigravity/brain" -name "$ARTIFACT_NAME" -type f -newermt "@$START_EPOCH" 2>/dev/null | head -1 || true)"
  if [ -n "$CANDIDATE" ] && [ -s "$CANDIDATE" ]; then
    ABSOLUTE_ARTIFACT_PATH="$CANDIDATE"
    break
  fi
done

if [ -z "$ABSOLUTE_ARTIFACT_PATH" ]; then
  CANDIDATE="$(find "$HOME/.gemini/antigravity/brain" -name "$ARTIFACT_NAME" -type f -newermt "@$START_EPOCH" 2>/dev/null | head -1 || true)"
  if [ -n "$CANDIDATE" ] && [ -s "$CANDIDATE" ]; then
    ABSOLUTE_ARTIFACT_PATH="$CANDIDATE"
  fi
fi

if [ -z "$ABSOLUTE_ARTIFACT_PATH" ]; then
  fail_and_notify "antigravity artifact path not found"
fi
if [ ! -s "$ABSOLUTE_ARTIFACT_PATH" ]; then
  fail_and_notify "antigravity artifact missing or empty"
fi

echo "artifact path: $ABSOLUTE_ARTIFACT_PATH"
cp "$ABSOLUTE_ARTIFACT_PATH" "$OUT_FILE"
cp "$OUT_FILE" "$BLOG_FILE"

if ! grep -q '^title:' "$OUT_FILE" || ! grep -q '^date: ' "$OUT_FILE" || ! grep -q '^description:' "$OUT_FILE" || ! grep -q '^tags:' "$OUT_FILE"; then
  fail_and_notify "frontmatter validation failed"
fi

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
- TOOLS.md: When Antigravity exposes a concrete artifact path, prefer file-first retrieval over asking for a chat paste.
- TOOLS.md: Reflection publishing benefits from a two-stage flow: deep draft first, then sanitization / compression / publish finalization.

## Rationale
These are durable workflow improvements beyond a single review day.

## Trace
- Source: $REVIEW_FILE
- Generation: opencli antigravity via ${MODEL_LABEL}
- Artifact: $ABSOLUTE_ARTIFACT_PATH
EOF

echo "building"
npm run build || fail_and_notify "build failed"

git add "$BLOG_FILE" "$IMPROVEMENT_FILE" "$ARTIFACT_DIR/source-review.md" "$SANITIZED_REVIEW" "$OUT_FILE" "$READ_JSON" "$RAW_HINTS"
if git diff --cached --quiet; then
  echo "no staged diff after generation"
  exit 0
fi

git commit -m "feat: publish ${DATE} reflection" || fail_and_notify "git commit failed"
git push origin HEAD || fail_and_notify "git push failed"

rm -f "$FAIL_FLAG"
if [ ! -f "$SUCCESS_FLAG" ]; then
  if notify "magma-blog 自动发布已恢复（${DATE}）\n- 状态：发布成功\n- 后续同日期不会再重试。"; then
    : > "$SUCCESS_FLAG"
    echo "success notification sent"
  else
    echo "success notification failed"
  fi
fi

echo "[$(date '+%F %T')] DONE date=$DATE"
