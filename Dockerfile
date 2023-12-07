FROM  --platform=linux/amd64 ubuntu:jammy-20231128

# Set non-interactive frontend for apt-get (prevents tzdata prompt)
ENV DEBIAN_FRONTEND=noninteractive

# Set up environment variables
ENV CHROMEDRIVER_DIR="/opt/chromedriver" \
    PATH="/opt/google-chrome/chrome-linux64:/opt/chromedriver/chromedriver-linux64:$PATH"
# Update and install only the necessary packages

RUN apt update -y \
    && apt install -y --no-install-recommends \
        wget \
        curl \
        unzip \
        ca-certificates \
        gnupg2 \
        sudo \
        libgbm-dev \
        xz-utils \
        git

# Create a non-root user
RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && usermod -aG sudo runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers

USER runner

# Install Chrome and ChromeDriver
COPY install-chrome.sh /usr/local/bin/install-chrome.sh
COPY install-chrome-driver.sh /usr/local/bin/install-chrome-driver.sh

RUN sudo chmod +x /usr/local/bin/install-chrome.sh \
    && sudo chmod +x /usr/local/bin/install-chrome-driver.sh \
    && sudo /usr/local/bin/install-chrome.sh \
    && sudo /usr/local/bin/install-chrome-driver.sh $CHROMEDRIVER_DIR

# Set environment variables for Chrome
ENV CHROME_BIN=/usr/bin/google-chrome \
    CHROME_PATH=/usr/lib/google-chrome/

# Install Flutter
RUN curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.9-stable.tar.xz -o flutter.tar.xz \
    && tar xf flutter.tar.xz -C . \
    && rm flutter.tar.xz

ENV PATH="$PATH:/home/runner/flutter/bin"

RUN    sudo apt clean \
        && sudo rm -rf /var/lib/apt/lists/*
