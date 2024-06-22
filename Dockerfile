# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04 as base

ENV DEBIAN_FRONTEND noninteractive

# Update system and install necessary packages
RUN apt-get update -y && apt-get install -y \
    curl \
    make \
    gcc \
    g++ \
    ca-certificates \
    git

# Install NVM and Node.js
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 18.20.0

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && nvm alias default $NODE_VERSION

# Ensure Node and npm are available in the PATH
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Enable corepack to manage package managers like Yarn and pnpm
RUN corepack enable

# Set cache directory for Yarn to be shared between different Docker stages
RUN yarn config set cache-folder /tmp/yarn-cache

# Setup stage for application build
FROM base as setup

WORKDIR /www

# Copy package.json and yarn.lock for dependency installation
COPY package.json yarn.lock /www/

# Install all dependencies
RUN yarn install

# Copy TypeScript config and all application source files
COPY tsconfig.build.json ./
COPY . /www/

# Build the application
RUN yarn build

# Final stage build, preparing the production environment
FROM base as final

WORKDIR /www

# Copy built application from the setup stage
COPY --from=setup /www/build /www/build
COPY --from=setup /tmp/yarn-cache /tmp/yarn-cache

# Copy package management files
COPY package.json yarn.lock /www/

# Install production dependencies
RUN yarn install --production

# Clear Yarn cache to reduce image size
RUN yarn cache clean

# Define the command to run the application
ENTRYPOINT ["yarn", "start"]

# FROM ubuntu:22.04 as base

# ENV DEBIAN_FRONTEND noninteractive

# RUN apt-get update -y && apt-get install -y \
#     apt-transport-https \
#     curl \
#     make \
#     gcc \
#     g++

# # nodejs
# RUN curl -sL https://deb.nodesource.com/setup_18.x | bash

# # install depdencies and enable corepack
# RUN apt-get update -y && apt-get install -y --allow-unauthenticated nodejs
# RUN corepack enable

# # Set cache dir so it can be shared between different docker stages
# RUN yarn config set cache-folder /tmp/yarn-cache

# FROM base as setup

# # AFJ specifc setup
# WORKDIR /www

# # Copy root package files
# COPY package.json /www/package.json
# COPY yarn.lock /www/yarn.lock

# # Run yarn install
# RUN yarn install

# COPY tsconfig.build.json /www/tsconfig.build.json
# COPY . /www

# RUN yarn build

# FROM base as final

# WORKDIR /www

# COPY --from=setup /www/build /www/build
# COPY --from=setup /tmp/yarn-cache /tmp/yarn-cache

# # Copy root package files and mediator app package
# COPY package.json /www/package.json
# COPY yarn.lock /www/yarn.lock

# WORKDIR /www

# # Run yarn install
# RUN yarn install --production

# # Clean cache to reduce image size
# RUN yarn cache clean

# ENTRYPOINT [ "yarn", "start" ]
