#!/bin/bash

echo "🔨 Building Testing Image Only..."

# Build testing stage
docker build -t ilt-backend:test --target testing -f Dockerfile.enhanced .

if [ $? -eq 0 ]; then
    echo "✅ Testing Image built successfully!"
    
    # Show image info
    echo "📊 Image Information:"
    docker images ilt-backend:test --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    
    echo ""
    echo "🚀 Usage examples:"
    echo ""
    echo "# Run tests:"
    echo "docker run --rm ilt-backend:test"
    echo ""
    echo "# Run with docker-compose:"
    echo "docker-compose -f docker-compose.enhanced.yml up ilt-backend-test"
    echo ""
    echo "# Run tests interactively:"
    echo "docker run -it --rm ilt-backend:test /bin/sh"
else
    echo "❌ Failed to build Testing Image"
    exit 1
fi
