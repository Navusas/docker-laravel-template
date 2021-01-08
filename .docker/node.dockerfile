### This file is not used.

FROM node:latest

# Set environment to development
ENV NODE_ENV=development

# Set the working directory
WORKDIR /var/www/

# Copy files to read from when installing node modules

COPY ./src/package*.json ./
COPY ./src/webpack* ./

# Remove current node modules (to avoid discrepencies)
#RUN rm -rf ./src/node_modules ./src/package-lock.json

# Install the NPM version 7+
RUN npm install npm@7 

# Install cross environment
RUN npm install -g cross-env

# Install all other dependnacies
RUN npm install --no-bin-links

EXPOSE 9090
