# Deploying the Web application

This document provides instructions on how to deploy the Web application using Docker.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

- Docker: [Install Docker](https://docs.docker.com/get-docker/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/) (alternatively, Docker Desktop includes Docker Compose)

Verify the installations by running:

```bash
docker --version
docker-compose --version
```

## Building the Docker Image

The Dockerfile for the Web application is located in the `infra/docker/` directory as `Dockerfile.web`.

The web application is dependent on a MySQL database and a backend service. Find the Docker Compose configuration file at `infra/docker/docker-compose.yml`. A "demo" configuration is also available at `infra/docker/docker-compose.demo.yml` for quick setup. We'll use the demo configuration for this guide.

### Environment Variables

Note that the docker compose file references an environment file for the web application. Let's look at the required environment variables.

```bash
# apps/web/.env.example
NEXT_PUBLIC_MAPBOX_PUBLIC_ACCESS_TOKEN=your_mapbox_access_token_here
SNOWER_API_KEY="your_snower_api_key_here"
SNOWER_USERNAME="snower_username_here"
SNOWER_PASSWORD="snower_password_here"

# Backend URLs:
# - BACKEND_URL: Server-side only (for SSR, server actions). In Docker, use internal hostname.
# - NEXT_PUBLIC_BACKEND_URL: Client-side (for browser requests). Use publicly accessible URL.
#
# Local development (both can be the same):
BACKEND_URL="http://localhost:3001"
NEXT_PUBLIC_BACKEND_URL="http://localhost:3001"
#
# Docker deployment:
# BACKEND_URL="http://backend:3001"
# NEXT_PUBLIC_BACKEND_URL="http://localhost:3001"
```

Copy the example environment file and update it with your actual values to a file that is not committed to version control, such as `apps/web/.env`.

Do not store sensitive information in the docker compose file or any file that is committed to version control.

### Build and Start the Containers

To build and start the containers using the demo configuration, navigate to the `infra/docker/` directory and run:

```bash
cd infra/docker/
# sudo may be required depending on your Docker installation
docker compose -f docker-compose.demo.yml up --build
```

Note: If you are still using a weaker VPS, you may need to first take down the existing containers to avoid freezing due to insufficient memory and building each service one by one:

```bash
docker compose -f docker-compose.demo.yml down
docker compose -f docker-compose.demo.yml build db
docker compose -f docker-compose.demo.yml build backend
docker compose -f docker-compose.demo.yml build web
docker compose -f docker-compose.demo.yml up web
```

This command will build the Docker images and start the containers for the database, backend, and web application.

Unfreezing the VPS can only be done by restarting the VPS via the hosting provider's control panel. The legacy application restarts without problems usually.
IF it does not, and it is the map that is not loading, a process occupying the port that the application is trying to use needs to be killed.
This error should be found from the pm2 logs if that is the case, "Error: listen EADDRINUSE: address already in use :::3000".
For example with the command "lsof -i :3000" you can find the PID that needs to be killed if this is the case.