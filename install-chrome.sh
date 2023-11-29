#!/bin/bash
set -e

# Assign arguments to variables
CHROME_DIR=$1
CHROMEDRIVER_DIR=$2



# Update and install dependencies for Google Chrome
sudo apt-get update -y && sudo apt-get install -y --no-install-recommends --fix-missing \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libcurl3-gnutls \
    libcurl3-nss \
    libcurl4 \
    libdbus-1-3 \
    libdrm2 \
    libexpat1 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libu2f-udev \
    libvulkan1 \
    libx11-6 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    wget \
    xdg-utils \
    jq \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/*

# Create directories for Chrome and ChromeDriver
mkdir -p $CHROME_DIR
mkdir -p $CHROMEDRIVER_DIR

# Download the webpage
curl -s https://googlechromelabs.github.io/chrome-for-testing/ -o chrome-for-testing.html

# Extract the download URL for Google Chrome and ChromeDriver for Linux 64-bit
CHROME_URL=$(grep -oP 'https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/linux64/chrome-linux64.zip' chrome-for-testing.html | head -n 1)
CHROMEDRIVER_URL=$(grep -oP 'https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/linux64/chromedriver-linux64.zip' chrome-for-testing.html | head -n 1)

# Download and unzip Google Chrome
wget $CHROME_URL -O chrome.zip
unzip chrome.zip -d $CHROME_DIR
rm chrome.zip

# Download and unzip ChromeDriver
wget $CHROMEDRIVER_URL -O chromedriver.zip
unzip chromedriver.zip -d $CHROMEDRIVER_DIR
rm chromedriver.zip
