FROM alpine:3.18.6

RUN apk update && apk upgrade
RUN apk add vim nginx

RUN mkdir -p /etc/nginx/ssl
RUN apk add openssl
