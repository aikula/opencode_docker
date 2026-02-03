# OpenCode Portable Development Environment

A portable, Docker-based AI coding agent setup configured for full-stack development with Python, PostgreSQL, React, and modern web technologies.

## 📁 Quick Start

```bash
# 1. Clone this repository (your OpenCode setup)
git clone <your-repo-url>
cd opencode-setup

# 2. Configure environment (ONE TIME - in script directory)
cp .env.example .env
# Edit .env with your API keys (GH_TOKEN, OPENCODE_API_KEY, etc.)

# 3. Run from ANY project directory
cd /path/to/your-project
/full/path/to/opencode-setup/opencode

# Or run web interface
/full/path/to/opencode-setup/opencode-web
```

> **Important**: `.env` file stays in the **script directory**, NOT in your projects. This keeps all your API keys in one place.

## 🗂️ Directory Structure

```
~/opencode-setup/              # OpenCode installation (ONE location)
├── .env                       # ⭐ API keys (NOT in git - configure once!)
├── .env.example               # Template for .env (in git)
├── .gitignore                 # Git ignore rules
├── AGENTS.md                  # Project instructions for AI (in git)
├── opencode.json              # OpenCode configuration (in git)
├── opencode                   # ⭐ Script to run CLI
├── opencode-web               # ⭐ Script to run web interface
├── opencode-build             # Script to build custom Docker image
├── opencode-stop              # Script to stop all containers
├── opencode-ps                # Script to show container status
├── Dockerfile                 # Custom image with Python tools (+392MB)
├── .dockerignore              # Docker build exclusions
├── .opencode/                 # Portable OpenCode config (in git)
│   ├── rules/                 # Development rules per technology
│   │   ├── python.md          # Python best practices
│   │   ├── react.md           # React/TypeScript best practices
│   │   ├── database.md        # PostgreSQL/Database best practices
│   │   └── docker.md          # Docker/DevOps best practices
│   ├── agents/                # Custom agents (empty - add your own)
│   ├── commands/              # Custom slash commands (empty)
│   ├── plugins/               # Custom plugins (empty)
│   └── MCP_GUIDE.md           # Guide to popular MCP servers
└── data/                      # NOT in git - cache, auth, history
    ├── auth/                  # Authentication tokens
    ├── config/                # Global OpenCode config
    ├── cache/                 # Cache and temporary files
    └── pip-cache/             # Pip package cache (persistent)

~/projects/                    # Your various projects
├── my-python-app/             # Each project has:
│   ├── .opencode/             # Project-specific rules (in git)
│   │   └── rules/             # Override defaults for this project
│   └── ...project files...
├── my-react-app/
│   ├── .opencode/             # Different rules for React project
│   └── ...project files...
└── my-go-service/
    └── ...project files...
```

## 🎯 Why `.opencode` in the Project?

You asked if `.opencode` should be shared across all projects. **The answer is NO** - here's why:

### ❌ Don't Share `.opencode` Globally

| Reason | Explanation |
|--------|-------------|
| **Project-specific rules** | Each project has different tech stack, patterns, conventions |
| **Different MCP servers** | Backend projects need Postgres MCP, frontend don't |
| **Team collaboration** | `.opencode` in git means team shares same AI configuration |
| **Context relevance** | Python rules clutter React project, and vice versa |

### ✅ DO: Project-specific `.opencode` (Current Setup)

```
your-project/.opencode/    # Commited to git - team shares
├── rules/python.md        # Python best practices for THIS project
├── rules/react.md         # React patterns for THIS project
└── agents/reviewer.md     # Custom code reviewer agent

your-other-project/.opencode/  # Different config
├── rules/go.md           # Go rules for THIS project
└── agents/deployer.md    # Deployment agent
```

### 📦 What IS Shared Across Projects?

The **scripts** (`opencode`, `opencode-web`) are your "launcher" - they live in ONE location and you run them from ANY project directory:

```bash
# In project A
cd ~/projects/project-a
~/bin/opencode    # Uses project-a/.opencode/config

# In project B
cd ~/projects/project-b
~/bin/opencode    # Uses project-b/.opencode/config
```

## 🐳 Custom Docker Image

This setup includes a custom Docker image built on top of `ghcr.io/anomalyco/opencode:latest` with additional Python tools:

### Pre-installed Python Packages

| Package | Purpose |
|---------|---------|
| `requests` | HTTP library |
| `pandas` | Data manipulation |
| `numpy` | Numerical computing |
| `black` | Code formatter |
| `flake8` | Linter |
| `pytest` | Testing framework |
| `ipython` | Enhanced REPL |

### Image Size

| Image | Size |
|-------|------|
| Base `opencode:latest` | 227MB |
| Custom `opencode-python:latest` | 619MB |

### Rebuilding the Image

If you modify `Dockerfile`:

```bash
./opencode-build
```

## 🔧 Docker Volumes Explained

```bash
# From SCRIPT_DIR (opencode-setup):
-v "$SCRIPT_DIR/data/auth:/root/.local/share/opencode"   # Auth tokens (shared)
-v "$SCRIPT_DIR/data/config:/root/.config/opencode"      # Global config (shared)
-v "$SCRIPT_DIR/data/cache:/root/.cache/opencode"        # Cache (shared)
-v "$SCRIPT_DIR/data/pip-cache:/root/.cache/pip"         # Pip cache (shared)

# From PROJECT_DIR (where you run the script from):
-v "$PROJECT_DIR:/workspace"                              # Project files
-v "$PROJECT_DIR/.opencode:/workspace/.opencode"          # Project-specific config

# SSH keys (read-only)
-v "$HOME/.ssh:/root/.ssh:ro"
```

### Why Pip Cache?

The `pip-cache` volume persists downloaded packages between container runs, so:
- Reinstalling the same package is instant (cached)
- AI agent can install new packages without re-downloading
- Cache survives `docker run --rm`

### What Gets Committed to Git?

| Location | Path | In Git? | Why |
|----------|------|---------|-----|
| **Script dir** | `opencode.json` | ✅ Yes | Portable MCP/agent config |
| **Script dir** | `.opencode/` | ✅ Yes | Default rules, agents |
| **Script dir** | `AGENTS.md` | ✅ Yes | Default project instructions |
| **Script dir** | `.env` | ❌ No | Contains API keys |
| **Script dir** | `data/` | ❌ No | Cache, auth, history |
| **Project dir** | `.opencode/` | ✅ Yes | Project-specific overrides |

### Key Point

- **`.env` stays in script directory** - one place for all API keys
- **Each project can have `.opencode/`** - project-specific rules
- **`opencode.json` in script dir** - default MCP config for all projects
- **`opencode.json` in project dir** (optional) - override per project

## 🔑 Environment Variables

Configure in `~/opencode-setup/.env` (ONE TIME):

```bash
# Required
OPENCODE_API_KEY=sk-...          # OpenCode Zen API key
GH_TOKEN=ghp_...                 # GitHub token for MCP server

# Optional MCP Servers (enable as needed)
DATABASE_URL=postgresql://...    # Enable Postgres MCP
BRAVE_API_KEY=...                # Enable Brave Search MCP
EXA_API_KEY=...                  # Enable Exa Search MCP
```

> **Note**: These keys are used for ALL projects. Keep them secure!

## 🚀 Available MCP Servers

| MCP Server | Enabled By Default | Description |
|------------|-------------------|-------------|
| `github` | ✅ Yes | Repository management, PRs, issues |
| `git` | ✅ Yes | Local git operations |
| `filesystem` | ✅ Yes | File operations in workspace |
| `memory` | ✅ Yes | Persistent knowledge graph |
| `sequential-thinking` | ✅ Yes | Complex problem solving |
| `fetch` | ✅ Yes | Web content fetching |
| `sqlite` | ✅ Yes | Local database |
| `postgres` | ❌ No | Set `DATABASE_URL` to enable |
| `brave-search` | ❌ No | Set `BRAVE_API_KEY` to enable |

## 📝 Development Rules Included

- **Python**: PEP 8, type hints, async patterns, pytest
- **React/TypeScript**: Hooks-first, proper typing, React Query
- **PostgreSQL**: Schema design, query patterns, migrations
- **Docker**: Multi-stage builds, security, production practices

## 🛠️ Scripts Reference

Run from **any project directory** using full path:

```bash
# Assuming installed in ~/opencode-setup/
~/opencode-setup/opencode          # Run CLI in current project
~/opencode-setup/opencode-web      # Run web interface (http://localhost:7777)
~/opencode-setup/opencode-web -d   # Run web interface in background
~/opencode-setup/opencode-build    # Build custom Docker image
~/opencode-setup/opencode-stop     # Stop all OpenCode containers
~/opencode-setup/opencode-ps       # Show container status
```

### Optional: Add to PATH

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:$HOME/opencode-setup"

# Then use from anywhere:
cd /path/to/any-project
opencode          # Works!
opencode-web      # Works!
```

## 🔒 Security Notes

1. **Never commit `.env`** - use `.env.example` as template
2. **Use `.gitignore`** - excludes `data/` and sensitive files
3. **GitHub Token** - needs `repo`, `read:org` scopes
4. **Database URL** - contains credentials, keep in `.env`

## 📚 Customization

### Project-Specific Rules

Create `.opencode/rules/` in your project:

```bash
cd /path/to/my-project
mkdir -p .opencode/rules

# Add project-specific rules
echo "# My Project Rules" > .opencode/rules/project.md
```

### Add Custom Agent (Global or Project)

**Global** (in `~/opencode-setup/.opencode/agents/`):
```bash
# Affects all projects
~/opencode-setup/.opencode/agents/my-agent.md
```

**Project-specific** (in `/my-project/.opencode/agents/`):
```bash
# Affects only this project
/my-project/.opencode/agents/my-agent.md
```

Agent file format:
```markdown
---
description: My custom agent for specific task
model: opencode/glm-4.7-free
tools:
  edit: true
  bash: true
---

You are a specialist in...
```

### Disable Specific MCP Server

Edit `~/opencode-setup/opencode.json`:

```json
"mcp": {
  "postgres": {
    "enabled": false  // Disable Postgres MCP
  }
}
```

## 🐛 Troubleshooting

**Issue**: MCP server not working
```bash
# Check if env var is set
echo $DATABASE_URL

# Enable in opencode.json
"postgres": { "enabled": true }
```

**Issue**: Git operations failing
```bash
# Check GH_TOKEN
echo $GH_TOKEN

# Test GitHub connection
curl -H "Authorization: token $GH_TOKEN" https://api.github.com/user
```

**Issue**: Container can't access files
```bash
# Check permissions
ls -la .opencode/

# Fix permissions
chmod -R 755 .opencode/
```
