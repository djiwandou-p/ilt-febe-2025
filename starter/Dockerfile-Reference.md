# 🐳 Complete Dockerfile Instructions Reference

## 📋 Basic Instructions

### **FROM** - Base Image
```dockerfile
FROM node:18-alpine
FROM ubuntu:20.04
FROM python:3.9-slim
```
- **Purpose**: Specifies the base image
- **Best Practice**: Use specific versions, not `latest`

### **WORKDIR** - Working Directory
```dockerfile
WORKDIR /app
WORKDIR /usr/src/app
```
- **Purpose**: Sets working directory for subsequent commands
- **Benefits**: Creates directory if it doesn't exist, affects RUN/COPY/CMD

### **COPY** - Copy Files
```dockerfile
COPY package*.json ./
COPY . .
COPY --chown=user:group source dest
```
- **Purpose**: Copies files from host to container
- **Best Practice**: Copy package files first for better caching

### **ADD** - Advanced Copy
```dockerfile
ADD https://example.com/file.tar.gz /tmp/
ADD source.tar.gz /app/
```
- **Purpose**: Enhanced COPY with URL support and auto-extraction
- **Note**: Generally prefer COPY unless you need ADD's features

### **RUN** - Execute Commands
```dockerfile
RUN npm ci --only=production
RUN apt-get update && apt-get install -y package
RUN npm ci && npm cache clean --force
```
- **Purpose**: Executes commands during build
- **Best Practice**: Chain commands with `&&` to reduce layers

### **EXPOSE** - Document Ports
```dockerfile
EXPOSE 3000
EXPOSE 80 443
```
- **Purpose**: Documents which ports the container uses
- **Note**: Doesn't actually open ports, just documentation

### **CMD** - Default Command
```dockerfile
CMD ["npm", "start"]
CMD ["node", "server.js"]
CMD npm start
```
- **Purpose**: Default command when container starts
- **Note**: Can be overridden with `docker run` command

### **ENTRYPOINT** - Container Entry Point
```dockerfile
ENTRYPOINT ["docker-entrypoint.sh"]
ENTRYPOINT ["node"]
CMD ["server.js"]
```
- **Purpose**: Sets the container's main executable
- **Note**: CMD becomes arguments to ENTRYPOINT

## 🔧 Advanced Instructions

### **ENV** - Environment Variables
```dockerfile
ENV NODE_ENV=production
ENV PORT=3000
ENV PATH="/app/node_modules/.bin:$PATH"
```
- **Purpose**: Sets environment variables
- **Best Practice**: Use for build-time and runtime variables

### **ARG** - Build Arguments
```dockerfile
ARG VERSION=latest
ARG BUILD_DATE
ARG VCS_REF
```
- **Purpose**: Defines variables available during build
- **Usage**: `docker build --build-arg VERSION=1.0 .`

### **LABEL** - Metadata
```dockerfile
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="My Application"
```
- **Purpose**: Adds metadata to image
- **Benefits**: Helps with image organization and documentation

### **USER** - Switch User
```dockerfile
USER nodejs
USER 1000
USER nobody
```
- **Purpose**: Changes user for subsequent commands
- **Security**: Run as non-root user when possible

### **VOLUME** - Define Volumes
```dockerfile
VOLUME ["/app/data", "/app/logs"]
VOLUME /var/lib/mysql
```
- **Purpose**: Declares mount points for persistent data
- **Note**: Creates anonymous volumes if not specified

### **HEALTHCHECK** - Health Monitoring
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```
- **Purpose**: Defines how to check if container is healthy
- **Options**: interval, timeout, start-period, retries

## 🏗️ Multi-Stage Builds

### **Basic Multi-Stage**
```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine AS production
COPY --from=builder /app/dist /usr/share/nginx/html
```

### **Stage Naming**
```dockerfile
FROM node:18-alpine AS base
FROM base AS development
FROM base AS production
FROM base AS testing
```

## 🚀 Best Practices

### **1. Layer Caching**
```dockerfile
# Good - package.json changes don't invalidate node_modules
COPY package*.json ./
RUN npm ci
COPY . .

# Bad - any change invalidates everything
COPY . .
RUN npm ci
```

### **2. Security**
```dockerfile
# Create non-root user
RUN addgroup -g 1001 -S appuser && \
    adduser -S appuser -u 1001

# Switch to non-root user
USER appuser

# Don't run as root
USER 1000
```

### **3. Multi-Platform Support**
```dockerfile
FROM --platform=$TARGETPLATFORM node:18-alpine
ARG TARGETPLATFORM
ARG BUILDPLATFORM
```

### **4. Clean Up**
```dockerfile
RUN apt-get update && \
    apt-get install -y package && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

### **5. Signal Handling**
```dockerfile
# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init
ENTRYPOINT ["dumb-init", "--"]
CMD ["npm", "start"]
```

## 📊 Common Patterns

### **Node.js Application**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### **Python Application**
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["python", "app.py"]
```

### **Static Website**
```dockerfile
FROM nginx:alpine
COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## 🔍 Debugging Commands

### **Build with Progress**
```bash
docker build --progress=plain -t myapp .
```

### **Inspect Image Layers**
```bash
docker history myapp
docker inspect myapp
```

### **Run Interactive Shell**
```bash
docker run -it --rm myapp /bin/sh
```

### **Check Image Size**
```bash
docker images myapp
docker system df
```

## 💡 Pro Tips

1. **Use .dockerignore** to exclude unnecessary files
2. **Pin base image versions** for reproducible builds
3. **Minimize layers** by combining RUN commands
4. **Use multi-stage builds** to reduce final image size
5. **Scan images** for security vulnerabilities
6. **Test builds** in CI/CD pipeline
7. **Use BuildKit** for faster builds: `DOCKER_BUILDKIT=1 docker build .` 