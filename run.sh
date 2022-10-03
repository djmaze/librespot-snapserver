#!/bin/bash
set -euo pipefail

# Change snapserver source to Spotify only if the configuration file is writable
# This allows bind-mounting a custom configuration file (must use "ro" mode)
if [ -w /etc/snapserver.conf ]; then
  credentials=""
  if [[ -n "${USERNAME:-}" ]] && [[ -n "${PASSWORD:-}" ]]; then
    credentials="\&username=$USERNAME\&password=$PASSWORD"
  fi

  sed -i "s,^source = .*,source = librespot:///librespot?name=Spotify\&devicename=$DEVICE_NAME\&bitrate=320\&volume=100$credentials," /etc/snapserver.conf
fi

exec snapserver
