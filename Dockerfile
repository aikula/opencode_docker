# TODO: pin to a specific version tag for reproducible builds
# Check available tags: https://github.com/anomalyco/opencode/pkgs/container/opencode
# Example: FROM ghcr.io/anomalyco/opencode:0.3.85
FROM ghcr.io/anomalyco/opencode:latest

RUN set -eux; \
    if command -v apk >/dev/null 2>&1; then \
        apk add --no-cache \
            gcompat \
            libc6-compat \
            python3 \
            py3-pip \
            py3-virtualenv \
            git \
            curl \
            wget \
            jq \
            vim \
            docker-cli; \
        ln -sf /usr/bin/python3 /usr/bin/python; \
    elif command -v apt-get >/dev/null 2>&1; then \
        apt-get update; \
        apt-get install -y --no-install-recommends \
            python3 \
            python3-pip \
            python3-venv \
            python-is-python3 \
            git \
            curl \
            wget \
            jq \
            vim \
            docker.io; \
        rm -rf /var/lib/apt/lists/*; \
    else \
        echo "Unsupported base image: neither apk nor apt-get found" >&2; \
        exit 1; \
    fi

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python3 -m venv "$VIRTUAL_ENV"

RUN "$VIRTUAL_ENV/bin/python" -m pip install --upgrade pip

RUN "$VIRTUAL_ENV/bin/pip" install --no-cache-dir \
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
