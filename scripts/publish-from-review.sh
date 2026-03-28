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
DRAFT_FILE="$ARTIFACT_DIR/antigravity-draft.md"
FINAL_FILE="$ARTIFACT_DIR/final-reflection.md"
FINAL_AGENT_RESULT="$ARTIFACT_DIR/final-agent-result.txt"
FINAL_AGENT_PROMPT="$ARTIFACT_DIR/final-agent-prompt.txt"
FINAL_AGENT_ID="worker-general"

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
    if notify "magma-blog 发布链失败（${DATE}）\n- 原因：${reason}\n- 本轮未完成正式发布。"; then
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
title_iter = list(re.finditer(r'title:\s*"([^"]+)"', text))
real_start = None
for m in reversed(title_iter):
    title = m.group(1).strip()
    if title and title != '...':
        real_start = m.start()
        break
if real_start is None:
    raise SystemExit(2)
chunk = text[real_start:]
flat = re.search(r'title:\s*"(?P<title>[^"]+)"\s+date:\s*(?P<date>\d{4}-\d{2}-\d{2})\s+description:\s*"(?P<desc>[^"]+)"\s+tags:\s*(?P<tags>\[.*?\])\s+(?P<body>.*)', chunk, re.S)
if not flat:
    raise SystemExit(2)
body = flat.group('body')
body = re.sub(r'\n(?:Thinking\.|Copy|Ask anything.*|Planning|Send)\s*$', '', body, flags=re.S).strip()
match = (
    '---\n'
    f'title: "{flat.group("title").strip()}"\n'
    f'date: {flat.group("date").strip()}\n'
    f'description: "{flat.group("desc").strip()}"\n'
    f'tags: {flat.group("tags").strip()}\n'
    '---\n\n'
    + body + '\n'
)
out.write_text(match)
PY
}

antigravity_generate_draft() {
  local prompt_file="$1"
  local read_json="$2"
  local raw_hints="$3"
  local out_file="$4"
  local i
  ensure_antigravity || return 1
  run_opencli_step "opencli antigravity status" $OPENCLI_BIN antigravity status -f json >/dev/null 2>&1 || return 1
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
    fi
  done
  return 1
}

generate_final_via_subagent() {
  local review_file="$1"
  local draft_file="$2"
  local out_file="$3"
  cat > "$FINAL_AGENT_PROMPT" <<EOF
You are writing the FINAL publishable reflection article.

Inputs:
- Review file: $review_file
- Antigravity draft file: $draft_file
- Output file you must write: $out_file
- Date: $DATE

Requirements:
- Read both input files.
- The Antigravity draft is only a rough draft; improve structure, clarity, and precision.
- Produce a clean final article for publication, not notes about the process.
- Use first-person voice.
- 500-900 words.
- Remove private identifiers, handles, email addresses, and overly specific personal traces.
- Focus on durable workflow / judgment / system / engineering lessons.
- End with an unresolved tension, not a neat conclusion.
- Write valid markdown with valid YAML frontmatter in this exact shape:
---
title: "..."
date: $DATE
description: "..."
tags:
  - reflection
  - ...
---

[body]

Do not print the article to stdout. Write it to $out_file and then print exactly one line:
FINAL_WRITTEN
EOF
  python3 - "$REPO" "$FINAL_AGENT_PROMPT" "$FINAL_AGENT_RESULT" <<'PY'
from pathlib import Path
import subprocess, sys
repo = Path(sys.argv[1])
prompt_file = Path(sys.argv[2])
result_file = Path(sys.argv[3])
prompt = prompt_file.read_text()
cmd = [
    '/Users/lab/.local/bin/openclaw',
    'sessions', 'spawn',
    '--runtime', 'subagent',
    '--agent', 'worker-general',
    '--mode', 'run',
    '--cwd', str(repo),
    '--task', prompt,
]
p = subprocess.run(cmd, capture_output=True, text=True)
result_file.write_text((p.stdout or '') + '\n' + (p.stderr or ''))
raise SystemExit(p.returncode)
PY
  grep -q 'FINAL_WRITTEN' "$FINAL_AGENT_RESULT" || return 1
  [ -s "$out_file" ] || return 1
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
rm -f "$READ_JSON" "$RAW_HINTS" "$DRAFT_FILE" "$FINAL_FILE" "$FINAL_AGENT_RESULT" "$FINAL_AGENT_PROMPT"

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

notify "magma-blog 草稿已生成（${DATE}）\n- Antigravity draft 已保存到 artifacts/${DATE}/antigravity-draft.md\n- 现在自动触发智能体终稿生成。"

if ! generate_final_via_subagent "$SANITIZED_REVIEW" "$DRAFT_FILE" "$FINAL_FILE"; then
  fail_and_notify "subagent final reflection generation failed"
fi

cp "$FINAL_FILE" "$BLOG_FILE"

if ! grep -q '^title:' "$FINAL_FILE" || ! grep -q '^date: ' "$FINAL_FILE" || ! grep -q '^description:' "$FINAL_FILE" || ! grep -q '^tags:' "$FINAL_FILE"; then
  fail_and_notify "final reflection frontmatter validation failed"
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
- TOOLS.md: Antigravity is a draft source, not the final publication authority.
- TOOLS.md: Final publishable reflection content is generated by a second intelligent authoring stage before scripted release.

## Rationale
The pipeline now separates exploratory drafting from final publication writing, while keeping release steps deterministic and fully automated.

## Trace
- Source: $REVIEW_FILE
- Draft: $DRAFT_FILE
- Final: $FINAL_FILE
- Final agent: $FINAL_AGENT_ID
EOF

echo "building"
npm run build || fail_and_notify "build failed"

git add "$BLOG_FILE" "$IMPROVEMENT_FILE" "$ARTIFACT_DIR/source-review.md" "$SANITIZED_REVIEW" "$DRAFT_FILE" "$FINAL_FILE" "$FINAL_AGENT_PROMPT" "$FINAL_AGENT_RESULT"
[ -f "$READ_JSON" ] && git add "$READ_JSON"
[ -f "$RAW_HINTS" ] && git add "$RAW_HINTS"
if git diff --cached --quiet; then
  echo "no staged diff after generation"
  exit 0
fi

git commit -m "feat: publish ${DATE} reflection" || fail_and_notify "git commit failed"
git push origin HEAD || fail_and_notify "git push failed"

rm -f "$FAIL_FLAG"
if [ ! -f "$SUCCESS_FLAG" ]; then
  if notify "magma-blog 自动发布已完成（${DATE}）\n- 状态：正式稿已发布\n- 流程：Antigravity 草稿 → subagent 终稿生成 → 脚本发布\n- 后续同日期不会再重试。"; then
    : > "$SUCCESS_FLAG"
    echo "success notification sent"
  else
    echo "success notification failed"
  fi
fi

echo "[$(date '+%F %T')] DONE date=$DATE"
