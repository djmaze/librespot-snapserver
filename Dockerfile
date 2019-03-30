FROM rust:1.27 AS librespot

RUN apt-get update \
 && apt-get -y install build-essential portaudio19-dev curl unzip \
 && apt-get clean && rm -fR /var/lib/apt/lists

RUN cd /tmp \
 && curl -sLO https://github.com/librespot-org/librespot/archive/master.zip \
 && unzip master.zip \
 && cd librespot-master \
 && cargo build --release \
 && chmod +x /tmp/librespot-master/target/release/librespot

FROM ubuntu

RUN apt-get update \
 && apt-get -y install curl libportaudio2 libvorbis0a libavahi-client3 libflac8 libvorbisenc2 libvorbisfile3 \
 && apt-get clean && rm -fR /var/lib/apt/lists

ARG ARCH=amd64
ARG SNAPCAST_VERSION=0.11.1

RUN curl -sL -o /tmp/snapserver.deb https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/snapserver_${SNAPCAST_VERSION}_${ARCH}.deb \
 && dpkg -i /tmp/snapserver.deb \
 && rm /tmp/snapserver.deb

COPY --from=librespot /tmp/librespot-master/target/release/librespot /usr/local/bin/

ENTRYPOINT ["snapserver"]
EXPOSE 1704/tcp 1705/tcp
