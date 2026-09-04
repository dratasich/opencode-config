# Benchmarks

```
ggml_vulkan: Found 2 Vulkan devices:
ggml_vulkan: 0 = AMD Ryzen 7 7800X3D 8-Core Processor (RADV RAPHAEL_MENDOCINO) (radv) | uma: 1 | fp16: dot2 | bf16: 0 | fp4: 0 | warp size: 32 | shared memory: 65536 | int dot: 1 | matrix cores: none
ggml_vulkan: 1 = AMD Radeon RX 7800 XT (RADV NAVI32) (radv) | uma: 0 | fp16: dot2 | bf16: 0 | fp4: 0 | warp size: 64 | shared memory: 65536 | int dot: 1 | matrix cores: KHR_coopmat
```

## 2026-07-19

llama build: 55309e7 (10068)

results are from fastest to slowest result

```bash
llama-bench -m ~/models/Qwen3-8B-Q4_K_M.gguf -ngl 99
# 26.4s  So 19 Jul 2026 20:23:16
```

| model                          |       size |     params | backend    | ngl |            test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | --------------: | -------------------: |
| qwen3 8B Q4_K - Medium         |   4.68 GiB |     8.19 B | Vulkan     |  99 |           pp512 |      1855.04 ± 12.26 |
| qwen3 8B Q4_K - Medium         |   4.68 GiB |     8.19 B | Vulkan     |  99 |           tg128 |        101.07 ± 0.03 |

```bash
llama-bench -m ~/models/qwen2.5-coder-14b-instruct-q4_k_m.gguf -ngl 99
# 10.8s  So 19 Jul 2026 20:24:43
```

| model                          |       size |     params | backend    | ngl |            test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | --------------: | -------------------: |
| qwen2 14B Q4_K - Medium        |   8.37 GiB |    14.77 B | Vulkan     |  99 |           pp512 |       1049.58 ± 0.76 |
| qwen2 14B Q4_K - Medium        |   8.37 GiB |    14.77 B | Vulkan     |  99 |           tg128 |         55.97 ± 0.03 |

```bash
llama-bench -m ~/models/Devstral-Small-2-24B-Instruct-2512-Q4_K_M.gguf -ngl 99
# 1.1m  So 19 Jul 2026 20:22:48
```

| model                          |       size |     params | backend    | ngl |            test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | --------------: | -------------------: |
| mistral3 14B Q4_K - Medium     |  13.34 GiB |    23.57 B | Vulkan     |  99 |           pp512 |        644.08 ± 0.93 |
| mistral3 14B Q4_K - Medium     |  13.34 GiB |    23.57 B | Vulkan     |  99 |           tg128 |         36.58 ± 0.12 |

## 2026-09-04

llama build: b10068-54a1a10

results are from fastest to slowest result

```bash
llama-bench -m /home/denise/models/Devstral-Small-2-24B-Instruct-2512-Q4_K_M.gguf -ngl 99
# took 30s
```

| model                          |       size |     params | backend    | ngl |            test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | --------------: | -------------------: |
| mistral3 14B Q4_K - Medium     |  13.34 GiB |    23.57 B | Vulkan     |  99 |           pp512 |        647.69 ± 1.93 |
| mistral3 14B Q4_K - Medium     |  13.34 GiB |    23.57 B | Vulkan     |  99 |           tg128 |         36.41 ± 0.11 |

```bash
llama-bench -m /home/denise/models/Meta-Llama-3.1-8B-Instruct-Q8_0.gguf -ngl 99
# took 16s
```

| model                          |       size |     params | backend    | ngl |            test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | --------------: | -------------------: |
| llama 8B Q8_0                  |   7.95 GiB |     8.03 B | Vulkan     |  99 |           pp512 |      1982.91 ± 11.26 |
| llama 8B Q8_0                  |   7.95 GiB |     8.03 B | Vulkan     |  99 |           tg128 |         66.33 ± 0.05 |

```bash
llama-bench -m /home/denise/models/Mistral-Nemo-Instruct-2407-Q5_K_M.gguf -ngl 99
# took 18s
```

| model                          |       size |     params | backend    | ngl |            test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | --------------: | -------------------: |
| llama 13B Q5_K - Medium        |   8.12 GiB |    12.25 B | Vulkan     |  99 |           pp512 |       1307.74 ± 7.22 |
| llama 13B Q5_K - Medium        |   8.12 GiB |    12.25 B | Vulkan     |  99 |           tg128 |         59.99 ± 0.13 |

```bash
llama-bench -m /home/denise/models/Qwen3-8B-Q4_K_M.gguf -ngl 99
# took 11s
```

| model                          |       size |     params | backend    | ngl |            test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | --------------: | -------------------: |
| qwen3 8B Q4_K - Medium         |   4.68 GiB |     8.19 B | Vulkan     |  99 |           pp512 |       1863.85 ± 5.15 |
| qwen3 8B Q4_K - Medium         |   4.68 GiB |     8.19 B | Vulkan     |  99 |           tg128 |         99.03 ± 0.64 |

summary (tg128, tokens/sec, fastest first):

| model                                        | tg128 t/s |
| -------------------------------------------- | --------: |
| Qwen3-8B Q4_K_M                              |     99.03 |
| Meta-Llama-3.1-8B-Instruct Q8_0              |     66.33 |
| Mistral-Nemo-Instruct-2407 Q5_K_M            |     59.99 |
| Devstral-Small-2-24B-Instruct-2512 Q4_K_M    |     36.41 |

official benchmark scores (from model cards, full-precision models;
quantized local variants will score slightly lower):

| model                     | MMLU | coding                    | tool use / agentic       | source |
| ------------------------- | ---: | ------------------------- | ------------------------ | ------ |
| Qwen3-8B                  |    - | -                         | -                        | [qwen3 blog](https://qwen.ai/blog?id=qwen3) (charts only, no per-model table; 8B rivals Qwen2.5-14B) |
| Llama-3.1-8B-Instruct     | 69.4 | HumanEval 72.6, MBPP 72.8 | BFCL 76.1, API-Bank 82.6 | [model card](https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct) |
| Mistral-Nemo-Instruct     | 68.0 | -                         | -                        | [model card](https://huggingface.co/mistralai/Mistral-Nemo-Instruct-2407) |
| Devstral-Small-2-24B-2512 |    - | SWE-bench Verified 68.0, SWE-bench Multilingual 55.7 | Terminal Bench 2 22.5 | [model card](https://huggingface.co/mistralai/Devstral-Small-2-24B-Instruct-2512) |

takeaway: Devstral Small 2 is by far the strongest for agentic coding
(SWE-bench 68% vs Claude Sonnet 4.5's 77.2%, at only 24B params), but 3x
slower locally than Qwen3-8B. Qwen3-8B is the speed/quality sweet spot.
