# Optimized Dockerfile for OpenCode Development Environment (Alpine Linux)
FROM ghcr.io/anomalyco/opencode:latest

# System packages - keeps index for runtime installs
# Alpine uses apk, minimal packages to reduce size
RUN apk update && \
    apk add \
    python3 \
    py3-pip \
    git \
    curl \
    jq \
    && rm -rf /var/cache/apk/*.apk /tmp/* /var/tmp/*

# Python packages - PEP 668 workaround
# --break-system-packages is safe in isolated container
# --prefer-binary uses precompiled wheels for faster installs
RUN python3 -m pip install --upgrade pip --no-cache-dir --break-system-packages && \
    pip install --no-cache-dir --prefer-binary --break-system-packages \
    requests \
    pandas \
    numpy \
    black \
    flake8 \
    pytest \
    ipython

# Git configuration
RUN git config --global user.name "OpenCode Agent" && \
    git config --global user.email "agent@opencode.local" && \
    git config --global core.autocrlf false && \
    git config --global init.defaultBranch main

WORKDIR /workspace
ENTRYPOINT ["opencode"]
