#!/data/data/com.termux/files/usr/bin/bash
# ═══════════════════════════════════════════════
#  Hermes v5.0.0 Omni — Installer for Termux
# ═══════════════════════════════════════════════

echo "⚡ Installing Hermes v5.0.0 Omni..."

# Dependencies
pkg update -y 2>/dev/null
pkg install -y python nodejs git curl jq wget unzip 2>/dev/null
pip install requests cryptography 2>/dev/null

# Download CLI
curl -s -o "$PREFIX/bin/hermes" \
  "https://raw.githubusercontent.com/ivansslo/hermes-agent-cli/main/hermes"
chmod +x "$PREFIX/bin/hermes"

# Setup dirs
mkdir -p "$HOME/.hermes/workspace"

echo ""
echo "✅ Hermes installed!"
echo ""
echo "  Run: hermes setup   (configure API keys)"
echo "  Run: hermes help    (see all commands)"
echo "  Run: hermes status  (check connections)"
