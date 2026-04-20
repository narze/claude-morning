#!/bin/sh

OUTPUT=$(CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS=1 CLAUDE_CODE_DISABLE_CLAUDE_MDS=1 CLAUDE_CODE_DISABLE_THINKING=1 ENABLE_CLAUDEAI_MCP_SERVERS=false CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 claude -p "ping" --model haiku --system-prompt "" --tools "" --disable-slash-commands --output-format json --setting-sources "" 2>/dev/null)
IS_ERROR=$(echo "$OUTPUT" | jq -r '.is_error')
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S%z")

if [ "$IS_ERROR" = "true" ]; then
  API_ERROR=$(echo "$OUTPUT" | jq -r '.api_error_status // "unknown error"')
  echo "$TIMESTAMP ERROR $API_ERROR"
else
  COST=$(echo "$OUTPUT" | jq -r '.total_cost_usd')
  echo "$TIMESTAMP cost=$COST"
fi

if [ "$1" = "--debug" ]; then
  echo "$OUTPUT" | jq .
fi
