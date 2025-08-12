#!/bin/bash

echo "🔨 Building Development Image Only..."

# Build development stage
docker build -t ilt-backend:dev --target development -f Dockerfile.enhanced .

if [ $? -eq 0 ]; then
    echo "✅ Development Image built successfully!"
    
    # Show image info
    echo "📊 Image Information:"
    docker images ilt-backend:dev --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    
    echo ""
    echo "🚀 Usage examples:"
    echo ""
    echo "# Run development container:"
    echo "docker run -d --name ilt-backend-dev -p 3001:3000 \\"
    echo "  -e DATABASE_URL=\"your-db-url\" ilt-backend:dev"
    echo ""
    echo "# Run with docker-compose:"
    echo "docker-compose -f docker-compose.enhanced.yml up -d ilt-backend-dev"
    echo ""
    echo "# Test the endpoint:"
    echo "curl http://localhost:3001/health"
    echo "curl http://localhost:3001/products"
else
    echo "❌ Failed to build Development Image"
    exit 1
fi
