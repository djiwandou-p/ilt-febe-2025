#!/bin/bash

echo "Testing Docker setup..."

# Clean up any existing containers
echo "Cleaning up existing containers..."
docker stop ilt-backend 2>/dev/null || true
docker rm ilt-backend 2>/dev/null || true

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
        sleep 5
        
        # Test the endpoint
        echo "Testing application..."
        response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 || echo "000")
        
        if [ "$response" = "200" ] || [ "$response" = "404" ]; then
            echo "✅ Application is responding! (HTTP $response)"
        else
            echo "⚠️  Application might not be ready yet. Response: $response"
        fi
        
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