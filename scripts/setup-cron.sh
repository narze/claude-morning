#!/bin/sh
SCHEDULE="${CLAUDE_CRON_SCHEDULE:-0 */5 * * *}"
echo "$SCHEDULE /scripts/ping.sh >> /var/log/claude-ping.log 2>&1" > /etc/crontabs/root
echo "Cron configured: $SCHEDULE"
