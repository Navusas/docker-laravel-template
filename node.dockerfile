FROM node:15.2-alpine

WORKDIR /var/www

# Create layer to cache the occasionally changing dependencies
COPY ./src/package*.json ./

RUN npm install
#RUN npm install -g nodemon

ENV NODE_ENV=development

EXPOSE 9090

CMD ["npm", "run", "dev"]
#CMD ["nodemon", "-L"]

