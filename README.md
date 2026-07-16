# ⚡ Hermes Agent CLI v5.11.1 "Unified"

**Full AI Agent CLI for Termux** — integrates 100 repositories into one unified command-line tool.

> **v5.11.1** — Firebase Admin SDK (self-serve) + new AIS-DEV endpoint. **v5.11.0** fixed the v5.10.x double-patch damage (see [Changelog](#-changelog)).

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
hermes orchestrator <task> # Autonomous orchestrator (Planner→Coder→Reviewer)
hermes import [task]      # Export agent definition for AI Studio / AIS-DEV
hermes venv init          # Create ~/.hermes/python3_venv + rich/pygments
hermes plugins init       # Enable / and # suggestions in interactive chat
hermes ai-best            # Show strongest active AI selected from all keys
hermes crew [topic]       # CrewAI multi-agent research
hermes embed <text>       # Voyage AI embedding
hermes crawl <url>        # Crawl URL to markdown
hermes firebase [action]  # Firebase Firestore operations
hermes models             # List all AI models
hermes status             # Full system health check
hermes deploy [worker]    # Deploy to existing CF Workers (roc-site, hermes-cloudflare)
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

1. Groq (`GROQ_KEY`) → `llama-3.3-70b-versatile` (fast)
2. AIS-DEV (`TOKEN`) → `gemini-2.5-flash` (high thinking + grounding)
3. OpenAI (`OPENAI_KEY`) → `gpt-4o`
4. OpenRouter (`OR_KEY`) → `openai/gpt-4o`
5. Gemini (`GEMINI_KEY`) → `gemini-2.5-flash`
6. Hermes Gateway / Cloud Run / CF AI fallback

## 🔌 Plugin Suggestions

```bash
hermes venv init
hermes plugins init
hermes chat
```

## 🔑 Supported Providers

- ⚡ **Groq** — Free, ultra-fast (Llama 3.3 70B, Llama 8B)
- 🧠 **AIS-DEV** — Google AI Studio applet (Gemini 2.5 Flash, high thinking + grounding)
- 🧠 **OpenAI Direct** — GPT-4o, GPT-5, o3/o4 reasoning models
- 🌐 **OpenRouter** — 100+ models (GPT-4o, Qwen3, DeepSeek, Gemini, Scout)
- 💎 **Gemini** — Google AI (2.5 Flash, 2.5 Pro, 3 Pro Preview)
- ☁️ **CF AI** — Cloudflare AI Factory (60 models)
- 🔗 **Gateway** — RocSpace Gateway proxy
- 🖥️ **Cloud Run** — GCP Cloud Run app (legacy)

## 🔥 Firebase Admin SDK (self-serve service account)

```bash
# 1. Firebase Console ⚙ Project Settings → Service accounts
#      → klik "Generate new private key"
# 2. Simpan key ke salah satu lokasi:
#      ~/.hermes/serviceAccountKey.json     # Termux
#      assets/serviceAccountKey.json       # repo ini (sudah di-gitignore)
#    atau: export FIREBASE_SERVICE_ACCOUNT=/path/key.json
# 3. Install SDK:
hermes venv init && hermes venv pip firebase-admin
#    (Termux bila build grpcio gagal: pkg install python-grpcio -y)

hermes firebase admin status          # project info + daftar collections
hermes firebase admin list chats 10   # list dokumen Firestore
hermes firebase admin save "halo"     # simpan dokumen (default koleksi: chats)
```

File kunci **tidak pernah ikut di-push** — `serviceAccountKey.json` sudah masuk `.gitignore`.

**Deploy Hosting (CLI klien, terpisah dari Admin SDK):**

```bash
npm install -g firebase-tools          # CLI (sudah otomatis via install.sh)
firebase login --no-localhost          # login headless/Termux
hermes firebase deploy                 # deploy isi ~/.hermes/workspace
```

## 🌐 Endpoints (v5.9.0 — unified router)

All 14 domains route through **roc-site** unified router:

| Service | URL |
|---|---|
| Gateway (primary) | `https://ai.roadfx.biz.id` |
| Gateway (mirror) | `https://gateway.roadfx.biz.id` |
| Gateway (backup) | `https://api.roadfx.biz.id` |
| Dashboard | `https://dashboard.roadfx.biz.id` |
| Chat-Live | `https://chat.roadfx.biz.id` |
| CF AI Factory | `https://factory.roadfx.biz.id` |
| Links Hub | `https://app.roadfx.biz.id` |
| Auth | `https://auth.roadfx.biz.id` |
| Webhook | `https://webhook.roadfx.biz.id` |
| R2 Explorer | `https://r2.roadfx.biz.id` |
| Status | `https://status.roadfx.biz.id` |
| CloudRun Proxy | `https://cloudrun.roadfx.biz.id` |
| AIS-DEV (AI Studio applet) | `https://ais-dev-jqizmthqeu2hdc4e3pgh63-70765440683.asia-east1.run.app` ✅ *live (updated 2026-07-16)* |
| Cloud Run (legacy) | `https://ai-vitality-819208434965.us-west1.run.app` ⚠️ *down (billing)* |
| Oracle VM | `http://161.118.253.28` |
| Uptime Kuma | `http://161.118.253.28:3001` |
| Solace | `mr-connection-mwc1f9igml1.messaging.solace.cloud` |

## 🤖 16 AI Models (5 OpenAI Direct)

| Model | Provider | Speed |
|---|---|---|
| llama-3.3-70b-versatile | Groq ⚡ | Fast |
| llama-3.1-8b-instant | Groq | Fast |
| qwen/qwen3-32b | OpenRouter | Medium (thinking) |
| qwen/qwen3-235b-a22b | OpenRouter | Slow |
| qwen/qwen3-30b-a3b | OpenRouter | Medium (thinking) |
| openai/gpt-4o | OpenRouter | Medium |
| openai/gpt-oss-120b | OpenRouter | Slow |
| deepseek/deepseek-r1 | OpenRouter | Slow (thinking) |
| meta-llama/llama-4-scout-17b-16e-instruct | OpenRouter | Medium |
| google/gemini-2.5-flash | OpenRouter | Fast |
| google/gemini-2.5-pro-preview | OpenRouter | Slow |

## 🏗️ Projects Integrated

| Project | Description |
|---|---|
| [⭐ rocspace](https://github.com/ivansslo/rocspace) | **Monorepo** — v17.1.1, Unified Router (Gateway, Site, Shared) |
| roc-containers | Container manager & CLI v1.2.0 |
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
| RocSpace Gateway v17.1.1 | Cloudflare Workers | Global | ✅ Active |
| roc-site (Unified Router) | Cloudflare Workers | Global | ✅ Active (14 domains) |
| Oracle VM (roc-vm) | OCI | Singapore | ✅ Running |
| Cloud Run (ai-vitality) | Google Cloud | us-west1 | ⚠️ Offline (billing) |
| AIS-DEV | Google Cloud Run | asia-east1 | ✅ Active |
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

by Ivan Ssl (ivansslo) — v5.11.1 "Unified"

## 🆕 Changelog

### v5.11.1 — Firebase Admin + AIS-DEV endpoint (2026-07-16)

- **Firebase Admin SDK bridge** (`hermes firebase admin`): koneksi Firestore
  via service account — *self-serve* key (`~/.hermes/serviceAccountKey.json`,
  `assets/serviceAccountKey.json`, atau env `FIREBASE_SERVICE_ACCOUNT` /
  ADC). Commands: `status`, `list [collection] [limit]`, `save <message>`.
  Tertanam di file `hermes` tunggal agar jalan juga di instalasi Termux.
- **AIS-DEV endpoint updated** ke deployment baru
  (`ais-dev-jqizmthqeu2hdc4e3pgh63…asia-east1.run.app`, live ✅) — yang lama 404.
- `.gitignore`: `serviceAccountKey.json` ikut terproteksi.
- **Firebase CLI (firebase-tools)** otomatis diinstall oleh `install.sh`
  (skip: `HERMES_NO_FIREBASE_CLI=1`); pesan error `hermes firebase deploy`
  diperjelas (install → `firebase login --no-localhost` → `firebase init hosting`).

### v5.11.0 — Repair Release (2026-07-16)

Fixes the damage caused by applying both v5.10 patch scripts twice:

- **CRITICAL:** `orchestrator` / `import` functions were appended *after* the
  main `case` dispatcher, so the commands could never run ("command not found").
  They are now defined **before** the dispatcher.
- **CRITICAL:** the `ais` provider was selectable but had **no API call branch**
  in `chat` / `ask` / `ask_internal` → fell through to the Groq fallback with a
  Gemini model name. AIS now posts to `$AIS_DEV/v1/chat/completions` with `TOKEN`.
- **CRITICAL:** broken JSON quoting in the OpenAI branches of `ask`/`ask_internal`
  (missing backslash escapes → invalid payload). Both fixed.
- Fixed `_best_ai_runtime` nesting bug (AIS check was trapped inside the
  `gateway` block) — ranking now: Groq → AIS-DEV → OpenAI → OpenRouter →
  Gemini → Gateway → CloudRun → CF.
- Fixed wrong default OpenAI model (`qwen/qwen3-32b` → `gpt-4o`).
- Removed all double/triple duplicates: `AIS_DEV` constant, `_provider_ready`
  entries, `cmd_orchestrator`/`cmd_import_to_aistudio` (×2 each), dispatcher
  entries (×4), help lines, config/status echo lines.
- Cleaned `cmd_models` lists (removed non-existent models, deduped).
- **Repo hygiene:** deleted committed `hermes.bak.*` (~400 KB) and the duplicate
  `apply-roc-agentsroute-patch.sh`; `*.bak.*` added to `.gitignore`;
  `patch-roc-agentsroute.sh` rewritten to be **idempotent** (no-op on v5.11+).
- `install.sh` updated to v5.11.0; `hermes_install.sh` fixed (undefined color
  variables, `deply` typo, unguarded re-clone).
- `agent_install.sh`, `proot_install.sh`, `nous_agent.sh` reduced to wrappers
  around the canonical `nous_hermes_agent_install.sh` (they were buggy
  duplicates: PEP 668 failures, broken "Ubuntu installed?" check).

### v5.10.0 — Orchestrator + Modern UI

- Added `orchestrator` command (full autonomous loop)
- Added `import` / `ais-import` (auto-export for AI Studio)
- New UI templates integrated (orchestrator-live.html)
- AIS_DEV first-class + gemini-2.5-flash
