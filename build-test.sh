#!/bin/bash

set -euo pipefail

TEA_VERSION=$(curl -s https://gitea.com/api/v1/repos/gitea/tea/releases/latest | jq -r '.tag_name' | sed 's/^v//')

if [ -z "${TEA_VERSION}" ]; then
    echo "Failed to fetch version, building with tag 'latest'..."
    docker build --no-cache -t localhost:35876/jpr-tea:latest .
else
    echo "Building TEA version ${TEA_VERSION}..."
    docker build --network=host \
        --no-cache \
        --progress=plain \
        -f Dockerfile.test \
        --build-arg TEA_VERSION="${TEA_VERSION}" \
        -t "localhost:35876/jpr-test:${TEA_VERSION}" \
        -t localhost:35876/jpr-test:latest .
fi

