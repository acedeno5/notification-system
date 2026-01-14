#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
COMPOSE_FILE="$ROOT_DIR/docker/docker-compose.yml"

echo "Building and starting services using docker-compose..."
docker compose -f "$COMPOSE_FILE" up --build -d

# Wait for producer health
echo "Waiting for notification-producer to become healthy..."
for i in {1..30}; do
  if docker compose -f "$COMPOSE_FILE" exec -T notification-producer /bin/sh -c "curl -fsS http://localhost:8080/api/health" >/dev/null 2>&1; then
    echo "notification-producer is healthy"
    exit 0
  fi
  sleep 2
done

echo "Warning: notification-producer did not report healthy after timeout"
