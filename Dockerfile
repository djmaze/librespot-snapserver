FROM rust:1.45 AS librespot

RUN apt-get update \
 && apt-get -y install build-essential portaudio19-dev curl unzip \
 && apt-get clean && rm -fR /var/lib/apt/lists

ARG ARCH=amd64
ARG LIBRESPOT_VERSION=0.1.3

COPY ./install-librespot.sh /tmp/
RUN /tmp/install-librespot.sh

FROM debian:sid

RUN apt-get update \
 && apt-get -y install snapserver \
 && apt-get clean && rm -fR /var/lib/apt/lists

COPY --from=librespot /usr/local/cargo/bin/librespot /usr/local/bin/

COPY run.sh /
CMD ["/run.sh"]

ENV DEVICE_NAME=Snapcast
EXPOSE 1704/tcp 1705/tcp
