#!/bin/bash
snapserver -d --stream.sampleformat=44100:16:2
librespot -n $DEVICE_NAME -b 320 --backend pipe > /tmp/snapfifo
