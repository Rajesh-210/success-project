#!/bin/bash
set -e

cd "$WORKSPACE/success-project/success-project"

docker compose down
docker compose up -d

echo "======================================="
echo "✅ APPLICATION REDEPLOYED"
echo "======================================="
