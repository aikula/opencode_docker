#!/bin/bash
set -e

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$INSTALL_DIR"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Установка OpenCode Launcher"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Создать директории
mkdir -p data/{auth,config,cache}

# 1. CLI СКРИПТ
cat > opencode << 'EOF'
#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"
CONTAINER_NAME="opencode-${PROJECT_NAME}"

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🚀 OpenCode CLI${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "📁 Проект:      ${GREEN}$PROJECT_NAME${NC}"
echo -e "📂 Директория:  ${BLUE}$PROJECT_DIR${NC}"
echo -e "🐳 Контейнер:   ${GREEN}$CONTAINER_NAME${NC}"
echo ""

if [ -f "$SCRIPT_DIR/.env" ]; then
    set -a; source "$SCRIPT_DIR/.env"; set +a
    echo -e "${GREEN}✅ Конфигурация: $SCRIPT_DIR/.env${NC}"
else
    echo -e "${RED}❌ Файл .env не найден${NC}"; exit 1
fi

if [ -z "$OPENCODE_API_KEY" ] || [ "$OPENCODE_API_KEY" = "sk-" ]; then
    echo -e "${YELLOW}⚠️  OPENCODE_API_KEY не настроен!${NC}"; exit 1
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Запуск OpenCode CLI...${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

docker run -it --rm \
    --name "$CONTAINER_NAME" \
    -v "$SCRIPT_DIR/data/auth:/root/.local/share/opencode" \
    -v "$SCRIPT_DIR/data/config:/root/.config/opencode" \
    -v "$SCRIPT_DIR/data/cache:/root/.cache/opencode" \
    -v "$PROJECT_DIR:/workspace" \
    -v "$HOME/.ssh:/root/.ssh:ro" \
    -w /workspace \
    -e OPENCODE_API_KEY="$OPENCODE_API_KEY" \
    -e LLM_PROVIDER="${LLM_PROVIDER:-opencode}" \
    -e GH_TOKEN="$GH_TOKEN" \
    -e GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME:-OpenCode Agent}" \
    -e GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-agent@opencode.local}" \
    ghcr.io/anomalyco/opencode:latest

echo ""
echo -e "${GREEN}✅ OpenCode завершен${NC}"
EOF

# 2. WEB СКРИПТ
cat > opencode-web << 'EOF'
#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"
CONTAINER_NAME="opencode-web-${PROJECT_NAME}"

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🌐 OpenCode Web Interface${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "📁 Проект:      ${GREEN}$PROJECT_NAME${NC}"
echo -e "📂 Директория:  ${BLUE}$PROJECT_DIR${NC}"
echo -e "🐳 Контейнер:   ${GREEN}$CONTAINER_NAME${NC}"
echo ""

if [ -f "$SCRIPT_DIR/.env" ]; then
    set -a; source "$SCRIPT_DIR/.env"; set +a
else
    echo -e "${RED}❌ Файл .env не найден${NC}"; exit 1
fi

if [ -z "$OPENCODE_API_KEY" ] || [ "$OPENCODE_API_KEY" = "sk-" ]; then
    echo -e "${YELLOW}⚠️  OPENCODE_API_KEY не настроен!${NC}"; exit 1
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🌐 Веб-интерфейс запускается...${NC}"
echo ""
echo -e "   URL:    ${BLUE}http://localhost:7777${NC}"
echo -e "   Логин:  ${GREEN}opencode${NC}"
echo -e "   Пароль: ${GREEN}${OPENCODE_SERVER_PASSWORD:-me482482}${NC}"
echo ""
echo -e "${YELLOW}Нажмите Ctrl+C для остановки${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

DETACH=""
if [ "$1" = "-d" ] || [ "$1" = "--detach" ]; then
    DETACH="-d"
    IT_FLAG=""
    echo -e "${BLUE}Запуск в фоновом режиме...${NC}"
else
    IT_FLAG="-it"
fi

docker run $DETACH $IT_FLAG --rm \
    --name "$CONTAINER_NAME" \
    -p 127.0.0.1:7777:7777 \
    -v "$SCRIPT_DIR/data/auth:/root/.local/share/opencode" \
    -v "$SCRIPT_DIR/data/config:/root/.config/opencode" \
    -v "$SCRIPT_DIR/data/cache:/root/.cache/opencode" \
    -v "$PROJECT_DIR:/workspace" \
    -v "$HOME/.ssh:/root/.ssh:ro" \
    -w /workspace \
    -e OPENCODE_API_KEY="$OPENCODE_API_KEY" \
    -e LLM_PROVIDER="${LLM_PROVIDER:-opencode}" \
    -e OPENCODE_SERVER_PASSWORD="${OPENCODE_SERVER_PASSWORD:-me482482}" \
    -e GH_TOKEN="$GH_TOKEN" \
    ghcr.io/anomalyco/opencode:latest web --port 7777

if [ ! -z "$DETACH" ]; then
    echo ""
    echo -e "${GREEN}✅ Запущен в фоне${NC}"
    echo -e "   Остановить: ${BLUE}opencode-stop${NC}"
    echo -e "   Логи:       ${BLUE}docker logs -f $CONTAINER_NAME${NC}"
fi
EOF

# 3. STOP СКРИПТ
cat > opencode-stop << 'EOF'
#!/bin/bash
GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🛑 Остановка OpenCode контейнеров${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

CONTAINERS=$(docker ps -q --filter "name=opencode-")

if [ -z "$CONTAINERS" ]; then
    echo -e "${YELLOW}⚠️  Нет запущенных контейнеров${NC}"
    exit 0
fi

echo -e "${BLUE}Найдены контейнеры:${NC}"
docker ps --filter "name=opencode-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo -e "${YELLOW}Останавливаю...${NC}"
docker stop $CONTAINERS

echo ""
echo -e "${GREEN}✅ Все контейнеры остановлены${NC}"
EOF

# 4. PS СКРИПТ
cat > opencode-ps << 'EOF'
#!/bin/bash
GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📊 Статус OpenCode контейнеров${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

RUNNING=$(docker ps -q --filter "name=opencode-")
if [ ! -z "$RUNNING" ]; then
    echo -e "${GREEN}🟢 Запущенные:${NC}"
    docker ps --filter "name=opencode-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
fi

STOPPED=$(docker ps -aq --filter "name=opencode-" --filter "status=exited")
if [ ! -z "$STOPPED" ]; then
    echo -e "${YELLOW}🟡 Остановленные:${NC}"
    docker ps -a --filter "name=opencode-" --filter "status=exited" --format "table {{.Names}}\t{{.Status}}"
    echo ""
fi

if [ -z "$RUNNING" ] && [ -z "$STOPPED" ]; then
    echo -e "${YELLOW}⚠️  Нет контейнеров OpenCode${NC}"
fi
EOF

# 5. BUILD СКРИПТ
cat > opencode-build << 'EOF'
#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🔨 Сборка OpenCode образа с Python${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

cd "$SCRIPT_DIR"
echo -e "${BLUE}Сборка образа...${NC}"
docker build -t opencode-python:latest .

echo ""
echo -e "${GREEN}✅ Образ собран: opencode-python:latest${NC}"
echo ""
echo -e "Чтобы использовать свой образ, замените в скриптах:"
echo -e "  ${BLUE}ghcr.io/anomalyco/opencode:latest${NC} → ${GREEN}opencode-python:latest${NC}"
EOF

# 6. DOCKERFILE
cat > Dockerfile << 'EOF'
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
EOF

# Права на выполнение
chmod +x opencode opencode-web opencode-stop opencode-ps opencode-build

echo "✅ Создано:"
echo "   - opencode        (CLI)"
echo "   - opencode-web    (Web interface)"
echo "   - opencode-stop   (Stop containers)"
echo "   - opencode-ps     (Show status)"
echo "   - opencode-build  (Build custom image)"
echo "   - Dockerfile      (Python image)"
echo ""
echo "✅ Директории:"
echo "   - data/auth/"
echo "   - data/config/"
echo "   - data/cache/"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 Следующие шаги:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Проверьте .env файл:"
echo "   cat .env"
echo ""
echo "2. Добавьте aliases в ~/.bashrc:"
echo "   echo \"alias opencode='bash $INSTALL_DIR/opencode'\" >> ~/.bashrc"
echo "   echo \"alias opencode-web='bash $INSTALL_DIR/opencode-web'\" >> ~/.bashrc"
echo "   echo \"alias opencode-stop='bash $INSTALL_DIR/opencode-stop'\" >> ~/.bashrc"
echo "   echo \"alias opencode-ps='bash $INSTALL_DIR/opencode-ps'\" >> ~/.bashrc"
echo "   source ~/.bashrc"
echo ""
echo "3. Попробуйте запустить:"
echo "   cd /any/project"
echo "   bash $INSTALL_DIR/opencode"
echo ""
echo "✅ Установка завершена!"
