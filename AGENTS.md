# Repository Guidelines

## Project Structure & Module Organization

This repository contains a personal Neovim configuration based on LazyVim.

- `init.lua` loads `lua/config/lazy.lua`, which bootstraps lazy.nvim and imports plugin specifications.
- `lua/config/` contains editor options, keymaps, autocommands, and plugin-manager setup.
- `lua/plugins/` contains plugin specifications and overrides. Keep related configuration in a focused file, such as `bufferline.lua` or `lsp.lua`.
- `lua/insideee-dev/` contains custom Lua helpers and integrations.
- `snippets/` contains JSON snippets for JavaScript, TypeScript, JSX, and TSX.
- `lazyvim.json` records enabled extras; `lazy-lock.json` pins plugin revisions.
- `README.md` documents editor behavior; `TUTORIAL-TESTE.md` provides manual workflow checks.

## Build, Test, and Development Commands

Run these commands from the repository root:

- `nvim`: start the configured editor. First launch may download lazy.nvim and plugins.
- `nvim --headless '+qa'`: smoke-test startup after dependencies are installed; inspect output for errors.
- `stylua --check init.lua lua/`: check Lua formatting using `stylua.toml`.
- `stylua init.lua lua/`: format Lua files; review the diff for unrelated changes.
- Inside Neovim, use `:Lazy` to inspect plugins, `:LazyExtras` to inspect extras, and `:checkhealth` to diagnose dependencies.

There is no application build step.

## Coding Style & Naming Conventions

Use two spaces for indentation and a 120-column target, as configured in `stylua.toml`. Follow existing Lua module patterns: plugin files return specification tables; reusable helpers return a module table. Use descriptive lowercase filenames and `snake_case` for new Lua functions and variables. Give keymaps clear `desc` values and check for conflicting mappings.

## Testing Guidelines

No automated test framework or coverage threshold is configured. Smoke-test startup, then exercise affected commands and keymaps interactively. For UI changes, inspect tabs, splits, and floating windows. For LSP or completion changes, open representative JS/TS files and check diagnostics and suggestions. Use `TUTORIAL-TESTE.md` as a checklist, confirming behavior against current configuration.

## Commit & Pull Request Guidelines

Recent commits use short, lowercase imperative subjects, such as `update plugins config`; no mandatory prefix convention is evident. Keep commits focused. Pull requests should explain the behavior change, list validation performed, and link relevant issues. Include screenshots for visible layout changes. Review lockfile updates and exclude logs, credentials, and temporary backups from new commits.
