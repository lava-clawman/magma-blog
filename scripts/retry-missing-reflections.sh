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
ORCH="$REPO/scripts/orchestrate-reflection-finalization.py"
LOCK_DIR="$REPO/.locks"
mkdir -p "$LOCK_DIR"

SELF_MARKER="retry-missing-reflections.sh"
cleanup_lock=''
cleanup_trap() {
  if [ -n "$cleanup_lock" ]; then
    rm -f "$cleanup_lock"
    cleanup_lock=''
  fi
}
trap cleanup_trap EXIT INT TERM HUP

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
  cleanup_lock="$lock_file"
  return 0
}

run_publish_stage() {
  local date="$1"
  local review_file="$REVIEWS_DIR/Daily-Review-${date}.md"
  local blog_file="$REPO/src/content/blog/${date}-reflection.md"
  local artifact_dir="$REPO/artifacts/${date}"
  local draft_ready="$artifact_dir/draft-ready.json"
  local draft_file="$artifact_dir/antigravity-draft.md"
  local final_file="$artifact_dir/final-reflection.md"
  local success_flag="$artifact_dir/.success-notified"
  local publish_done="$artifact_dir/publish-complete.json"
  local login_required_flag="$artifact_dir/claude-login-required.json"
  local stage_lock="$LOCK_DIR/retry-${date}.lock"
  local publish_lock="$LOCK_DIR/publish-${date}.lock"
  local orchestrate_lock="$LOCK_DIR/orchestrate-${date}.lock"

  if [ ! -f "$review_file" ]; then
    return 1
  fi

  # The blog file is written before dependency install/build/git push. Its
  # presence only means the publish attempt reached the staging step, not that
  # publication completed. Only durable completion markers stop retries.
  if [ -f "$success_flag" ] || [ -f "$publish_done" ]; then
    return 1
  fi

  if [ -f "$login_required_flag" ]; then
    local auth_file="$artifact_dir/claude-auth-status.txt"
    local auth_rc=0
    set +e
    claude auth status --text > "$auth_file" 2>&1
    auth_rc=$?
    set -e
    # Claude CLI may exit 0 for an expired login, so require the explicit
    # authenticated status line before clearing the circuit-breaker marker.
    if [ "$auth_rc" -ne 0 ] || ! grep -Eiq '^Login method:' "$auth_file"; then
      echo "login required for $date, skipping blind retry until Claude auth is restored"
      return 1
    fi
    echo "Claude auth restored for $date; clearing login-required marker"
    rm -f "$login_required_flag"
  fi

  if [ -e "$publish_lock" ]; then
    local publish_pid="$(read_lock_pid "$publish_lock")"
    local publish_marker="$(read_lock_marker "$publish_lock")"
    if lock_matches_owner "$publish_pid" "$publish_marker"; then
      echo "publish lock exists for $date, skipping (pid=$publish_pid marker=$publish_marker)"
      return 1
    fi
    echo "removing stale publish lock for $date"
    rm -f "$publish_lock"
  fi

  if [ -e "$orchestrate_lock" ]; then
    local orchestrate_pid="$(read_lock_pid "$orchestrate_lock")"
    local orchestrate_marker="$(read_lock_marker "$orchestrate_lock")"
    if lock_matches_owner "$orchestrate_pid" "$orchestrate_marker"; then
      echo "orchestrate lock exists for $date, skipping (pid=$orchestrate_pid marker=$orchestrate_marker)"
      return 1
    fi
    echo "removing stale orchestrate lock for $date"
    rm -f "$orchestrate_lock"
  fi

  if ! acquire_lock "$stage_lock" "$SELF_MARKER"; then
    echo "retry lock exists for $date, skipping"
    return 1
  fi

  if [ -f "$final_file" ] || { [ -f "$draft_ready" ] && [ -f "$draft_file" ]; }; then
    /usr/bin/python3 "$ORCH" "$date"
    cleanup_trap
    return 0
  fi

  "$REPO/scripts/publish-from-review.sh" "$date"
  cleanup_trap
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
