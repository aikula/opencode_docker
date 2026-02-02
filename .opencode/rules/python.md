# Python Development Rules

## Code Style

Follow **PEP 8** with these specifics:

```python
# Use type hints consistently
def process_data(items: list[dict[str, Any]]) -> dict[str, int]:
    """Process items and return summary statistics."""
    ...

# Prefer dataclasses for data containers
@dataclass
class User:
    id: int
    name: str
    email: str

# Use context managers
with open("file.txt") as f:
    content = f.read()

# Prefer pathlib over os.path
from pathlib import Path
config_path = Path("config") / "settings.yaml"
```

## Async/Await Patterns

For I/O-bound operations, use **asyncio**:

```python
import asyncio
import asyncpg

async def fetch_users(pool: asyncpg.Pool) -> list[dict]:
    async with pool.acquire() as conn:
        rows = await conn.fetch("SELECT * FROM users")
        return [dict(row) for row in rows]

# Run async from sync
asyncio.run(fetch_users(pool))
```

## Error Handling

```python
# Be specific with exceptions
try:
    result = divide(a, b)
except ZeroDivisionError:
    logger.error("Cannot divide by zero")
    raise

# Use custom exceptions for domain errors
class ValidationError(Exception):
    pass
```

## Dependencies

- Use **pyproject.toml** for modern Python projects
- Pin versions: `package==1.2.3` for production
- Use **uv** for fast dependency management

## Testing

```python
# Use pytest with fixtures
import pytest

@pytest.fixture
async def db_pool():
    pool = await asyncpg.create_pool("...")
    yield pool
    await pool.close()

def test_user_creation(db_pool):
    user = create_user(db_pool, "test@example.com")
    assert user.email == "test@example.com"
```

## Security

- Never commit `.env` files
- Use `python-dotenv` for environment variables
- Validate all inputs with Pydantic
- Run `pip-audit` to check for vulnerabilities
