#!/usr/bin/env bash
# Test whether local GGUF models support structured tool calling via llama.cpp.
#
# For each model in ~/models (or MODELS_DIR):
#   1. start `llama serve` on a test port
#   2. send a chat completion with a dummy tool
#   3. PASS if the response contains a structured `tool_calls` field,
#      FAIL if the model only emits tool-call-like text in `content`
#
# Usage:
#   ./test-tool-calling.sh                # test all *.gguf in ~/models
#   ./test-tool-calling.sh model.gguf ... # test specific files
#
# Env overrides:
#   MODELS_DIR   (default: ~/models)
#   PORT         (default: 12399)
#   CTX          (default: 8192, kept small for fast load)
#   TIMEOUT      (default: 120, seconds to wait for /health)

set -u

MODELS_DIR="${MODELS_DIR:-$HOME/models}"
PORT="${PORT:-12399}"
CTX="${CTX:-8192}"
TIMEOUT="${TIMEOUT:-120}"
LOG_DIR="$(mktemp -d)"
trap 'rm -rf "$LOG_DIR"' EXIT

if [ "$#" -gt 0 ]; then
    MODELS=("$@")
else
    mapfile -t MODELS < <(find "$MODELS_DIR" -maxdepth 1 -name '*.gguf' | sort)
fi

if [ "${#MODELS[@]}" -eq 0 ]; then
    echo "no .gguf models found in $MODELS_DIR" >&2
    exit 1
fi

probe() {
    curl -s --max-time 60 "http://127.0.0.1:$PORT/v1/chat/completions" \
        -H 'Content-Type: application/json' \
        -d '{
            "model": "test",
            "messages": [{"role": "user", "content": "What is the weather in Berlin? Use the get_weather tool."}],
            "tools": [{
                "type": "function",
                "function": {
                    "name": "get_weather",
                    "description": "Get the current weather for a city",
                    "parameters": {
                        "type": "object",
                        "properties": {"city": {"type": "string"}},
                        "required": ["city"]
                    }
                }
            }],
            "tool_choice": "auto",
            "max_tokens": 200
        }'
}

verdict() {
    # stdin: JSON response. Prints PASS/FAIL and a short reason.
    python3 -c '
import json, sys
try:
    r = json.load(sys.stdin)
except Exception as e:
    print(f"FAIL (bad response: {e})")
    sys.exit(0)
m = r.get("choices", [{}])[0].get("message", {})
tc = m.get("tool_calls")
if tc:
    name = tc[0].get("function", {}).get("name", "?")
    print(f"PASS (structured tool_calls: {name})")
else:
    c = (m.get("content") or "")[:80].replace("\n", " ")
    print(f"FAIL (plain text: {c!r})")
'
}

printf '%-50s %s\n' "MODEL" "RESULT"
printf '%-50s %s\n' "-----" "------"

failed=()
for model in "${MODELS[@]}"; do
    base="$(basename "$model")"
    log="$LOG_DIR/$base.log"

    llama serve -m "$model" --alias test -ngl 99 -c "$CTX" \
        --jinja --host 127.0.0.1 --port "$PORT" \
        >"$log" 2>&1 &
    pid=$!

    # wait for health
    up=0
    for _ in $(seq "$TIMEOUT"); do
        if curl -sf --max-time 2 "http://127.0.0.1:$PORT/health" >/dev/null 2>&1; then
            up=1
            break
        fi
        if ! kill -0 "$pid" 2>/dev/null; then
            break
        fi
        sleep 1
    done

    if [ "$up" -ne 1 ]; then
        printf '%-50s %s\n' "$base" "ERROR (server did not start, see $log)"
        failed+=("$base")
        kill "$pid" 2>/dev/null
        wait "$pid" 2>/dev/null
        continue
    fi

    # probe up to 3 times (model output is not deterministic)
    result=""
    for _ in 1 2 3; do
        result="$(probe | verdict)"
        case "$result" in
            PASS*) break ;;
        esac
    done
    printf '%-50s %s\n' "$base" "$result"
    case "$result" in
        FAIL*|ERROR*) failed+=("$base") ;;
    esac

    kill "$pid" 2>/dev/null
    wait "$pid" 2>/dev/null
done

echo
if [ "${#failed[@]}" -eq 0 ]; then
    echo "all models support structured tool calling"
else
    echo "models WITHOUT working tool calling (${#failed[@]}):"
    printf '  - %s\n' "${failed[@]}"
fi
