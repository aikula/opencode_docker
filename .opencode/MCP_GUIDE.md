# Popular MCP Servers for Development

Based on research from Smithery.ai usage data and GitHub popularity, here are the most useful MCP servers for full-stack development.

## 🔥 Top Essential MCP Servers

### Already Configured

| Server | Usage | Status |
|--------|-------|--------|
| **GitHub** | 2,890+ uses | ✅ Enabled |
| **Git** | High demand | ✅ Enabled |
| **Filesystem** | Essential | ✅ Enabled |
| **Memory** | 263+ uses | ✅ Enabled |
| **Sequential Thinking** | 5,550+ uses | ✅ Enabled |
| **Fetch** | Web content | ✅ Enabled |

### Ready to Enable (set env var)

| Server | Enable With | Use Case |
|--------|-------------|----------|
| **PostgreSQL** | `DATABASE_URL=` | Database queries, schema inspection |
| **Brave Search** | `BRAVE_API_KEY=` | Web search, documentation lookup |
| **Exa** | `EXA_API_KEY=` | Semantic web search |

## 📦 Recommended Additional MCP Servers

### For Python Development

```json
"python-executor": {
  "type": "local",
  "command": ["uvx", "mcp-server-python-executor"],
  "enabled": false,
  "description": "Execute Python code in sandboxed environment"
}
```

### For Browser Testing

```json
"playwright": {
  "type": "local",
  "command": ["npx", "-y", "@executeautomation/playwright-mcp-server"],
  "enabled": false,
  "description": "Browser automation and testing"
}
```

### For Database (MySQL)

```json
"mysql": {
  "type": "local",
  "command": ["npx", "-y", "@f4ww4z/mcp-mysql-server"],
  "enabled": false,
  "description": "MySQL database operations"
}
```

### For Kubernetes

```json
"kubernetes": {
  "type": "local",
  "command": ["uvx", "mcp-kubernetes-server"],
  "enabled": false,
  "env": {
    "KUBECONFIG": "/root/.kube/config"
  },
  "description": "Kubernetes cluster management"
}
```

### For Redis

```json
"redis": {
  "type": "local",
  "command": ["npx", "-y", "@modelcontextprotocol/server-redis"],
  "enabled": false,
  "env": {
    "REDIS_URI": "redis://localhost:6379"
  },
  "description": "Redis key-value store operations"
}
```

### For Slack

```json
"slack": {
  "type": "local",
  "command": ["npx", "-y", "@modelcontextprotocol/server-slack"],
  "enabled": false,
  "env": {
    "SLACK_bot_token": "xoxb-..."
  },
  "description": "Slack messaging and notifications"
}
```

## 🌐 Popular Web/Research MCP Servers

| Server | Uses | Description |
|--------|------|-------------|
| **Brave Search** | 680+ | Web and local search |
| **Web Research** | 533+ | Google search + content extraction |
| **Exa** | 171+ | AI-optimized semantic search |
| **Firecrawl** | Popular | Powerful web scraping |

## 🛠️ Development Tool MCP Servers

| Server | Use Case |
|--------|----------|
| **Docker MCP** | Container management |
| **Kubernetes** | K8s cluster operations |
| **Tavily** | Search + extract for AI agents |
| **Playwright** | Browser automation |
| **Puppeteer** | Web scraping, testing |

## 📊 Database MCP Servers

| Server | Status |
|--------|--------|
| **PostgreSQL** | ✅ In config (disabled by default) |
| **SQLite** | ✅ In config (enabled) |
| **MySQL** | Available |
| **MongoDB** | Available |
| **Redis** | Available |
| **Neo4j** | Available |

## 🔐 Security MCP Servers

| Server | Description |
|--------|-------------|
| **GitGuardian** | Scan for secrets in code |
| **Snyk** | Vulnerability scanning |

## 📝 How to Add New MCP Server

1. Get the MCP server command (from [mcpservers.org](https://mcpservers.org))

2. Add to `opencode.json`:

```json
"mcp": {
  "my-server": {
    "type": "local",
    "command": ["npx", "-y", "mcp-server-name"],
    "enabled": true,
    "description": "What it does"
  }
}
```

3. If it requires environment variables, add to `.env`:

```bash
MY_SERVER_API_KEY=your_key_here
```

4. Pass env var in `opencode` script:

```bash
-e MY_SERVER_API_KEY="${MY_SERVER_API_KEY:-}" \
```

## ⚠️ MCP Server Context Warning

> **From OpenCode docs**: "When you use an MCP server, it adds to the context. This can quickly add up if you have a lot of tools."

**GitHub MCP** is particularly heavy - it can exceed context limits with large repositories.

**Recommendation**: Enable only what you need for current work.

## 🔗 Useful Resources

- **Registry**: [mcpservers.org](https://mcpservers.org) - Browse all MCP servers
- **Official**: [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)
- **Popular List**: [popular-mcp-servers](https://github.com/pedrojaques99/popular-mcp-servers)
- **Docker MCP**: [Docker MCP Catalog](https://hub.docker.com/mcp/server/)

## 📈 Usage Statistics (Source: Smithery.ai)

1. Sequential Thinking - 5,550+ uses
2. wcgw - 4,920+ uses
3. GitHub - 2,890+ uses
4. Brave Search - 680+ uses
5. Web Research - 533+ uses
6. iTerm - 402+ uses
7. TaskManager - 374+ uses
8. SQLite - 274+ uses
9. Fetch - 269+ uses
10. Memory - 263+ uses
