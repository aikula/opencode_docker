# Быстрый старт OpenCode

## ⚡ Настройка за 5 минут

### 1. Установите Docker
```bash
# Linux
curl -fsSL https://get.docker.com | sh

# macOS
brew install --cask docker
```

### 2. Получите API ключи

| Ключ | Где получить | Для чего |
|-----|-------------|----------|
| **OPENCODE_API_KEY** | https://opencode.ai/docs/zen/ | Доступ к AI моделям (GLM-4.7-free) |
| **GH_TOKEN** | https://github.com/settings/tokens | GitHub MCP сервер |

### 3. Настройте (ОДИН РАЗ)

```bash
cd ~/opencode-setup  # или куда вы клонировали репозиторий
cp .env.example .env
nano .env  # Добавьте ваши ключи
```

### 4. Запустите в ЛЮБОМ проекте

```bash
cd /path/to/your-project
~/opencode-setup/opencode          # CLI режим
~/opencode-setup/opencode-web      # Веб-интерфейс на http://localhost:7777
```

## 📁 Что и где лежит?

```
~/opencode-setup/          # ОДНО местоположение для всего
├── .env                   # ⭐ Ваши API ключи (настроить один раз!)
├── opencode               # ⭐ Запускайте из любого проекта
├── opencode-web           # ⭐ Веб-интерфейс
├── opencode.json          # Конфигурация MCP серверов
├── .opencode/             # Правила по умолчанию для всех проектов
└── data/                  # Кэш, авторизация, pip кэш (не в git)

~/projects/my-app/         # Ваши проекты
├── .opencode/             # Опционально: правила для конкретного проекта
└── ...ваш код...
```

## 🎯 Частые сценарии использования

### Создать новый Python проект
```bash
mkdir my-api && cd my-api
~/opencode-setup/opencode
# Попросите: "Создай FastAPI проект с PostgreSQL"
```

### Работать с существующим проектом
```bash
cd ~/projects/existing-app
~/opencode-setup/opencode
# Попросите: "Проанализируй код и предложи улучшения"
```

### Веб-интерфейс
```bash
~/opencode-setup/opencode-web
# Откройте http://localhost:7777 в браузере
```

## 🔧 Включение MCP серверов

Добавьте в `~/opencode-setup/.env`:

```bash
# PostgreSQL (установите DATABASE_URL для включения postgres MCP)
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb

# Brave Search (получите ключ на https://search.brave.com/api/)
BRAVE_API_KEY=your_key_here
```

## 📚 Больше информации

- Полная документация: `README.md`
- Гайд по MCP серверам: `.opencode/MCP_GUIDE.md`
- Правила разработки: `.opencode/rules/*.md`

## 🐳 Docker образ

Эта настройка использует кастомный Docker образ с Python инструментами:

**Первая сборка** (уже сделана для вас):
```bash
~/opencode-setup/opencode-build
```

**Предустановлено**: pandas, numpy, requests, black, flake8, pytest, ipython

**Размер образа**: 619MB (против 227MB базового)
