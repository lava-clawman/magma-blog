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
WORKSPACE_NAME="magma-blog"
WORKSPACE_HELPER="$REPO/scripts/antigravity-open-workspace.py"
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
MODEL_LABEL="Claude Opus 4.6 (Thinking)"
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

restart_antigravity() {
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
    return 1
  fi
  "$ANTIGRAVITY_APP" --remote-debugging-port=9224 >/tmp/antigravity-opencli.log 2>&1 &
  sleep 8
  if curl -fsS "$OPENCLI_CDP_ENDPOINT/json/version" >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

ensure_workspace_page() {
  local status_json title workspace_target
  status_json="$($OPENCLI_BIN antigravity status -f json 2>/dev/null || true)"
  title="$(printf '%s' "$status_json" | python3 - <<'PY'
import json,sys
raw=sys.stdin.read().strip()
if not raw:
    print('')
    raise SystemExit(0)
try:
    print(json.loads(raw).get('title',''))
except Exception:
    print('')
PY
)"

  workspace_target="$(python3 "$WORKSPACE_HELPER" "" "$ARTIFACT_DIR/antigravity-targets.json" 2>/dev/null || true)"
  if [ -n "$workspace_target" ] && [ "$workspace_target" != "NO_MATCH" ]; then
    export OPENCLI_CDP_TARGET="$workspace_target"
    echo "selected existing antigravity workspace target: $workspace_target"
    return 0
  fi

  if [ "$title" = "Launchpad" ]; then
    echo "antigravity is on Launchpad and no existing workspace page is visible; trying to open a recent workspace"
    osascript <<EOF >/dev/null 2>&1 || true
      tell application "Antigravity" to activate
      delay 0.5
      tell application "System Events"
        key code 125
        delay 0.2
        key code 36
      end tell
EOF
    sleep 5
  fi

  workspace_target="$(python3 "$WORKSPACE_HELPER" "" "$ARTIFACT_DIR/antigravity-targets.json" 2>/dev/null || true)"
  if [ -n "$workspace_target" ] && [ "$workspace_target" != "NO_MATCH" ]; then
    export OPENCLI_CDP_TARGET="$workspace_target"
    echo "selected workspace target after Launchpad exit: $workspace_target"
    return 0
  fi

  status_json="$($OPENCLI_BIN antigravity status -f json 2>/dev/null || true)"
  title="$(printf '%s' "$status_json" | python3 - <<'PY'
import json,sys
raw=sys.stdin.read().strip()
if not raw:
    print('')
    raise SystemExit(0)
try:
    print(json.loads(raw).get('title',''))
except Exception:
    print('')
PY
)"
  if [ "$title" != "Launchpad" ] && [ -n "$title" ]; then
    unset OPENCLI_CDP_TARGET
    echo "antigravity already on non-Launchpad page: $title"
    return 0
  fi
  return 1
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
  model_read="$($OPENCLI_BIN antigravity read -f json 2>/dev/null || true)"
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
    current_model_is_target && return 0
  fi
  current_model_is_target
}

extract_draft_from_read_json() {
  local read_json="$1"
  local out_file="$2"
  python3 - "$read_json" "$out_file" "$DATE" <<'PY'
import json, re, sys
from pathlib import Path
p = Path(sys.argv[1])
out = Path(sys.argv[2])
date = sys.argv[3]
try:
    data = json.loads(p.read_text())
except Exception:
    raise SystemExit(1)
text = "\n".join(item.get("content", "") for item in data if isinstance(item, dict))
if 'Our servers are experiencing high traffic right now' in text or 'Agent terminated due to error' in text:
    raise SystemExit(3)
# guard against extracting from the echoed prompt itself
review_marker = f'Daily Review source:# Daily Review {date}'
marker_pos = text.find(review_marker)
if marker_pos != -1:
    search_text = text[marker_pos + len(review_marker):]
else:
    search_text = text
fm_iter = list(re.finditer(r'---\s*title:\s*"([^"]+)"\s*date:\s*(\d{4}-\d{2}-\d{2})\s*description:\s*"([^"]+)"\s*tags:\s*(\[.*?\])', search_text, re.S))
real = None
for m in fm_iter:
    title = m.group(1).strip()
    fm_date = m.group(2).strip()
    if title and title != '...' and fm_date == date:
        real = m
if real is None:
    raise SystemExit(2)
chunk = search_text[real.start():]
end_markers = [
    '\nundo\n',
    '\nThought for ',
    '\nError\n',
    '\nAsk anything, @ to mention, / for workflows',
    '\nPlanning\n',
]
end = len(chunk)
for mk in end_markers:
    pos = chunk.find(mk)
    if pos != -1 and pos < end:
        end = pos
chunk = chunk[:end].strip()
if not chunk.startswith('---'):
    raise SystemExit(2)
if len(chunk.splitlines()) < 8:
    raise SystemExit(2)
out.write_text(chunk.rstrip() + '\n')
PY
}

antigravity_generate_draft() {
  local prompt_file="$1"
  local read_json="$2"
  local raw_hints="$3"
  local out_file="$4"
  local round i rc
  ensure_antigravity || return 1
  run_opencli_step "opencli antigravity status" $OPENCLI_BIN antigravity status -f json >/dev/null 2>&1 || return 1
  ensure_workspace_page || return 1
  for round in 1 2 3; do
    echo "antigravity draft round $round/3"
    run_opencli_step "opencli antigravity new" $OPENCLI_BIN antigravity new -f json >/dev/null 2>&1 || return 1
    switch_model_if_needed || return 1
    run_opencli_step "opencli antigravity send" $OPENCLI_BIN antigravity send "$(cat "$prompt_file")" -f json >/dev/null 2>&1 || return 1
    for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
      sleep 10
      if $OPENCLI_BIN antigravity read -f json > "$read_json" 2>/dev/null; then
        cp "$read_json" "$raw_hints"
        if extract_draft_from_read_json "$read_json" "$out_file"; then
          echo "draft extracted from Antigravity read payload"
          return 0
        fi
        rc=$?
        if [ "$rc" -eq 3 ]; then
          echo "antigravity upstream high-traffic / terminated error detected; retrying round"
          break
        fi
      fi
    done
  done
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
READ_JSON="$ARTIFACT_DIR/antigravity-read.json"
RAW_HINTS="$ARTIFACT_DIR/antigravity-hints.txt"
rm -f "$READ_JSON" "$RAW_HINTS" "$DRAFT_FILE" "$DRAFT_READY_FLAG"

cat > "$PROMPT_FILE" <<EOF
Write a PUBLIC reflection blog post draft from the daily review below.

HARD OUTPUT CONTRACT:
- Return a SINGLE complete markdown draft directly in chat.
- Do NOT ask follow-up questions.
- Do NOT say you created a file.
- Do NOT include planning/status text on purpose.
- The draft may include frontmatter and body.

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

if ! antigravity_generate_draft "$PROMPT_FILE" "$READ_JSON" "$RAW_HINTS" "$DRAFT_FILE"; then
  fail_and_notify "antigravity draft generation failed"
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
