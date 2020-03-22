FROM rust:1.42 AS librespot

RUN apt-get update \
 && apt-get -y install build-essential portaudio19-dev curl unzip \
 && apt-get clean && rm -fR /var/lib/apt/lists

ARG LIBRESPOT_VERSION=0.1.1

RUN cd /tmp \
 && curl -sLO https://github.com/librespot-org/librespot/archive/v0.1.1.zip \
 && unzip v${LIBRESPOT_VERSION}.zip \
 && cd librespot-${LIBRESPOT_VERSION} \
 && cargo build --release \
 && chmod +x target/release/librespot

FROM ubuntu:bionic

RUN apt-get update \
 && apt-get -y install curl libportaudio2 libvorbis0a libavahi-client3 libflac8 libvorbisenc2 libvorbisfile3 libopus0 \
 && apt-get clean && rm -fR /var/lib/apt/lists

ARG ARCH=amd64
ARG SNAPCAST_VERSION=0.19.0
ARG LIBRESPOT_VERSION=0.1.1

RUN curl -sL -o /tmp/snapserver.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/snapserver_${SNAPCAST_VERSION}-1_${ARCH}.deb \
 && dpkg -i /tmp/snapserver.deb \
 && rm /tmp/snapserver.deb

COPY --from=librespot /tmp/librespot-${LIBRESPOT_VERSION}/target/release/librespot /usr/local/bin/

ADD init.sh /
RUN chmod +x /init.sh
CMD ["/init.sh"]

ENV DEVICE_NAME=Snapcast
EXPOSE 1704/tcp 1705/tcp
