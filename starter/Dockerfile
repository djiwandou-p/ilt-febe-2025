# Use Node.js 18 Alpine as base image for smaller size
FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Development stage
FROM base AS development
# Install all dependencies including dev dependencies
RUN npm ci

# Copy source code
COPY . .

# Expose port
EXPOSE 3000

# Start the application with nodemon for development
CMD ["npm", "run", "start"]

# Production stage
FROM base AS production
# Install only production dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Run database migrations
#RUN npm install -g node-pg-migrate
#RUN npm run migrate

# Expose port
EXPOSE 3000

# Start the application with production script (no nodemon)
CMD ["npm", "run", "start:prod"] 