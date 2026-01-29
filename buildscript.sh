#!/bin/bash

echo "Logging into Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Build backend image
docker build -t $DOCKER_USERNAME/ci_backend_full_pipeline:v1 \
  -f backend/Dockerfile backend

# Build frontend image
docker build -t $DOCKER_USERNAME/ci_frontend_full_pipeline:v1 \
  -f dive-react-app/Dockerfile dive-react-app

# Push images
docker push $DOCKER_USERNAME/ci_backend_full_pipeline:v1
docker push $DOCKER_USERNAME/ci_frontend_full_pipeline:v1

