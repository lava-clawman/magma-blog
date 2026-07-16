#!/usr/bin/env bash
set -euo pipefail

PATH=/Users/lab/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
HOME=/Users/lab

running_under_cron() {
  local pid="$$"
  local parent=''
  local comm=''
  while [ -n "$pid" ] && [ "$pid" != "1" ]; do
    parent="$(ps -p "$pid" -o ppid= 2>/dev/null | tr -d ' ')"
    comm="$(ps -p "$pid" -o comm= 2>/dev/null || true)"
    case "$comm" in
      */cron|cron|*/crond|crond)
        return 0
        ;;
    esac
    pid="$parent"
  done
  return 1
}

if [ "${MAGMA_BLOG_ALLOW_CRON:-}" != "1" ] && running_under_cron; then
  echo "magma-blog scheduler migrated from cron to LaunchAgent; cron invocation skipped"
  exit 0
fi

REPO="$HOME/Flash-Claude/projects/magma-blog"
REVIEWS_DIR="$HOME/Flash-Claude/FlashNotes/reviews"
LOG_DIR="$REPO/logs"
LOCK_DIR="$REPO/.locks"
OPENCLAW_BIN="/Users/lab/.local/bin/openclaw"
ORCH_SCRIPT="$REPO/scripts/orchestrate-reflection-finalization.py"
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
FINAL_FILE="$ARTIFACT_DIR/final-reflection.md"
PUBLISH_DONE_FLAG="$ARTIFACT_DIR/publish-complete.json"
LOGIN_REQUIRED_FLAG="$ARTIFACT_DIR/claude-login-required.json"
LAST_DRAFT_STATUS="unknown"
DRAFT_AGENT_SESSION="draft-${DATE}"
SELF_MARKER="publish-from-review.sh"

read_lock_pid() {
  local lock_file="$1"
  head -n 1 "$lock_file" 2>/dev/null | tr -dc '0-9'
}

read_lock_marker() {
  local lock_file="$1"
  sed -n '2p' "$lock_file" 2>/dev/null
}

lock_matches_owner() {
  local pid="$1"
  local marker="$2"
  [ -n "$pid" ] || return 1
  [ -n "$marker" ] || return 1
  kill -0 "$pid" 2>/dev/null || return 1
  ps -p "$pid" -o command= 2>/dev/null | grep -F "$marker" >/dev/null
}

acquire_lock() {
  local lock_file="$1"
  local marker="$2"
  local pid=''
  local old_marker=''

  if [ -e "$lock_file" ]; then
    pid="$(read_lock_pid "$lock_file")"
    old_marker="$(read_lock_marker "$lock_file")"
    if lock_matches_owner "$pid" "$old_marker"; then
      echo "active lock exists: $lock_file (pid=$pid marker=$old_marker)"
      return 1
    fi
    echo "removing stale lock: $lock_file${pid:+ (pid=$pid marker=${old_marker:-unknown})}"
    rm -f "$lock_file"
  fi

  {
    printf '%s\n' "$$"
    printf '%s\n' "$marker"
  } > "$lock_file"
  return 0
}

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

write_login_required_state() {
  local detail="${1:-Claude CLI auth status failed}"
  python3 - "$LOGIN_REQUIRED_FLAG" "$DATE" "$detail" <<'PY'
import json, sys
from pathlib import Path
path, date, detail = sys.argv[1:4]
Path(path).write_text(json.dumps({
    'date': date,
    'stage': 'login_required',
    'detail': detail,
}, indent=2) + '\n')
PY
}

claude_auth_ready() {
  local auth_file="$ARTIFACT_DIR/claude-auth-status.txt"
  local rc=0
  set +e
  claude auth status --text > "$auth_file" 2>&1
  rc=$?
  set -e
  # Claude CLI can return exit code 0 even when the saved login is expired.
  # Treat the human-readable status as authoritative and require the known
  # authenticated form rather than trusting the process exit code alone.
  if [ "$rc" -eq 0 ] && grep -Eiq '^Login method:' "$auth_file"; then
    rm -f "$LOGIN_REQUIRED_FLAG"
    return 0
  fi
  LAST_DRAFT_STATUS="login_required"
  write_login_required_state "$(head -n 20 "$auth_file" 2>/dev/null | tr '\n' ' ' | sed 's/  */ /g' | sed 's/^ *//; s/ *$//')"
  return 1
}

fail_and_notify() {
  local reason="$1"
  echo "$reason"
  mkdir -p "$ARTIFACT_DIR"
  if [ ! -f "$FAIL_FLAG" ]; then
    local extra="- 尚未进入终稿与发布阶段。"
    case "$LAST_DRAFT_STATUS" in
      login_required)
        extra="- 真实原因：Claude CLI 登录已失效，需要重新登录。\n- 自动恢复：每小时检查一次认证状态；认证恢复前暂停草稿重试，恢复后自动继续。\n- 尚未进入终稿与发布阶段。"
        ;;
      command_failed)
        extra="- 真实原因：Claude CLI 命令执行失败。\n- 自动恢复：后续每小时重试一次。\n- 尚未进入终稿与发布阶段。"
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

  if grep -qi 'Not logged in .*Please run /login' "$err_file" 2>/dev/null; then
    LAST_DRAFT_STATUS="login_required"
    return 1
  fi

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

if ! acquire_lock "$LOCK_FILE" "$SELF_MARKER"; then
  exit 0
fi
trap 'rm -f "$LOCK_FILE"' EXIT INT TERM HUP

if [ ! -f "$REVIEW_FILE" ]; then
  echo "review missing: $REVIEW_FILE"
  exit 0
fi

cd "$REPO"

if [ -f "$PUBLISH_DONE_FLAG" ] || [ -f "$BLOG_FILE" ]; then
  echo "publish already complete for $DATE, skipping"
  exit 0
fi

mkdir -p "$ARTIFACT_DIR"

if [ -f "$DRAFT_READY_FLAG" ] && [ -s "$DRAFT_FILE" ]; then
  echo "existing draft-ready state found for $DATE; preserving and invoking orchestrator"
  /usr/bin/python3 "$ORCH_SCRIPT" "$DATE"
  exit $?
fi

if [ -s "$FINAL_FILE" ]; then
  echo "existing final draft found for $DATE; invoking orchestrator"
  /usr/bin/python3 "$ORCH_SCRIPT" "$DATE"
  exit $?
fi

if git ls-files --error-unmatch "$BLOG_FILE" >/dev/null 2>&1; then
  echo "blog already tracked for $DATE, skipping"
  exit 0
fi

echo "git sync preflight"
git pull --rebase origin main || fail_and_notify "git pull --rebase preflight failed"

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
rm -f "$DRAFT_FILE"

if ! claude_auth_ready; then
  fail_and_notify "Claude Code auth preflight failed"
fi

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

rm -f "$LOGIN_REQUIRED_FLAG"

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

notify "magma-blog 草稿已生成（${DATE}）\n- Draft: artifacts/${DATE}/antigravity-draft.md\n- 已写入 draft-ready.json，继续进入终稿与发布编排。"

echo "draft stage complete; invoking orchestration layer"
/usr/bin/python3 "$ORCH_SCRIPT" "$DATE"
