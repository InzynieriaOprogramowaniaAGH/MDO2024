FROM node:16-alpine
RUN apk add git
RUN git clone https://github.com/devenes/node-js-dummy-test.git
WORKDIR node-js-dummy-test
RUN npm install
