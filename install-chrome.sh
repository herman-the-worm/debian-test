#!/bin/bash
set -e

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
apt-get update -y && apt-get install -y \
    --no-install-recommends --fix-missing \
     google-chrome-stable
