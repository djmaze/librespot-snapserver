# librespot-snapserver

Run a [Snapcast](https://github.com/badaix/snapcast) server with [Spotify support](https://github.com/plietar/librespot) as a Docker container.

This is a multi-arch image currently working on the `amd64` and `armhf` platforms. This means you can use the same image regardless of platform.

_Note: You need a Spotify premium account._

## Usage

Run it like this (on your PC or ARM-based device):

    docker run -d --name snapserver --net host -e DEVICE_NAME=Snapcast mazzolino/librespot-snapserver

That will make the device available to all Spotify clients in your network. Add your Spotify credentials in order to limit control to clients logged in with your account:

    docker run -d --name snapserver --net host -e DEVICE_NAME=Snapcast -e USERNAME=my-spotify-username -e PASSWORD=my-spotify-password mazzolino/librespot-snapserver

Now you can connect your snapclient to your host's ip. The receiver should show up in Spotify under the `DEVICE_NAME` given above (e.g. `Snapcast`). Have fun playing music!

## Building the images

* The following lines will build _and push_ your image. Use the `build` make target in order to just build the image locally.
* Replace `my/image` with your own image name.

On your ARM device:

    sudo make IMAGE_NAME=my/image ARCH=armhf

Then, on your PC:

    sudo make IMAGE_NAME=my/image
    make manifest IMAGE_NAME=my/image

Notes:

* Add `SNAPCAST_VERSION=x.xx.x` in order to build a different version of snapcast or `LIBRESPOT_VERSION=x.x.x` to build a different version of librespot.
