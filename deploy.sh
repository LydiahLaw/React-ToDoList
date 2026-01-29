#!/bin/bash

echo "Deployment is starting"

docker pull $DOCKER_USERNAME/ci_backend_full_pipeline:v1
docker pull $DOCKER_USERNAME/ci_frontend_full_pipeline:v1

echo "stopping old containers if any"
docker-compose down || true

echo "building and starting new containers"

docker-compose up -d --build

echo "deployment is successful"

