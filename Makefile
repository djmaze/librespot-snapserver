ARCH=amd64
SNAPCAST_VERSION=0.14.0
IMAGE_NAME=mazzolino/librespot-snapserver

MANIFEST_IMAGE=${IMAGE_NAME}:${SNAPCAST_VERSION}
LATEST_MANIFEST_IMAGE=${IMAGE_NAME}:latest

ARCH_IMAGE=${MANIFEST_IMAGE}-${ARCH}
LATEST_ARCH_IMAGE=${LATEST_MANIFEST_IMAGE}-${ARCH}

IMAGE_TEMPLATE=${MANIFEST_IMAGE}-ARCH
LATEST_IMAGE_TEMPLATE=${LATEST_MANIFEST_IMAGE}-ARCH

push: build
		docker push ${ARCH_IMAGE}
		docker push ${LATEST_ARCH_IMAGE}
ifeq ($(ARCH),armhf)
		docker push ${MANIFEST_IMAGE}-arm
		docker push ${LATEST_MANIFEST_IMAGE}-arm
endif


build:
		docker build -t ${ARCH_IMAGE} --build-arg ARCH=${ARCH} --build-arg SNAPCAST_VERSION=${SNAPCAST_VERSION} .
		docker tag ${ARCH_IMAGE} ${LATEST_ARCH_IMAGE}
ifeq ($(ARCH),armhf)
		docker tag ${MANIFEST_IMAGE}-armhf ${MANIFEST_IMAGE}-arm
		docker tag ${LATEST_MANIFEST_IMAGE}-armhf ${LATEST_MANIFEST_IMAGE}-arm
endif

manifest:
		manifest-tool push from-args --platforms linux/amd64,linux/arm --template ${IMAGE_TEMPLATE} --target ${MANIFEST_IMAGE}
		manifest-tool push from-args --platforms linux/amd64,linux/arm --template ${LATEST_IMAGE_TEMPLATE} --target ${LATEST_MANIFEST_IMAGE}
