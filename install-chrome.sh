#!/bin/bash
set -e

# Download and install Google Chrome
CHROME_DEB_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
CHROME_DEB_PATH="/tmp/google-chrome-stable_current_amd64.deb"
curl -o $CHROME_DEB_PATH $CHROME_DEB_URL
apt update -y \
    && apt install -y $CHROME_DEB_PATH
rm -f $CHROME_DEB_PATH

## Get Chrome versions information
#CHROME_PLATFORM="linux64"
#CHROME_VERSIONS_URL="https://googlechromelabs.github.io/chrome-for-testing/latest-patch-versions-per-build-with-downloads.json"
#CHROME_VERSIONS_JSON=$(curl -fsSL "${CHROME_VERSIONS_URL}")
#
## Extract Chrome version from the JSON
#CHROME_VERSION=$(echo "${CHROME_VERSIONS_JSON}" | jq -r '.latest_patch_version')
#
## Download and install ChromeDriver
#CHROMEDRIVER_VERSION=$(echo "${CHROME_VERSIONS_JSON}" | jq -r '.builds["'"$CHROME_VERSION"'"].version')
#CHROMEDRIVER_URL=$(echo "${CHROME_VERSIONS_JSON}" | jq -r '.builds["'"$CHROME_VERSION"'"].downloads.chromedriver[] | select(.platform=="'"${CHROME_PLATFORM}"'").url')
#CHROMEDRIVER_DIR="/usr/local/share/chromedriver-linux64"
#CHROMEDRIVER_BIN="$CHROMEDRIVER_DIR/chromedriver"
#
#echo "Installing ChromeDriver version $CHROMEDRIVER_VERSION"
#curl -fsSL -o /tmp/chromedriver.zip $CHROMEDRIVER_URL
#mkdir -p $CHROMEDRIVER_DIR
#unzip -qq /tmp/chromedriver.zip -d $CHROMEDRIVER_DIR
#rm /tmp/chromedriver.zip
#
#chmod +x $CHROMEDRIVER_BIN
#ln -s $CHROMEDRIVER_BIN /usr/bin/chromedriver
#
## Set CHROMEWEBDRIVER environment variable
#echo 'export CHROMEWEBDRIVER='${CHROMEDRIVER_DIR} >> /etc/environment
#
## Download and install Chromium
#CHROME_REVISION=$(echo "${CHROME_VERSIONS_JSON}" | jq -r '.builds["'"$CHROME_VERSION"'"].revision')
#CHROMIUM_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F${CHROME_REVISION}%2Fchrome-linux.zip?alt=media"
#CHROMIUM_DIR="/usr/local/share/chromium"
#CHROMIUM_BIN="${CHROMIUM_DIR}/chrome-linux/chrome"
#
#echo "Installing Chromium revision $CHROME_REVISION"
#curl -fsSL -o /tmp/chromium.zip $CHROMIUM_URL
#mkdir -p $CHROMIUM_DIR
#unzip -qq /tmp/chromium.zip -d $CHROMIUM_DIR
#rm /tmp/chromium.zip
#
#ln -s $CHROMIUM_BIN /usr/bin/chromium
#ln -s $CHROMIUM_BIN /usr/bin/chromium-browser
