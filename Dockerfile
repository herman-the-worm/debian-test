FROM  --platform=linux/amd64 ubuntu:jammy-20231128

# Set non-interactive frontend for apt-get (prevents tzdata prompt)
ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_MANUALLY_TRAP_SIG=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1
ARG TARGETOS=linux
ARG RUNNER_ARCH="x64"
ARG TARGETARCH=amd64
ARG RUNNER_VERSION=2.311.0
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.5.0
ARG DOCKER_VERSION=24.0.6
ARG BUILDX_VERSION=0.11.2


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
        tar \
        sudo \
        libgbm-dev \
        xz-utils \
        git

RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && groupadd docker --gid 123 \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

WORKDIR /home/runner

RUN curl -f -L -o runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./runner.tar.gz \
    && rm runner.tar.gz

RUN curl -f -L -o runner-container-hooks.zip https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${RUNNER_CONTAINER_HOOKS_VERSION}.zip \
    && unzip ./runner-container-hooks.zip -d ./k8s \
    && rm runner-container-hooks.zip

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
RUN sudo curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.9-stable.tar.xz -o flutter.tar.xz \
    && sudo tar xf flutter.tar.xz -C . \
    && sudo rm flutter.tar.xz

ENV PATH="$PATH:/home/runner/flutter/bin"

RUN    sudo apt clean \
        && sudo rm -rf /var/lib/apt/lists/*

RUN sudo chmod 777 /home/runner/* -R
RUN sudo sudo chown -R runner:runner /home/runner
