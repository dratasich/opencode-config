# opencode-config

My personal opencode-config.

> [!CAUTION]
> Be extra careful about the permissions. opencode is so under heavy development (see GitHub issues)
> and has several possibilities to ignore/deny/blacklist files, such that issues arise
> from one month to another. Keep it updated and do not allow command execution on your machine.
> Try your config in a small project in a container.

Got some starting point from:

- [Joel Hooks](https://github.com/joelhooks/opencode-config)
- [Filip Balada](https://github.com/flpbalada/my-opencode-config)
- [opencode configuration docs](https://opencode.ai/docs/permissions/)

## Rationale

- Agents should not be trusted -> setup permissions over opencode-defaults
  (e.g., no scan/read/write for files outside of the cwd).
- Agents need guidelines -> AGENT.md files.

## Agents

| Agent    | Description                                                                 |
| :------- | :-------------------------------------------------------------------------- |
| researcher | Researches dev and devops topics. Read-only; no write/edit access. |
| reviewer   | Guidelines for reviewing and how the agent should style/write the response. |

## Additional Tools

Install skills:

```bash
npx skills add https://github.com/juliusbrussee/caveman
```

- [caveman - agent skill to reduce tokens](https://github.com/juliusbrussee/caveman)
- [rtk - cli proxy to reduce token consumption](https://github.com/rtk-ai/rtk)
- [babysitter - enforce your workflow](https://github.com/a5c-ai/babysitter)
- [openspec - SDD](https://github.com/Fission-AI/OpenSpec)

## Connect to other providers

On my AMD GPU it was easiest to run the models with
[llama.cpp](https://llama-cpp.com/) with vulkan (see AUR for latest)
(Ollama didn't detect my GPU and I didn't want to bother installing/struggling with ROCm).
