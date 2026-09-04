#!/usr/bin/env bash
# Start llama.cpp server for a model listed in opencode.jsonc.
# The alias must match the model key in opencode.jsonc's
# provider.llama.cpp.models so opencode can find it.
#
# Usage:
#   ./serve.sh qwen3-8b
#   ./serve.sh devstral-small-2-2512
#   ./serve.sh            # list available aliases

set -eu

MODELS_DIR="${MODELS_DIR:-$HOME/models}"
PORT="${PORT:-12345}"
CTX="${CTX:-32768}"

model_file() {
    case "$1" in
        qwen3-8b)              echo "Qwen3-8B-Q4_K_M.gguf" ;;
        devstral-small-2-2512) echo "Devstral-Small-2-24B-Instruct-2512-Q4_K_M.gguf" ;;
        *) return 1 ;;
    esac
}

aliases() {
    printf '  %s\n' qwen3-8b devstral-small-2-2512
}

if [ "$#" -ne 1 ]; then
    echo "usage: $(basename "$0") <alias>" >&2
    echo "available aliases (must match opencode.jsonc):" >&2
    aliases >&2
    exit 1
fi

alias_name="$1"
if ! file="$(model_file "$alias_name")"; then
    echo "unknown alias: $alias_name" >&2
    echo "available aliases:" >&2
    aliases >&2
    exit 1
fi

model="$MODELS_DIR/$file"
if [ ! -f "$model" ]; then
    echo "model file not found: $model" >&2
    exit 1
fi

exec llama serve -m "$model" --alias "$alias_name" \
    -ngl 99 -c "$CTX" -fa on -ctk q8_0 -ctv q8_0 \
    --jinja --host 127.0.0.1 --port "$PORT"
