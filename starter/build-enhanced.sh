#!/bin/bash

echo "🐳 Building Enhanced Docker Images..."

# Function to build a specific stage
build_stage() {
    local stage=$1
    local tag=$2
    local description=$3
    
    echo ""
    echo "🔨 Building $description..."
    echo "Stage: $stage"
    echo "Tag: $tag"
    
    docker build -t $tag --target $stage -f Dockerfile.enhanced .
    
    if [ $? -eq 0 ]; then
        echo "✅ $description built successfully!"
        
        # Show image info
        echo "📊 Image Information:"
        docker images $tag --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    else
        echo "❌ Failed to build $description"
        return 1
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [environment]"
    echo ""
    echo "Available environments:"
    echo "  production  - Build production image only"
    echo "  development - Build development image only"
    echo "  testing     - Build testing image only"
    echo "  secure      - Build secure production image only"
    echo "  all         - Build all images (default)"
    echo ""
    echo "Examples:"
    echo "  $0                    # Build all images"
    echo "  $0 development        # Build development only"
    echo "  $0 production         # Build production only"
    echo "  $0 secure            # Build secure only"
}

# Check if environment argument is provided
ENVIRONMENT=${1:-all}

case $ENVIRONMENT in
    "production")
        echo "🎯 Building Production Image Only..."
        build_stage "production" "ilt-backend:prod" "Production Image"
        ;;
    "development")
        echo "🎯 Building Development Image Only..."
        build_stage "development" "ilt-backend:dev" "Development Image"
        ;;
    "testing")
        echo "🎯 Building Testing Image Only..."
        build_stage "testing" "ilt-backend:test" "Testing Image"
        ;;
    "secure")
        echo "🎯 Building Secure Production Image Only..."
        build_stage "secure" "ilt-backend:secure" "Secure Production Image"
        ;;
    "all")
        echo "🎯 Building All Images..."
        # Production stage
        build_stage "production" "ilt-backend:prod" "Production Image"
        
        # Development stage
        build_stage "development" "ilt-backend:dev" "Development Image"
        
        # Testing stage
        build_stage "testing" "ilt-backend:test" "Testing Image"
        
        # Secure stage
        build_stage "secure" "ilt-backend:secure" "Secure Production Image"
        ;;
    *)
        echo "❌ Invalid environment: $ENVIRONMENT"
        show_usage
        exit 1
        ;;
esac

echo ""
echo "🎉 All builds completed!"
echo ""
echo "📋 Available images:"
docker images ilt-backend --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

echo ""
echo "🚀 Usage examples:"
echo ""
echo "# Run production image:"
echo "docker run -d --name ilt-backend-prod -p 3000:3000 \\"
echo "  -e DATABASE_URL=\"your-db-url\" ilt-backend:prod"
echo ""
echo "# Run development image:"
echo "docker run -d --name ilt-backend-dev -p 3001:3000 \\"
echo "  -e DATABASE_URL=\"your-db-url\" ilt-backend:dev"
echo ""
echo "# Run secure image:"
echo "docker run -d --name ilt-backend-secure -p 3002:3000 \\"
echo "  -e DATABASE_URL=\"your-db-url\" ilt-backend:secure"
echo ""
echo "# Run tests:"
echo "docker run --rm ilt-backend:test" 