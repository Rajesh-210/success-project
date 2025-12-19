#!/bin/bash
set -e

# ============================
# CONFIGURATION
# ============================
DOCKERHUB_USERNAME="chilukurir"
BACKEND_IMAGE="success-project-backend"
FRONTEND_IMAGE="success-project-frontend"

APP_DIR="/home/ubuntu/success-project-runtime"

# ============================
# Update & install packages
# ============================
sudo apt update -y
sudo apt install -y curl

# ============================
# Install Docker (if not exists)
# ============================
if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com | sudo bash
  sudo usermod -aG docker $USER
fi

# ============================
# Install Docker Compose
# ============================
if ! command -v docker-compose &> /dev/null; then
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

# ============================
# Create app directory
# ============================
mkdir -p ${APP_DIR}
cd ${APP_DIR}

# ============================
# Docker Hub login
# ============================
docker login

# ============================
# Pull images
# ============================
docker pull ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
docker pull ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest

# ============================
# Stop old containers
# ============================
docker compose down || true

# ============================
# Create docker-compose.yml
# ============================
cat <<EOF > docker-compose.yml
services:
  mysql:
    image: mysql:8
    container_name: urban_mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: myuccc_db_final
    volumes:
      - mysql_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-proot"]
      interval: 10s
      timeout: 5s
      retries: 10

  backend:
    image: ${DOCKERHUB_USERNAME}/${BACKEND_IMAGE}:latest
    container_name: urban_backend
    restart: always
    depends_on:
      mysql:
        condition: service_healthy
    environment:
      SPRING_PROFILES_ACTIVE: prod
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/myuccc_db_final
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: root
    ports:
      - "8080:8080"

  frontend:
    image: ${DOCKERHUB_USERNAME}/${FRONTEND_IMAGE}:latest
    container_name: urban_frontend
    restart: always
    depends_on:
      - backend
    ports:
      - "80:80"

volumes:
  mysql_data:
EOF

# ============================
# Run containers
# ============================
docker compose up -d

echo "======================================="
echo "✅ DEPLOYMENT SUCCESSFUL"
echo "Frontend: http://<EC2_PUBLIC_IP>"
echo "Backend : http://<EC2_PUBLIC_IP>:8080"
echo "======================================="
