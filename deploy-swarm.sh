#!/bin/bash
set -e

#############################################
# CONFIGURATION
#############################################
DOCKERHUB_USERNAME="yourdockerhub"     # 🔁 CHANGE THIS
PROJECT_NAME="urban"
STACK_NAME="urban"
NETWORK_NAME="app_net"

BACKEND_IMAGE="$DOCKERHUB_USERNAME/urban-backend"
FRONTEND_IMAGE="$DOCKERHUB_USERNAME/urban-frontend"

BACKEND_DIR="urban_operations_cc"
FRONTEND_DIR="urban_operations_cc_Frontend"

#############################################
# PRE-CHECKS
#############################################
if ! command -v docker &> /dev/null; then
  echo "❌ Docker not installed"
  exit 1
fi

if ! docker info | grep -q "Swarm: active"; then
  echo "❌ Docker Swarm not initialized"
  echo "Run: docker swarm init"
  exit 1
fi

#############################################
# LOGIN TO DOCKER HUB
#############################################
echo "🔐 Logging into Docker Hub..."
docker login || exit 1

#############################################
# BUILD IMAGES
#############################################
echo "🔨 Building backend image..."
docker build -t $BACKEND_IMAGE:latest ./$BACKEND_DIR

echo "🔨 Building frontend image..."
docker build -t $FRONTEND_IMAGE:latest ./$FRONTEND_DIR

#############################################
# PUSH IMAGES
#############################################
echo "🚀 Pushing images to Docker Hub..."
docker push $BACKEND_IMAGE:latest
docker push $FRONTEND_IMAGE:latest

#############################################
# CREATE OVERLAY NETWORK (if not exists)
#############################################
if ! docker network ls | grep -q "$NETWORK_NAME"; then
  echo "🌐 Creating overlay network..."
  docker network create --driver overlay --attachable $NETWORK_NAME
fi

#############################################
# DEPLOY STACK
#############################################
echo "🚀 Deploying Docker Swarm stack..."
docker stack deploy -c docker-compose.yml $STACK_NAME

#############################################
# STATUS
#############################################
echo "===================================="
echo "✅ DEPLOYMENT COMPLETE"
echo "===================================="
docker service ls
