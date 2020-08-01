FROM rust:1.45 AS librespot

RUN apt-get update \
 && apt-get -y install build-essential portaudio19-dev curl unzip \
 && apt-get clean && rm -fR /var/lib/apt/lists

ARG LIBRESPOT_VERSION=0.1.3

RUN cargo install librespot --version ${LIBRESPOT_VERSION}

FROM ubuntu:bionic

RUN apt-get update \
 && apt-get -y install curl libportaudio2 libvorbis0a libavahi-client3 libflac8 libvorbisenc2 libvorbisfile3 libopus0 \
 && apt-get clean && rm -fR /var/lib/apt/lists

ARG ARCH=amd64
ARG SNAPCAST_VERSION=0.20.0

RUN curl -sL -o /tmp/snapserver.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/snapserver_${SNAPCAST_VERSION}-1_${ARCH}.deb \
 && dpkg -i /tmp/snapserver.deb \
 && rm /tmp/snapserver.deb

COPY --from=librespot /usr/local/cargo/bin/librespot /usr/local/bin/

COPY run.sh /
CMD ["/run.sh"]

ENV DEVICE_NAME=Snapcast
EXPOSE 1704/tcp 1705/tcp
