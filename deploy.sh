#!/bin/bash
set -e

cd "$WORKSPACE/success-project/success-project"

docker compose down || true
docker compose up -d

echo "======================================="
echo "✅ APPLICATION RUNNING"
echo "Frontend: http://<SERVER_PUBLIC_IP>"
echo "Backend : http://<SERVER_PUBLIC_IP>:8081"
echo "======================================="
