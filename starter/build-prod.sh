#!/bin/bash

echo "🔨 Building Production Image Only..."

# Build production stage
docker build -t ilt-backend:prod --target production -f Dockerfile.enhanced .

if [ $? -eq 0 ]; then
    echo "✅ Production Image built successfully!"
    
    # Show image info
    echo "📊 Image Information:"
    docker images ilt-backend:prod --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    
    echo ""
    echo "🚀 Usage examples:"
    echo ""
    echo "# Run production container:"
    echo "docker run -d --name ilt-backend-prod -p 3000:3000 \\"
    echo "  -e DATABASE_URL=\"your-db-url\" ilt-backend:prod"
    echo ""
    echo "# Run with docker-compose:"
    echo "docker-compose -f docker-compose.enhanced.yml up -d ilt-backend-prod"
    echo ""
    echo "# Test the endpoint:"
    echo "curl http://localhost:3000/health"
    echo "curl http://localhost:3000/products"
else
    echo "❌ Failed to build Production Image"
    exit 1
fi
