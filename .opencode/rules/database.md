# Database Development Rules

## PostgreSQL Best Practices

### Schema Design

```sql
-- Always use primary keys
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Use appropriate column types
-- text > varchar (unless size limit needed)
-- timestamptz > timestamp (always store timezone)
-- numeric > money (for financial data)

-- Add indexes for frequently queried columns
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at DESC);
```

### Query Patterns

```sql
-- Use parameterized queries (never string concatenation)
-- Python/asyncpg example:
await conn.execute(
    "INSERT INTO users (email) VALUES ($1)",
    email
)

-- Use EXPLAIN ANALYZE for slow queries
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = $1;

-- Use transactions for multi-step operations
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
```

### Migrations

```bash
# Create migration
alembic revision --autogenerate -m "add user preferences"

# Apply migrations
alembic upgrade head

# Rollback
alembic downgrade -1
```

### Connection Management

```python
# Use connection pools
import asyncpg

pool = await asyncpg.create_pool(
    "postgresql://user:pass@localhost/db",
    min_size=5,
    max_size=20
)

# Always use context managers
async with pool.acquire() as conn:
    result = await conn.fetchrow("SELECT * FROM users WHERE id = $1", user_id)
```

## Common Patterns

### Soft Deletes

```sql
ALTER TABLE users ADD COLUMN deleted_at TIMESTAMPTZ;

-- Query active records
SELECT * FROM users WHERE deleted_at IS NULL;
```

### Audit Trail

```sql
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(255) NOT NULL,
    record_id INTEGER NOT NULL,
    action VARCHAR(50) NOT NULL,
    changed_by INTEGER REFERENCES users(id),
    changed_at TIMESTAMPTZ DEFAULT NOW()
);
```

### JSONB Usage

```sql
-- For flexible schema data
ALTER TABLE users ADD COLUMN metadata JSONB DEFAULT '{}';

-- Query JSONB fields
SELECT * FROM users WHERE metadata->>'theme' = 'dark';

-- Index JSONB
CREATE INDEX idx_users_metadata ON users USING GIN(metadata);
```

## Performance Tips

1. **Use EXPLAIN ANALYZE** before optimizing
2. **Add indexes** after identifying slow queries
3. **Use connection pooling** (PgBouncer for production)
4. **Avoid SELECT \*** - only fetch needed columns
5. **Use prepared statements** for repeated queries
6. **Consider materialized views** for complex aggregations
