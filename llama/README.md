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

Extend `opencode.jsonc`.

## References

- [Arch Wiki - llama.cpp](https://wiki.archlinux.org/title/Llama.cpp)
- [whatllm.org](https://whatllm.org/best-open-source-llm)
