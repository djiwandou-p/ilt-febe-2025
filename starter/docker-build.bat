@echo off
echo Building Docker image...
docker build -t ilt-backend --target production .

echo Running container...
docker run -d --name ilt-backend -p 3000:3000 -e DATABASE_URL="postgresql://neondb_owner:npg_t3XHxm0kiSbN@ep-still-bush-a8rhnfn6-pooler.eastus2.azure.neon.tech/neondb?sslmode=require&channel_binding=require" ilt-backend

echo Container started! Access your app at http://localhost:3000
echo To view logs: docker logs ilt-backend
echo To stop: docker stop ilt-backend
echo To remove: docker rm ilt-backend
pause 