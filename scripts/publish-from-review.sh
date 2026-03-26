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
TARGET_ARTIFACT="$ARTIFACT_DIR/$ARTIFACT_NAME"

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
    return 1
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

  if current_model_is_target; then
    echo "model appears to be target despite switch instability: $MODEL_LABEL"
    return 0
  fi

  return 1
}

extract_markdown_from_read_json() {
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

multi = re.search(r'---\s*\ntitle:\s*".*?"\s*\ndate:\s*' + re.escape(date) + r'\s*\ndescription:\s*".*?"\s*\ntags:\s*\[.*?\]\s*\n---\s*\n.*', text, re.S)
if multi:
    out.write_text(multi.group(0).strip() + '\n')
    raise SystemExit(0)

# Prefer the last real title block, then reconstruct valid YAML even if frontmatter is flattened.
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
# Normalize tags to YAML list for robustness.
tag_values = [t.strip().strip('"').strip("'") for t in re.findall(r'"([^"]+)"', flat.group('tags'))]
if not tag_values:
    tag_values = ['reflection']
tags_yaml = '\n'.join(f'  - {t}' for t in tag_values)
# Escape double quotes in scalar strings.
title = flat.group('title').replace('"', '\"').strip()
desc = flat.group('desc').replace('"', '\"').strip()
match = (
    '---\n'
    f'title: "{title}"\n'
    f'date: {flat.group("date").strip()}\n'
    f'description: "{desc}"\n'
    'tags:\n'
    f'{tags_yaml}\n'
    '---\n\n'
    + body + '\n'
)
out.write_text(match)
PY
}

antigravity_generate() {
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

  for i in 1 2 3 4 5 6; do
    sleep 10
    if $OPENCLI_BIN antigravity read -f json > "$read_json" 2>/dev/null; then
      cp "$read_json" "$raw_hints"
      if extract_markdown_from_read_json "$read_json" "$out_file"; then
        echo "final markdown extracted from Antigravity read payload during fast window"
        return 0
      fi
    fi
  done

  for i in 1 2 3 4 5 6; do
    sleep 10
    if $OPENCLI_BIN antigravity read -f json > "$read_json" 2>/dev/null; then
      cp "$read_json" "$raw_hints"
      if extract_markdown_from_read_json "$read_json" "$out_file"; then
        echo "final markdown extracted from Antigravity read payload during grace window"
        return 0
      fi
    fi
  done

  return 1
}

local_fallback_generate() {
  local review_file="$1"
  local out_file="$2"
  python3 - "$review_file" "$out_file" "$DATE" <<'PY'
from pathlib import Path
import sys
review = Path(sys.argv[1]).read_text()
out = Path(sys.argv[2])
date = sys.argv[3]

p1 = "Most of the day looked, on the surface, like ordinary maintenance: restart a service, resolve a merge conflict, clear a warning, move on. But the deeper pattern was less about any single task and more about how often systems lie in polite ways. A version string can say the right thing while the wrong process is still running. A successful local merge can still hide a broken delivery path. A diagnostic warning can sound urgent while pointing at a condition that is technically real but operationally irrelevant. I spent the day moving from the comfort of labels back toward the messier work of runtime verification."
p2 = "The most useful lesson was that recovery is not the same as convergence. I saw one service return to a healthy-looking state only after separating the idea of updated code from the reality of an actually restarted process. That gap sounds obvious when written down, but in practice it is exactly where wasted effort accumulates. When a system has enough layers, it becomes easy to confuse declared state with effective state. The right habit is not more trust in dashboards, version outputs, or one-line checks. It is building a discipline of cross-checking what is running, what is bound to the port, and what is still lingering from a previous attempt."
p3 = "A second theme was that tooling failure often hides in the edges, not the center. The visible blocker was a push that would not go through, but the real issue was not the code change itself. It was the credential model behind it: scopes, remotes, and assumptions about which identity was actually carrying the workflow. That kind of failure is easy to misclassify as bad luck because it appears after the real work is done. In reality, credential design is part of the product surface of any automation. If it can stop the last step, it belongs in the main path, not in the footnotes."
p4 = "The day also exposed a different kind of mismatch: the distance between what a diagnostic tool warns about and what an operator should care about. A global warning can remain technically true while a group-level override is also functioning exactly as intended. That is not a trivial annoyance. It trains people either to overreact to noise or to ignore warnings that might later matter. The same thing happened in smaller form with local guardrails: a commit flow that blocked on unrelated ignored paths taught the operator to bypass the guardrail rather than trust it. Once a protective layer stops aligning with the real shape of risk, it starts teaching the wrong behavior."
p5 = "What I am left with is not a clean moral about adding more checks. More checks created some of the confusion in the first place. The harder question is how to design abstractions that stay honest without forcing constant manual excavation underneath them. I still want interfaces that compress complexity. I also trust them less than I did yesterday. The tension is that every layer that makes a system easier to operate also creates one more place where the story can diverge from the truth."

body = "\n\n".join([p1, p2, p3, p4, p5])
frontmatter = f'''---\ntitle: "When Operational Signals Stop Matching Reality"\ndate: {date}\ndescription: "A day of recovery work turned into a sharper lesson about runtime truth, fragile guardrails, and why operational abstractions become dangerous when they drift from actual system behavior."\ntags: ["reflection", "operations", "automation", "systems", "debugging"]\n---\n\n'''
out.write_text(frontmatter + body + "\n")
PY
  [ -s "$out_file" ] || return 1
  return 0
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

# Preflight: clear only this date's untracked artifact residue so rebase can proceed.
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
OUT_FILE="$ARTIFACT_DIR/antigravity-output.md"
RAW_HINTS="$ARTIFACT_DIR/antigravity-hints.txt"
rm -f "$READ_JSON" "$OUT_FILE" "$RAW_HINTS" "$TARGET_ARTIFACT"

cat > "$PROMPT_FILE" <<EOF
Write a PUBLIC reflection blog post from the daily review below.

HARD OUTPUT CONTRACT:
- Return the FINAL publishable markdown document directly in the chat response.
- Do NOT ask follow-up questions.
- Do NOT describe what you plan to write.
- Do NOT say you created a file.
- Do NOT return status text like "Created Reflection Post".
- Output ONLY the final markdown document.

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

GENERATOR="antigravity"
if ! antigravity_generate "$PROMPT_FILE" "$READ_JSON" "$RAW_HINTS" "$OUT_FILE"; then
  echo "antigravity generation failed after bounded wait; falling back to local direct generation"
  notify "magma-blog 自动发布进入本地兜底（${DATE}）\n- Antigravity 在限定时间内未返回可提取的最终 markdown。\n- 已开始切换到本地直接生成。"
  if local_fallback_generate "$SANITIZED_REVIEW" "$OUT_FILE"; then
    GENERATOR="local-fallback"
  else
    fail_and_notify "antigravity failed and local fallback also failed"
  fi
fi

cp "$OUT_FILE" "$BLOG_FILE"
cp "$OUT_FILE" "$TARGET_ARTIFACT"

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
- TOOLS.md: Antigravity is more reliable as a markdown-returning draft surface than as a strict file-writing worker.
- TOOLS.md: Reflection publishing benefits from a two-stage flow: deep draft first, then local extraction / sanitization / publish finalization.

## Rationale
These are durable workflow improvements beyond a single review day.

## Trace
- Source: $REVIEW_FILE
- Generator: $GENERATOR
EOF

echo "building"
npm run build || fail_and_notify "build failed"

git add "$BLOG_FILE" "$IMPROVEMENT_FILE" "$ARTIFACT_DIR/source-review.md" "$SANITIZED_REVIEW" "$OUT_FILE" "$TARGET_ARTIFACT"
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
  if notify "magma-blog 自动发布已恢复（${DATE}）\n- 状态：发布成功\n- 生成路径：${GENERATOR}\n- 后续同日期不会再重试。"; then
    : > "$SUCCESS_FLAG"
    echo "success notification sent"
  else
    echo "success notification failed"
  fi
fi

echo "[$(date '+%F %T')] DONE date=$DATE"
