#!/bin/bash
set -Euo pipefail
# Run the Engine proxy, passing in the current config
./engineproxy_linux_amd64 -config config.json
