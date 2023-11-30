FROM --platform=linux/amd64 ubuntu:20.04
#FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/runtime-deps:6.0 as build


# Replace value with the latest runner release version
# source: https://github.com/actions/runner/releases
# ex: 2.303.0
ARG RUNNER_VERSION=2.311.0
ARG RUNNER_ARCH="x64"
# Replace value with the latest runner-container-hooks release version
# source: https://github.com/actions/runner-container-hooks/releases
# ex: 0.3.1
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.5.0

# Set non-interactive frontend for apt-get (prevents tzdata prompt)
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for non-interactive installation
ENV CHROMEDRIVER_DIR="/opt/chromedriver" \
    PATH="/opt/google-chrome/chrome-linux64:/opt/chromedriver/chromedriver-linux64:$PATH"
ENV RUNNER_MANUALLY_TRAP_SIG=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    sudo \
    lsb-release \
    curl \
    tar \
    unzip \
    ca-certificates \
    wget \
    apt-utils \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*


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



WORKDIR /home/runner

# Copy the installation script for Google Chrome
COPY install-chrome-driver.sh /usr/local/bin/install-chrome.sh
COPY install-edge.sh /usr/local/bin/install-edge.sh
COPY install-chrome-driver.sh /usr/local/bin/install-chrome-driver.sh

RUN sudo chmod +x /usr/local/bin/install-chrome-driver.sh
RUN sudo chmod +x /usr/local/bin/install-edge.sh
RUN sudo chmod +x /usr/local/bin/install-chrome.sh

RUN sudo /usr/local/bin/install-chrome.sh
RUN sudo /usr/local/bin/install-chrome-driver.sh $CHROMEDRIVER_DIR
RUN sudo /usr/local/bin/install-edge.sh

# Add ChromeDriver directories to PATH
ENV PATH=$PATH:$CHROMEDRIVER_DIR

RUN sudo apt update -y \
    && sudo apt install -y --no-install-recommends \
        apt-transport-https \
        bash \
        coreutils \
        dbus \
        docker \
        file \
        gcc \
        git \
        iproute2 \
        iptables \
        jq \
        libc6 \
        libglu1-mesa \
        libyaml-dev \
        locales \
        lsb-release \
        openssl \
        pigz \
        pkg-config \
        snapd \
        software-properties-common \
        sudo \
        time \
        tzdata \
        uidmap \
        xz-utils \
        software-properties-common \
        apt-transport-https \
        zip \
        && sudo apt clean \
        && sudo rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.9-stable.tar.xz -o flutter.tar.xz \
    && tar xf flutter.tar.xz -C .  \
    && rm flutter.tar.xz

ENV PATH="$PATH:/home/runner/flutter/bin"


