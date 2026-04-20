#!/bin/sh
if [ "$CLAUDE_MORNING_TZ" != "" ]; then
  export TZ="$CLAUDE_MORNING_TZ"
  echo "Timezone set to: $TZ"
fi
if [ "$1" = "daemon" ]; then
  /scripts/setup-cron.sh
  exec crond -f -l 8
else
  exec claude "$@"
fi
