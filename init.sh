#!/bin/bash
snapserver -d
librespot -n $DEVICE_NAME -b 320 --backend pipe > /tmp/snapfifo