#!/bin/bash
set -e

# ============================
# CONFIG
# ============================
ZIP_FILE="success-project.zip"
BACKEND_IMAGE="success-project-backend"
FRONTEND_IMAGE="success-project-frontend"

# ============================
# Go to Jenkins workspace
# ============================
cd "$WORKSPACE"

# ============================
# Unzip project
# ============================
unzip -o "$ZIP_FILE"
cd success-project

# ============================
# Stop existing containers
# ============================
docker compose down || true

# ============================
# Build & Run
# ============================
docker compose build
docker compose up -d

# ============================
# Docker login (NON-INTERACTIVE)
# ============================
echo "$DOCKERHUB_TOKEN" | docker login \
  -u "$DOCKERHUB_USERNAME" \
  --password-stdin

# ============================
# Tag & Push images
# ============================
docker tag ${BACKEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest1
docker tag ${FRONTEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest1

docker push ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest1
docker push ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest1

echo "======================================="
echo "✅ BUILD + RUN + PUSH COMPLETED"
echo "======================================="
