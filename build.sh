#!/bin/bash
set -e

# ============================
# CONFIG
# ============================
REPO_DIR="$WORKSPACE"
ZIP_FILE="success-project.zip"

DOCKERHUB_USERNAME="chilukurir"
BACKEND_IMAGE="success-project-backend"
FRONTEND_IMAGE="success-project-frontend"

# ============================
# Go to Jenkins workspace
# ============================
cd ${REPO_DIR}

# ============================
# Unzip project
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

# ============================
# Docker Hub Login (non-interactive recommended)
# ============================
docker login

# ============================
# Tag & Push
# ============================
docker tag ${BACKEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker tag ${FRONTEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

docker push ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker push ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

echo "======================================="
echo "✅ BUILD + RUN + PUSH COMPLETED"
echo "======================================="
