# Портативная среда разработки OpenCode

Портативная среда AI-агента для кодирования на основе Docker, настроенная для full-stack разработки с Python, PostgreSQL, React и современными веб-технологиями.

## 📁 Быстрый старт

```bash
# 1. Клонируйте этот репозиторий (ваша настройка OpenCode)
git clone <ваш-repo-url>
cd opencode-setup

# 2. Настройте окружение (ОДИН РАЗ - в директории со скриптами)
cp .env.example .env
# Отредактируйте .env с вашими API ключами (GH_TOKEN, OPENCODE_API_KEY и т.д.)

# 3. Запустите из ЛЮБОЙ директории проекта
cd /path/to/your-project
/full/path/to/opencode-setup/opencode

# Или запустите веб-интерфейс
/full/path/to/opencode-setup/opencode-web
```

> **Важно**: Файл `.env` находится в **директории со скриптами**, НЕ в ваших проектах. Это хранит все ваши API ключи в одном месте.

## 🗂️ Структура директорий

```
~/opencode-setup/              # Установка OpenCode (ОДНО местоположение)
├── .env                       # ⭐ API ключи (НЕ в git - настроить один раз!)
├── .env.example               # Шаблон для .env (в git)
├── .gitignore                 # Правила git ignore
├── AGENTS.md                  # Инструкции для AI (в git)
├── opencode.json              # Конфигурация OpenCode (в git)
├── opencode                   # ⭐ Скрипт для запуска CLI
├── opencode-web               # ⭐ Скрипт для запуска веб-интерфейса
├── opencode-build             # Скрипт для сборки кастомного Docker образа
├── opencode-stop              # Скрипт для остановки всех контейнеров
├── opencode-ps                # Скрипт для статуса контейнеров
├── Dockerfile                 # Кастомный образ с Python инструментами
├── .opencode/                 # Портативная конфигурация OpenCode (в git)
│   ├── rules/                 # Правила разработки по технологиям
│   │   ├── python.md          # Best practices для Python
│   │   ├── react.md           # Best practices для React/TypeScript
│   │   ├── database.md        # Best practices для PostgreSQL/Database
│   │   └── docker.md          # Best practices для Docker/DevOps
│   ├── agents/                # Кастомные агенты (пусто - добавьте свои)
│   ├── commands/              # Кастомные slash команды (пусто)
│   ├── plugins/               # Кастомные плагины (пусто)
│   └── MCP_GUIDE.md           # Гайд по популярным MCP серверам
└── data/                      # НЕ в git - кэш, auth, история
    ├── auth/                  # Токены авторизации
    ├── config/                # Глобальная конфигурация OpenCode
    └── cache/                 # Кэш и временные файлы

~/projects/                    # Ваши различные проекты
├── my-python-app/             # Каждый проект имеет:
│   ├── .opencode/             # Специфичные правила проекта (в git)
│   │   └── rules/             # Переопределите настройки для этого проекта
│   └── ...файлы проекта...
├── my-react-app/
│   ├── .opencode/             # Другие правила для React проекта
│   └── ...файлы проекта...
└── my-go-service/
    └── ...файлы проекта...
```

## 🎯 Почему `.opencode` в проекте?

Вы спросили, стоит ли делить `.opencode` между всеми проектами. **Ответ - НЕТ** - вот почему:

### ❌ Не делите `.opencode` глобально

| Причина | Объяснение |
|---------|------------|
| **Специфичные правила проекта** | Каждый проект имеет разный стек, паттерны, конвенции |
| **Разные MCP серверы** | Backend проекты нужны Postgres MCP, frontend - нет |
| **Командная работа** | `.opencode` в git означает, что команда делит одну AI конфигурацию |
| **Актуальность контекста** | Python правила захламляют React проект, и наоборот |

### ✅ ДО: Специфичный для проекта `.opencode` (Текущая настройка)

```
your-project/.opencode/    # Закоммичено в git - команда делится
├── rules/python.md        # Python best practices для ЭТОГО проекта
├── rules/react.md         # React паттерны для ЭТОГО проекта
└── agents/reviewer.md     # Кастомный агент для ревью кода

your-other-project/.opencode/  # Другая конфигурация
├── rules/go.md           # Go правила для ЭТОГО проекта
└── agents/deployer.md    # Агент для деплоя
```

### 📦 Что И так делится между проектами?

**Скрипты** (`opencode`, `opencode-web`) - это ваш "launcher" - они живут в ОДНОМ месте и вы запускаете их из ЛЮБОЙ директории проекта:

```bash
# В проекте A
cd ~/projects/project-a
~/bin/opencode    # Использует project-a/.opencode/config

# В проекте B
cd ~/projects/project-b
~/bin/opencode    # Использует project-b/.opencode/config
```

## 🔧 Docker volumes объяснение

```bash
# Из SCRIPT_DIR (opencode-setup):
-v "$SCRIPT_DIR/data/auth:/root/.local/share/opencode"   # Токены авторизации (общие)
-v "$SCRIPT_DIR/data/config:/root/.config/opencode"      # Глобальная конфигурация (общая)
-v "$SCRIPT_DIR/data/cache:/root/.cache/opencode"        # Кэш (общий)

# Из PROJECT_DIR (откуда запускаете скрипт):
-v "$PROJECT_DIR:/workspace"                              # Файлы проекта
-v "$PROJECT_DIR/.opencode:/workspace/.opencode"          # Специфичная конфигурация проекта

# SSH ключи (read-only)
-v "$HOME/.ssh:/root/.ssh:ro"
```

### Что попадает в Git?

| Локация | Путь | В Git? | Почему |
|----------|------|---------|---------|
| **Script dir** | `opencode.json` | ✅ Да | Портативная MCP/agent конфигурация |
| **Script dir** | `.opencode/` | ✅ Да | Правила, агенты по умолчанию |
| **Script dir** | `AGENTS.md` | ✅ Да | Инструкции по умолчанию |
| **Script dir** | `.env` | ❌ Нет | Содержит API ключи |
| **Script dir** | `data/` | ❌ Нет | Кэш, auth, история |
| **Project dir** | `.opencode/` | ✅ Да | Специфичные правила проекта |

### Ключевой момент

- **`.env` в директории скриптов** - одно место для всех API ключей
- **Каждый проект может иметь `.opencode/`** - специфичные правила
- **`opencode.json` в директории скриптов** - MCP конфигурация по умолчанию для всех проектов
- **`opencode.json` в директории проекта** (опционально) - переопределение для проекта

## 🔑 Переменные окружения

Настройте в `~/opencode-setup/.env` (ОДИН РАЗ):

```bash
# Обязательные
OPENCODE_API_KEY=sk-...          # OpenCode Zen API ключ
GH_TOKEN=ghp_...                 # GitHub токен для MCP сервера

# Опциональные MCP серверы (включайте по необходимости)
DATABASE_URL=postgresql://...    # Включить Postgres MCP
BRAVE_API_KEY=...                # Включить Brave Search MCP
EXA_API_KEY=...                  # Включить Exa Search MCP
```

> **Примечание**: Эти ключи используются для ВСЕХ проектов. Храните их в безопасности!

## 🚀 Доступные MCP серверы

| MCP сервер | Включен по умолчанию | Описание |
|------------|---------------------|----------|
| `github` | ✅ Да | Управление репозиториями, PRs, issues |
| `git` | ✅ Да | Локальные git операции |
| `filesystem` | ✅ Да | Файловые операции в workspace |
| `memory` | ✅ Да | Постоянный граф знаний |
| `sequential-thinking` | ✅ Да | Решение сложных задач |
| `fetch` | ✅ Да | Загрузка веб-контента |
| `sqlite` | ✅ Да | Локальная база данных |
| `postgres` | ❌ Нет | Установите `DATABASE_URL` для включения |
| `brave-search` | ❌ Нет | Установите `BRAVE_API_KEY` для включения |

## 📝 Включенные правила разработки

- **Python**: PEP 8, type hints, async паттерны, pytest
- **React/TypeScript**: Hooks-first, правильная типизация, React Query
- **PostgreSQL**: Дизайн схемы, паттерны запросов, миграции
- **Docker**: Multi-stage сборки, безопасность, production практики

## 🛠️ Справочник скриптов

Запускайте из **любой директории проекта** используя полный путь:

```bash
# Предполагая установку в ~/opencode-setup/
~/opencode-setup/opencode          # Запустить CLI в текущем проекте
~/opencode-setup/opencode-web      # Запустить веб-интерфейс (http://localhost:7777)
~/opencode-setup/opencode-web -d   # Запустить в фоне
~/opencode-setup/opencode-build    # Собрать кастомный Docker образ
~/opencode-setup/opencode-stop     # Остановить все контейнеры OpenCode
~/opencode-setup/opencode-ps       # Показать статус контейнеров
```

### Опционально: Добавить в PATH

```bash
# Добавьте в ~/.bashrc или ~/.zshrc
export PATH="$PATH:$HOME/opencode-setup"

# Затем используйте отовсюду:
cd /path/to/any-project
opencode          # Работает!
opencode-web      # Работает!
```

## 🔒 Заметки по безопасности

1. **Никогда не коммитьте `.env`** - используйте `.env.example` как шаблон
2. **Используйте `.gitignore`** - исключает `data/` и чувствительные файлы
3. **GitHub токен** - нужны права `repo`, `read:org`
4. **Database URL** - содержит креды, храните в `.env`

## 📚 Кастомизация

### Специфичные правила проекта

Создайте `.opencode/rules/` в вашем проекте:

```bash
cd /path/to/my-project
mkdir -p .opencode/rules

# Добавьте специфичные правила
echo "# Правила моего проекта" > .opencode/rules/project.md
```

### Добавьте кастомного агента (Глобально или Проект)

**Глобально** (в `~/opencode-setup/.opencode/agents/`):
```bash
# Влияет на все проекты
~/opencode-setup/.opencode/agents/my-agent.md
```

**Специфично для проекта** (в `/my-project/.opencode/agents/`):
```bash
# Влияет только на этот проект
/my-project/.opencode/agents/my-agent.md
```

Формат файла агента:
```markdown
---
description: Мой кастомный агент для специфичной задачи
model: opencode/glm-4.7-free
tools:
  edit: true
  bash: true
---

Вы специалист в...
```

### Отключить специфичный MCP сервер

Отредактируйте `~/opencode-setup/opencode.json`:

```json
"mcp": {
  "postgres": {
    "enabled": false  // Отключить Postgres MCP
  }
}
```

## 🐛 Troubleshooting

**Проблема**: MCP сервер не работает
```bash
# Проверьте, установлена ли переменная окружения
echo $DATABASE_URL

# Включите в opencode.json
"postgres": { "enabled": true }
```

**Проблема**: Git операции не работают
```bash
# Проверьте GH_TOKEN
echo $GH_TOKEN

# Проверьте подключение к GitHub
curl -H "Authorization: token $GH_TOKEN" https://api.github.com/user
```

**Проблема**: Контейнер не может получить доступ к файлам
```bash
# Проверьте права доступа
ls -la .opencode/

# Исправьте права доступа
chmod -R 755 .opencode/
```
