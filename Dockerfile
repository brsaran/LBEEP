FROM alpine:3.15.0

RUN apk update && apk add perl-app-cpanminus openjdk17-jre-headless

COPY . /app

WORKDIR /app

RUN mkdir temp && chmod 777 temp

ENTRYPOINT ["/app/LBEEP"]
