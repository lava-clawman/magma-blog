#!/usr/bin/env bash
set -euo pipefail

PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
HOME=/Users/lab
CRON_LINE='30 6 * * * PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin HOME=/Users/lab /Users/lab/Flash-Claude/projects/magma-blog/scripts/publish-from-review.sh >/tmp/magma-blog-cron.log 2>&1'

TMP="$(mktemp)"
crontab -l 2>/dev/null | grep -v 'magma-blog/scripts/publish-from-review.sh' > "$TMP" || true
echo "$CRON_LINE" >> "$TMP"
crontab "$TMP"
rm -f "$TMP"

echo "Installed cron:"
crontab -l | grep 'magma-blog/scripts/publish-from-review.sh'
