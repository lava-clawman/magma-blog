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
LAST_DRAFT_STATUS="unknown"
DRAFT_AGENT_SESSION="draft-${DATE}"

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
    local extra="- 尚未进入终稿与发布阶段。"
    case "$LAST_DRAFT_STATUS" in
      login_required)
        extra="- 真实原因：Claude CLI 返回未登录状态（Not logged in · Please run /login），短重试后仍未恢复。\n- 尚未进入终稿与发布阶段。"
        ;;
      command_failed)
        extra="- 真实原因：Claude CLI 命令执行失败。\n- 尚未进入终稿与发布阶段。"
        ;;
      validation_failed)
        extra="- 真实原因：Claude 已返回输出，但草稿校验未通过。\n- 尚未进入终稿与发布阶段。"
        ;;
    esac
    if notify "magma-blog 草稿阶段失败（${DATE}）\n- 原因：${reason}\n${extra}"; then
      : > "$FAIL_FLAG"
      echo "failure notification sent"
    else
      echo "failure notification failed"
    fi
  fi
  exit 1
}

agent_generate_draft() {
  local prompt_file="$1"
  local out_file="$2"
  local err_file="$ARTIFACT_DIR/claude-draft.stderr.txt"
  local raw_file="$ARTIFACT_DIR/claude-draft.raw.txt"
  local meta_file="$ARTIFACT_DIR/claude-draft.meta.json"
  local validate_log="$ARTIFACT_DIR/claude-draft.validate.txt"
  local result_file="$ARTIFACT_DIR/claude-draft.agent-result.txt"
  local task_file="$ARTIFACT_DIR/claude-draft.agent-task.txt"
  local response_file="$ARTIFACT_DIR/claude-draft.agent-response.txt"
  local status_file="$ARTIFACT_DIR/claude-draft.agent-status.json"
  local rc=0
  LAST_DRAFT_STATUS="unknown"
  rm -f "$err_file" "$raw_file" "$meta_file" "$validate_log" "$result_file" "$task_file" "$response_file" "$status_file" "$out_file"

  cat > "$task_file" <<EOF
In the current working directory, read the prompt file at ${prompt_file}.

Your job is NOT to author the article yourself.
Your job is to invoke Claude Code CLI from inside this agent context so Claude generates the draft.

CRITICAL EXECUTION RULES:
- Use the exec tool to run Claude Code CLI.
- Run Claude in non-interactive print mode, not chat mode.
- Claude must be the component that generates the article text.
- Save Claude's generated markdown draft directly to ${out_file}.
- You may use shell redirection and/or a follow-up write step if needed, but the prose itself must come from Claude CLI output, not from you composing it directly.
- Do NOT ask follow-up questions.

Claude output requirements:
- Valid YAML frontmatter plus body.
- Frontmatter must include:
  - title
  - date: ${DATE}
  - description
  - tags
- Use first-person voice.
- 500-900 words.
- Remove private identifiers, handles, email addresses, and overly specific personal traces.
- Focus on durable workflow / judgment / system / engineering lessons.
- End with an unresolved tension, not a neat conclusion.
- Do NOT include planning notes, status text, or meta-commentary in the saved file.

Suggested Claude command shape:
claude --permission-mode bypassPermissions --print "$(cat ${prompt_file})"

After Claude-generated content has been successfully saved to ${out_file}, reply with exactly: DRAFT_WRITTEN
EOF

  set +e
  "$OPENCLAW_BIN" agent \
    --agent worker-general \
    --session-id "$DRAFT_AGENT_SESSION" \
    --message "$(cat "$task_file")" \
    --timeout 600 \
    --json > "$response_file" 2> "$err_file"
  rc=$?
  set -e

  cp "$response_file" "$result_file" 2>/dev/null || true
  cp "$out_file" "$raw_file" 2>/dev/null || true

  if [ "$rc" -ne 0 ]; then
    LAST_DRAFT_STATUS="command_failed"
    python3 - "$meta_file" "$rc" "$response_file" "$err_file" "$status_file" <<'PY'
import json, sys
from pathlib import Path
meta, rc, outp, errp, statusp = sys.argv[1:6]
out = Path(outp).read_text() if Path(outp).exists() else ''
err = Path(errp).read_text() if Path(errp).exists() else ''
status = {'stage': 'agent_command_failed'}
Path(statusp).write_text(json.dumps(status, indent=2) + '\n')
Path(meta).write_text(json.dumps({
  'stage': 'agent_command_failed',
  'returncode': int(rc),
  'stdout_chars': len(out),
  'stderr_chars': len(err),
  'stdout_head': out[:2000],
  'stderr_head': err[:2000],
}, indent=2) + '\n')
PY
    return 1
  fi

  if [ ! -s "$out_file" ]; then
    LAST_DRAFT_STATUS="command_failed"
    python3 - "$meta_file" "$response_file" "$err_file" "$status_file" <<'PY'
import json, sys
from pathlib import Path
meta, outp, errp, statusp = sys.argv[1:5]
out = Path(outp).read_text() if Path(outp).exists() else ''
err = Path(errp).read_text() if Path(errp).exists() else ''
status = {'stage': 'draft_file_missing'}
Path(statusp).write_text(json.dumps(status, indent=2) + '\n')
Path(meta).write_text(json.dumps({
  'stage': 'draft_file_missing',
  'returncode': 0,
  'stdout_chars': len(out),
  'stderr_chars': len(err),
  'stdout_head': out[:2000],
  'stderr_head': err[:2000],
}, indent=2) + '\n')
PY
    return 1
  fi

  cp "$out_file" "$raw_file" 2>/dev/null || true
  python3 - "$out_file" "$out_file" "$DATE" "$validate_log" <<'PY'
import re, sys
from pathlib import Path
text = Path(sys.argv[1]).read_text()
out  = Path(sys.argv[2])
date = sys.argv[3]
logp = Path(sys.argv[4])
fm_iter = list(re.finditer(
    r'---\s*\ntitle:\s*"([^"]+)"\s*\ndate:\s*(\d{4}-\d{2}-\d{2})\s*\ndescription:\s*"([^"]+)"\s*\ntags:\s*(\[.*?\]|(?:\n\s*- .*?)+)',
    text, re.S,
))
real = None
for m in fm_iter:
    if m.group(1).strip() and m.group(2).strip() == date:
        real = m
        break
if real is None:
    logp.write_text('validation_failed: no matching frontmatter block found\n')
    raise SystemExit(2)
chunk = text[real.start():].strip()
if not chunk.startswith('---'):
    logp.write_text('validation_failed: extracted chunk does not start with frontmatter\n')
    raise SystemExit(2)
if len(chunk.splitlines()) < 8:
    logp.write_text('validation_failed: extracted chunk too short by line count\n')
    raise SystemExit(2)
body = chunk.split('---', 2)[-1]
if len(body.strip()) < 400:
    logp.write_text(f'validation_failed: body too short ({len(body.strip())} chars)\n')
    raise SystemExit(4)
out.write_text(chunk.rstrip() + '\n')
logp.write_text(f'validation_ok: body_chars={len(body.strip())}\n')
PY
  rc=$?
  python3 - "$meta_file" "$rc" "$out_file" "$err_file" "$validate_log" "$response_file" "$status_file" <<'PY'
import json, sys
from pathlib import Path
meta, rc, outp, errp, logp, resp, statusp = sys.argv[1:8]
out = Path(outp).read_text() if Path(outp).exists() else ''
err = Path(errp).read_text() if Path(errp).exists() else ''
log = Path(logp).read_text() if Path(logp).exists() else ''
response = Path(resp).read_text() if Path(resp).exists() else ''
status = {'stage': 'validation_done' if int(rc) == 0 else 'validation_failed'}
Path(statusp).write_text(json.dumps(status, indent=2) + '\n')
Path(meta).write_text(json.dumps({
  'stage': 'validation_done' if int(rc) == 0 else 'validation_failed',
  'returncode': int(rc),
  'draft_chars': len(out),
  'stderr_chars': len(err),
  'agent_response_chars': len(response),
  'draft_head': out[:2000],
  'stderr_head': err[:2000],
  'agent_response_head': response[:2000],
  'validation': log[:2000],
}, indent=2) + '\n')
PY
  if [ "$rc" -eq 0 ]; then
    LAST_DRAFT_STATUS="success"
  else
    LAST_DRAFT_STATUS="validation_failed"
  fi
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

if ! agent_generate_draft "$PROMPT_FILE" "$DRAFT_FILE"; then
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
