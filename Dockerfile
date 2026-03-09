FROM ghcr.io/anomalyco/opencode:latest

RUN set -eux; \
    if command -v apk >/dev/null 2>&1; then \
        apk add --no-cache \
            python3 \
            py3-pip \
            py3-virtualenv \
            git \
            curl \
            wget \
            jq \
            vim; \
    elif command -v apt-get >/dev/null 2>&1; then \
        apt-get update && apt-get install -y \
            python3 \
            python3-pip \
            python3-venv \
            python-is-python3 \
            git \
            curl \
            wget \
            jq \
            vim \
            && rm -rf /var/lib/apt/lists/*; \
    else \
        echo "Unsupported base image: no apk or apt-get found" >&2; \
        exit 1; \
    fi; \
    if ! command -v python >/dev/null 2>&1; then \
        ln -sf "$(command -v python3)" /usr/local/bin/python; \
    fi

ENV PATH="/opt/venv/bin:${PATH}"

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/python -m pip install --upgrade pip

RUN /opt/venv/bin/pip install --no-cache-dir \
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
