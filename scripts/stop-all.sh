#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
COMPOSE_FILE="$ROOT_DIR/docker/docker-compose.yml"

echo "Stopping containers and removing network and volumes..."
docker compose -f "$COMPOSE_FILE" down --remove-orphans
