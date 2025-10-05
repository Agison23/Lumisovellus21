# North Star

# Backend 

## Local development with docker

A local development environment is available with docker.

1. Copy the `.env.example` file into `.env` file in the `backend` directory

```shell session
cp backend/app/.env.example backend/app/.env
```

2. Build the docker containers based on the environment 

    For development

```shell session
    NODE_ENV=dev docker-compose up --build
```

    For Production

```shell session
    NODE_ENV=prod docker-compose up --build
```


3. Launch docker-compose

```shell session
docker-compose up 
```

At this point, the docker should be up and running. Now, let's add some data.

4. Access the docker container command line

```shell session
docker-compose exec backend sh
```

