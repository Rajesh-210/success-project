#!/bin/bash
set -e

# ============================
# CONFIG
# ============================
REPO_DIR="$HOME/success-project"
ZIP_FILE="success-project.zip"

DOCKERHUB_USERNAME="chilukurir"
BACKEND_IMAGE="success-project-backend"
FRONTEND_IMAGE="success-project-frontend"

# ============================
# System update & packages
# ============================
sudo apt update -y
sudo apt install -y unzip curl

# ============================
# Install Docker (if missing)
# ============================
if ! command -v docker &>/dev/null; then
  curl -fsSL https://get.docker.com | sudo bash
fi

# ============================
# Install Docker Compose
# ============================
if ! command -v docker-compose &>/dev/null; then
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

# ============================
# Go to project
# ============================
cd ${REPO_DIR}

# ============================
# Unzip project (your exact flow)
# ============================
unzip -o ${ZIP_FILE}
cd success-project

# ============================
# Stop old containers
# ============================
docker compose down || true

# ============================
# Build images
# ============================
docker compose build

# ============================
# Run containers
# ============================
docker compose up -d

echo "✅ Containers are running on this server"

# ============================
# OPTIONAL: Push to Docker Hub
# ============================
docker login

docker tag ${BACKEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker tag ${FRONTEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

docker push ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker push ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

echo "======================================="
echo "✅ BUILD + RUN + PUSH COMPLETED"
echo "Frontend: http://<SERVER_PUBLIC_IP>"
echo "Backend : http://<SERVER_PUBLIC_IP>:8080"
echo "======================================="
