FROM ghcr.io/anomalyco/opencode:latest

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3 \
    git \
    curl \
    wget \
    jq \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade pip

RUN pip install --no-cache-dir \
    requests \
    pandas \
    numpy \
    black \
    flake8 \
    pytest \
    ipython

RUN git config --global user.name "OpenCode Agent" && \
    git config --global user.email "agent@opencode.local"

WORKDIR /workspace
ENTRYPOINT ["opencode"]
