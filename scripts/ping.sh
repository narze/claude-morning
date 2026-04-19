#!/bin/sh

OUTPUT=$(CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS=1 CLAUDE_CODE_DISABLE_CLAUDE_MDS=1 CLAUDE_CODE_DISABLE_THINKING=1 ENABLE_CLAUDEAI_MCP_SERVERS=false CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-3-5 claude -p "ping" --model haiku --system-prompt "" --tools "" --disable-slash-commands --output-format json --setting-sources "")
COST=$(echo "$OUTPUT" | grep -o '"total_cost_usd":[0-9.]*' | cut -d: -f2)
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") cost=$COST"
