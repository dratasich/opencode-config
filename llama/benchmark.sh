#!/usr/bin/env bash
# Run llama-bench for all GGUF models and append results to benchmarks.md.
#
# Usage:
#   ./benchmark.sh                  # all *.gguf in ~/models, append to benchmarks.md
#   ./benchmark.sh -n               # dry run: print results, do not append
#   ./benchmark.sh model.gguf ...   # specific model(s)
#
# Env overrides:
#   MODELS_DIR  (default: ~/models)
#   OUTPUT      (default: benchmarks.md next to this script)

set -u

MODELS_DIR="${MODELS_DIR:-$HOME/models}"
OUTPUT="${OUTPUT:-$(dirname "$(readlink -f "$0")")/benchmarks.md}"
APPEND=1

if [ "${1:-}" = "-n" ]; then
    APPEND=0
    shift
fi

if [ "$#" -gt 0 ]; then
    MODELS=("$@")
else
    mapfile -t MODELS < <(find "$MODELS_DIR" -maxdepth 1 -name '*.gguf' | sort)
fi

if [ "${#MODELS[@]}" -eq 0 ]; then
    echo "no .gguf models found in $MODELS_DIR" >&2
    exit 1
fi

date="$(date +%Y-%m-%d)"
build="$(llama --version 2>/dev/null | head -1)"

section="
## $date

llama build: $build

results are from fastest to slowest result
"

for model in "${MODELS[@]}"; do
    base="$(basename "$model")"
    echo "benchmarking $base ..." >&2

    start="$(date +%s)"
    table="$(llama-bench -m "$model" -ngl 99 -o md 2>/dev/null | grep -v '^build: ')"
    rc=$?
    end="$(date +%s)"

    if [ "$rc" -ne 0 ] || [ -z "$table" ]; then
        echo "  FAILED (llama-bench exited $rc), skipping" >&2
        continue
    fi

    section+="
\`\`\`bash
llama-bench -m $model -ngl 99
# took $((end - start))s
\`\`\`

$table
"
done

if [ "$APPEND" -eq 1 ]; then
    printf '%s\n' "$section" >> "$OUTPUT"
    echo "appended results to $OUTPUT" >&2
else
    printf '%s\n' "$section"
fi
