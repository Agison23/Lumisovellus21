FROM node:24-alpine3.21 as base 
WORKDIR /backend
COPY package.json /backend
RUN apk add --no-cache sqlite
RUN npm install
COPY . /backend
RUN mkdir -p /app/db

FROM base as dev   
CMD ["npm","run","dev"]

FROM base as prod
CMD ["npm","start"]
