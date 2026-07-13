# ⚡ Hermes Agent CLI v5.6.2 "Omni"

**Full AI Agent CLI for Termux** — integrates 100 repositories into one unified command-line tool.

## 🚀 Quick Install (Termux)

```bash
curl -s https://raw.githubusercontent.com/ivansslo/hermes-agent-cli/main/install.sh | bash
```

## 📖 Commands

```
hermes setup              # Interactive API key setup
hermes chat [model]       # Interactive AI chat (Groq/OpenRouter/Gemini/CF AI)
hermes ask <question>     # Quick question (non-interactive)
hermes code <desc>        # Generate code from description
hermes coding             # Interactive code commands (/run /agent /venv /sh)
hermes agent <task>       # Active multi-step coding agent (read/write/run)
hermes venv init          # Create ~/.hermes/python3_venv + rich/pygments
hermes plugins init       # Enable / and # suggestions in interactive chat
hermes crew [topic]       # CrewAI multi-agent research
hermes embed <text>       # Voyage AI embedding
hermes crawl <url>        # Crawl URL to markdown
hermes firebase [action]  # Firebase Firestore operations
hermes models             # List all AI models
hermes status             # Full system health check
hermes deploy [worker]    # Deploy to existing CF Workers
hermes clone [repo|all]   # Clone repositories
hermes push [dir] [msg]   # Push to GitHub
hermes termux [action]    # Termux system tools
hermes links              # Show all URLs
hermes update             # Update CLI
```


## ⌘ Code Commands + python3_venv

Hermes CLI now includes an interactive coding mode inspired by `hermes-agent` slash commands:

```bash
hermes venv init                 # create ~/.hermes/python3_venv
hermes coding                    # enter interactive code mode
```

Inside `hermes coding`:

```text
/agent <complex task>             active AI agent: inspect files, write changes, run tests
/file <path>                      load a file into context
/preview                          syntax-highlight current code (Pygments if venv exists)
/run                              run current code (Python uses python3_venv)
/sh <command>                     run shell commands in the workspace
/refactor | /fix | /debug | /test AI code actions
/apply [path]                     save last AI code block
/venv init|status|pip <pkg>       manage python3_venv
```

Set runtime options if needed:

```bash
export HERMES_CODE_WORKSPACE=$PWD
export HERMES_AGENT_STEPS=10
export HERMES_RUN_TIMEOUT=120
```


## 🔌 Plugin Suggestions for `/` and `#`

Interactive prompts now use `prompt_toolkit` when `python3_venv` is available. Type `/` or `#` in `hermes chat`, `hermes coding`, or `hermes studio` to see command/tag suggestions.

```bash
hermes venv init
hermes plugins init
hermes chat
```

Custom suggestions:

```bash
hermes plugins add /deploy-check
hermes plugins add '#security'
hermes plugins list
```

Plugin files are stored in:

```text
~/.hermes/plugins/*.commands
```

## 🏗️ Projects Integrated

| Project | Description |
|---------|-------------|
| Solace-Hermes-Project | CF Workers Gateway (25+ endpoints) |
| ai-vitality | AI Studio + Firebase |
| roadfx-full-stack | Express + Firebase Hosting |
| roadfx-ai-stack | Worker UI (158KB) |
| solace-crewai-cli | CrewAI multi-agent |
| codex-master-ai-api | 15+ models API |
| hermes-agent | Python agent framework |
| droid-ai-toolkit | Android AI toolkit |
| crawl4ai | Web crawler |
| Cloud Run App | ai-vitality on GCP |

## 🔑 Supported Providers

- ⚡ **Groq** — Free, ultra-fast (Llama 3.3 70B, Qwen3 32B, etc.)
- 🌐 **OpenRouter** — 100+ models (GPT-4o, Claude, Gemini, DeepSeek)
- 💎 **Gemini** — Direct Google AI (2.5 Flash/Pro)
- ☁️ **CF AI** — Cloudflare AI Factory (60 models)
- 🔗 **Gateway** — Hermes Gateway proxy
- 🖥️ **Cloud Run** — GCP Cloud Run app

## 🌐 Endpoints

- Dashboard: `hermes-cloudflare.certveis.workers.dev/dashboard`
- Chat: `hermes-cloudflare.certveis.workers.dev/chat`
- Cloud Run: `ai-vitality-819208434965.us-west1.run.app`
- Firebase: `planning-with-ai-36675.web.app`

## 📱 Install on Termux

```bash
pkg install curl
curl -s https://raw.githubusercontent.com/ivansslo/hermes-agent-cli/main/install.sh | bash
hermes setup
hermes status
```

---

by Ivan Ssl (ivansslo) — v5.6.2 "Omni"
