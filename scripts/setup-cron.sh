#!/bin/sh
SCHEDULES="${CLAUDE_MORNING_CRON_SCHEDULES:-${CLAUDE_MORNING_CRON_SCHEDULE:-0 8 * * *}}"
CRONFILE="/etc/crontabs/root"
> "$CRONFILE"

echo "# Generated crontab" >> "$CRONFILE"
echo "$SCHEDULES" | tr ',' '\n' | while IFS= read -r SCHEDULE; do
  SCHEDULE=$(echo "$SCHEDULE" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  [ -z "$SCHEDULE" ] && continue
  echo "$SCHEDULE /scripts/ping.sh 2>&1 | tee -a /var/log/claude-ping.log >> /proc/1/fd/1" >> "$CRONFILE"
  echo "Cron scheduled: $SCHEDULE" >&2
done