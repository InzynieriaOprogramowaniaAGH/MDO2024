FROM alpine:latest

RUN apk update && apk add git 

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024.git /my_repository

WORKDIR /my_repository

