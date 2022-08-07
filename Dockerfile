FROM rust:1.62-bullseye AS librespot

RUN apt-get update \
 && apt-get -y install build-essential portaudio19-dev curl \
 && apt-get clean && rm -fR /var/lib/apt/lists

ARG LIBRESPOT_VERSION=0.4.2

COPY ./install-librespot.sh /tmp/
RUN --mount=type=tmpfs,target=/usr/local/cargo/registry/index /tmp/install-librespot.sh

###

FROM debian:bullseye

RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >/etc/apt/sources.list.d/bullseye-backports.list

RUN apt-get update \
 && apt-get -y install snapserver/bullseye-backports \
 && apt-get clean && rm -fR /var/lib/apt/lists

COPY --from=librespot /usr/local/cargo/bin/librespot /usr/local/bin/

COPY run.sh /
CMD ["/run.sh"]

ENV DEVICE_NAME=Snapcast
EXPOSE 1704/tcp 1705/tcp
