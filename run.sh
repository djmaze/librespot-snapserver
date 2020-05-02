#!/bin/bash
set -euo pipefail

sed -i "s,^stream = .*,stream = librespot:///librespot?name=Spotify\&devicename=$DEVICE_NAME\&bitrate=320\&volume=100," /etc/snapserver.conf

snapserver
