#!/bin/bash

# ============================
# EDIT THESE VALUES
# ============================
GIT_REPO_URL="https://github.com/YOUR_USERNAME/YOUR_REPO.git"
REPO_DIR="success-project"
ZIP_FILE="success-project.zip"

DOCKERHUB_USERNAME="YOUR_DOCKERHUB_USERNAME"
BACKEND_IMAGE="success-project-backend"
FRONTEND_IMAGE="success-project-frontend"

# ============================
# Update system
# ============================
sudo apt update -y

# ============================
# Install required packages
# ============================
sudo apt install -y git unzip curl

# ============================
# Install Docker
# ============================
curl -fsSL https://get.docker.com | sudo bash
sudo usermod -aG docker $USER

# ============================
# Install Docker Compose
# ============================
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# ============================
# Go to home directory
# ============================
cd ~

# ============================
# Clone Git repository
# ============================
rm -rf $REPO_DIR
git clone $GIT_REPO_URL

# ============================
# After cloning (your exact steps)
# ============================
cd $REPO_DIR
ls
unzip $ZIP_FILE
cd success-project

# ============================
# Build Docker images
# ============================
docker compose build

# ============================
# RUN containers (IMPORTANT)
# ============================
docker compose up -d

echo "======================================="
echo "✅ APPLICATION IS RUNNING"
echo "Frontend: http://<EC2_PUBLIC_IP>"
echo "Backend : http://<EC2_PUBLIC_IP>:8080"
echo "======================================="

# ============================
# Docker Hub Login
# ============================
docker login

# ============================
# Tag Docker images
# ============================
docker tag ${BACKEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker tag ${FRONTEND_IMAGE}:latest ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

# ============================
# Push images to Docker Hub
# ============================
docker push ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker push ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

echo "======================================="
echo "✅ BUILD + RUN + PUSH COMPLETED"
echo "======================================="
