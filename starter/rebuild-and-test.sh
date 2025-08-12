#!/bin/bash

echo "🔄 Rebuilding and testing Docker container..."

# Stop and remove existing container
echo "Stopping existing container..."
docker stop ilt-backend 2>/dev/null || true
docker rm ilt-backend 2>/dev/null || true

# Remove existing image to ensure clean rebuild
echo "Removing existing image..."
docker rmi ilt-backend 2>/dev/null || true

# Build the production image
echo "Building production Docker image..."
docker build -t ilt-backend --target production .

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Run the container
    echo "Running container..."
    docker run -d \
      --name ilt-backend \
      -p 3000:3000 \
      -e DATABASE_URL="postgresql://neondb_owner:npg_t3XHxm0kiSbN@ep-still-bush-a8rhnfn6-pooler.eastus2.azure.neon.tech/neondb?sslmode=require&channel_binding=require" \
      ilt-backend
    
    if [ $? -eq 0 ]; then
        echo "✅ Container started successfully!"
        echo "Waiting for app to start..."
        sleep 8
        
        # Check container status
        echo "Checking container status..."
        docker ps | grep ilt-backend
        
        # Check logs for any errors
        echo "Container logs:"
        docker logs ilt-backend
        
        # Test the endpoint
        echo ""
        echo "Testing application endpoints..."
        
        # Test root endpoint
        echo "Testing root endpoint..."
        curl -s -o /dev/null -w "Root endpoint: %{http_code}\n" http://localhost:3000/ || echo "Root endpoint: Failed to connect"
        
        # Test products endpoint
        echo "Testing products endpoint..."
        curl -s -o /dev/null -w "Products endpoint: %{http_code}\n" http://localhost:3000/products || echo "Products endpoint: Failed to connect"
        
        echo ""
        echo "Container is running!"
        echo "Access your app at http://localhost:3000"
        echo "To view logs: docker logs ilt-backend"
        echo "To stop: docker stop ilt-backend"
        echo "To remove: docker rm ilt-backend"
    else
        echo "❌ Failed to start container"
        exit 1
    fi
else
    echo "❌ Build failed!"
    exit 1
fi 