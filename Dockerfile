# syntax=docker/dockerfile:1

ARG NODE_VERSION=18.17.1

### FIRST STAGE
FROM node:${NODE_VERSION}-alpine as development

WORKDIR /usr/src/app

COPY package*.json .

RUN npm install

# Copy the rest of the source files into the image.
COPY . .

RUN npm run build


### SECOND STAGE
FROM node:${NODE_VERSION}-alpine as production

# Use production node environment by default.
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json .

RUN npm ci --only=production

COPY --from=development /usr/src/app/dist ./dist

CMD ["node", "dist/index.js"]
