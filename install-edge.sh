#!/bin/bash
set -e
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -

sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-stable.list'

apt-get update -y && apt-get install -y \
    --fix-missing \
    microsoft-edge-stable