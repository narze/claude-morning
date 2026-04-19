# claude-morning

A lightweight Docker container that runs Claude Code on a daily schedule to keep your Claude subscription session active.

## How it works

- Runs as a persistent container (24/7) via Docker Compose
- A cron job fires `claude -p "ping"` at 8AM daily using Haiku (minimal cost)
- Auth state is persisted in `./data/` so you only log in once
- Logs timestamp and cost to stdout on each run

## Setup

### 1. Build the image

```bash
docker compose build
```

### 2. Authenticate

Start the container, then exec in to log in via Claude's TUI:

```bash
docker compose up -d
docker compose exec -it claude-morning claude
```

Login from within the TUI. Credentials are saved to `./data/` and persist across restarts.

### 3. Done

The container will run the ping script at 8AM daily.

## Configuration

| Environment variable   | Default        | Description           |
|------------------------|----------------|-----------------------|
| `CLAUDE_CRON_SCHEDULE` | `0 8 * * *`    | Cron schedule for ping |

Override in `docker-compose.yml` or at runtime:

```bash
CLAUDE_CRON_SCHEDULE="0 9 * * *" docker compose up -d
```

## Useful commands

```bash
# Check cron is configured correctly
docker compose exec claude-morning cat /etc/crontabs/root

# Tail the ping log
docker compose exec claude-morning tail -f /var/log/claude-ping.log

# Run ping manually
docker compose exec claude-morning /scripts/ping.sh

# Run ping with full JSON output
docker compose exec claude-morning /scripts/ping.sh --debug

# Re-authenticate
docker compose exec -it claude-morning claude
```

## Files

```
Dockerfile          — node:24-alpine + jq + claude-code
entrypoint.sh       — daemon mode runs crond; otherwise passes args to claude
scripts/ping.sh     — runs claude -p "ping" and logs timestamp + cost
scripts/setup-cron.sh — writes crontab from $CLAUDE_CRON_SCHEDULE
data/               — persisted Claude auth state (gitignored)
```
