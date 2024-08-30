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

### Login problems?

It might be necessary to get a credentials file instead of using username and password. See [this issue](https://github.com/librespot-org/librespot/issues/1308) for more details.

1. Use [this tool](https://github.com/dspearson/librespot-auth) to get the file `credentials.json`.
2. Mount it into your container and use the `CACHE` option, like this:

    ```bash
    docker run -d --name snapserver --net host -e DEVICE_NAME=Snapcast -e CACHE=/data -v /path/to/credentials.json:/data/credentials.json mazzolino/librespot-snapserver
    ```

### Custom configuration

If you want to configure the snapcast server differently, you can mount your own `snapserver.conf` into the container:

```bash
docker run -d --name snapserver --net host -v /path/to/your/snapserver.conf:/etc/snapserver.conf:ro mazzolino/librespot-snapserver
```

NOTE: The configuration file needs to be mounted *read-only* for this to work.

Make sure to include a Spotify source in your configuration, like this:

```
[stream]
source = librespot:///librespot?name=Spotify&devicename=DEVICE_NAME&bitrate=320&volume=100&username=USERNAME&password=PASSWORD
```

(Replace `DEVICE_NAME`, `USERNAME` and `PASSWORD` accordingly.)

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
