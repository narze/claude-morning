#!/bin/sh
if [ "$1" = "daemon" ]; then
  /scripts/setup-cron.sh
  exec crond -f -l 8
else
  exec claude "$@"
fi
