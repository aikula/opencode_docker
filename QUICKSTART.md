# OpenCode Quick Start

## ⚡ 5 Minutes Setup

### 1. Install Docker
```bash
# Linux
curl -fsSL https://get.docker.com | sh

# macOS
brew install --cask docker
```

### 2. Get API Keys

| Key | Where | Purpose |
|-----|-------|---------|
| **OPENCODE_API_KEY** | https://opencode.ai/docs/zen/ | AI model access (GLM-4.7-free) |
| **GH_TOKEN** | https://github.com/settings/tokens | GitHub MCP server |

### 3. Configure (ONE TIME)

```bash
cd ~/opencode-setup  # or wherever you cloned this
cp .env.example .env
nano .env  # Add your keys
```

### 4. Run in ANY Project

```bash
cd /path/to/your-project
~/opencode-setup/opencode          # CLI mode
~/opencode-setup/opencode-web      # Web interface at http://localhost:7777
```

## 📁 What Goes Where?

```
~/opencode-setup/          # ONE location for everything
├── .env                   # ⭐ Your API keys (configure once!)
├── opencode               # ⭐ Run this from any project
├── opencode-web           # ⭐ Web interface
├── opencode.json          # MCP servers config
├── .opencode/             # Default rules for all projects
└── data/                  # Cache, auth (not in git)

~/projects/my-app/         # Your projects
├── .opencode/             # Optional: project-specific rules
└── ...your code...
```

## 🎯 Common Use Cases

### Start New Python Project
```bash
mkdir my-api && cd my-api
~/opencode-setup/opencode
# Ask: "Create a FastAPI project with PostgreSQL"
```

### Work on Existing Project
```bash
cd ~/projects/existing-app
~/opencode-setup/opencode
# Ask: "Analyze this codebase and suggest improvements"
```

### Web Interface
```bash
~/opencode-setup/opencode-web
# Open http://localhost:7777 in browser
```

## 🔧 Enable MCP Servers

Add to `~/opencode-setup/.env`:

```bash
# PostgreSQL (set DATABASE_URL to enable postgres MCP)
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb

# Brave Search (get key at https://search.brave.com/api/)
BRAVE_API_KEY=your_key_here
```

## 📚 More Info

- Full documentation: `README.md`
- MCP servers guide: `.opencode/MCP_GUIDE.md`
- Development rules: `.opencode/rules/*.md`
