#!/bin/bash
# Patch for roc-agentsroute/hermes
# Adds AIS_DEV support, better models, autonomous orchestrator mode, AI Studio integration

HERMES="hermes"
[ ! -f "$HERMES" ] && echo "Run from roc-agentsroute dir" && exit 1

echo "Backing up..."
cp "$HERMES" "$HERMES.bak.$(date +%s)"

# 1. Add AIS_DEV constant (after CLOUDRUN)
sed -i '/CLOUDRUN="https:\/\/ai-vitality-819208434965.us-west1.run.app"/a AIS_DEV="https://ais-dev-4kbznhxyc5wsr5c6oxw6zz-70765440683.asia-east1.run.app"  # NEW Google AI Studio Applet (fast + high thinking)' "$HERMES"

# 2. Update _default_model_for for better models
sed -i 's|    gateway)      echo "llama-3.3-70b-versatile" ;;|    gateway)      echo "llama-3.3-70b-versatile" ;;\n    ais|aisdev|newcr|ais-dev) echo "gemini-2.5-flash" ;;  # fast + high-thinking (AI Studio)|' "$HERMES"

# 3. Add AIS_DEV to _provider_ready
sed -i 's|    cloudrun)      [ -n "$TOKEN" ] ;;|    cloudrun)      [ -n "$TOKEN" ] ;;\n    ais|aisdev|newcr|ais-dev) [ -n "$TOKEN" ] ;;  # same TOKEN as gateway|' "$HERMES"

# 4. Update _best_ai_runtime ranking (prefer AIS_DEV for thinking/coding)
sed -i 's|  # Ranking: Groq (free/fast) → OpenAI → OpenRouter → Gemini → Gateway → CloudRun → CF|  # Ranking: Groq (fast) → AIS_DEV (thinking) → OpenRouter (smart) → Gemini → Gateway → ...|' "$HERMES"

# Add AIS_DEV early in best selection
sed -i '/if _provider_ready gateway; then/a \  if _provider_ready ais; then\n    echo "ais|gemini-2.5-flash"; return\n  fi' "$HERMES"

# 5. Add new autonomous orchestrator mode function
cat >> "$HERMES" << 'NEWCODE'

# ═════════════════════════════════════════════════════════════════════════════
#  AUTONOMOUS ORCHESTRATOR (High Thinking + Coding + Grounding)
# ═════════════════════════════════════════════════════════════════════════════
cmd_orchestrator() {
  local task="$*"
  [ -z "$task" ] && { err "Usage: hermes orchestrator <complex task>"; return 1; }

  header
  echo -e "${BOLD}🧠 Autonomous Orchestrator${N}"
  echo -e "  Task: ${C}$task${N}"
  echo -e "  Mode: Planner → Researcher → Coder → Reviewer → Tester + Grounding"
  echo ""

  local workdir="${HERMES_CODE_WORKSPACE:-$(pwd)}"
  local steps=5
  local last=""

  for step in $(seq 1 $steps); do
    echo -e "${Y}── Orchestrator Step $step/$steps ──${N}"

    local prompt="You are Hermes Autonomous Orchestrator (high thinking, coding, grounding).
Task: $task
Step: $step of $steps
Context from previous: $last

Return ONLY valid JSON:
{
  \"thought\": \"short reasoning with grounding\",
  \"role\": \"planner|researcher|coder|reviewer|tester\",
  \"action\": \"shell|read|write|search|done\",
  \"command\": \"...\",
  \"path\": \"...\",
  \"content\": \"...\",
  \"grounding\": \"source or reasoning\",
  \"message\": \"final summary\"
}"

    local response=$(cmd_ask_internal "$prompt" "You are a precise autonomous orchestrator. Output ONLY compact JSON.")
    local json=$(printf "%s" "$response" | _extract_json_object)

    if [ -z "$json" ]; then
      warn "No valid JSON. Raw:"
      printf "%s\n" "$response" | head -c 400
      continue
    fi

    local role=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("role",""))' "$json" 2>/dev/null)
    local thought=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("thought",""))' "$json" 2>/dev/null)
    local action=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("action",""))' "$json" 2>/dev/null)

    echo -e "  ${C}Role:${N} $role | ${C}Thought:${N} $thought"

    case "$action" in
      shell)
        local cmd=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("command",""))' "$json" 2>/dev/null)
        echo -e "  ${BOLD}$ $cmd${N}"
        local out=$(cd "$workdir" && timeout 60 bash -lc "$cmd" 2>&1 | head -50)
        printf "%s\n" "$out" | sed 's/^/    /'
        last="shell: $cmd | output: $(echo "$out" | tail -5)"
        ;;
      write)
        local path=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("path",""))' "$json" 2>/dev/null)
        local content=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("content",""))' "$json" 2>/dev/null)
        mkdir -p "$(dirname "$workdir/$path")"
        echo "$content" > "$workdir/$path"
        ok "Wrote $path"
        last="wrote: $path"
        ;;
      done)
        local msg=$(python3 -c 'import json,sys; print(json.loads(sys.argv[1]).get("message","Done."))' "$json" 2>/dev/null)
        ok "$msg"
        return 0
        ;;
      *)
        echo -e "  ${D}Action: $action${N}"
        ;;
    esac
    echo ""
  done
  warn "Max steps reached. Continue manually with /agent or hermes coding"
}

# Auto import to AI Studio / AIS-DEV
cmd_import_to_aistudio() {
  local task="${*:-Autonomous Hermes Agent from roc-agentsroute}"
  header
  echo -e "${BOLD}📥 Auto Import to AI Studio / AIS-DEV${N}\n"

  echo -e "  Exporting current agent definition to AIS-DEV compatible format..."
  
  local agent_def="{
    \"name\": \"Hermes Autonomous Orchestrator\",
    \"version\": \"5.9.0\",
    \"description\": \"High-thinking autonomous agent with coding, grounding, planner-researcher-coder-reviewer-tester loop\",
    \"source\": \"roc-agentsroute\",
    \"task\": \"$task\",
    \"providers\": [\"ais\", \"gateway\", \"gemini\", \"groq\"],
    \"modes\": [\"autonomous\", \"orchestrator\", \"coding\", \"fast-response\"]
  }"

  echo "$agent_def" | python3 -m json.tool

  echo ""
  echo -e "  ${C}To use in AI Studio:${N}"
  echo -e "    1. Open: ${AIS_DEV}/ or https://aistudio.google.com"
  echo -e "    2. Paste the JSON above as system prompt or custom agent"
  echo -e "    3. Or run: hermes studio chat (uses Gemini directly)"
  echo ""
  ok "Agent definition ready for import"
}
NEWCODE

echo "New functions added (orchestrator + import)"

# 6. Add new commands to case statement at the end
sed -i '/case "${1:-help}" in/a \  orchestrator)  shift; cmd_orchestrator "$@" ;;\n  import|ais-import) shift; cmd_import_to_aistudio "$@" ;;' "$HERMES"

# 7. Update cmd_models to show better models for thinking/coding
sed -i '/echo -e "  ${Y}⚡ Groq (Free, Ultra-Fast):${N}"/a \  echo -e "  ${G}🧠 AIS-DEV / Gemini (High Thinking + Fast):${N}"\n  echo -e "    gemini-2.5-flash          (recommended for coding + thinking)"\n  echo -e "    gemini-2.5-pro-preview"' "$HERMES"

# 8. Update help
sed -i '/echo -e "    ${BOLD}studio${N} \[open|chat|status\]  AI Studio (projects + Gemini chat)"/a \  echo -e "    ${BOLD}orchestrator${N} <task>       Autonomous high-thinking orchestrator (Planner→Researcher→Coder→...)"\n  echo -e "    ${BOLD}import|ais-import${N}         Export agent for AI Studio / AIS-DEV"' "$HERMES"

# 9. Add AIS_DEV to status/config output
sed -i '/echo -e "  ${W}Cloud Run:${N}   $CLOUDRUN"/a \  echo -e "  ${W}AIS-DEV:${N}     $AIS_DEV"' "$HERMES"

echo "✅ Patch applied successfully!"
echo "New commands available:"
echo "  hermes orchestrator <task>     # Autonomous agent mode"
echo "  hermes import <task>           # Export for AI Studio"
echo "  hermes chat --provider ais     # Use new AIS-DEV"
