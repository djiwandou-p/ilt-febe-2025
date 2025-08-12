@echo off
echo 🔄 Rebuilding and testing Docker container...

REM Stop and remove existing container
echo Stopping existing container...
docker stop ilt-backend 2>nul
docker rm ilt-backend 2>nul

REM Remove existing image to ensure clean rebuild
echo Removing existing image...
docker rmi ilt-backend 2>nul

REM Build the production image
echo Building production Docker image...
docker build -t ilt-backend --target production .

if %errorlevel% equ 0 (
    echo ✅ Build successful!
    
    REM Run the container
    echo Running container...
    docker run -d --name ilt-backend -p 3000:3000 -e DATABASE_URL="postgresql://neondb_owner:npg_t3XHxm0kiSbN@ep-still-bush-a8rhnfn6-pooler.eastus2.azure.neon.tech/neondb?sslmode=require&channel_binding=require" ilt-backend
    
    if %errorlevel% equ 0 (
        echo ✅ Container started successfully!
        echo Waiting for app to start...
        timeout /t 8 /nobreak >nul
        
        REM Check container status
        echo Checking container status...
        docker ps | findstr ilt-backend
        
        REM Check logs for any errors
        echo Container logs:
        docker logs ilt-backend
        
        echo.
        echo Container is running!
        echo Access your app at http://localhost:3000
        echo To view logs: docker logs ilt-backend
        echo To stop: docker stop ilt-backend
        echo To remove: docker rm ilt-backend
        
        echo.
        echo Testing endpoints in 3 seconds...
        timeout /t 3 /nobreak >nul
        
        REM Test the endpoints
        echo Testing products endpoint...
        curl -s http://localhost:3000/products
        
    ) else (
        echo ❌ Failed to start container
        pause
        exit /b 1
    )
) else (
    echo ❌ Build failed!
    pause
    exit /b 1
)

pause 