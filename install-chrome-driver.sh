#!/bin/bash
set -e

## Assign arguments to variables
CHROMEDRIVER_DIR="/opt/chromedriver"


# Create directories for  ChromeDriver
mkdir -p $CHROMEDRIVER_DIR

# Download the webpage
curl -s https://googlechromelabs.github.io/chrome-for-testing/ -o chrome-for-testing.html

# Extract the download URL for Google Chrome and ChromeDriver for Linux 64-bit
CHROMEDRIVER_URL=$(grep -oP 'https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/linux64/chromedriver-linux64.zip' chrome-for-testing.html | head -n 1)

# Download and unzip ChromeDriver
wget $CHROMEDRIVER_URL -O chromedriver.zip
unzip -o chromedriver.zip -d $CHROMEDRIVER_DIR
rm chromedriver.zip
