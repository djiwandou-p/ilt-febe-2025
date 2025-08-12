@echo off
echo 🐳 Building Enhanced Docker Images...

echo.
echo 🔨 Building Production Image...
echo Stage: production
echo Tag: ilt-backend:prod
docker build -t ilt-backend:prod --target production -f Dockerfile.enhanced .

if %errorlevel% equ 0 (
    echo ✅ Production Image built successfully!
) else (
    echo ❌ Failed to build Production Image
    pause
    exit /b 1
)

echo.
echo 🔨 Building Development Image...
echo Stage: development
echo Tag: ilt-backend:dev
docker build -t ilt-backend:dev --target development -f Dockerfile.enhanced .

if %errorlevel% equ 0 (
    echo ✅ Development Image built successfully!
) else (
    echo ❌ Failed to build Development Image
    pause
    exit /b 1
)

echo.
echo 🔨 Building Testing Image...
echo Stage: testing
echo Tag: ilt-backend:test
docker build -t ilt-backend:test --target testing -f Dockerfile.enhanced .

if %errorlevel% equ 0 (
    echo ✅ Testing Image built successfully!
) else (
    echo ❌ Failed to build Testing Image
    pause
    exit /b 1
)

echo.
echo 🔨 Building Secure Production Image...
echo Stage: secure
echo Tag: ilt-backend:secure
docker build -t ilt-backend:secure --target secure -f Dockerfile.enhanced .

if %errorlevel% equ 0 (
    echo ✅ Secure Production Image built successfully!
) else (
    echo ❌ Failed to build Secure Production Image
    pause
    exit /b 1
)

echo.
echo 🎉 All builds completed!
echo.
echo 📋 Available images:
docker images ilt-backend --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

echo.
echo 🚀 Usage examples:
echo.
echo # Run production image:
echo docker run -d --name ilt-backend-prod -p 3000:3000 -e DATABASE_URL="your-db-url" ilt-backend:prod
echo.
echo # Run development image:
echo docker run -d --name ilt-backend-dev -p 3001:3000 -e DATABASE_URL="your-db-url" ilt-backend:dev
echo.
echo # Run secure image:
echo docker run -d --name ilt-backend-secure -p 3002:3000 -e DATABASE_URL="your-db-url" ilt-backend:secure
echo.
echo # Run tests:
echo docker run --rm ilt-backend:test

pause 