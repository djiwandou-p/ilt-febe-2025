#!/bin/bash

echo "🔍 Troubleshooting Development Container..."

# Check if development image exists
echo "1. Checking if development image exists..."
if docker images | grep -q "ilt-backend.*dev"; then
    echo "✅ Development image found"
    docker images ilt-backend:dev --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
else
    echo "❌ Development image not found. Building it first..."
    ./build-dev.sh
    if [ $? -ne 0 ]; then
        echo "❌ Failed to build development image"
        exit 1
    fi
fi

echo ""
echo "2. Checking container status..."
if docker ps | grep -q "ilt-backend-dev"; then
    echo "✅ Development container is running"
    docker ps | grep ilt-backend-dev
elif docker ps -a | grep -q "ilt-backend-dev"; then
    echo "⚠️  Development container exists but is not running"
    echo "Container details:"
    docker ps -a | grep ilt-backend-dev
    echo ""
    echo "Starting the container..."
    docker start ilt-backend-dev
    sleep 5
else
    echo "❌ Development container not found. Creating it..."
    echo "Creating development container..."
    docker run -d --name ilt-backend-dev -p 3001:3000 \
      -e DATABASE_URL="postgresql://neondb_owner:npg_t3XHxm0kiSbN@ep-still-bush-a8rhnfn6-pooler.eastus2.azure.neon.tech/neondb?sslmode=require&channel_binding=require" \
      ilt-backend:dev
    
    if [ $? -eq 0 ]; then
        echo "✅ Development container created and started"
        sleep 5
    else
        echo "❌ Failed to create development container"
        exit 1
    fi
fi

echo ""
echo "3. Checking container logs..."
echo "Recent logs from development container:"
docker logs --tail 20 ilt-backend-dev

echo ""
echo "4. Checking container health..."
if docker ps | grep -q "ilt-backend-dev"; then
    echo "✅ Container is running and healthy"
    
    echo ""
    echo "5. Testing endpoints..."
    echo "Testing health endpoint..."
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/health 2>/dev/null || echo "000")
    
    if [ "$response" = "200" ]; then
        echo "✅ Health endpoint working (HTTP $response)"
    else
        echo "⚠️  Health endpoint not responding (HTTP $response)"
        echo "Waiting a bit more for container to fully start..."
        sleep 10
        
        response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/health 2>/dev/null || echo "000")
        if [ "$response" = "200" ]; then
            echo "✅ Health endpoint now working (HTTP $response)"
        else
            echo "❌ Health endpoint still not working (HTTP $response)"
        fi
    fi
    
    echo ""
    echo "Testing products endpoint..."
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/products 2>/dev/null || echo "000")
    if [ "$response" = "200" ] || [ "$response" = "404" ]; then
        echo "✅ Products endpoint responding (HTTP $response)"
    else
        echo "⚠️  Products endpoint not responding (HTTP $response)"
    fi
    
else
    echo "❌ Container is not running properly"
    echo "Container status:"
    docker ps -a | grep ilt-backend-dev
fi

echo ""
echo "6. Summary and next steps..."
if docker ps | grep -q "ilt-backend-dev"; then
    echo "🎉 Development container is running successfully!"
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
    echo "   Restart container: docker restart ilt-backend-dev"
else
    echo "❌ Development container is not running properly"
    echo ""
    echo "🔧 Troubleshooting steps:"
    echo "1. Check logs: docker logs ilt-backend-dev"
    echo "2. Check container status: docker ps -a"
    echo "3. Try rebuilding: ./build-dev.sh"
    echo "4. Check port conflicts: netstat -tulpn | grep 3001"
fi
