#!/bin/sh
SCHEDULE="${CLAUDE_CRON_SCHEDULE:-0 */5 * * *}"
echo "$SCHEDULE /scripts/ping.sh 2>&1 | tee -a /var/log/claude-ping.log >> /proc/1/fd/1" > /etc/crontabs/root
echo "Cron configured: $SCHEDULE"
