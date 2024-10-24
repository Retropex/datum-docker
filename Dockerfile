FROM debian:bookworm-slim AS build

RUN apt update &&     apt-get install -y build-essential cmake curl libmicrohttpd-dev libjansson-dev                        libcurl4-openssl-dev libpq-dev libgcrypt20-dev libsodium-dev                        netcat-traditional pkg-config git

ARG ARCH
ARG PLATFORM

COPY /.git /parent_dir/.git

ADD ./datum_gateway /parent_dir/datum_gateway
WORKDIR /parent_dir/datum_gateway
RUN git status
RUN cmake . && make

FROM debian:bookworm-slim AS base

RUN apt update

RUN apt install libmicrohttpd12 libjansson4 libsodium23 curl -y

WORKDIR /app

COPY --from=build /parent_dir/datum_gateway/datum_gateway /usr/local/bin/datum_gateway

LABEL org.opencontainers.image.source https://github.com/retropex/datum-docker

LABEL org.opencontainers.image.description Datum in a container

CMD [datum_gateway]
