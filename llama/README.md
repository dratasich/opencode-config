# llama.cpp-vulkan

After installation of [llama.cpp-vulkan](http://aur.archlinux.org/packages/llama.cpp-vulkan)
and python-huggingface-hub (extra repo):

```bash
# create model folder
mkdir ~/models
# download a model
hf download Qwen/Qwen3-8B-GGUF --include Qwen3-8B-Q4_K_M.gguf --local-dir ~/models
# serve model
llama serve -m ~/models/Qwen3-8B-Q4_K_M.gguf --alias qwen3-8b -ngl 99 -c 32768 -fa on -ctk q8_0 -ctv q8_0 --jinja --host 127.0.0.1 --port 12345
```

Or use the wrapper script (aliases match the model keys in `opencode.jsonc`):

```bash
./serve.sh qwen3-8b              # fast default
./serve.sh devstral-small-2-2512 # stronger agentic coding, slower
./serve.sh                       # list aliases
```

Extend `opencode.jsonc`.

## Tool calling

Not every model that advertises tool use actually returns structured
`tool_calls` through llama.cpp's OpenAI API. Some just print tool-call-like
text (e.g. `<tools>{...}</tools>`), which opencode then shows as plain text
instead of executing the tool.

Test your models:

```bash
./test-tool-calling.sh            # all *.gguf in ~/models
./test-tool-calling.sh foo.gguf   # specific model(s)
```

Results with llama.cpp-vulkan b10068 (2026-09):

| Model | Tool calling |
| :---- | :----------- |
| Devstral-Small-2-24B-Instruct-2512-Q4_K_M | works |
| Devstral-Small-2507-Q4_K_M | broken (plain text) |
| Meta-Llama-3.1-8B-Instruct-Q8_0 | works |
| Mistral-Nemo-Instruct-2407-Q5_K_M | works |
| Qwen3-8B-Q4_K_M | works |
| qwen2.5-coder-14b-instruct-q4_k_m | broken (`<tools>` instead of `<tool_call>`) |
| qwen2.5-coder-1.5b-instruct-q8_0 | broken (no tags at all) |

Good local coding models with working tool calling: Qwen3-8B,
Devstral-Small-2 (2512), Llama-3.1-8B, Mistral-Nemo.

## Benchmarks

```bash
./benchmark.sh
```

Results with llama.cpp-vulkan b10068 (2026-09), plus official
SWE-bench Verified scores for quality comparison:

| model                                     | tg128 t/s | SWE-bench Verified | notes |
| ----------------------------------------- | --------: | -----------------: | ----- |
| Qwen3-8B Q4_K_M                           |     99.03 |                  - | fastest, no official score (rivals Qwen2.5-14B per Qwen blog) |
| Meta-Llama-3.1-8B-Instruct Q8_0           |     66.33 |                  - | HumanEval 72.6, BFCL (tool use) 76.1 instead |
| Mistral-Nemo-Instruct-2407 Q5_K_M         |     59.99 |                  - | MMLU 68.0 only, no coding bench on card |
| Devstral-Small-2-24B-Instruct-2512 Q4_K_M |     36.41 |              68.0% | best local agentic coding, but slowest |

frontier reference points (from [benchlm.ai](https://benchlm.ai/coding), 2026-09):

| model           | SWE-bench Verified | coding rank |
| --------------- | -----------------: | ----------: |
| Kimi K3         |                  - |           #4 |
| Claude Opus 5   |              96.0% |          #5 |
| Claude Sonnet 5 |              85.2% |          #9 |

takeaway: Devstral Small 2 at 68% reaches ~70% of Opus 5's score locally,
for free, at 24B params - but at 36 t/s it is 3x slower than Qwen3-8B.

## References

- [Arch Wiki - llama.cpp](https://wiki.archlinux.org/title/Llama.cpp)
- [whatllm.org](https://whatllm.org/best-open-source-llm)
