#!/usr/bin/env bash
set -euo pipefail

PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
HOME=/Users/lab
DAILY_LINE='30 6 * * * PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin HOME=/Users/lab /Users/lab/Flash-Claude/projects/magma-blog/scripts/publish-from-review.sh >/tmp/magma-blog-cron.log 2>&1'
RETRY_LINE='35 * * * * PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin HOME=/Users/lab /Users/lab/Flash-Claude/projects/magma-blog/scripts/retry-missing-reflections.sh >/tmp/magma-blog-retry.log 2>&1'

TMP="$(mktemp)"
crontab -l 2>/dev/null | grep -v 'magma-blog/scripts/publish-from-review.sh' | grep -v 'magma-blog/scripts/retry-missing-reflections.sh' > "$TMP" || true
echo "$DAILY_LINE" >> "$TMP"
echo "$RETRY_LINE" >> "$TMP"
crontab "$TMP"
rm -f "$TMP"

echo "Installed cron lines:"
crontab -l | grep 'magma-blog/scripts/'
echo "Generator path: Antigravity / Claude Opus 4.6 via opencli"
