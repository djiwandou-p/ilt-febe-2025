#!/bin/bash

echo "🔨 Building Secure Production Image Only..."

# Build secure stage
docker build -t ilt-backend:secure --target secure -f Dockerfile.enhanced .

if [ $? -eq 0 ]; then
    echo "✅ Secure Production Image built successfully!"
    
    # Show image info
    echo "📊 Image Information:"
    docker images ilt-backend:secure --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    
    echo ""
    echo "🚀 Usage examples:"
    echo ""
    echo "# Run secure container:"
    echo "docker run -d --name ilt-backend-secure -p 3002:3000 \\"
    echo "  -e DATABASE_URL=\"your-db-url\" ilt-backend:secure"
    echo ""
    echo "# Run with docker-compose:"
    echo "docker-compose -f docker-compose.enhanced.yml up -d ilt-backend-secure"
    echo ""
    echo "# Test the endpoint:"
    echo "curl http://localhost:3002/health"
    echo "curl http://localhost:3002/products"
else
    echo "❌ Failed to build Secure Production Image"
    exit 1
fi
