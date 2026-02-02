# OpenCode - AI Development Environment

## Overview

This is a portable **OpenCode AI Development Environment** - a Docker-based AI coding agent configured for full-stack development.

This `AGENTS.md` file provides default instructions that the AI agent follows across all projects. You can override these in individual projects by creating your own `AGENTS.md`.

## Default Tech Stack

- **Backend**: Python (FastAPI, Django, asyncio), PostgreSQL, Redis
- **Frontend**: React, Next.js, TypeScript, Tailwind CSS
- **DevOps**: Docker, Kubernetes, Git, GitHub Actions
- **Data**: pandas, numpy, PostgreSQL, vector databases

## Core Development Principles

### Code Style
- **Python**: Follow PEP 8, use type hints, docstrings for functions
- **TypeScript/JavaScript**: ESLint + Prettier, functional patterns
- **React**: Hooks-first, avoid class components, proper error boundaries

### Architecture Patterns
- **Backend**: Clean Architecture / Hexagonal Architecture
- **API**: RESTful design with proper HTTP status codes
- **Database**: Use asyncpg for PostgreSQL, proper indexing
- **Frontend**: Component composition, React Query, Zustand

### Security
- Never commit API keys - use environment variables
- Validate all inputs, sanitize database queries
- Use HTTPS for production
- Run security audits: `pip-audit`, `npm audit`

### Testing
- **Python**: pytest with fixtures, aim for >80% coverage
- **Frontend**: Vitest/Jest, React Testing Library
- **E2E**: Playwright for critical user flows

## When to Ask vs. Decide

**Ask the user before:**
- Deleting files or directories
- Running database migrations in production
- Changing authentication/authorization logic
- Deploying to production environments
- Making breaking API changes

**Decide autonomously:**
- Code formatting and linting fixes
- Adding tests for new code
- Documentation improvements
- Refactoring within the same module
- Adding type hints to existing code

## Common Commands

### Python Projects
```bash
# Setup
python -m venv .venv && source .venv/bin/activate
pip install -e ".[dev]"

# Development
pytest                      # Run tests
pytest --cov               # With coverage
ruff check .               # Linting
ruff check --fix .         # Auto-fix
mypy app/                  # Type checking

# Database
alembic revision --autogenerate -m "message"
alembic upgrade head
```

### React/Next.js Projects
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

## Project Structure Template

```
project/
├── backend/                 # Python backend
│   ├── app/                # Main application
│   ├── tests/              # Test suite
│   └── Alembic/            # DB migrations
├── frontend/               # React/Next.js frontend
│   ├── src/
│   │   ├── components/     # Reusable components
│   │   ├── hooks/          # Custom hooks
│   │   └── lib/            # Utilities
│   └── tests/
├── docker/                 # Docker configurations
├── scripts/                # Utility scripts
└── docs/                   # Project documentation
```

## Git Workflow

- Feature branches: `feature/`, `fix/`, `refactor/`
- Conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`
- Always create PRs for review, no direct main commits
- Use `GH_TOKEN` environment variable for GitHub operations

## MCP Tools Available

This environment has MCP servers configured for:
- **GitHub**: Repository management, PRs, issues
- **PostgreSQL**: Database queries and schema inspection (set `DATABASE_URL`)
- **SQLite**: Local database for development
- **Filesystem**: Secure file operations within workspace
- **Memory**: Persistent knowledge across sessions
- **Sequential Thinking**: Complex problem-solving
- **Fetch**: Web content fetching
- **Git**: Local git repository operations

## Project-Specific Customization

To override these defaults for a specific project, create `AGENTS.md` in that project's root directory. The project-specific file will take precedence over this default one.
