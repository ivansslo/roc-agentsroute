# ⚡ Hermes Agent CLI v5.8.0 "Omni"

**Full AI Agent CLI for Termux** — integrates 100 repositories into one unified command-line tool.

## 🚀 Quick Install (Termux)

```bash
curl -s https://raw.githubusercontent.com/ivansslo/roc-agentsroute/main/install.sh | bash
```

## 📖 Commands

```
hermes setup              # Interactive API key setup
hermes chat [model]       # Best-AI interactive chat (auto from all active keys)
hermes ask <question>     # Quick question (non-interactive)
hermes code <desc>        # Generate code from description
hermes coding             # Interactive code commands (/run /agent /venv /sh)
hermes agent <task>       # Active multi-step coding agent (read/write/run)
hermes venv init          # Create ~/.hermes/python3_venv + rich/pygments
hermes plugins init       # Enable / and # suggestions in interactive chat
hermes ai-best            # Show strongest active AI selected from all keys
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

Hermes CLI includes an interactive coding mode:

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

## 🧠 Best AI Chat + Agent Mode

Hermes Chat defaults to `PROVIDER=best`, selecting the strongest available runtime:

1. OpenRouter (`OR_KEY`) → `openai/gpt-4o`
2. Gemini (`GEMINI_KEY`) → `gemini-2.5-flash`
3. Groq (`GROQ_KEY`) → `llama-3.3-70b-versatile`
4. Hermes Gateway / Cloud Run / CF AI fallback

## 🔌 Plugin Suggestions

```bash
hermes venv init
hermes plugins init
hermes chat
```

## 🔑 Supported Providers

- ⚡ **Groq** — Free, ultra-fast (Llama 3.3 70B, Llama 8B)
- 🌐 **OpenRouter** — 100+ models (GPT-4o, Qwen3, DeepSeek, Gemini, Scout)
- 💎 **Gemini** — Google AI (2.5 Flash, 2.5 Pro)
- ☁️ **CF AI** — Cloudflare AI Factory (60 models)
- 🔗 **Gateway** — RocSpace Gateway proxy
- 🖥️ **Cloud Run** — GCP Cloud Run app

## 🌐 Endpoints (v5.8.0 — updated to roadfx.biz.id)

| Service | URL |
|---|---|
| Gateway (primary) | `https://ai.roadfx.biz.id` |
| Gateway (mirror) | `https://gateway.roadfx.biz.id` |
| Gateway (backup) | `https://api.roadfx.biz.id` |
| Dashboard | `https://ai.roadfx.biz.id/dashboard` |
| Chat-Live | `https://ai.roadfx.biz.id/chat-live` |
| CF AI Factory | `https://factory.roadfx.biz.id` |
| Links Hub | `https://app.roadfx.biz.id` |
| Cloud Run | `https://ai-vitality-819208434965.us-west1.run.app` |
| Oracle VM | `http://161.118.253.28` |
| Solace | `mr-connection-mwc1f9igml1.messaging.solace.cloud` |
| Uptime Kuma | `http://161.118.253.28:3001` |

## 🤖 11 Verified AI Models

| Model | Provider | Speed |
|---|---|---|
| llama-3.3-70b-versatile | Groq ⚡ | Fast |
| llama-3.1-8b-instant | Groq | Fast |
| qwen/qwen3-32b | OpenRouter | Medium (thinking) |
| qwen/qwen3-235b-a22b | OpenRouter | Slow |
| qwen/qwen3.6-27b | OpenRouter | Medium (thinking) |
| openai/gpt-4o | OpenRouter | Medium |
| openai/gpt-oss-120b | OpenRouter | Slow |
| deepseek/deepseek-r1 | OpenRouter | Slow (thinking) |
| meta-llama/llama-4-scout-17b-16e-instruct | OpenRouter | Medium |
| google/gemini-2.5-flash | OpenRouter | Fast |
| google/gemini-2.5-pro-preview | OpenRouter | Slow |

## 🏗️ Projects Integrated

| Project | Description |
|---|---|
| [⭐ rocspace](https://github.com/ivansslo/rocspace) | **Monorepo** — Turborepo + TypeScript (Gateway, Site, Shared) |
| roc-containers | Container manager & CLI |
| ai-vitality | AI Studio + Firebase |
| roadfx-full-stack | Express + Firebase Hosting |
| solace-crewai-cli | CrewAI multi-agent |
| codex-master-ai-api | 15+ models API |
| hermes-agent | Python agent framework |
| droid-ai-toolkit | Android AI toolkit |
| crawl4ai | Web crawler |

## 🏗️ Infrastructure

| Service | Provider | Region | Status |
|---|---|---|---|
| RocSpace Gateway v16.1.0 | Cloudflare Workers | Global | ✅ Active |
| roc-site Router | Cloudflare Workers | Global | ✅ Active |
| Oracle VM (roc-vm) | OCI | Singapore | ✅ Running |
| Cloud Run (ai-vitality) | Google Cloud | us-west1 | ✅ Active |
| Aiven PostgreSQL | Aiven | AWS Jakarta | ✅ Running |
| Solace PubSub+ | Solace Cloud | Singapore | ✅ Connected |
| Tailscale VPN | Tailscale | Global | ✅ Connected |

## 📱 Install on Termux

```bash
pkg install curl
curl -s https://raw.githubusercontent.com/ivansslo/roc-agentsroute/main/install.sh | bash
hermes setup
hermes status
```

---

by Ivan Ssl (ivansslo) — v5.8.0 "Omni"
