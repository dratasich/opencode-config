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
| reviewer | Guidelines for reviewing and how the agent should style/write the response. |
