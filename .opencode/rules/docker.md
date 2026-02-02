# Docker & DevOps Rules

## Dockerfile Best Practices

```dockerfile
# Use specific version tags
FROM python:3.12-slim

# Non-root user
RUN useradd -m -u 1000 appuser
USER appuser
WORKDIR /app

# Multi-stage builds for smaller images
FROM builder AS builder
RUN pip install --user -r requirements.txt

FROM python:3.12-slim
COPY --from=builder /root/.local /root/.local

# Layer caching: copy requirements first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8000/health || exit 1
```

## Docker Compose

```yaml
services:
  app:
    build: .
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/app
    depends_on:
      db:
        condition: service_healthy
    volumes:
      - .:/app

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: postgres
    healthcheck:
      test: ["CMD", "pg_isready"]
      interval: 5s
```

## Production Considerations

1. **Never run as root** in containers
2. **Use .dockerignore** to exclude unnecessary files
3. **Scan images** for vulnerabilities: `docker scan`
4. **Limit resources**: set `mem_limit` and `cpus`
5. **Use secrets** for sensitive data (not environment variables)

## Kubernetes (if using)

```yaml
# Always set resource limits
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "500m"

# Use liveness and readiness probes
livenessProbe:
  httpGet:
    path: /health
    port: 8000
  initialDelaySeconds: 10
readinessProbe:
  httpGet:
    path: /ready
    port: 8000
```
