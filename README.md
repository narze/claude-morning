# claude-morning

A lightweight Docker container that runs Claude Code on a daily schedule to keep your Claude subscription session active.

## How it works

- Runs as a persistent container (24/7) via Docker Compose
- A cron job fires `claude -p "ping"` at 8AM daily using Haiku (minimal cost)
- Auth state is persisted in `./data/` so you only log in once
- Logs timestamp and cost to stdout on each run

## Usage

### Option A: Pull from GHCR (recommended)

Create a `docker-compose.yml`:

```yaml
services:
  claude-morning:
    image: ghcr.io/narze/claude-morning:latest
    volumes:
      - claude-data:/root/.claude
    command: daemon
    environment:
      - CLAUDE_MORNING_CRON_SCHEDULE=0 8 * * *
      - CLAUDE_MORNING_TZ=Asia/Bangkok
    restart: unless-stopped

volumes:
  claude-data:
```

Then:

```bash
docker compose up -d
docker compose exec -it claude-morning claude
# log in from within the TUI
```

### Option B: Build from source

```bash
git clone https://github.com/narze/claude-morning
cd claude-morning
docker compose build
docker compose up -d
docker compose exec -it claude-morning claude
# log in from within the TUI
```

## Configuration

| Environment variable         | Default           | Description                     |
|------------------------------|-------------------|---------------------------------|
| `CLAUDE_MORNING_CRON_SCHEDULE`| `0 8 * * *`       | Cron schedule for ping          |
| `CLAUDE_MORNING_TZ`          | (none/UTC)        | Timezone (e.g. `Asia/Bangkok`)  |

## Examples

### Run at 6 AM in Tokyo timezone

```yaml
environment:
  - CLAUDE_MORNING_CRON_SCHEDULE=0 6 * * *
  - CLAUDE_MORNING_TZ=Asia/Tokyo
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

## Development

```bash
git clone https://github.com/narze/claude-morning
cd claude-morning
docker compose build
docker compose up -d

# Test the ping script
docker compose exec claude-morning /scripts/ping.sh --debug
```

## Files

```
Dockerfile            — node:24-alpine + jq + claude-code
entrypoint.sh         — daemon mode runs crond; otherwise passes args to claude
scripts/ping.sh       — runs claude -p "ping" and logs timestamp + cost
scripts/setup-cron.sh — writes crontab from $CLAUDE_MORNING_CRON_SCHEDULE
data/                 — persisted Claude auth state (gitignored)
```
