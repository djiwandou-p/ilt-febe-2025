#!/bin/bash

echo "🐳 Pushing Docker image to Docker Hub..."

# Check if image exists locally
if ! docker images | grep -q "ilt-backend"; then
    echo "❌ Local image 'ilt-backend' not found!"
    echo "Please build the image first using: ./docker-build.sh"
    exit 1
fi

# Tag the image with Docker Hub username
echo "Tagging image as djwd/ilt-backend:v1.0..."
docker tag ilt-backend djwd/ilt-backend:v1.0

if [ $? -eq 0 ]; then
    echo "✅ Image tagged successfully!"
    
    # Check if user is logged in to Docker Hub
    if ! docker info | grep -q "Username"; then
        echo "⚠️  You are not logged in to Docker Hub"
        echo "Please login first using: docker login"
        echo "Then run this script again."
        exit 1
    fi
    
    # Push the image to Docker Hub
    echo "Pushing image to Docker Hub..."
    docker push djwd/ilt-backend:v1.0
    
    if [ $? -eq 0 ]; then
        echo "✅ Image pushed successfully to Docker Hub!"
        echo "Your image is now available at: https://hub.docker.com/r/djwd/ilt-backend"
        echo ""
        echo "To pull this image on another machine:"
        echo "docker pull djwd/ilt-backend:v1.0"
        echo ""
        echo "To run this image on another machine:"
        echo "docker run -d --name ilt-backend -p 3000:3000 -e DATABASE_URL=\"your-db-url\" djwd/ilt-backend:v1.0"
    else
        echo "❌ Failed to push image to Docker Hub"
        exit 1
    fi
else
    echo "❌ Failed to tag image"
    exit 1
fi 