FROM node:18-alpine3.18


RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev bash git python3 pixman-dev cairo-dev pango-dev

ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}


ENV SHARP_IGNORE_GLOBAL_LIBVIPS=1
ENV npm_config_arch=arm64
ENV npm_config_platform=linuxmusl

WORKDIR /opt/app

COPY package.json package-lock.json ./

RUN npm install -g node-gyp
RUN npm config set fetch-retry-maxtimeout 600000 -g 
RUN npm install --platform=linuxmusl --arch=arm64 sharp
RUN npm install

ENV PATH /opt/node_modules/.bin:$PATH

COPY . .

RUN chown -R node:node /opt/app

USER node

RUN ["npm", "run", "build"]

EXPOSE 1337

CMD ["npm", "run", "develop"]
