#!/bin/bash
set -e

# ============================
# CONFIG
# ============================
ZIP_FILE="success-project.zip"
STACK_NAME="success-project"
NETWORK_NAME="success-overlay"

BACKEND_IMAGE="success-project-backend"
FRONTEND_IMAGE="success-project-frontend"

# ============================
# Move to script directory
# ============================
cd "$(dirname "$0")"

# ============================
# Unzip Project
# ============================
unzip -o "$ZIP_FILE"
cd success-project

# ============================
# Docker Login
# ============================
if [ -z "$DOCKERHUB_USERNAME" ] || [ -z "$DOCKERHUB_TOKEN" ]; then
  echo "❌ DOCKERHUB_USERNAME or DOCKERHUB_TOKEN not set"
  exit 1
fi

echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

# ============================
# Create Overlay Network (if not exists)
# ============================
if ! docker network ls | grep -w "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "🔧 Creating overlay network: $NETWORK_NAME"
  docker network create --driver overlay --attachable "$NETWORK_NAME"
else
  echo "✅ Overlay network already exists: $NETWORK_NAME"
fi

# ============================
# Build Docker Images
# ============================
docker compose build

# ============================
# Tag Images
# ============================
docker tag ${BACKEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker tag ${FRONTEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

# ============================
# Push Images
# ============================
docker push ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker push ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

# ============================
# Deploy Stack
# ============================
docker stack deploy -c docker-compose.yml $STACK_NAME

# ============================
# Status
# ============================
echo "======================================="
echo "✅ Docker Swarm Deployment Completed"
echo "Network : $NETWORK_NAME"
echo "Stack   : $STACK_NAME"
echo "======================================="

docker service ls
