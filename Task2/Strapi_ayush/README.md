# Task 2

- First we setup our strapi if its not setup using command
> npx create-strapi@latest

### Dockerfile

```dockerfile
FROM node
WORKDIR /opt/
COPY . .
RUN npm install -g node-gyp && npm config set fetch-retry-maxtimeout 600000 -g && npm install
ENV PATH=./node_modules/.bin:$PATH
RUN ["npm", "run", "build"]
EXPOSE 1337
CMD ["npm", "run", "develop"]
```

### docker-compose.yml

```yml
version: '3'
services:
  mysql:
    container_name: strapi_mysql
    image: mysql:8.0
    env_file: .env
    command: --default-authentication-plugin=mysql_native_password
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - ./strapi_db/backup:/var/lib/mysql
    networks:
      - strapi
    ports:
      - 3306:3306
  
  strapi:
    build: .
    container_name: strapi
    env_file: .env
    environment:
      DATABASE_CLIENT: ${DATABASE_CLIENT}
      DATABASE_HOST: ${DATABASE_HOST}
      DATABASE_PORT: ${DATABASE_PORT}
      DATABASE_NAME: ${DATABASE_NAME}
      DATABASE_USERNAME: ${DATABASE_USERNAME}
      DATABASE_PASSWORD: ${DATABASE_PASSWORD}
      DATABASE_SSL: ${DATABASE_SSL}
      ADMIN_JWT_SECRET: ${ADMIN_JWT_SECRET}
      APP_KEYS: ${APP_KEYS}
      NODE_ENV: ${NODE_ENV}
    ports:
      - 1337:1337
    depends_on:
      - mysql
    networks:
      - strapi

networks:
  strapi:
    name: Strapi
    driver: bridge
```

### Commands used

- To run the docker compose. It will also create the image using Dockerfile
> docker compose up -d --build

- To see the logs of the compose
> docker compose logs -f

- To stop the compose 
> docker compose stop 

