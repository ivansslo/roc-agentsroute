#!/data/data/com.termux/files/usr/bin/bash
# ═══════════════════════════════════════════════
#  Hermes v5.6.2 Omni — Installer for Termux
# ═══════════════════════════════════════════════

echo "⚡ Installing Hermes v5.6.2 Omni..."

# Dependencies
pkg update -y 2>/dev/null
pkg install -y python nodejs git curl jq wget unzip 2>/dev/null
pip install requests cryptography 2>/dev/null

# python3_venv for responsive code commands (/run, /preview, /agent)
mkdir -p "$HOME/.hermes"
if command -v python3 >/dev/null 2>&1; then
  python3 -m venv "$HOME/.hermes/python3_venv" 2>/dev/null || true
  if [ -x "$HOME/.hermes/python3_venv/bin/python" ]; then
    "$HOME/.hermes/python3_venv/bin/python" -m pip install -U pip setuptools wheel >/dev/null 2>&1 || true
    "$HOME/.hermes/python3_venv/bin/python" -m pip install -U rich pygments prompt_toolkit requests >/dev/null 2>&1 || true
  fi
fi

# Download CLI
curl -s -o "$PREFIX/bin/hermes" \
  "https://raw.githubusercontent.com/ivansslo/hermes-agent-cli/main/hermes"
chmod +x "$PREFIX/bin/hermes"

# Setup dirs
mkdir -p "$HOME/.hermes/workspace" "$HOME/.hermes/plugins"
cat > "$HOME/.hermes/plugins/multi-agent.commands" <<'EOF'
/agents
/agent
/crew
/research
/plan
/reviewer
/coder
/tester
#multi-agent
#researcher
#planner
#coder
#reviewer
#tester
EOF

echo ""
echo "✅ Hermes installed!"
echo ""
echo "  Run: hermes setup   (configure API keys)"
echo "  Run: hermes help    (see all commands)"
echo "  Run: hermes status  (check connections)"
