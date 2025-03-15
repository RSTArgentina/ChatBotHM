# Use the official Node.js image as the base image
FROM node:18-alpine

# Install necessary dependencies for Puppeteer
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    yarn

# Set the working directory
WORKDIR /usr/src/app

ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./
COPY prisma ./prisma/

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Copy the Prisma schema file to the correct location
COPY prisma/schema.prisma prisma/schema.prisma

# Build the application
RUN npm run build

# Expose the port the app runs on
EXPOSE 3000

# Set the environment variable for Puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Start the application
CMD ["node", "dist/main"]