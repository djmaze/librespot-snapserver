#!/bin/bash
set -euo pipefail

exec cargo install librespot --version "${LIBRESPOT_VERSION}"
