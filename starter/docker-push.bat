@echo off
echo 🐳 Pushing Docker image to Docker Hub...

REM Check if image exists locally
docker images | findstr "ilt-backend" >nul
if %errorlevel% neq 0 (
    echo ❌ Local image 'ilt-backend' not found!
    echo Please build the image first using: docker-build.bat
    pause
    exit /b 1
)

REM Tag the image with Docker Hub username
echo Tagging image as djwd/ilt-backend:v1.0...
docker tag ilt-backend djwd/ilt-backend:v1.0

if %errorlevel% equ 0 (
    echo ✅ Image tagged successfully!
    
    REM Check if user is logged in to Docker Hub
    docker info | findstr "Username" >nul
    if %errorlevel% neq 0 (
        echo ⚠️  You are not logged in to Docker Hub
        echo Please login first using: docker login
        echo Then run this script again.
        pause
        exit /b 1
    )
    
    REM Push the image to Docker Hub
    echo Pushing image to Docker Hub...
    docker push djwd/ilt-backend:v1.0
    
    if %errorlevel% equ 0 (
        echo ✅ Image pushed successfully to Docker Hub!
        echo Your image is now available at: https://hub.docker.com/r/djwd/ilt-backend
        echo.
        echo To pull this image on another machine:
        echo docker pull djwd/ilt-backend:v1.0
        echo.
        echo To run this image on another machine:
        echo docker run -d --name ilt-backend -p 3000:3000 -e DATABASE_URL="your-db-url" djwd/ilt-backend:v1.0
    ) else (
        echo ❌ Failed to push image to Docker Hub
        pause
        exit /b 1
    )
) else (
    echo ❌ Failed to tag image
    pause
    exit /b 1
)

pause 