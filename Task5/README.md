# Task 5
General Deploy Strapi on EC2 using Terraform and Docker.
Everything should still be automated via Terraform.

Steps you should perform:

- Write a Dockerfile to containerize the Strapi app
- Build and push Docker image to Docker Hub or ECR
- Use Terraform to:
    - Launch an EC2 instance 
    - using the user-data script
        - Install Docker
        - Pull the Docker image
        - Run the Strapi container

## 1. Write Dockerfile to containerize the Strapi App
- Now we know to make strapi app we have the command
> npx create-strapi@latest

- To containerize the Strapi App we have the code 
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
## 2. Build the image and push it into Docker Hub
- To build the image we run the command 
> docker build -t task5_Strapi .
- Then we can see the images using 
> docker images

- Now to pusht the image to docker file, I follow this link
[link](https://docs.docker.com/get-started/introduction/build-and-push-first-image/)
- I created the repository first, then locally login with you docker account
> docker login
- Then tag the image with the repo name. Here I did something like this
> docker tag [imageid] ayush2832/reponame:tag
- After that push the image using command
> docker push ayush2832/reponame:tag 
- Then in the Docker Hub you can verify it.

## 3. Launching EC2 with terrafrom and run Strapi container
So for this, first I created seperate dir for VPC and EC2
```
terraform
|______VPC
        |____main.tf
|______EC2
        |____main.tf
```
- This way we can provision different environment seperately. So first we will setup the VPC, subnet, Internet gateway, route table, and association of route table.
- Now in the vpc/main.tf file, I have define the code to create VPC, subent, route table, gatewa etc.

- Then in the ec2/main.tf. I have defined the code to creat the ec2 container and also the security group and there is one part where we defin the file path for the file which we use fo userdata for creation of ec2 creation

> user_data = file("${path.module}/script.sh")

- And the script we are using is

```sh
#!/bin/bash

# Install docker
sudo apt update -y
sudo apt install docker.io -y

# create .env file
cat <<EOF > /home/ubuntu/.env
# Server
HOST=0.0.0.0
PORT=1337

# Secrets
APP_KEYS=KVozPDcMLJoeDfU2kU4jqQ==,YtPI8ep/NOwSpjbC++5rBg==,/jUEMQ9IyPOU6vFIYiFpgQ==,4anKn39+LSQNiNNDoexJIw==
API_TOKEN_SALT=V/qBXwnXn0xf6A6KQP14tQ==
ADMIN_JWT_SECRET=mVISSjAr2gX81V10mjacNA==
TRANSFER_TOKEN_SALT=KEsmUJvep0HsIUaud/7eFQ==
ENCRYPTION_KEY=x/VX6cOsLMrVt70wxCpj6Q==

# Database
DATABASE_CLIENT=sqlite
DATABASE_HOST=
DATABASE_PORT=
DATABASE_NAME=
DATABASE_USERNAME=
DATABASE_PASSWORD=
DATABASE_SSL=false
DATABASE_FILENAME=.tmp/data.db
JWT_SECRET=bdipEHxkpPS5PNwYpj0dLA==
EOF

# Pull docker image and run 
sudo docker run -d --name Strapi_cont -p 1337:1337 --env-file /home/ubuntu/.env ayush2832/strapi:v1
```
- After that we run the file using the command  in their respective directory
> terraform apply --auto-approve


