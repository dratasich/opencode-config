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
