# Task 3

## Dockerfile

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

## docker-compose.yml 

```yml
version: '3'
services:
  postgres:
    container_name: strapi_postgres
    image: postgres:16.0-alpine
    env_file: .env
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - strapi_db:/var/lib/postgresql/data/
    networks:
      - strapi
    ports:
      - "5432:5432"
  
  strapi:
    container_name: strapi
    build:
      dockerfile: Dockerfile
    env_file: .env
    environment:
      DATABASE_CLIENT: ${DATABASE_CLIENT}
      DATABASE_HOST: ${DATABASE_HOST}
      DATABASE_PORT: ${DATABASE_PORT}
      DATABASE_NAME: ${DATABASE_NAME}
      DATABASE_USERNAME: ${DATABASE_USERNAME}
      DATABASE_PASSWORD: ${DATABASE_PASSWORD}
      JWT_SECRET: ${JWT_SECRET}
      ADMIN_JWT_SECRET: ${ADMIN_JWT_SECRET}
      APP_KEYS: ${APP_KEYS}
      NODE_ENV: ${NODE_ENV}
    ports:
      - "1337:1337"
    depends_on:
      - postgres
    networks:
      - strapi

volumes:
  strapi_db:

networks:
  strapi:
    name: Strapi
    driver: bridge
```

## Nginx host configuration
1. First we have command `sudo vim /etc/nginx/sites-available/default`

```bash
location /{
    proxy_pass http://localhost:1337
}

```
- Then we run the command `sudo systemctl restart nginx`
