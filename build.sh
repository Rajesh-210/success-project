#!/bin/bash
set -e

# ============================
# CONFIGURATION
# ============================
GIT_REPO_URL="https://github.com/Rajesh-210/success-project.git"
REPO_DIR="success-project"
ZIP_FILE="success-project.zip"

DOCKERHUB_USERNAME="YOUR_DOCKERHUB_USERNAME"
BACKEND_IMAGE="success-project-backend"
FRONTEND_IMAGE="success-project-frontend"

# ============================
# Update & install packages
# ============================
sudo apt update -y
sudo apt install -y git unzip curl

# ============================
# Install Docker (if not exists)
# ============================
if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com | sudo bash
  sudo usermod -aG docker $USER
fi

# ============================
# Install Docker Compose (plugin)
# ============================
if ! command -v docker-compose &> /dev/null; then
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

# ============================
# Clone repository
# ============================
cd ~
rm -rf ${REPO_DIR}
git clone ${GIT_REPO_URL}
cd ${REPO_DIR}

# ============================
# Unzip project (as per your flow)
# ============================
ls
unzip -o ${ZIP_FILE}
cd success-project

# ============================
# Build Docker images
# ============================
docker compose build

# ============================
# Run containers (sanity check)
# ============================
docker compose up -d

echo "✅ Application started on build server (for validation)"

# ============================
# Docker Hub login
# ============================
docker login

# ============================
# Tag images
# ============================
docker tag ${BACKEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker tag ${FRONTEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

# ============================
# Push images
# ============================
docker push ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker push ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

echo "======================================="
echo "✅ BUILD + RUN + PUSH COMPLETED"
echo "======================================="
