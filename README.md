# librespot-snapserver

Run a [Snapcast](https://github.com/badaix/snapcast) server with [Spotify support](https://github.com/librespot-org/librespot) as a Docker container.

This is a multi-arch image currently working on the `amd64` and `armhf` platforms. This means you can use the same image regardless of platform.

_Note: You need a Spotify premium account._

## Usage

Run it like this (on your PC or ARM-based device):

    docker run -d --name snapserver --net host -e DEVICE_NAME=Snapcast mazzolino/librespot-snapserver

That will make the device available to all Spotify clients in your network. Add your Spotify credentials in order to limit control to clients logged in with your account:

    docker run -d --name snapserver --net host -e DEVICE_NAME=Snapcast -e USERNAME=my-spotify-username -e PASSWORD=my-spotify-password mazzolino/librespot-snapserver

Now you can connect your snapclient to your host's ip. The receiver should show up in Spotify under the `DEVICE_NAME` given above (e.g. `Snapcast`). Have fun playing music!

## Building the images

In order to build images for the non-amd64 architectures, you need to build on amd64 machine and enable qemu binfmt support. The easiest way for this is to run:

```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

The following command will build the images for all supported architectures. Replace `my/image` with your own image name:

```bash
docker buildx build --platform=linux/amd64,linux/arm/v7,linux/arm64 -t my/image --load .
```

To build only an image for the current architecture, run:

```bash
docker buildx build -t my/image --load .
```
