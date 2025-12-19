#!/bin/bash
set -e

APP_DIR="$HOME/success-project/success-project"

cd ${APP_DIR}

echo "🔄 Restarting application containers..."

docker compose down
docker compose up -d

echo "======================================="
echo "✅ APPLICATION RESTARTED SUCCESSFULLY"
echo "Frontend: http://<SERVER_PUBLIC_IP>"
echo "Backend : http://<SERVER_PUBLIC_IP>:8080"
echo "======================================="
