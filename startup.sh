#!/bin/bash
set -euo pipefail

[ -z "$PORT" ] && echo "Expected PORT to be set by the environment" && exit 1
[ -z "$API_KEY" ] && echo "Expected API_KEY to be set by the environment" && exit 1

# Substitute the $PORT and $API_KEY environment variables supplied at runtime.
# This is useful for virtually hosted environments where the port cannot be known ahead of time.

eval "cat <<EOF
$(<config-template.json)
EOF
" > config.json

# Run the Engine proxy, passing in the current config
./engineproxy_linux_amd64 -config config.json
