# ==============================================
# Конфигурация окружения OpenCode (шаблон)
# ==============================================
# Скопируйте этот файл в .env и заполните своими значениями
#
# ВАЖНО: Никогда не коммитьте .env в git!
# ==============================================

# ==============================================
# Конфигурация провайдера LLM
# ==============================================
# OpenCode Zen - официальный провайдер OpenCode с бесплатными моделями
# GLM-4.7-free: БЕСПЛАТНАЯ модель уровня Claude/GPT
# Получите ключ: https://opencode.ai/docs/zen/
# ВНИМАНИЕ: Для бесплатной модели требуется добавить способ оплаты в Zen
LLM_PROVIDER=opencode

# ==============================================
# Конфигурация API OpenCode Zen
# ==============================================
# Получите API ключ: https://opencode.ai/docs/zen/
# GLM-4.7-free: FREE, 200K context, отличный для кода
# Требуется регистрация в Zen и добавление платежного метода
OPENCODE_API_KEY=your-opencode-zen-api-key-here

# ==============================================
# Альтернативные провайдеры (опционально)
# ==============================================
# Для прямого подключения к провайдерам (вне Zen):
# ZAI_API_KEY=your-zhipuai-api-key-here
# ANTHROPIC_API_KEY=sk-ant-your-key-here
# OPENAI_API_KEY=sk-your-key-here
# GOOGLE_API_KEY=your-key-here

# ==============================================
# Веб-интерфейс (опционально)
# ==============================================
# Пароль для веб-интерфейса
# Сгенерируйте: openssl rand -base64 16
OPENCODE_SERVER_PASSWORD=your-secure-random-password-here

# ==============================================
# Конфигурация Git (опционально)
# ==============================================
# Создайте токен: https://github.com/settings/tokens
# Требуемые права: repo, read:org
GH_TOKEN=ghp_your_token_here
GIT_AUTHOR_NAME=Your Name
GIT_AUTHOR_EMAIL=your.email@example.com

# ==============================================
# Логирование и отладка
# ==============================================
LOG_LEVEL=info
DEBUG=false

# ==============================================
# Конфигурация MCP серверов
# ==============================================
# PostgreSQL MCP (опционально - включает postgres MCP сервер)
# Получите строку подключения от вашего провайдера базы данных
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# PostgreSQL (альтернативный формат подключения)
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_postgres_password
POSTGRES_DATABASE=mydb

# Brave Search MCP (опционально - получите ключ на https://search.brave.com/api/)
BRAVE_API_KEY=your_brave_api_key_here

# Exa Search MCP (опционально - получите ключ на https://exa.ai)
EXA_API_KEY=your_exa_api_key_here

# ==============================================
# Настройки сервера OpenCode
# ==============================================
OPENCODE_SERVER_PORT=7777
