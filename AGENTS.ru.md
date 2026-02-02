# OpenCode - Среда разработки с AI

## Обзор

Это портативная **Среда разработки OpenCode с AI** - Docker-based AI агент для кодирования, настроенный для full-stack разработки.

Файл `AGENTS.md` содержит инструкции по умолчанию, которые AI агент следует во всех проектах. Вы можете переопределить их в отдельных проектах, создав свой собственный `AGENTS.md`.

## Стек технологий по умолчанию

- **Backend**: Python (FastAPI, Django, asyncio), PostgreSQL, Redis
- **Frontend**: React, Next.js, TypeScript, Tailwind CSS
- **DevOps**: Docker, Kubernetes, Git, GitHub Actions
- **Data**: pandas, numpy, PostgreSQL, vector databases

## Основные принципы разработки

### Стиль кода
- **Python**: Следуйте PEP 8, используйте type hints, docstrings для функций
- **TypeScript/JavaScript**: ESLint + Prettier, функциональные паттерны
- **React**: Hooks-first, избегайте классовых компонентов, proper error boundaries

### Архитектурные паттерны
- **Backend**: Clean Architecture / Hexagonal Architecture
- **API**: RESTful дизайн с правильными HTTP статус кодами
- **Database**: Используйте asyncpg для PostgreSQL, правильные индексы
- **Frontend**: Композиция компонентов, React Query, Zustand

### Безопасность
- Никогда не коммитьте API ключи - используйте переменные окружения
- Валидируйте все входные данные, санитайзите запросы к БД
- Используйте HTTPS для продакшена
- Запускайте security аудит: `pip-audit`, `npm audit`

### Тестирование
- **Python**: pytest с fixtures, стремитесь к >80% покрытию
- **Frontend**: Vitest/Jest, React Testing Library
- **E2E**: Playwright для критичных пользовательских потоков

## Когда спрашивать vs решать самому

**Спрашивайте пользователя перед:**
- Удалением файлов или директорий
- Запуском миграций БД в продакшене
- Изменением логики аутентификации/авторизации
- Деплоем в продакшен
- Сломом API изменений

**Решайте автономно:**
- Форматирование и линтинг кода
- Добавление тестов для нового кода
- Улучшение документации
- Рефакторинг внутри модуля
- Добавление type hints

## Частые команды

### Python проекты
```bash
# Настройка
python -m venv .venv && source .venv/bin/activate
pip install -e ".[dev]"

# Разработка
pytest                      # Запустить тесты
pytest --cov               # С покрытием
ruff check .               # Линтинг
ruff check --fix .         # Авто-фикс
mypy app/                  # Типизация

# База данных
alembic revision --autogenerate -m "message"
alembic upgrade head
```

### React/Next.js проекты
```bash
npm run dev
npm run build
npm run lint
npm run type-check
npm run test
```

### Docker & DevOps
```bash
docker compose up -d
docker compose logs -f
docker compose down --volumes
```

## Шаблон структуры проекта

```
project/
├── backend/                 # Python backend
│   ├── app/                # Основное приложение
│   ├── tests/              # Тесты
│   └── Alembic/            # Миграции БД
├── frontend/               # React/Next.js frontend
│   ├── src/
│   │   ├── components/     # Переиспользуемые компоненты
│   │   ├── hooks/          # Кастомные хуки
│   │   └── lib/            # Утилиты
│   └── tests/
├── docker/                 # Конфигурации Docker
├── scripts/                # Утилиты
└── docs/                   # Документация
```

## Git workflow

- Фичи-бранчи: `feature/`, `fix/`, `refactor/`
- Конвенциональные коммиты: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`
- Всегда создавайте PRs для ревью, без прямых коммитов в main
- Используйте `GH_TOKEN` для GitHub операций

## Доступные MCP инструменты

Эта среда имеет MCP серверы для:
- **GitHub**: Управление репозиториями, PRs, issues
- **PostgreSQL**: Запросы к БД и инспекция схемы (установите `DATABASE_URL`)
- **SQLite**: Локальная БД для разработки
- **Filesystem**: Безопасные файловые операции в workspace
- **Memory**: Постоянные знания между сессиями
- **Sequential Thinking**: Решение сложных задач
- **Fetch**: Загрузка веб-контента
- **Git**: Локальные git операции

## Проектная спецификация

Для переопределения настроек по умолчанию в конкретном проекте создайте `AGENTS.md` в корневой директории проекта. Проектный файл будет иметь приоритет над этим файлом.
