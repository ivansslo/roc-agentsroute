#!/bin/bash
set -e
cd "$(dirname "$0")"

HERMES="hermes"
[ ! -f "$HERMES" ] && echo "hermes binary not found" && exit 1

echo "Creating backup..."
cp "$HERMES" "$HERMES.bak.$(date +%s)"

echo "1. Adding AIS_DEV constant..."
if ! grep -q "AIS_DEV=" "$HERMES"; then
  sed -i '/CLOUDRUN="https:\/\/ai-vitality-819208434965.us-west1.run.app"/a AIS_DEV="https://ais-dev-4kbznhxyc5wsr5c6oxw6zz-70765440683.asia-east1.run.app"  # NEW Google AI Studio Applet (fast + high thinking)' "$HERMES"
fi

echo "2. Adding AIS_DEV to _default_model_for..."
sed -i '/cloudrun)     echo "llama-3.3-70b-versatile" ;;/a \    ais|aisdev|newcr|ais-dev) echo "gemini-2.5-flash" ;;  # fast + high-thinking (recommended for coding/thinking)' "$HERMES"

echo "3. Adding AIS_DEV to _provider_ready..."
sed -i '/cloudrun)      \[ -n "\$TOKEN" \] ;;/a \    ais|aisdev|newcr|ais-dev) [ -n "$TOKEN" ] ;;  # same TOKEN as gateway' "$HERMES"

echo "4. Updating best runtime ranking (prefer AIS-DEV for high thinking)..."
sed -i 's|  # Ranking: Groq (free/fast) → OpenAI → OpenRouter → Gemini → Gateway → CloudRun → CF|  # Ranking: Groq (fast) → AIS-DEV (high thinking + grounding) → OpenRouter → Gemini → Gateway → ...|' "$HERMES"

# Add AIS-DEV early in best selection (after groq)
if ! grep -q "_provider_ready ais" "$HERMES"; then
  sed -i '/if _provider_ready groq; then/a \  if _provider_ready ais; then\n    echo "ais|gemini-2.5-flash"; return\n  fi' "$HERMES"
fi

echo "5. Appending Autonomous Orchestrator + AI Studio import functions..."

cat >> "$HERMES" << 'NEW_FUNCS'

# ═════════════════════════════════════════════════════════════════════════════
#  AUTONOMOUS ORCHESTRATOR (High Thinking + Coding + Grounding + Fast Response)
# ═════════════════════════════════════════════════════════════════════════════
cmd_orchestrator() {
  local task="$*"
  [ -z "$task" ] && { err "Usage: hermes orchestrator <complex task>"; return 1; }

  header
  echo -e "${BOLD}🧠 Autonomous Orchestrator${N} — High Thinking + Grounding"
  echo -e "  Task: ${C}$task${N}"
  echo -e "  Flow: Planner → Researcher → Coder → Reviewer → Tester + Grounding"
  echo -e "  Supports: coding, fast response, high thinking, real-world tasks\n"

  local workdir="${HERMES_CODE_WORKSPACE:-$(pwd)}"
  local steps=6
  local last=""

  for step in $(seq 1 $steps); do
    echo -e "${Y}── Step $step/$steps ──${N}"

    local prompt="You are Hermes Autonomous Orchestrator (high-thinking, coding, grounding).
Task: $task
Step: $step/$steps
Previous: $last

Return ONLY compact JSON:
{
  \"thought\": \"grounded reasoning\",
  \"role\": \"planner|researcher|coder|reviewer|tester\",
  \"action\": \"shell|read|write|search|done\",
  \"command\": \"...\",
  \"path\": \"...\",
  \"content\": \"...\",
  \"grounding\": \"source/logic\",
  \"message\": \"summary\"
}"

    local resp=$(cmd_ask_internal "$prompt" "Output ONLY valid JSON.")
    local json=$(printf "%s" "$resp" | _extract_json_object 2>/dev/null)

    if [ -z "$json" ]; then
      warn "Bad JSON from model"
      last="model returned invalid JSON"
      continue
    fi

    local role=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("role",""))' "$json" 2>/dev/null)
    local action=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("action",""))' "$json" 2>/dev/null)
    local thought=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("thought",""))' "$json" 2>/dev/null)

    echo -e "  ${C}[$role]${N} $thought"

    case "$action" in
      shell)
        local cmd=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("command",""))' "$json" 2>/dev/null)
        echo -e "  ${BOLD}$ $cmd${N}"
        local out=$(cd "$workdir" && timeout 90 bash -lc "$cmd" 2>&1 | head -60)
        printf "    %s\n" "$out"
        last="shell: $cmd"
        ;;
      write)
        local p=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("path",""))' "$json" 2>/dev/null)
        local c=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("content",""))' "$json" 2>/dev/null)
        mkdir -p "$(dirname "$workdir/$p")"
        echo "$c" > "$workdir/$p"
        ok "Wrote $p"
        last="wrote:$p"
        ;;
      done)
        local msg=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("message","Complete"))' "$json" 2>/dev/null)
        ok "$msg"
        return 0
        ;;
      *)
        echo -e "  ${D}$action${N}"
        last="$action"
        ;;
    esac
    echo ""
  done
  warn "Max steps reached"
}

cmd_import_to_aistudio() {
  local task="${*:-Autonomous Hermes Orchestrator}"
  header
  echo -e "${BOLD}📥 Auto Export for Google AI Studio / AIS-DEV${N}\n"

  cat << JSON
{
  "name": "Hermes Autonomous Orchestrator",
  "source": "roc-agentsroute v5.9.0 (patched)",
  "task": "$task",
  "modes": ["autonomous", "orchestrator", "coding", "fast-response", "high-thinking", "grounding"],
  "providers": ["ais", "gateway", "gemini", "groq", "openrouter"],
  "loop": "Planner → Researcher → Coder → Reviewer → Tester + Grounding",
  "endpoints": {
    "ais_dev": "$AIS_DEV",
    "gateway": "$GATEWAY"
  },
  "recommended_model": "gemini-2.5-flash (fast + high thinking)"
}
JSON

  echo ""
  echo -e "${C}How to import:${N}"
  echo "  1. Open $AIS_DEV or aistudio.google.com"
  echo "  2. New prompt / custom agent"
  echo "  3. Paste the JSON as system instructions"
  echo "  4. Or run: hermes studio chat"
  echo ""
  ok "Agent definition ready for AI Studio / AIS-DEV"
}
NEW_FUNCS

echo "6. Registering new commands..."
sed -i '/case "${1:-help}" in/a \  orchestrator) shift; cmd_orchestrator "$@" ;;\n  import|ais-import) shift; cmd_import_to_aistudio "$@" ;;' "$HERMES"

echo "7. Updating help text..."
sed -i '/studio.*AI Studio/a \  echo -e "    ${BOLD}orchestrator${N} <task>       Autonomous high-thinking orchestrator (coding + grounding)"\n  echo -e "    ${BOLD}import|ais-import${N}         Export agent for AI Studio / AIS-DEV"' "$HERMES"

echo "8. Adding AIS-DEV to config/status output..."
sed -i '/Cloud Run:/a \  echo -e "  ${W}AIS-DEV:${N}     $AIS_DEV"' "$HERMES"

echo ""
echo "✅ Patch applied successfully!"
echo ""
echo "New features:"
echo "  hermes orchestrator \"Build a production autonomous coding agent with grounding\""
echo "  hermes import \"High thinking mode\""
echo "  hermes chat --provider ais"
echo "  hermes studio"
echo ""
echo "AIS-DEV is now a first-class provider (uses gemini-2.5-flash by default for fast + high thinking)."
