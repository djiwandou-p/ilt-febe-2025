#!/bin/bash

echo "🧪 Testing Development Container Fix..."

# Clean up any existing containers
echo "Cleaning up existing containers..."
docker stop ilt-backend-dev 2>/dev/null || true
docker rm ilt-backend-dev 2>/dev/null || true

# Remove existing development image
echo "Removing existing development image..."
docker rmi ilt-backend:dev 2>/dev/null || true

# Build the development image
echo "Building development image with fix..."
docker build -t ilt-backend:dev --target development -f Dockerfile.enhanced .

if [ $? -eq 0 ]; then
    echo "✅ Development image built successfully!"
    
    # Run the container
    echo "Running development container..."
    docker run -d --name ilt-backend-dev -p 3001:3000 \
      -e DATABASE_URL="postgresql://neondb_owner:npg_t3XHxm0kiSbN@ep-still-bush-a8rhnfn6-pooler.eastus2.azure.neon.tech/neondb?sslmode=require&channel_binding=require" \
      ilt-backend:dev
    
    if [ $? -eq 0 ]; then
        echo "✅ Development container started successfully!"
        echo "Waiting for app to start..."
        sleep 10
        
        # Check container status
        echo "Container status:"
        docker ps | grep ilt-backend-dev
        
        # Check logs for nodemon
        echo ""
        echo "Container logs (checking for nodemon):"
        docker logs ilt-backend-dev
        
        # Test the endpoints
        echo ""
        echo "Testing endpoints..."
        
        # Test health endpoint
        echo "Testing health endpoint..."
        response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/health 2>/dev/null || echo "000")
        
        if [ "$response" = "200" ]; then
            echo "✅ Health endpoint working! (HTTP $response)"
        else
            echo "⚠️  Health endpoint not responding yet (HTTP $response)"
            echo "Waiting a bit more..."
            sleep 5
            response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/health 2>/dev/null || echo "000")
            if [ "$response" = "200" ]; then
                echo "✅ Health endpoint now working! (HTTP $response)"
            else
                echo "❌ Health endpoint still not working (HTTP $response)"
            fi
        fi
        
        # Test products endpoint
        echo ""
        echo "Testing products endpoint..."
        response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/products 2>/dev/null || echo "000")
        if [ "$response" = "200" ] || [ "$response" = "404" ]; then
            echo "✅ Products endpoint responding! (HTTP $response)"
        else
            echo "⚠️  Products endpoint not responding (HTTP $response)"
        fi
        
        echo ""
        echo "🎉 Development container test completed!"
        echo ""
        echo "📋 Container Information:"
        docker ps | grep ilt-backend-dev
        echo ""
        echo "🌐 Access your application:"
        echo "   Health: http://localhost:3001/health"
        echo "   Products: http://localhost:3001/products"
        echo ""
        echo "📝 Useful commands:"
        echo "   View logs: docker logs ilt-backend-dev"
        echo "   Stop container: docker stop ilt-backend-dev"
        echo "   Remove container: docker rm ilt-backend-dev"
        
    else
        echo "❌ Failed to start development container"
        exit 1
    fi
else
    echo "❌ Failed to build development image"
    exit 1
fi
