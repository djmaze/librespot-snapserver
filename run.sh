#!/bin/bash
set -euo pipefail

# On alpine the snapserver.conf is located at /usr/etc/snapserver.conf
# This allows bind-mounting a custom configuration file to /etc/snapserver.conf

if [ -e /etc/snapserver.conf ]; then
  # If a custom configuration exists, symlink it
  ln -sf /etc/snapserver.conf  /usr/etc/snapserver.conf
else
  # Change snapserver source to Spotify only if no custom configuration is mounted
  credentials=""
  if [[ -n "${USERNAME:-}" ]] && [[ -n "${PASSWORD:-}" ]]; then
    credentials="\&username=$USERNAME\&password=$PASSWORD"
  elif [[ -n "${CACHE:-}" ]]; then
    credentials="\&cache=$CACHE"
  fi

  sed -i "s,^source = .*,source = librespot:///librespot?name=Spotify\&devicename=$DEVICE_NAME\&bitrate=320\&volume=100$credentials," /usr/etc/snapserver.conf
fi

exec snapserver -c /usr/etc/snapserver.conf
