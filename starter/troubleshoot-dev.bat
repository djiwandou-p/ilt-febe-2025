@echo off
echo 🔍 Troubleshooting Development Container...

echo.
echo 1. Checking if development image exists...
docker images | findstr "ilt-backend.*dev" >nul
if %errorlevel% equ 0 (
    echo ✅ Development image found
    docker images ilt-backend:dev --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
) else (
    echo ❌ Development image not found. Building it first...
    call build-dev.bat
    if %errorlevel% neq 0 (
        echo ❌ Failed to build development image
        pause
        exit /b 1
    )
)

echo.
echo 2. Checking container status...
docker ps | findstr "ilt-backend-dev" >nul
if %errorlevel% equ 0 (
    echo ✅ Development container is running
    docker ps | findstr ilt-backend-dev
) else (
    docker ps -a | findstr "ilt-backend-dev" >nul
    if %errorlevel% equ 0 (
        echo ⚠️  Development container exists but is not running
        echo Container details:
        docker ps -a | findstr ilt-backend-dev
        echo.
        echo Starting the container...
        docker start ilt-backend-dev
        timeout /t 5 /nobreak >nul
    ) else (
        echo ❌ Development container not found. Creating it...
        echo Creating development container...
        docker run -d --name ilt-backend-dev -p 3001:3000 -e DATABASE_URL="postgresql://neondb_owner:npg_t3XHxm0kiSbN@ep-still-bush-a8rhnfn6-pooler.eastus2.azure.neon.tech/neondb?sslmode=require&channel_binding=require" ilt-backend:dev
        
        if %errorlevel% equ 0 (
            echo ✅ Development container created and started
            timeout /t 5 /nobreak >nul
        ) else (
            echo ❌ Failed to create development container
            pause
            exit /b 1
        )
    )
)

echo.
echo 3. Checking container logs...
echo Recent logs from development container:
docker logs --tail 20 ilt-backend-dev

echo.
echo 4. Checking container health...
docker ps | findstr "ilt-backend-dev" >nul
if %errorlevel% equ 0 (
    echo ✅ Container is running and healthy
    
    echo.
    echo 5. Testing endpoints...
    echo Testing health endpoint...
    timeout /t 3 /nobreak >nul
    
    echo Testing with curl...
    curl -s http://localhost:3001/health
    
    echo.
    echo Testing products endpoint...
    curl -s http://localhost:3001/products
    
) else (
    echo ❌ Container is not running properly
    echo Container status:
    docker ps -a | findstr ilt-backend-dev
)

echo.
echo 6. Summary and next steps...
docker ps | findstr "ilt-backend-dev" >nul
if %errorlevel% equ 0 (
    echo 🎉 Development container is running successfully!
    echo.
    echo 📋 Container Information:
    docker ps | findstr ilt-backend-dev
    echo.
    echo 🌐 Access your application:
    echo    Health: http://localhost:3001/health
    echo    Products: http://localhost:3001/products
    echo.
    echo 📝 Useful commands:
    echo    View logs: docker logs ilt-backend-dev
    echo    Stop container: docker stop ilt-backend-dev
    echo    Remove container: docker rm ilt-backend-dev
    echo    Restart container: docker restart ilt-backend-dev
) else (
    echo ❌ Development container is not running properly
    echo.
    echo 🔧 Troubleshooting steps:
    echo 1. Check logs: docker logs ilt-backend-dev
    echo 2. Check container status: docker ps -a
    echo 3. Try rebuilding: build-dev.bat
    echo 4. Check port conflicts: netstat -an | findstr 3001
)

pause
